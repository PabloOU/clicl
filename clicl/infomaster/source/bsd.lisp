;; bsd.lisp
;; access to the BSD internals of Darwin for MCL
;; (c) 2003 Brendan Burns <bburns@cs.umass.edu>
;; portions (c) 2003 Gary King <gwking@cs.umass.edu>
;; portions of this code were taken from code by Gary Byers

;; This code is derived from Apple computer's MiniShell sample
;; application. This code is included below and can be found at
;; http://developer.apple.com/samplecode/Sample_Code/OS_Utilities/MiniShell.htm

;; This code is released under the LGPL, 
;; please see http://www.gnu.org for more info.
;; The author is not responsible for all of the Really Bad Things(tm)
;; you could do with this code.

;; TODO
;;   other bsd system calls
;;   load-framework-bundle is not BSD specific, it should be moved

;;; ---------------------------------------------------------------------------
;;; Instructions
;;; ---------------------------------------------------------------------------

#|
The main interface for Darwin access is the macro system-command. 
It takes a Unix command as a string argument and returns the results
of that command as a string. For example:

? (system-command "date")
"Sat Jan 11 23:45:32 EST 2003"

? (system-command "cal")
"    January 2003
 S  M Tu  W Th  F  S
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30 31
"

The macro takes an optional parameter, mac-line-feeds?, which defaults
to true. If false, the string returned will use Unix line feeds.
|#

#-EKSL-UTILITIES
(eval-when (:compile-toplevel :eval-toplevel :execute)
  (unless (find-package :bsd)
    (defpackage "BSD")))                ; eval-when

#-EKSL-UTILITIES
(in-package :BSD)

#+EKSL-UTILITIES
(in-package u)

(export '(darwin-interface create-darwin-interface hostname run-shell spawn-shell
          with-darwin-interface system-command cd ls chdir))

;;; This class wraps the pointers necessary for accessing Darwin's BSD layer.
;;; (:reader fread-fn) The pointer to the fread(3) function
;;; (:reader popen-fn) The pointer to the popen(3) function
;;; (:reader pclose-fn) The pointer to the pclose(3) function
;;; (:reader hostname-fn) The pointer to the gethostname(3) function
(defclass darwin-interface ()
  ((read :reader fread-fn
         :initform nil
         :initarg :read)
   (open :reader popen-fn
         :initform nil
         :initarg :open)
   (close :reader pclose-fn
          :initform nil
          :initarg :close)
   (host :reader hostname-fn
         :initform nil
         :initarg :host)
   (fclose :reader fclose-fn
           :initform nil
           :initarg :fclose)
   (fopen :reader fopen-fn
          :initform nil
          :initarg :fopen)
   (fwrite :reader fwrite-fn
           :initform nil
           :initarg :fwrite)
   (cd :reader chdir-fn
       :initform nil
       :initarg :chdir)
   (bundle :reader bundle
           :initform nil
           :initarg :bundle)))

;;; ---------------------------------------------------------------------------
;;; This code taken (nearly) directly from Gary Byers' example
;;; It assumes that you will pass it a CFString (not a lisp string) 
;;; see (with-cfstrs ...)
;;; (:parameter bundle) The pointer to the BundleRef
;;; (:parameter name) The name (a CFString) of the function to find
;;; (:returns) The pointer to the function
;;; ---------------------------------------------------------------------------
(defun get-addr (bundle name)
  (let* ((addr (#_CFBundleGetFunctionPointerForName bundle name)))
    (rlet ((buf :long))
      (setf (%get-ptr buf) addr)
      (ash (%get-signed-long buf) -2))))

;;; ---------------------------------------------------------------------------
;;; Create a darwin interface
;;; (:returns) The darwin interface, properly initialized
;;; ---------------------------------------------------------------------------
(defmethod create-darwin-interface ()
  (let ((bundle (load-framework-bundle "System.framework")))
    (when (not (%null-ptr-p bundle))
      (with-cfstrs ((fread "fread")
                    (popen "popen")
                    (pclose "pclose")
                    (hostname "gethostname")
                    (fopen "fopen")
                    (fclose "fclose")
                    (fwrite "fwrite")
                    (chdir "chdir"))
        (make-instance 'darwin-interface
          :read (get-addr bundle fread)
          :open (get-addr bundle popen)
          :close (get-addr bundle pclose)
          :host (get-addr bundle hostname)
          :fclose (get-addr bundle fclose)
          :fopen (get-addr bundle fopen)
          :fwrite (get-addr bundle fwrite)
          :chdir (get-addr bundle chdir)
          :bundle bundle)))))

;;; ---------------------------------------------------------------------------
;;; Hmmm, do we need dispose the function ptrs too?  I'm not sure --bb
;;; (:parameter darwin-interface) The interface to dispose
;;; (:returns) nil
;;; ---------------------------------------------------------------------------
(defmethod dispose-darwin-interface ((darwin-interface darwin-interface))
  (if (bundle darwin-interface)
    (#_CFRelease (bundle darwin-interface)))
  (setf (slot-value darwin-interface 'read) nil
        (slot-value darwin-interface 'open) nil
        (slot-value darwin-interface 'close) nil
        (slot-value darwin-interface 'host) nil
        (slot-value darwin-interface 'fclose) nil
        (slot-value darwin-interface 'fopen) nil
        (slot-value darwin-interface 'fwrite) nil
        (slot-value darwin-interface 'cd) nil
        (slot-value darwin-interface 'bundle) nil))

;;; ---------------------------------------------------------------------------
;;; Get the string hostname of the current machine, (adapted from Gary Byers)
;;; (:parameter darwin-interface) The darwin-interface to use for the call
;;; (:returns) The string of the hostname
;;; ---------------------------------------------------------------------------
(defmethod hostname ((darwin-interface darwin-interface))
  (%stack-block ((buf 512))
    (if (eql 0 (ccl::ppc-ff-call
                (hostname-fn darwin-interface)
                :address buf
                :unsigned-fullword 512
                :signed-fullword))
      (%get-cstring buf))))


;;; ---------------------------------------------------------------------------
;;; see man chdir(2) changes the current working directory
;;; (:parameter darwin-interface) the interface to use.
;;; (:parameter path) The path of the directory to cd to
;;; (:returns) zero if sucessful
;;; ---------------------------------------------------------------------------
(defmethod chdir ((darwin-interface darwin-interface) (path string))
  (ccl::with-cstr (c-path path)
    (ccl::ppc-ff-call (chdir-fn darwin-interface)
                      :address c-path
                      :signed-fullword)))


(defmethod bsd-path-to-mac ((path string))
  (let ((real-path (substitute #\: #\/ path)))
    (if (not (eq (elt real-path (1- (length path))) #\:))
      (setf real-path (concatenate 'string real-path ":")))
    (if (eq (elt real-path 0) #\:)
      (if (string-equal (subseq real-path 0 8) ":volumes")
        (subseq real-path 9)
        (concatenate 'string (namestring (ccl::boot-directory)) 
                     (subseq real-path 1)))
      (concatenate 'string (namestring (ccl::mac-default-directory))
                   real-path))))

;;; Note, this really ought to set-mac-default-directory, but I don't want
;;; to write the code to translate *BSD paths to Mac...
(defmacro cd (dir)
  `(let* ((di (create-darwin-interface))
          (res (chdir di ,dir)))
     (if (zerop res) 
       (progn 
         ,dir
         (set-mac-default-directory (bsd-path-to-mac ,dir)))
       nil)))

(defmacro ls (&key (args "") (stream *standard-output*)) 
  `(progn
     (format ,stream "~A" (system-command (concatenate 'string "ls " ,args)))
     nil))



;;; ---------------------------------------------------------------------------
;;; see man fopen(3)
;;; (:parameter darwin-interface) The interface to call on
;;; (:parameter path) The path to the file (Un*x style)
;;; (:parameter mode) The mode to open the file (see the man page)
;;; (:returns) The file pointer (or zero if there's an error)
;;; ---------------------------------------------------------------------------
(defmethod fopen ((darwin-interface darwin-interface) (path string) (mode string))
  (with-cstrs ((c-path path)
               (c-mode mode))
    (ccl::ppc-ff-call (fopen-fn darwin-interface)
                      :address c-path
                      :address c-mode
                      :unsigned-fullword)))

;;; ---------------------------------------------------------------------------
;;; see man fclose(3)
;;; (:parameter darwin-interface) the interface to call on
;;; (:parameter fp) The file pointer to close
;;; (:returns) zero if everything's cool, errno otherwise.
;;; ---------------------------------------------------------------------------
(defmethod fclose ((darwin-interface darwin-interface) fp)
  (ccl::ppc-ff-call (fclose-fn darwin-interface)
                    :unsigned-fullword fp
                    :signed-fullword))

;;; ---------------------------------------------------------------------------
;;; see man popen(3)  
;;; (:parameter darwin-interface) the interface to call on
;;; (:parameter command) is a Lisp string
;;; (:returns) an integer/FILE*, geez doesn't anyone know Un*x anymore?
;;; ---------------------------------------------------------------------------
(defmethod popen ((darwin-interface darwin-interface) (command string))
  (ccl::with-cstrs  ((read "r")
                     (cmd command))
    (ccl::ppc-ff-call
     (popen-fn darwin-interface)
     :address cmd
     :address read
     :address)))

;;; ---------------------------------------------------------------------------
;;; see man fwrite(3)
;;; (:parameter darwin-interface) the interface to call on
;;; (:parameter fp) the FILE* to write to
;;; (:parameter seq) the sequence of bytes to write
;;; (:parameter length) the length of the bytes to write
;;; (:returns) the number of bytes written
;;; ---------------------------------------------------------------------------
(defmethod fwrite ((darwin-interface darwin-interface) (fp integer) (seq sequence) (length integer))
  (fwrite darwin-interface (ccl::%int-to-ptr fp) seq length))

(defmethod fwrite ((darwin-interface darwin-interface) (fp macptr) (seq sequence) (length integer))
  (%stack-block ((buff length))
    (loop for i from 0 to (1- length)
          do (ccl::%put-byte buff (elt seq i) i))
    (ccl::ppc-ff-call (fwrite-fn darwin-interface)
                      :address buff
                      :unsigned-fullword 1
                      :unsigned-fullword length
                      :address fp
                      :signed-fullword)))

  ;;; ---------------------------------------------------------------------------
;;; see man fread(3)
;;; (:parameter darwin-interface) the interface to call on
;;; (:parameter fp) the pointer to the file from which to read.
;;; (:parameter seq) the sequence to read into
;;; (:parameter length) the number of bytes to read
;;; (:returns) the number of bytes read
;;; ---------------------------------------------------------------------------
(defmethod fread ((darwin-interface darwin-interface) (fp integer) (seq sequence) (length integer))
  (fread darwin-interface (ccl::%int-to-ptr fp) seq length))

(defmethod fread ((darwin-interface darwin-interface) (fp macptr) (seq sequence) (length integer))
  (%stack-block ((buf length))
    (let ((size (ccl::ppc-ff-call
                 (fread-fn darwin-interface)
                 :address buf
                 :unsigned-fullword 1
                 :unsigned-fullword length
                 :address fp
                 :signed-fullword)))
      (if (> size 0)
        (loop for i from 0 to (1- size)
              do (setf (elt seq i) (%get-byte buf i))))
      size)))


;;; ---------------------------------------------------------------------------
;;; see man fread(3)
;;; (:parameter darwin-interface) the interface to call on
;;; (:parameter fp) the pointer to the file from which to read.
;;; (:parameter max-length) the maximum number of chars to read
;;; (:returns) the string (or nil if zero chars are read or EOF)
;;; ---------------------------------------------------------------------------

(defmethod fread-string ((darwin-interface darwin-interface) fp &key (max-length 512))
  (let* ((result-seq (make-sequence '(vector (unsigned-byte 8)) max-length))
         (size (fread darwin-interface fp result-seq max-length))
         (result-string (make-sequence 'string size)))
    (loop for i from 0 to (1- size)
          do (setf (elt result-string i) (code-char (elt result-seq i))))
    (if (zerop size) nil result-string)))
    

;;; ---------------------------------------------------------------------------
;;; see man pclose(3)
;;; (:parameter darwin-interface) the darwin-interface to call on
;;; (:parameter fp) the file pointer to close
;;; (:returns) zero if everything is cool, -1 otherwise
;;; ---------------------------------------------------------------------------
(defmethod pclose ((darwin-interface darwin-interface) fp)
  (ccl::ppc-ff-call
   (pclose-fn darwin-interface)
   :address fp
   :signed-fullword))

;;; ---------------------------------------------------------------------------
;;; run a shell command
;;; (:parameter darwin-interface) the interface to run on
;;; (:parameter command) the shell command to run
;;; ---------------------------------------------------------------------------
(defmethod run-shell ((darwin-interface darwin-interface) (command string) 
                      &optional (mac-line-feeds? t))
  (let ((fp (popen darwin-interface command))
        (result ""))
    (when (not (%null-ptr-p fp))
      (let ((str (fread-string darwin-interface fp)))
        (loop while str
              do (setf result (concatenate 'string result str))
              do (setf str (fread-string darwin-interface fp)))
      (pclose darwin-interface fp)))
    (if mac-line-feeds?
      (substitute #\newline #\linefeed result)
      result)))

;;; ---------------------------------------------------------------------------
;;; while utilizing a darwin-interface do ...
;;; (:parameter darwin-interface) the name of the local darwin-interface
;;; (:parameter body) the code to execute
;;; (:returns) whatever (body) returns.
;;; ---------------------------------------------------------------------------
(defmacro with-darwin-interface (darwin-interface &body body)
  `(unwind-protect 
     (progn
       (setf ,darwin-interface (create-darwin-interface))
       ,@body)
     (dispose-darwin-interface ,darwin-interface)))

;;; ---------------------------------------------------------------------------
;;; simple utility for running shell commands
;;; *note, this shouldn't be called repeatedly, use with-darwin-interface 
;;; instead.
;;; (:parameter string) the command to run
;;; (:parameter mac-line-feeds :optional t) convert \n to \r in the result
;;; (:returns) the string read.
;;; ---------------------------------------------------------------------------

(defun system-command (string &optional (mac-line-feeds? t))
  (let ((system nil))
    (unwind-protect 
      (progn
        (setf system (create-darwin-interface))
        (run-shell system string mac-line-feeds?))
      (dispose-darwin-interface system))))

#+Why
(defmacro system-command (string &optional (mac-line-feeds? t))
  (let ((system (gensym)))
    `(unwind-protect 
       (progn
         (setf ,system (create-darwin-interface))
         (run-shell ,system ,string ,mac-line-feeds?))
       (dispose-darwin-interface ,system))))

;;; ---------------------------------------------------------------------------
;;; utilities 
;;; ---------------------------------------------------------------------------

;;; ---------------------------------------------------------------------------
;;; Load a bundle located somewhere normal.
;;; (e.g. /Frameworks, /Library/Frameworks, ~/Library/Frameworks, etc.
;;; the name should include the ".framework" suffix.
;;; (:parameter framework-name) The name of the framework to load.
;;; (:parameter load-executable :optional t) Load the bundle's executables, (e.g. link it into the current program, you better say yes, if you want to execute any of its functions.
;;; (:returns) A pointer to the bundle (A BundleRef* to be exact)
;;; ---------------------------------------------------------------------------
(defmethod load-framework-bundle ((framework-name string) &key (load-executable t))
  (with-cfstrs ((framework framework-name))
    (let ((err 0)
          (baseURL nil)
          (bundleURL nil)
          (result nil))
      (rlet ((folder :fsref))
        ;; Find the folder holding the bundle
        (setf err (#_FSFindFolder #$kOnAppropriateDisk #$kFrameworksFolderType 
                   t folder))
        
        ;; if everything's cool, make a URL for it
        (when (zerop err)
          (setf baseURL (#_CFURLCreateFromFSRef (%null-ptr) folder))
          (if (%null-ptr-p baseURL) 
            (setf err #$coreFoundationUnknownErr)))
        
        ;; if everything's cool, make a URL for the bundle
        (when (zerop err)
          (setf bundleURL (#_CFURLCreateCopyAppendingPathComponent (%null-ptr) 
                           baseURL framework nil))
          (if (%null-ptr-p bundleURL) 
            (setf err #$coreFoundationUnknownErr)))
        
        ;; if everything's cool, load it
        (when (zerop err)
          (setf result (#_CFBundleCreate (%null-ptr) bundleURL))
          (if (%null-ptr-p result)
            (setf err #$coreFoundationUnknownErr)))
        
        ;; if everything's cool, and the user wants it loaded, load it
        (when (and load-executable (zerop err))
          (if (not (#_CFBundleLoadExecutable result))
            (setf err #$coreFoundationUnknownErr)))
        
        ;; if there's an error, but we've got a pointer, free it and clear result
        (when (and (not (zerop err)) (not (%null-ptr-p result)))
          (#_CFRelease result)
          (setf result nil))
        
        ;; free the URLs if there non-null
        (when (not (%null-ptr-p bundleURL))
          (#_CFRelease bundleURL))
        (when (not (%null-ptr-p baseURL))
          (#_CFRelease baseURL))
        
        ;; return pointer + error value
        (values result err)))))


#| MiniShell.r

/*
	File:		MiniShell.r
	
	Disclaimer:	IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc.
				("Apple") in consideration of your agreement to the following terms, and your
				use, installation, modification or redistribution of this Apple software
				constitutes acceptance of these terms.  If you do not agree with these terms,
				please do not use, install, modify or redistribute this Apple software.

				In consideration of your agreement to abide by the following terms, and subject
				to these terms, Apple grants you a personal, non-exclusive license, under Apple�s
				copyrights in this original Apple software (the "Apple Software"), to use,
				reproduce, modify and redistribute the Apple Software, with or without
				modifications, in source and/or binary forms; provided that if you redistribute
				the Apple Software in its entirety and without modifications, you must retain
				this notice and the following text and disclaimers in all such redistributions of
				the Apple Software.  Neither the name, trademarks, service marks or logos of
				Apple Computer, Inc. may be used to endorse or promote products derived from the
				Apple Software without specific prior written permission from Apple.  Except as
				expressly stated in this notice, no other rights or licenses, express or implied,
				are granted by Apple herein, including but not limited to any patent rights that
				may be infringed by your derivative works or by other works in which the Apple
				Software may be incorporated.

				The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
				WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
				WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
				PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
				COMBINATION WITH YOUR PRODUCTS.

				IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
				CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
				GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
				ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
				OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
				(INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
				ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	Copyright � 1999-2001 Apple Computer, Inc., All Rights Reserved
*/

#include "Types.r"

data 'carb' (0) {
};


resource 'ALRT' (128) {
	{40, 40, 164, 398},
	128,
	{	/* array: 4 elements */
		/* [1] */
		OK, visible, sound1,
		/* [2] */
		OK, visible, sound1,
		/* [3] */
		OK, visible, sound1,
		/* [4] */
		OK, visible, sound1
	},
	alertPositionMainScreen
};

resource 'DITL' (128) {
	{	/* array DITLarray: 2 elements */
		/* [1] */
		{95, 158, 115, 216},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{11, 44, 80, 334},
		StaticText {
			disabled,
			"There was a problem loading the bundle. "
			" Please verify you are running on Mac OS"
			" X."
		}
	}
};


|#


#| MiniShell.c

/*
	File:		MiniShell.c
	
	Disclaimer:	IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc.
				("Apple") in consideration of your agreement to the following terms, and your
				use, installation, modification or redistribution of this Apple software
				constitutes acceptance of these terms.  If you do not agree with these terms,
				please do not use, install, modify or redistribute this Apple software.

				In consideration of your agreement to abide by the following terms, and subject
				to these terms, Apple grants you a personal, non-exclusive license, under Apple�s
				copyrights in this original Apple software (the "Apple Software"), to use,
				reproduce, modify and redistribute the Apple Software, with or without
				modifications, in source and/or binary forms; provided that if you redistribute
				the Apple Software in its entirety and without modifications, you must retain
				this notice and the following text and disclaimers in all such redistributions of
				the Apple Software.  Neither the name, trademarks, service marks or logos of
				Apple Computer, Inc. may be used to endorse or promote products derived from the
				Apple Software without specific prior written permission from Apple.  Except as
				expressly stated in this notice, no other rights or licenses, express or implied,
				are granted by Apple herein, including but not limited to any patent rights that
				may be infringed by your derivative works or by other works in which the Apple
				Software may be incorporated.

				The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
				WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
				WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
				PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
				COMBINATION WITH YOUR PRODUCTS.

				IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
				CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
				GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
				ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
				OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
				(INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
				ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	Copyright � 1999-2001 Apple Computer, Inc., All Rights Reserved
*/

#include <stdio.h>
#include <string.h>


// BSD function prototypes
int	execv( const char *path, char *const argv[] );
typedef int (*execvFuncPtr)( const char*, char **const );

FILE *	 popen(const char *command, const char *type);
typedef FILE *(*BSDpopenFuncPtr)( const char*, const char* );

int	pclose( FILE *stream );
typedef int (*BSDpcloseFuncPtr)( FILE* );

typedef int (*BSDfreadFuncPtr)( void *, size_t, size_t, FILE * );

BSDpopenFuncPtr		BSDpopenFunc;
BSDfreadFuncPtr		BSDfread;
BSDpcloseFuncPtr	BSDpclose;

void	InvokeTool( char *toolName );


static Boolean RunningOnCarbonX(void)
{
    UInt32 response;
    
    return (Gestalt(gestaltSystemVersion, 
                    (SInt32 *) &response) == noErr)
                && (response >= 0x01000);
}


static OSStatus LoadFrameworkBundle(CFStringRef framework, CFBundleRef *bundlePtr)
{
	OSStatus 	err;
	FSRef 		frameworksFolderRef;
	CFURLRef	baseURL;
	CFURLRef	bundleURL;
	
	if ( bundlePtr == nil )	return( -1 );
	
	*bundlePtr = nil;
	
	baseURL = nil;
	bundleURL = nil;
	
	err = FSFindFolder(kOnAppropriateDisk, kFrameworksFolderType, true, &frameworksFolderRef);
	if (err == noErr) {
		baseURL = CFURLCreateFromFSRef(kCFAllocatorSystemDefault, &frameworksFolderRef);
		if (baseURL == nil) {
			err = coreFoundationUnknownErr;
		}
	}
	if (err == noErr) {
		bundleURL = CFURLCreateCopyAppendingPathComponent(kCFAllocatorSystemDefault, baseURL, framework, false);
		if (bundleURL == nil) {
			err = coreFoundationUnknownErr;
		}
	}
	if (err == noErr) {
		*bundlePtr = CFBundleCreate(kCFAllocatorSystemDefault, bundleURL);
		if (*bundlePtr == nil) {
			err = coreFoundationUnknownErr;
		}
	}
	if (err == noErr) {
	    if ( ! CFBundleLoadExecutable( *bundlePtr ) ) {
			err = coreFoundationUnknownErr;
	    }
	}

	// Clean up.
	if (err != noErr && *bundlePtr != nil) {
		CFRelease(*bundlePtr);
		*bundlePtr = nil;
	}
	if (bundleURL != nil) {
		CFRelease(bundleURL);
	}	
	if (baseURL != nil) {
		CFRelease(baseURL);
	}	
	
	return err;
}

static pascal OSErr OpenDocumentsEventHandler( const AppleEvent *appleEvt, AppleEvent* reply, SInt32 refcon )
{
#pragma unused (reply, refcon)
	OSErr		err;
	AEDescList	documents;
	AEKeyword	keyWd;
	FSRef		fsRef;
	char		fullPath[4096];
	long		i, n;
	DescType	typeCd;
	Size		actSz;
	
	AECreateDesc( typeNull, NULL, 0, &documents );		//	Initial state
	
	err = AEGetParamDesc( appleEvt, keyDirectObject, typeAEList, &documents );	//	Get the open parameter
	if ( err != noErr ) goto Bail;
	
	err = AECountItems( &documents, &n );
	if ( err != noErr ) goto Bail;

	for ( i = 1 ; i <= n; i++ )
	{
//		err = AEGetNthPtr( &documents, i, typeFSS, &keyWd, &typeCd, (Ptr) &fileSpec, sizeof(fileSpec), (actSz = sizeof(fileSpec), &actSz) );
		err = AEGetNthPtr( &documents, i, typeFSRef, &keyWd, &typeCd, (Ptr) &fsRef, sizeof(FSRef), (actSz = sizeof(fsRef), &actSz) );
		if  ( err != noErr ) goto Bail;
		
		err	= FSRefMakePath( &fsRef, (UInt8*)fullPath, 4096 );
		if ( err != noErr ) goto Bail;
		
		InvokeTool( fullPath );
	}

Bail:
	AEDisposeDesc( &documents );
	return( err );
}


void main(void)
{
	CFBundleRef 		sysBundle;
	char				command[256];
	OSStatus 			err;
	
	InitCursor();
	
	if ( ! RunningOnCarbonX() )
	{
		(void) Alert( 128, nil );
		return;
	}
	
	err = AEInstallEventHandler( kCoreEventClass, kAEOpenDocuments, NewAEEventHandlerUPP(OpenDocumentsEventHandler), 0, false );

	//	Load the "System.framework" bundle.  Most UNIX/BSD routines are in the System.framework
	err = LoadFrameworkBundle( CFSTR("System.framework"), &sysBundle );
	if (err != noErr) goto Bail;
	
	//	Load the Mach-O function pointers for the routines we will be using.
	BSDfread		= (BSDfreadFuncPtr) CFBundleGetFunctionPointerForName( sysBundle, CFSTR("fread") );
	BSDpopenFunc	= (BSDpopenFuncPtr) CFBundleGetFunctionPointerForName( sysBundle, CFSTR("popen") );
	BSDpclose		= (BSDpcloseFuncPtr) CFBundleGetFunctionPointerForName( sysBundle, CFSTR("pclose") );
	if ( (BSDpopenFunc == nil) || (BSDpclose == nil) || (BSDfread == nil) )
		goto Bail;
	
	//	Print the instructions to the SIOUX window
	printf("LaunchTool\n\n");
	printf("Demonstrates how to run unix tools and shell scripts from a CFM Carbon\n");
	printf("application.  This sample demonstrates how to create a simple\n");
	printf("\"Terminal-like\" shell.  Simply enter unix commands or shell scripts");
	printf("into the SIOUX window and hit enter.  Try some simplecommands like\n");
	printf("\"ps -aux\", \"whoami\", \"ls -la\", or \"banner hello\".\n\n");
	printf("Type command-Q to Quit.\n\n");
	printf("Ewample: moof% whoami\n");
	
	InvokeTool( "whoami" );			//	Call the "whoami" tool
//	InvokeTool( "man popen" );		//	Lets view the man page for "popen()"
	
	do{
		printf("moof% ");
		(void) gets( command );
		InvokeTool( command );
	} while ( true );
		
	Bail:
	;
}


//	This routine does the interesting stuff, specifically the routine popen() loaded into the BSDpopenFunc function pointer
//	effectively does a fork() and execv() and also opens a stream for us to read output from.
void	InvokeTool( char *toolName )
{
	FILE				*fp;
	char				outputS[1024 * 24];						//	24k buffer
	int					bytesRead;
	
	fp = BSDpopenFunc( toolName, "r" );							//	Find out more about "popen()", type "man popen"
	if ( fp == nil ) return;

	bytesRead	= BSDfread( outputS, sizeof(char), sizeof(outputS), fp );	//	stdout gets redirected to this FILE*, stderr still goes to the console
	outputS[bytesRead]	= '\0';
	
	printf( "\"%s\" output: \n%s\n", toolName, outputS );		//	<-- This is the MSL printf

	(void) BSDpclose( fp );										//	Close the FILE stream
}

|#

;;; ***************************************************************************
;;; *                              End of File                                *
;;; ***************************************************************************