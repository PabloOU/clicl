;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (c) Copyright 1997-2005 by Michael Genesereth.  All rights reserved.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *epilog-version* 5.0
  "The value of this variable is the version of Epilog currently loaded.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Arithmetic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun =< (x y) (not (> x y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; List manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro caaaaar (x) `(caaaar (car ,x)))
(defmacro caaaadr (x) `(caaaar (cdr ,x)))
(defmacro caaadar (x) `(caaadr (car ,x)))
(defmacro caaaddr (x) `(caaadr (cdr ,x)))
(defmacro caadaar (x) `(caadar (car ,x)))
(defmacro caadadr (x) `(caadar (cdr ,x)))
(defmacro caaddar (x) `(caaddr (car ,x)))
(defmacro caadddr (x) `(caaddr (cdr ,x)))
(defmacro cadaaar (x) `(cadaar (car ,x)))
(defmacro cadaadr (x) `(cadaar (cdr ,x)))
(defmacro cadadar (x) `(cadadr (car ,x)))
(defmacro cadaddr (x) `(cadadr (cdr ,x)))
(defmacro caddaar (x) `(caddar (car ,x)))
(defmacro caddadr (x) `(caddar (cdr ,x)))
(defmacro cadddar (x) `(cadddr (car ,x)))
(defmacro caddddr (x) `(cadddr (cdr ,x)))
(defmacro cdaaaar (x) `(cdaaar (car ,x)))
(defmacro cdaaadr (x) `(cdaaar (cdr ,x)))
(defmacro cdaadar (x) `(cdaadr (car ,x)))
(defmacro cdaaddr (x) `(cdaadr (cdr ,x)))
(defmacro cdadaar (x) `(cdadar (car ,x)))
(defmacro cdadadr (x) `(cdadar (cdr ,x)))
(defmacro cdaddar (x) `(cdaddr (car ,x)))
(defmacro cdadddr (x) `(cdaddr (cdr ,x)))
(defmacro cddaaar (x) `(cddaar (car ,x)))
(defmacro cddaadr (x) `(cddaar (cdr ,x)))
(defmacro cddadar (x) `(cddadr (car ,x)))
(defmacro cddaddr (x) `(cddadr (cdr ,x)))
(defmacro cdddaar (x) `(cdddar (car ,x)))
(defmacro cdddadr (x) `(cdddar (cdr ,x)))
(defmacro cddddar (x) `(cddddr (car ,x)))
(defmacro cdddddr (x) `(cddddr (cdr ,x)))

(defun append* (l x) (append l (list x)))

(defun nconc* (l x) (nconc l (list x)))

(defun lessp (x y)
  (cond ((numberp x)
         (cond ((numberp y) (< x y))
               ((null y))
               ((or (characterp y) (stringp y) (symbolp y))
                (string< (princ-to-string x) y))))
        ((null x) nil)
        ((or (characterp x) (stringp x) (symbolp x))
         (cond ((numberp y) (string< x (princ-to-string y)))
               ((null y))
               ((or (characterp y) (stringp y) (symbolp y)) (string< x y))))))

(defun greaterp (x y)
  (cond ((numberp x)
         (cond ((numberp y) (> x y))
               ((null y))
               ((or (characterp y) (stringp y) (and y (symbolp y)))
                (string> (princ-to-string x) y))))
        ((null x) nil)
        ((or (characterp x) (stringp x) (and x (symbolp x)))
         (cond ((numberp y) (string> x (princ-to-string y)))
               ((null y))
               ((or (characterp y) (stringp y) (symbolp y)) (string> x y))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Routines for adding to, deleting from, checking lists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun addeq (x l) (if (member x l :test #'eq) l (cons x l)))

(defun addeql (x l) (if (member x l) l (cons x l)))

(defun addequal (x l) (if (member x l :test 'equal) l (cons x l)))


(defun endeq (x l) (if (member x l :test #'eq) l (nconc* l x)))

(defun endeql (x l) (if (member x l) l (nconc* l x)))

(defun endequal (x l) (if (member x l :test 'equal) l (nconc* l x)))


(defmacro delone (x l f)
  `(delete ,x ,l :test ,f :count ,1))

(defmacro delall (x l f)
  `(delete ,x ,l :test ,f))

;;; delq is predefined in allegro


(defmacro remone (x l f)
  `(remove ,x ,l :test ,f :count ,1))

(defmacro remall (x l f)
  `(remove ,x ,l :test ,f))


(defun memp (x l f)
  (do ((l l (cdr l)))
      ((null l) nil)
      (if (funcall f x (car l)) (return (car l)))))

(defun memps (x l f)
  (do ((l l (cdr l)) (nl))
      ((null l) (nreverse nl))
      (if (funcall f x (car l)) (setq nl (cons (car l) nl)))))

(defun amongp (x y f)
  (cond ((funcall f x y))
	((atom y) nil)
	(t (or (amongp x (car y) f) (amongp x (cdr y) f)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Association lists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro dssq (x l)
  `(rassoc ,x ,l :test #'eq))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Property lists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro defprop (x y z)
  `(setf (get ',x ',z) ',y))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Generators
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun generator (l)
  #'(lambda () (prog1 (car l) (setq l (cdr l)))))

(defun getall (g)
  (do ((ans (funcall g) (funcall g)) (nl))
      ((null ans) (nreverse nl))
      (setq nl (cons ans nl))))

(defun getn (g n)
  (do ((i 1 (1+ i)) (ans (funcall g) (funcall g)) (nl))
      ((or (null ans) (> i n)) (nreverse nl))
      (setq nl (cons ans nl))))

(defun andg (g1 g2)
  #'(lambda () (and (funcall g1) (funcall g2))))

;;;; Not good cause g1 checked everytime  Right?

(defun org (g1 g2)
  #'(lambda () (or (funcall g1) (funcall g2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Quotation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro kwote (x)
  (list 'quote x))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Success and Failure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun success (&rest l)
  (declare (ignore l))
  t)

(defun failure (&rest l)
  (declare (ignore l))
  nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; insert, uninsert, sentences, empty
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric insert (p th)
 (:documentation
 "(INSERT P TH)
  INSERT takes a sentence p and a theory TH as arguments.  The default version
  indexes P on all atoms in P (except for NIL and variables) and adds P to the
  contents of TH."))

(defmethod insert (p th)
  (cond ((and (listp p) (eq 'unprovable (car p))) (drop (cadr p) th))
        (t (addcontent p th) (index p p th) p)))

(defgeneric uninsert (p th)
 (:documentation
 "(UNINSERT P TH)
  UNINSERT takes a sentence P and a theory TH as arguments.  The default version
  unindexes P from all atoms in P and removes P from the contents of TH."))

(defmethod uninsert (p th)
  (unindex p p th)
  (remcontent p th)
  p)

(defgeneric empty (th)
 (:documentation
 "(EMPTY (TH)
  EMPTY takes a theory as argument.  It unindexes and removes the contents of
  the specified theory."))

(defmethod empty (th)
  (mapc #'(lambda (x) (clearindex x th)) (contents th))
  (clearcontent th)
  th)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; index, unindex, indexees, clearindex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric index (x d th)
 (:documentation
 "(INDEX X D TH)
  INDEX takes an expression X, a sentence D, and a theory TH as arguments and
indexes D with key X in theory TH."))

(defmethod index (x d th)
  (fullindex x d th))

(defun flatindex (p d th)
  (cond ((atom p) (unless (varp p) (indexatom p d th)))
        (t (dolist (x p)
             (unless (or (listp x) (varp x)) (indexatom x d th))))))

(defun relindex (p d th)
  (cond ((atom p)
         (cond ((varp p))
               (t (indexatom p d th))))
        (t (index (car p) d th))))

(defun fullindex (p d th)
  (cond ((atom p)
         (cond ((varp p))
               (t (indexatom p d th))))
        (t (do ((l p (cdr l)))
               ((atom l))
               (fullindex (car l) d th)))))

(defun indexatom (x d th)
  (setproperty x th (fancyendq d (getproperty x th))))

(defgeneric unindex (x d th)
 (:documentation
 "(UNINDEX X TH)
  UNINDEX takes an expression X, a sentence D, and a theory TH as arguments
  and unindexes D with key X in theory TH."))

(defmethod unindex (x d th)
  (fullunindex x d th))

(defun relunindex (p d th)
  (cond ((atom p)
         (cond ((varp p))
               (t (unindexatom p d th))))
        (t (unindex (car p) d th))))

(defun fullunindex (p d th)
  (cond ((atom p)
         (cond ((null p))
               ((varp p))
               (t (unindexatom p d th))))
        (t (fullunindex (car p) d th)
           (fullunindex (cdr p) d th))))

(defun unindexatom (x d th)
  (let (dum)
    (setq dum (fancydelq d (getproperty x th)))
    (if dum (setproperty x th dum)  ; (fancydelq d (getproperty x th)))
        (remproperty x th))
    d))

(defgeneric clearindex (x th)
 (:documentation
 "(CLEARINDEX X TH)
  CLEARINDEX takes an atom and a theory as arguments and removes all sentences
  indexed under the specified atom in the specified theory."))

(defmethod clearindex (x th)
  (fullclearindex x th))

(defun relclearindex (x th)
  (cond ((atom x) (remproperty x th))
        (t (remproperty (car x) th))))

(defun fullclearindex (x th)
  (cond ((atom x) (remproperty x th))
        (t (fullclearindex (car x) th)
           (fullclearindex (cdr x) th))))

(defgeneric indexees (x th)
 (:documentation
 "(INDEXEES X TH)
  INDEXEES takes an atom and a theory as arguments and returns a list of
  sentences indexed under the specified atom in the specified theory."))

(defmethod indexees (x th)
  (car (getproperty x th)))

(defgeneric indexps (p th)
 (:documentation
 "(INDEXPS P TH)
  INDEXPS takes an expression and a theory as arguments and returns a list of
  sentences stored in the specified theory that could potentially unify with the
  specified expression.  The default version simply calls INDEXEES on the leading
  non-logical constant in P."))

(defmethod indexps (p (th list))
  (declare (ignore p))
  th)

(defmethod indexps (p th)
  (relindexps p th))

(defun relindexps (p th)
  (cond ((null (setq p (operator p))) (contents th))
        ((varp p) (contents th))
        (t (indexees p th))))

(defun flatindexps (p th)
  (cond ((varp p) (contents th))
        ((atom p) (indexees p th))
        (t (do ((l (cdr p) (cdr l)))
               ((null l) (indexps (car p) th))
               (cond ((varp (car l)))
                     ((atom (car l)) (return (indexees (car l) th))))))))

(defun smartindexps (p th)
  (cond ((varp p) (contents th))
        ((atom p) (indexees p th))
        (t (do ((l (cdr p) (cdr l)) (len) (best (car p))
                (size (length (indexees (car p) th))))
               ((null l) (indexps best th))
               (cond ((varp (car l)))
                     ((not (atom (car l))))
                     ((< (setq len (length (indexees (car l) th))) size)
                      (setq best (car l) size len)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Properties
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *mobile* t)

(defparameter *thing* nil)

(defparameter plistarray (make-hash-table :test #'equalp))


(defmethod getproperty ((x symbol) z)
  (get x z))

(defmethod getproperty ((x number) z)
  (if *mobile* (getf (cdr (item x)) z)
      (getf (gethash x plistarray) z)))

(defmethod getproperty ((x string) z)
  (if *mobile* (getf (cdr (item x)) z)
      (getf (gethash x plistarray) z)))

(defmethod getproperty (x z)
  (getf (gethash x plistarray) z))


(defmethod setproperty ((x symbol) z y)
  (setf (get x z) y))

(defmethod setproperty ((x number) z y)
  (if *mobile* (setf (getf (cdr (itemize x)) z) y)
      (setf (getf (gethash x plistarray) z) y)))

(defmethod setproperty ((x string) z y)
  (if *mobile* (setf (getf (cdr (itemize x)) z) y)
      (setf (getf (gethash x plistarray) z) y)))

(defmethod setproperty (x z y)
  (setf (getf (gethash x plistarray) z) y))


(defmethod remproperty ((x symbol) z)
  (remprop x z))

(defmethod remproperty ((x number) z)
  (cond (*mobile*
         (when (setq x (item x))
           (remf (cdr x) z)
           (unless (cdr x) (unitemize (car x)))))
        (t (call-next-method x z))))

(defmethod remproperty ((x string) z)
  (cond (*mobile*
         (when (setq x (item x))
           (remf (cdr x) z)
           (unless (cdr x) (unitemize (car x)))))
        (t (call-next-method x z))))

(defmethod remproperty (x z)
  (remf (gethash x plistarray) z)
  (unless (gethash x plistarray) (remhash x plistarray)))


(defstruct mobile left right key depth)

(defun fathom (x)
  (1+ (max (depth (mobile-left x)) (depth (mobile-right x)))))

(defun depth (x)
  (cond ((mobile-p x) (mobile-depth x))
        (t 0)))

(defun entries (x)
  (cond ((null x) 0)
        ((not (mobile-p x)) 1)
        (t (+ (entries (mobile-left x)) (entries (mobile-right x))))))

(defun balancep (x)
  (cond ((not (mobile-p x)))
        ((> (depth (mobile-left x)) (1+ (depth (mobile-right x)))) nil)
        ((> (depth (mobile-right x)) (1+ (depth (mobile-left x)))) nil)
        ((balancep (mobile-left x)) (balancep (mobile-right x)))))

(defun plagiarize (x)
  (cond ((not (mobile-p x)) x)
        (t (make-mobile :left (plagiarize (mobile-left x))
                         :right (plagiarize (mobile-right x))
                         :key (mobile-key x)
                         :depth (mobile-depth x)))))

(defun mapentries (f x)
  (cond ((not (mobile-p x)) (funcall f x))
        (t (mapentries f (mobile-left x))
           (mapentries f (mobile-right x)))))


(defparameter *strings* nil)

(defmethod itemp ((x string))
  (strindexp x *strings*))

(defmethod item ((x string))
  (strindexee x *strings*))

(defmethod itemize ((x string))
  (let (*thing*)
    (setq *strings* (strindexit x *strings*))
    *thing*))

(defmethod unitemize ((x string))
  (setq *strings* (strunindex x *strings*))
  x)

(defun strindexp (x bt)
  (cond ((listp bt) (equalp x (car bt)))
        ((string-lessp x (mobile-key bt)) (strindexp x (mobile-left bt)))
        (t (strindexp x (mobile-right bt)))))

(defun strindexee (x bt)
  (cond ((listp bt) (when (equalp x (car bt)) bt))
        ((string-lessp x (mobile-key bt)) (strindexee x (mobile-left bt)))
        (t (strindexee x (mobile-right bt)))))

(defun strindexit (x bt)
  (cond ((null bt) (setq *thing* (list x)))
        ((listp bt)
         (cond ((string-equal x (car bt)) (setq *thing* bt))
               ((string-lessp x (car bt))
                (setq *thing* (list x))
                (make-mobile :left *thing* :right bt :key (car bt) :depth 1))
               (t (setq *thing* (list x))
                  (make-mobile :left bt :right *thing* :key x :depth 1))))
        ((string-lessp x (mobile-key bt))
         (setf (mobile-left bt) (strindexit x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (strleft bt))
        (t (setf (mobile-right bt) (strindexit x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (strright bt))))

(defun strindex (x bt)
  (cond ((null bt) (list x))
        ((listp bt)
         (cond ((string-equal x (car bt)) bt)
               ((string-lessp x (car bt))
                (make-mobile :left (list x) :right bt :key (car bt) :depth 1))
               (t (make-mobile :left bt :right (list x) :key x :depth 1))))
        ((string-lessp x (mobile-key bt))
         (setf (mobile-left bt) (strindex x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (strleft bt))
        (t (setf (mobile-right bt) (strindex x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (strright bt))))

(defun strunindex (x bt)
  (cond ((null bt) bt)
        ((listp bt) (unless (string-equal x (car bt)) bt))
        ((and (listp (mobile-left bt)) (string-equal x (car (mobile-left bt))))
         (mobile-right bt))
        ((string-lessp x (mobile-key bt))
         (setf (mobile-left bt) (strunindex x (mobile-left bt)))
         (setf (mobile-depth bt) (fathom bt))
         (strright bt))
        ((and (listp (mobile-right bt)) (string-equal x (car (mobile-right bt))))
         (mobile-left bt))
        (t (setf (mobile-right bt) (strunindex x (mobile-right bt)))
           (setf (mobile-depth bt) (fathom bt))
           (strleft bt))))

(defun strleft (x)
  (let (left right lr)
    (setq left (mobile-left x) right (mobile-right x))
    (cond ((>= (depth right) (1- (depth left))) x)
          ((< (depth right) (depth (mobile-left left)))
           (setf (mobile-left x) (mobile-right left))
           (setf (mobile-right left) x)
           (setf (mobile-depth x) (fathom x))
           (setf (mobile-depth left) (fathom left))
           left)
          (t (setq lr (mobile-right left))
             (setf (mobile-left x) (mobile-right lr))
             (setf (mobile-right lr) x)
             (setf (mobile-right left) (mobile-left lr))
             (setf (mobile-left lr) left)
             (setf (mobile-depth x) (fathom x))
             (setf (mobile-depth left) (fathom left))
             (setf (mobile-depth lr) (fathom lr))
             lr))))

(defun strright (x)
  (let (left right rl)
    (setq left (mobile-left x) right (mobile-right x))
    (cond ((>= (depth left) (1- (depth right))) x)
          ((< (depth left) (depth (mobile-right right)))
           (setf (mobile-right x) (mobile-left right))
           (setf (mobile-left right) x)
           (setf (mobile-depth x) (fathom x))
           (setf (mobile-depth right) (fathom right))
           right)
          (t (setq rl (mobile-left right))
             (setf (mobile-right x) (mobile-left rl))
             (setf (mobile-left rl) x)
             (setf (mobile-left right) (mobile-right rl))
             (setf (mobile-right rl) right)
             (setf (mobile-depth x) (fathom x))
             (setf (mobile-depth right) (fathom right))
             (setf (mobile-depth rl) (fathom rl))
             rl))))


(defparameter *numbers* nil)

(defmethod itemp ((x real))
  (numindexp x *numbers*))

(defmethod item ((x real))
  (numindexee x *numbers*))

(defmethod itemize ((x real))
  (let (*thing*)
    (setq *numbers* (numindexit x *numbers*))
    *thing*))

(defmethod unitemize ((x real))
  (setq *numbers* (numunindex x *numbers*))
  x)

(defun numindexp (x bt)
  (cond ((listp bt) (equal x (car bt)))
        ((< x (mobile-key bt)) (numindexp x (mobile-left bt)))
        (t (numindexp x (mobile-right bt)))))

(defun numindexee (x bt)
  (cond ((listp bt) (when (equal x (car bt)) bt))
        ((< x (mobile-key bt)) (numindexee x (mobile-left bt)))
        (t (numindexee x (mobile-right bt)))))

(defun numindexit (x bt)
  (cond ((null bt) (setq *thing* (list x)))
        ((listp bt)
         (cond ((= x (car bt)) (setq *thing* bt))
               ((< x (car bt))
                (setq *thing* (list x))
                (make-mobile :left *thing* :right bt :key (car bt) :depth 1))
               (t (setq *thing* (list x))
                  (make-mobile :left bt :right *thing* :key x :depth 1))))
        ((< x (mobile-key bt))
         (setf (mobile-left bt) (numindexit x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (numleft bt))
        (t (setf (mobile-right bt) (numindexit x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (numright bt))))

(defun numindex (x bt)
  (cond ((null bt) (list x))
        ((listp bt)
         (cond ((= x (car bt)) bt)
               ((< x (car bt))
                (make-mobile :left (list x) :right bt :key (car bt) :depth 1))
               (t (make-mobile :left bt :right (list x) :key x :depth 1))))
        ((< x (mobile-key bt))
         (setf (mobile-left bt) (numindex x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (numleft bt))
        (t (setf (mobile-right bt) (numindex x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (numright bt))))

(defun numunindex (x bt)
  (cond ((null bt) bt)
        ((listp bt) (unless (= x (car bt)) bt))
        ((and (listp (mobile-left bt)) (= x (car (mobile-left bt)))) (mobile-right bt))
        ((< x (mobile-key bt))
         (setf (mobile-left bt) (numunindex x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (numright bt))
        ((and (listp (mobile-right bt)) (= x (car (mobile-right bt)))) (mobile-left bt))
        (t (setf (mobile-right bt) (numunindex x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (numleft bt))))

(defun numleft (x)
  (let (left right lr)
    (setq left (mobile-left x) right (mobile-right x))
    (cond ((>= (depth right) (1- (depth left))) x)
          ((< (depth right) (depth (mobile-left left)))
           (setf (mobile-left x) (mobile-right left))
           (setf (mobile-right left) x)
           (setf (mobile-depth x) (fathom x))
           (setf (mobile-depth left) (fathom left))
           left)
          (t (setq lr (mobile-right left))
             (setf (mobile-left x) (mobile-right lr))
             (setf (mobile-right lr) x)
             (setf (mobile-right left) (mobile-left lr))
             (setf (mobile-left lr) left)
             (setf (mobile-depth x) (fathom x))
             (setf (mobile-depth left) (fathom left))
             (setf (mobile-depth lr) (fathom lr))
             lr))))

(defun numright (x)
  (let (left right rl)
    (setq left (mobile-left x) right (mobile-right x))
    (cond ((>= (depth left) (1- (depth right))) x)
          ((< (depth left) (depth (mobile-right right)))
           (setf (mobile-right x) (mobile-left right))
           (setf (mobile-left right) x)
           (setf (mobile-depth x) (fathom x))
           (setf (mobile-depth right) (fathom right))
           right)
          (t (setq rl (mobile-left right))
             (setf (mobile-right x) (mobile-left rl))
             (setf (mobile-left rl) x)
             (setf (mobile-left right) (mobile-right rl))
             (setf (mobile-right rl) right)
             (setf (mobile-depth x) (fathom x))
             (setf (mobile-depth right) (fathom right))
             (setf (mobile-depth rl) (fathom rl))
             rl))))



(defparameter *complexes* nil)

(defmethod itemp ((x complex))
  (compindexp x *complexes*))

(defmethod item ((x complex))
  (compindexee x *complexes*))

(defmethod itemize ((x complex))
  (let (*thing*)
    (setq *complexes* (compindexit x *complexes*))
    *thing*))

(defmethod unitemize ((x complex))
  (setq *complexes* (compunindex x *complexes*))
  x)

(defun compindexp (x bt)
  (cond ((listp bt) (equal x (car bt)))
        ((ltp x (mobile-key bt)) (compindexp x (mobile-left bt)))
        (t (compindexp x (mobile-right bt)))))

(defun compindexee (x bt)
  (cond ((listp bt) (when (equal x (car bt)) bt))
        ((ltp x (mobile-key bt)) (compindexee x (mobile-left bt)))
        (t (compindexee x (mobile-right bt)))))

(defun compindexit (x bt)
  (cond ((null bt) (setq *thing* (list x)))
        ((listp bt)
         (cond ((= x (car bt)) (setq *thing* bt))
               ((ltp x (car bt))
                (setq *thing* (list x))
                (make-mobile :left *thing* :right bt :key (car bt) :depth 1))
               (t (setq *thing* (list x))
                  (make-mobile :left bt :right *thing* :key x :depth 1))))
        ((ltp x (mobile-key bt))
         (setf (mobile-left bt) (compindexit x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (compleft bt))
        (t (setf (mobile-right bt) (compindexit x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (compright bt))))

(defun compindex (x bt)
  (cond ((null bt) (list x))
        ((listp bt)
         (cond ((= x (car bt)) bt)
               ((ltp x (car bt))
                (make-mobile :left (list x) :right bt :key (car bt) :depth 1))
               (t (make-mobile :left bt :right (list x) :key x :depth 1))))
        ((ltp x (mobile-key bt))
         (setf (mobile-left bt) (compindex x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (compleft bt))
        (t (setf (mobile-right bt) (compindex x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (compright bt))))

(defun compunindex (x bt)
  (cond ((null bt) bt)
        ((listp bt) (unless (= x (car bt)) bt))
        ((and (listp (mobile-left bt)) (= x (car (mobile-left bt)))) (mobile-right bt))
        ((ltp x (mobile-key bt))
         (setf (mobile-left bt) (compunindex x (mobile-left bt)))
         (setf (mobile-depth bt)
               (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
         (compright bt))
        ((and (listp (mobile-right bt)) (= x (car (mobile-right bt)))) (mobile-left bt))
        (t (setf (mobile-right bt) (compunindex x (mobile-right bt)))
           (setf (mobile-depth bt)
                 (1+ (max (depth (mobile-left bt)) (depth (mobile-right bt)))))
           (compleft bt))))

(defun compleft (x)
  (let (left right lr)
    (setq left (mobile-left x) right (mobile-right x))
    (cond ((>= (depth right) (1- (depth left))) x)
          ((< (depth right) (depth (mobile-left left)))
           (setf (mobile-left x) (mobile-right left))
           (setf (mobile-right left) x)
           (setf (mobile-depth x) (fathom x))
           (setf (mobile-depth left) (fathom left))
           left)
          (t (setq lr (mobile-right left))
             (setf (mobile-left x) (mobile-right lr))
             (setf (mobile-right lr) x)
             (setf (mobile-right left) (mobile-left lr))
             (setf (mobile-left lr) left)
             (setf (mobile-depth x) (fathom x))
             (setf (mobile-depth left) (fathom left))
             (setf (mobile-depth lr) (fathom lr))
             lr))))

(defun compright (x)
  (let (left right rl)
    (setq left (mobile-left x) right (mobile-right x))
    (cond ((>= (depth left) (1- (depth right))) x)
          ((< (depth left) (depth (mobile-right right)))
           (setf (mobile-right x) (mobile-left right))
           (setf (mobile-left right) x)
           (setf (mobile-depth x) (fathom x))
           (setf (mobile-depth right) (fathom right))
           right)
          (t (setq rl (mobile-left right))
             (setf (mobile-right x) (mobile-left rl))
             (setf (mobile-left rl) x)
             (setf (mobile-left right) (mobile-right rl))
             (setf (mobile-right rl) right)
             (setf (mobile-depth x) (fathom x))
             (setf (mobile-depth right) (fathom right))
             (setf (mobile-depth rl) (fathom rl))
             rl))))

(defmethod ltp ((x complex) (y complex))
  (< (realpart x) (realpart y)))


(defun operator (x)
  (cond ((atom x) x)
        ((eq 'unprovable (car x)) (operator (cadr x)))
        ((eq 'not (car x)) (operator (cadr x)))
        ((eq 'or (car x)) (operator (cadr x)))
        ((eq '<= (car x)) (operator (cadr x)))
        ((eq '=> (car x)) (operator (cadr x)))
        (t (operator (car x)))))

(defun argument (x)
  (cond ((atom x) x)
        ((eq 'unprovable (car x)) (argument (cadr x)))
        ((eq 'not (car x)) (argument (cadr x)))
        ((eq 'or (car x)) (argument (cadr x)))
        ((eq '<= (car x)) (argument (cadr x)))
        ((eq '=> (car x)) (argument (cadr x)))
        ((null (cdr x)) (argument (car x)))
        (t (argument (cadr x)))))

(defun arguments (x)
  (cond ((atom x) nil)
        ((eq 'unprovable (car x)) (arguments (cadr x)))
        ((eq 'not (car x)) (arguments (cadr x)))
        ((eq 'or (car x)) (arguments (cadr x)))
        ((eq '<= (car x)) (arguments (cadr x)))
        ((eq '=> (car x)) (arguments (cadr x)))
        (t (cdr x))))

(defun fancyendq (x dl)
  (cond ((null dl) (cons (setq x (list x)) x))
        ((eq x (cadr dl)) dl)
        (t (rplacd (cdr dl) (list x))
           (rplacd dl (cddr dl)))))

(defun fancydelq (x dl)
  (cond ((null dl) nil)
        ((eq x (caar dl)) (if (null (cdar dl)) nil (rplaca dl (cdar dl))))
        (t (do ((l (car dl) (cdr l)))
               ((null (cdr l)) dl)
               (when (eq x (cadr l))
                 (rplacd l (cddr l))
                 (if (null (cdr l)) (rplacd dl l))
                 (return dl))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; addcontent, remcontent, contents, clearcontent, *theories*, theory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *theories* nil
 "*THEORIES* has as value a list of all theories that contain sentences.")

(defclass theory ()
  ((content   :accessor content   :initarg :content   :initform nil)
   (includees :accessor includees :initarg :includees :initform nil)
   (includers :accessor includers :initarg :includers :initform nil)
   (doc       :accessor doc       :initarg :doc       :initform "")))

(defmethod documentation ((th theory) type)
  (declare (ignore type))
  (doc th))

(defmethod (setf documentation) (doc (th theory) type)
  (declare (ignore type))
  (setf (doc th) doc))

(defmethod content ((th symbol))
  (get th 'content))

(defmethod (setf content) (content (th symbol))
  (setf (get th 'content) content))

(defgeneric addcontent (p th)
 (:documentation
 "(ADDCONTENT P TH)
  ADDCONTENT takes a sentence and a theory as arguments and adds the specified
  sentence to the sentences stored in the specified theory, updating the variable
  *THEORIES* appopriately."))

(defmethod addcontent (p th)
  (let ((dum (content th)))
    (cond ((null dum)
           (setq *theories* (cons th *theories*))
           (setf (content th) (cons (setq p (list p)) p)))
          (t (rplacd (cdr dum) (list p))
             (rplacd dum (cddr dum))))
  p))

(defgeneric remcontent (p th)
 (:documentation
 "(REMCONTENT P TH)
  REMCONTENT takes a sentence and a theory as arguments and removes the
  specified sentence from the sentences stored in the specified theory, updating
  the variable *THEORIES* appopriately."))

(defmethod remcontent (p th)
  (if (null (setf (content th) (fancydelq p (content th))))
      (setq *theories* (delete th *theories* :count 1)))
  p)

(defgeneric contents (th)
 (:documentation
 "(CONTENTS TH)
  CONTENTS takes a theory as argument and returns a list of the sentences stored
  in that theory."))

(defmethod contents (th)
  (car (content th)))

(defgeneric clearcontent (th)
 (:documentation
 "(CLEARCONTENT TH)
  CLEARCONTENT takes a theory as argument and removes all sentences stored in
  that theory."))

(defmethod clearcontent (th)
  (setf (content th) nil)
  (setq *theories* (delete th *theories* :count 1))
  th)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; includes, unincludes, includers, includees, decludes
;;; *includers*, *includees*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *includers* nil
 "*INCLUDERS* has as value a list of all theories with included subtheories.
  It is updated by INCLUDES and UNINCLUDES.")

(defgeneric includes (t1 t2)
 (:documentation
 "(INCLUDES T1 T2)
  INCLUDES takes two theories as arguments.  It sets up the knowledge
  base so that the first theory includes the second theory.  The variable
  *INCLUDERS* is updated accordingly."))

(defmethod includes (t1 t2)
  (cond ((includees t1) (setf (includees t1) (endeq t2 (includees t1))))
	(t (setf (includees t1) (list t2))
	   (setq *includers* (cons t1 *includers*))))
  (setf (includers t2) (endeq t1 (includers t2)))
  t)

(defgeneric unincludes (t1 t2)
 (:documentation
 "(UNINCLUDES T1 T2)
  UNINCLUDES takes two theories as arguments.  It modifies the knowledge
  base so that the first theory does not include the second theory.  The
  variable *INCLUDERS* is updated accordingly."))

(defmethod unincludes (t1 t2)
  (cond ((setf (includees t1) (delete t2 (includees t1) :count 1)))
	(t (setq *includers* (delete t1 *includers* :count 1))))
  (setf (includers t2) (delete t1 (includers t2) :count 1))
  t)

(defgeneric decludes (th)
 (:documentation
 "(DECLUDES T1)
  DECLUDES takes a theory as argument and eliminates all of its inclusion
  links.  In effect, it calls UNINCLUDES on each included theory."))

(defmethod decludes (th)
  (do ((l (includees th) (cdr l)))
      ((null l) t)
      (unincludes th (car l))))

(defgeneric includee (th)
 (:documentation
 "(INCLUDEE TH)
  INCLUDEE takes a theory as argument and returns an included theory."))

(defmethod includee ((th list))
  nil)

(defmethod includee ((th symbol))
  (car (get th 'includees)))

(defmethod includee (th)
  (car (includees th)))

(defgeneric includees (th)
 (:documentation
 "(INCLUDEES TH)
  INCLUDEES takes a theory as argument and returns a list of its included
  theories."))

(defmethod includees ((th list))
  nil)

(defmethod includees ((th symbol))
  (get th 'includees))

(defmethod (setf includees) (ths (th symbol))
  (setf (get th 'includees) ths))

(defgeneric includers (th)
 (:documentation
 "(INCLUDERS TH)
  INCLUDERS takes a theory as argument and returns a list of theories that
  include it."))

(defmethod includers ((th symbol))
  (get th 'includers))

(defmethod (setf includers) (ths (th symbol))
  (setf (get th 'includers) ths))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; mapcar-theories, mapappend-theories, mapc-theories
;;; mapcan-theories, mapand-theories, mapor-theories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric mapcar-theories (f th)
 (:documentation
 "(MAPCAR-THEORIES F TH)
  MAPCAR-THEORIES takes as arguments a function and a theory.  It applies
  the function to the theory and calls MAPCAR-THEORIES on the functions and
  the theories included in the specified theory.  It returns a list of the 
  values of these calls to the function."))

(defmethod mapcar-theories (f th)
  (nreverse (mapcar-theoriesdb f th nil)))

(defun mapcar-theoriesdb (f th nl)
  (setq nl (cons (funcall f th) nl))
  (do ((l (includees th) (cdr l)))
      ((null l) nl)
      (setq nl (mapcar-theoriesdb f (car l) nl))))

(defgeneric mapappend-theories (f th)
 (:documentation
 "(MAPAPPEND-THEORIES F TH)
  MAPAPPEND-THEORIES takes as arguments a function and a theory.  It applies
  the function to the theory and calls MAPAPPEND-THEORIES on the functions and
  the theories included in the specified theory.  It merges the values obtained
  in this process using APPEND and returns the result."))

(defmethod mapappend-theories (f th)
  (nreverse (mapappend-theoriesdb f th nil)))

(defun mapappend-theoriesdb (f th nl)
  (setq nl (revappend (funcall f th) nl))
  (do ((l (includees th) (cdr l)))
      ((null l) nl)
      (setq nl (mapappend-theoriesdb f (car l) nl))))

(defgeneric mapcan-theories (f th)
 (:documentation
 "(MAPCAN-THEORIES F TH)
  MAPCAN-THEORIES takes as arguments a function and a theory.  It applies
  the function to the theory and calls MAPCAN-THEORIES on the functions and
  the theories included in the specified theory.  It merges the values obtained
  in this process using NCONC and returns the result."))

(defmethod mapcan-theories (f th)
  (nreverse (mapcan-theoriesdb f th nil)))

(defun mapcan-theoriesdb (f th nl)
  (setq nl (nreconc (funcall f th) nl))
  (do ((l (includees th) (cdr l)))
      ((null l) nl)
      (setq nl (mapcan-theoriesdb f (car l) nl))))

(defgeneric mapc-theories (f th)
 (:documentation
 "(MAPC-THEORIES F TH)
  MAPC-THEORIES takes as arguments a function and a theory.  It applies
  the function to the theory and calls MAPC-THEORIES on the function and
  the theories included in the specified theory.  It returns the specified 
  theory as value."))

(defmethod mapc-theories (f th)
  (funcall f th)
  (do ((l (includees th) (cdr l)))
      ((null l) th)
      (mapc-theories f (car l))))

(defgeneric mapand-theories (f th)
 (:documentation
 "(MAPAND-THEORIES F TH)
  MAPAND-THEORIES takes as argument a function and a theory.  It applies
  the function to the theory.  If the result is NIL, MAPAND-THEORIES
  returns that result as value.  Otherwise, it calls itself recursively on 
  the included theories, halting as soon as it obtains a null value.
  If no null value is found, it returns T."))

(defmethod mapand-theories (f th)
  (cond ((not (funcall f th)) nil)
        (t (do ((l (includees th) (cdr l)))
               ((null l) t)
               (if (null (mapand-theories f (car l))) (return nil))))))

(defgeneric mapor-theories (f th)
 (:documentation
 "(MAPOR-THEORIES F TH)
  MAPOR-THEORIES takes as argument a function and a theory.  It applies
  the function to the theory.  If the result is non-null, MAPOR-THEORIES
  returns that result as value.  Otherwise, it calls itself recursively on 
  the included theories, halting as soon as it obtains a non-null value.
  If no non-null value is found, it returns NIL."))

(defmethod mapor-theories (f th)
  (cond ((funcall f th))
        (t (do ((l (includees th) (cdr l)) (ans))
               ((null l) nil)
               (if (setq ans (mapor-theories f (car l))) (return ans))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; basic.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; These basic subroutines assume they are given ground primitives as args.
;;; They must work correctly for any such args.
;;;
;;; these could prove false even with variables so long as the args are
;;; primitive and the forms do not unify.  But the call does not even get
;;; here when there are variables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defprop word wordp basic)
(defprop constant constp basic)
(defprop indvar indvarpp basic)
(defprop seqvar seqvarpp basic)
(defprop variable varpp basic)

(defun wordp (x)
  (or (numberp x) (stringp x) (characterp x)
      (and (not (atom x)) (eq 'quote (car x)) (atom (cadr x)))))

(defun operatorp (x)
  (if (member x '(quote if cond setof listof execute
                  = /= not and or <= => <=> forall exists
                  defobject deffunction defrelation
                  := :=> :& :conservative-axiom)
              :test #'eq)
      t))

(defun constp (x)
  (or (numberp x) (stringp x) (characterp x)
      (and (not (atom x)) (eq 'quote (car x)) (atom (cadr x))
           (not (operatorp (cadr x))) (not (varp (cadr x))))))

(defun indvarpp (x)
  (and (not (atom x)) (eq 'quote (car x)) (indvarp (cadr x))))

(defun seqvarpp (x)
  (and (not (atom x)) (eq 'quote (car x)) (seqvarp (cadr x))))

(defun varpp (x)
  (and (not (atom x)) (eq 'quote (car x)) (varp (cadr x))))


(defprop id basicval basicval)
(defprop stringify basicval basicval)
(defprop symbolize basicval basicval)
(defprop convertfromstring basicval basicval)
(defprop nomination basicval basicval)
(defprop denotation basicval basicval)

(defun stringify (x)
  (prin1-to-string x))

(defun id (x)
  (prin1-to-string x))

(defun symbolize (s)
  (setq s (string-trim " " s))
  (when (stringp s)
    (nsubstitute #\_ #\space s)
    (nsubstitute #\* #\, s)
    (nsubstitute #\* #\: s)
    (nsubstitute #\* #\' s)
    (nsubstitute #\* #\( s)
    (nsubstitute #\* #\) s)
    (nsubstitute #\* #\\ s)
    (nsubstitute #\* #\" s)
    (convertfromstring s)))

(defun convertfromstring (x)
  (ignore-errors (read-from-string x nil nil)))

(defun nomination (x)
  (cond ((numberp x) x)
        ((characterp x) x)
        ((stringp x) x)
        ((symbolp x) (list 'quote x))))

(defun denotation (x)
  (unquote x))


(defprop integer integerp basic)
(defprop realnumber realp basic)
(defprop complexnumber complexp basic)
(defprop number numberp basic)
(defprop natural naturalp basic)
(defprop rationalnumber rationalp basic)
(defprop positive positivep basic)
(defprop negative negativep basic)
(defprop zero zeropp basic)
(defprop odd oddintegerp basic)
(defprop even evenintegerp basic)
(defprop logbit logbitpp basic) 
(defprop logtest logtest basic) 
(defprop < numlessp basic)
(defprop =< numleqp basic)
(defprop >= numgeqp basic)
(defprop > numgreaterp basic)
(defprop less lessp basic)
(defprop leq leqp basic)

(defun naturalp (x) (and (integerp x) (> x 0)))

(defun positivep (x) (and (realp x) (> x 0)))

(defun negativep (x) (and (realp x) (< x 0)))

(defun zeropp (x) (and (numberp x) (= x 0)))

(defun numlessp (x y) (and (realp x) (realp y) (< x y)))

(defun numgreaterp (x y) (and (realp x) (realp y) (> x y)))

(defun numleqp (x y) (and (realp x) (realp y) (=< x y)))

(defun numgeqp (x y) (and (realp x) (realp y) (>= x y)))

(defun oddintegerp (x) (and (integerp x) (oddp x)))

(defun evenintegerp (x) (and (integerp x) (evenp x)))

(defun logbitpp (x y) (and (integerp x) (integerp y) (logbitp x y)))

(defun logtestp (x y) (and (integerp x) (integerp y) (logtest x y)))


(defun basicval (x)
  (if (every #'primitivep (cdr x)) (ignore-errors (apply (car x) (cdr x)))))

(defun basicvalarith (x)
  (if (every 'numberp (cdr x)) (eval x) 'bottom))

  (defprop * basicvalarith basicval) 
  (defprop + basicvalarith basicval) 
  (defprop - basicvalarith basicval) 
  (defprop / basicvalarith basicval) 
  (defprop 1+ basicvalarith basicval) 
  (defprop 1- basicvalarith basicval) 
  (defprop abs basicvalarith basicval) 
  (defprop acos basicvalarith basicval) 
  (defprop acosh basicvalarith basicval) 
  (defprop ash basicvalarith basicval) 
  (defprop asin basicvalarith basicval) 
  (defprop asinh basicvalarith basicval) 
  (defprop atan basicvalarith basicval) 
  (defprop atanh basicvalarith basicval) 
  (defprop boole basicvalarith basicval) 
  (defprop ceiling basicvalarith basicval) 
  (defprop cis basicvalarith basicval) 
  (defprop complex basicvalarith basicval) 
  (defprop conjugate basicvalarith basicval) 
  (defprop cos basicvalarith basicval) 
  (defprop cosh basicvalarith basicval) 
  (defprop decode-float basicvalarith basicval) 
  (defprop denominator basicvalarith basicval) 
  (defprop exp basicvalarith basicval) 
  (defprop expt basicvalarith basicval) 
  (defprop fceiling basicvalarith basicval) 
  (defprop ffloor basicvalarith basicval) 
  (defprop float basicvalarith basicval) 
  (defprop float-digits basicvalarith basicval) 
  (defprop float-precision basicvalarith basicval) 
  (defprop float-radix basicvalarith basicval) 
  (defprop float-sign basicvalarith basicval) 
  (defprop floor basicvalarith basicval) 
  (defprop fround basicvalarith basicval) 
  (defprop ftruncate basicvalarith basicval) 
  (defprop gcd basicvalarith basicval) 
  (defprop imagpart basicvalarith basicval) 
  (defprop integer-decode-float basicvalarith basicval) 
  (defprop integer-length basicvalarith basicval) 
  (defprop isqrt basicvalarith basicval) 
  (defprop lcm basicvalarith basicval) 
  (defprop log basicvalarith basicval) 
  (defprop logand basicvalarith basicval) 
  (defprop logandc1 basicvalarith basicval) 
  (defprop logandc2 basicvalarith basicval) 
  (defprop logcount basicvalarith basicval) 
  (defprop logeqv basicvalarith basicval) 
  (defprop logior basicvalarith basicval) 
  (defprop lognand basicvalarith basicval) 
  (defprop lognor basicvalarith basicval) 
  (defprop lognot basicvalarith basicval) 
  (defprop logorc1 basicvalarith basicval) 
  (defprop logorc2 basicvalarith basicval) 
  (defprop logxor basicvalarith basicval) 
  (defprop max basicvalarith basicval) 
  (defprop min basicvalarith basicval) 
  (defprop mod basicvalarith basicval) 
  (defprop numerator basicvalarith basicval) 
  (defprop phase basicvalarith basicval) 
  (defprop rational basicvalarith basicval) 
  (defprop rationalize basicvalarith basicval) 
  (defprop realpart basicvalarith basicval) 
  (defprop rem basicvalarith basicval) 
  (defprop round basicvalarith basicval) 
  (defprop scale-float basicvalarith basicval) 
  (defprop signum basicvalarith basicval) 
  (defprop sin basicvalarith basicval) 
  (defprop sinh basicvalarith basicval) 
  (defprop sqrt basicvalarith basicval) 
  (defprop tan basicvalarith basicval) 
  (defprop tanh basicvalarith basicval) 
  (defprop truncate basicvalarith basicval)


(defprop character characterp basic)
(defprop alphabetic alphabeticp basic)
(defprop uppercase uppercasep basic)
(defprop lowercase lowercasep basic)
(defprop digit digitp basic)
(defprop alphanumeric alphanumberp basic)
(defprop chargreater chargreaterp basic)
(defprop charless charlessp basic)

(defun alphabeticp (x)
  (and (characterp x) (alpha-char-p x)))

(defun uppercasep (x)
  (and (characterp x) (upper-case-p x)))

(defun lowercasep (x)
  (and (characterp x) (lower-case-p x)))

(defun digitp (x)
  (and (characterp x) (or (digit-char-p x) (char= #\. x))))

(defun alphanumberp (x)
  (and (characterp x) (alphanumericp x)))

(defun chargreaterp (x y)
  (and (characterp x) (characterp y) (char-greaterp x y)))

(defun charlessp (x y)
  (and (characterp x) (characterp y) (char-lessp x y)))

(defprop charupcase basicval basicval)
(defprop chardowncase basicval basicval)
(defprop charstring basicval basicval)

(defun charupcase (x)
  (if (characterp x) (char-upcase x)))

(defun chardowncase (x)
  (if (characterp x) (char-downcase x)))

(defun charstring (x)
  (if (characterp x) (string x)))


(defprop string stringp basic)
(defprop substring substringp basic)
(defprop stringgreater stringgreaterp basic)
(defprop stringless stringlessp basic)
(defprop stringmatchall stringmatchallp basic)
(defprop stringmatchany stringmatchanyp basic)
(defprop stringmatchphrase stringmatchphrasep basic)

(defun substringp (x y)
  (and (stringp x) (stringp y) (search x y :test #'char-equal)))

(defun stringgreaterp (x y)
  (if (and (stringp x) (stringp y)) (string-greaterp x y)))

(defun stringlessp (x y)
  (if (and (stringp x) (stringp y)) (string-lessp x y)))

(defun stringmatches (pat str)
  (let (result)
    (setq result (coerce (regexec str pat) 'list))
    (if (and result (eql (caar result) 0) (eql (cadar result) (length str)))
        (do ((l result (cdr l)) (nl))
            ((null l) (values-list (nreverse nl)))
            (setq nl (cons (subseq str (caar l) (cadar l)) nl))))))

(defun strmatchp (pat str)
  (do ((i 1 (1+ i)))
      ((or (>= i (length pat)) (>= i (length str)))
       (= (length pat) (length str)))
      (cond ((char= (elt pat i) #\*))
            ((char-equal (elt pat i) (elt str i)))
            (t (return nil)))))

(defun stringmatchanyp (pat str)
  (some #'(lambda (s) (substringp s str)) (strwords pat)))

(defun stringmatchallp (pat str)
  (every #'(lambda (s) (substringp s str)) (strwords pat)))

(defun stringmatchphrasep (pat str)
  (setq pat (strwords pat))
  (do ((pos 0) (len (length str)))
      ((>= pos len) nil)
      (cond ((nonalphanumericp #\a (elt str pos)) (setq pos (1+ pos)))
            ((startphrasep pat str pos) (return t))
            ((setq pos (position #\a str :start pos :test #'nonalphanumericp)))
            (t (return nil)))))

(defun startphrasep (words str pos)
  (cond ((null words))
        (t (do ((len (length str)))
               ((>= pos len) nil)
               (cond ((nonalphanumericp #\a (elt str pos)) (setq pos (1+ pos)))
                     ((and (initstringp (car words) str pos)
                           (startphrasep (cdr words) str (+ pos (length (car words)))))
                      (return t))
                     (t (return nil)))))))

(defun initstringp (s1 s2 start)
  (do ((pos 0 (1+ pos)) (len1 (length s1)) (len2 (length s2)))
      ((>= pos len1) t)
      (cond ((>= start len2) (return nil))
            ((char-equal (elt s1 pos) (elt s2 start))
             (setq start (1+ start)))
            (t (return nil)))))

(defun strwords (s)
  (do ((pos 0) (len (length s)) (dum) (nl))
      ((>= pos len) (nreverse nl))
      (cond ((nonalphanumericp #\a (elt s pos)) (setq pos (1+ pos)))
            ((setq dum (position #\a s :start pos :test #'nonalphanumericp))
             (setq nl (cons (subseq s pos dum) nl) pos dum))
            (t (return (nreverse (cons (subseq s pos len) nl)))))))

(defun nonalphanumericp (x y)
  (declare (ignore x))
  (not (alphanumericp y)))


(defprop stringalphanumeric basicval basicval)
(defprop stringappend basicval basicval)
(defprop stringcapitalize basicval basicval)
(defprop stringcharpos basicval basicval)
(defprop stringdowncase basicval basicval)
(defprop stringelement basicval basicval)
(defprop stringlength basicval basicval)
(defprop stringposition basicval basicval)
(defprop stringsubleft basicval basicval)
(defprop stringsubright basicval basicval)
(defprop stringsubseq basicval basicval)
(defprop stringsubstitute basicval basicval)
(defprop stringupcase basicval basicval)

(defun stringlength (s)
  (if (stringp s) (length s)))

(defun stringelement (s n)
  (if (and (stringp s) (integerp n) (>= n 0) (<= n (length s)))
      (elt s (1- n))))

(defun stringsubseq (s beg end)
  (if (and (stringp s) (integerp beg) (>= beg 0) (<= beg (length s))
           (integerp end) (>= end 0) (<= end (length s)) (<= beg end))
      (subseq s (1- beg) end)))

(defun stringalphanumeric (s)
  (if (stringp s) (remove-if-not #'alphanumericp s)))

(defun stringcharpos (c s)
  (if (and (characterp c) (stringp s)
           (setq c (position c s :test #'char-equal)))
      (1+ c)))

(defun stringposition (s1 s2)
  (if (and (stringp s1) (stringp s2)
           (setq s1 (search s1 s2 :test #'string-equal)))
      (1+ s1)))

(defun stringappend (&rest sl)
  (do ((l sl (cdr l)) (dum) (nl))
      ((null l) (apply 'concatenate 'string (nreverse nl)))
      (setq dum (if (stringp (car l)) (car l) (princ-to-string (car l))))
      (setq nl (cons dum nl))))

(defun strappend (&rest sl)
  (apply #'stringappend sl))
 
(defun stringsubleft (z x)
  (when (startstringp x z) (subseq z (length x))))
 
(defun stringsubright (z y)
  (when (endstringp y z) (subseq z 0 (- (length z) (length y)))))

(defun startstringp (s1 s2)
  (declare (type string s1 s2))
  (let ((dum (mismatch s1 s2 :test #'char-equal)))
    (cond ((not dum))
          (t (>= dum (length s1))))))

(defun endstringp (y z)
  (equal (mismatch y z :test #'char-equal :from-end t) 0))

(defun stringsubstitute (c1 c2 s)
  (if (and (characterp c1) (characterp c2) (stringp s))
      (substitute c1 c2 s)))

(defun stringupcase (x)
  (if (stringp x) (string-upcase x)))

(defun stringdowncase (x)
  (if (stringp x) (string-downcase x)))

(defun stringcapitalize (x)
  (if (stringp x) (string-capitalize x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; match.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; This file contains various pattern matchers
;;;   differ in type of binding list
;;;   differ in degree of matching
;;; 
;;; All matchers 
;;;   work on atoms and lists (with @variables occurring in last position only)
;;;   handle quote
;;;   treat variables as free, i.e. quantifiers are ignored
;;;
;;; Implementation note:
;;;   The simple binding list matchers all assume that they are the only ones
;;;   creating their binding lists.  For example, code for MATCHP assumes that
;;;   variables cannot be bound to expressions containing variables with 
;;;   bindings on alist that we want to pursue.  By contrast, the various 
;;;   matchers that work with complex binding lists do not make this assumption.
;;;   They allow that their input binding lists may be arbitrarily complex.
;;;
;;;   Also matchers with complex binding lists assume that variables in their
;;;   distinct arguments are distinct, unless the alist arguments are the same.
;;;   Consequence (IDENTIFY '(P ?X) AL '(P ?X) BL) --> NIL if AL and BL not EQ.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special traceexpressions alist)))

(defconstant truth '((t . t)))

(defvar *occurcheck* t
 "*OCCURCHECK* determines whether or not various matchers, in considering the
  binding of a variable to a term, first check for occurrences of the variable
  in the term.  The default value is T.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; QUOTIFY assumes its argument is ground
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun quotify (x)
  (cond ((numberp x) x)
        ((characterp x) x)
        ((stringp x) x)
        (t (list 'quote x))))

(defun kwotify (x)
  (cond ((numberp x) x)
        ((characterp x) x)
        ((stringp x) x)
        ((member x '(t nil)) x)
        (t (list 'kwote x))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; UNQUOTE assumes its argument is ground
;;; NB: the value returned may not be ground
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun unquote (x)
  (cond ((numberp x) x)
        ((stringp x) x)
        ((characterp x) x)
        ((atom x) nil)
        ((eq 'quote (car x)) (cadr x))
        ((eq 'listof (car x)) (mapcar 'unquote (cdr x)))))

(defmethod varp (x)
 "(VARP X)
  VARP takes any object as argument and returns T if and only if the
  object is a variable."
  (and (symbolp x)
       (setq x (char (symbol-name x) 0))
       (or (eql #\? x) (eql #\@ x))))

(defmethod indvarp (x)
 "(INDVARP X)
  INDVARP takes any object as argument and returns T if and only if the
  object is an individual variable."
  (and (symbolp x) (eql #\? (char (symbol-name x) 0))))

(defmethod seqvarp (x)
 "(SEQVARP X)
  SEQVARP takes any object as argument and returns T if and only if the
  object is a sequence variable."
  (and (symbolp x) (eql #\@ (char (symbol-name x) 0))))

; UPDATED
(defun newindvar () (gentemp "?"))
(defun newseqvar () (gentemp "@"))
(defun newskolem2 () (gentemp "sk"))

;(defun newindvar () (gensym "?"))

;(defun newseqvar () (gensym "@"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (identp x y)
;;;    determines whether x and y are equal but handles quote
;;;    if success, returns t
;;;    if failure, returns nil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TLH: changed equalp to equal to make identp case sensitive
(defmethod identp (x y)
 "(IDENTP X Y)
  IDENTP takes two expressions as arguments and checks whether they are 
  meta-equal.  IDENTP returns T if the check is successful, and it
  returns NIL otherwise."
  (cond ((atom x) (cond ((atom y) (equal x y))  ; TLH change
                        ((eq 'quote (car y)) (descriptionp x (cadr y)))))
	((eq 'quote (car x)) (descriptionp y (cadr x)))
	((eq 'listof (car x)) (identplist x y))
	(t (cond ((atom y) nil)
                 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
		 (t (mapand 'identp x y))))))

(defun identplist (x y)
  (cond ((atom y) nil)
        ((eq 'quote (car y)) (mapand 'descriptionp (cdr x) (cadr y)))
        ((eq 'listof (car y)) (mapand 'identp (cdr x) (cdr y)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (descriptionp x y)
;;;    determines whether x is a description of y
;;;    equivalent to evaluating x and checking for equality with y 
;;;    but cheaper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun descriptionp (x y)
  (cond ((atom x) (if (or (numberp x) (stringp x) (characterp x)) (equalp x y)))
	((eq 'quote (car x)) (equalp (cadr x) y))
	((eq 'listof (car x))
         (cond ((not (listp y)) nil)
               (t (mapand 'descriptionp (cdr x) y))))))

(defun mapand (p l m)
  (do ()
      (nil)
      (cond ((null l) (return (null m)))
            ((null m) (return nil))
            ((funcall p (car l) (car m)) (setq l (cdr l) m (cdr m)))
            (t (return nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (samep x y) 
;;;    determines whether x and y are same up to variable renaming
;;;    if success, returns t
;;;    if failure, returns nil
;;;    knows about quote
;;;
;;; NB: binds vars to selves, including seqvars (therefore not bound to lists)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod samep (x y)
 "(SAMEP X Y)
  SAMEP takes two expressions as arguments and checks whether they have the
  same structure, i.e. they are meta-equal after variable renaming.
  SAMEP returns T if the check is successful, and it returns NIL otherwise."
  (if (samepexp x y truth) t))

(defmethod samelist (x y)
 "(SAMELIST X Y)
  SAMELIST takes two expressions as arguments and checks whether they have the
  same structure, i.e. they are meta-equal after variable renaming.
  SAMELIST returns a list of variable bindings, if the check is successful;
  and it returns NIL otherwise."
  (samepexp x y truth))

(defun samepexp (x y al)
  (cond ((indvarp x) (if (indvarp y) (samepvar x y al)))
        ((seqvarp x) (if (seqvarp y) (samepvar x y al)))
	((atom x) (cond ((atom y) (if (equalp x y) al))
                        ((eq 'quote (car y)) (if (descriptionp x (cadr y)) al))))
	((eq 'quote (car x)) (if (descriptionp y (cadr x)) al))
        ((eq 'listof (car x)) (sameplist x y al))
	(t (cond ((atom y) nil)
		 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
                 (t (samepexpexp x y al))))))

(defun samepvar (x y al)
  (let (dum)
    (cond ((setq dum (assoc x al :test #'eq)) (if (eq (cdr dum) y) al))
	  ((setq dum (dssq y al)) nil)
	  (t (acons x y al)))))

(defun sameplist (x y al)
  (cond ((atom y) nil)
        ((eq 'quote (car y)) (if (mapand 'descriptionp (cdr x) (cadr y)) al))
        ((eq 'listof (car y)) (samepexpexp (cdr x) (cdr y) al))))

(defun samepexpexp (l m al)
  (do ((l l (cdr l)) (m m (cdr m)))
      (nil)
      (cond ((null l) (return (if (null m) al)))
            ((null m) (return nil))
            ((setq al (samepexp (car l) (car m) al)))
            (t (return nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (instp x y)
;;;     determines whether x is an instance of y
;;;     if success, returns alist
;;;     if failure, returns nil
;;;     knows about quote
;;;
;;; (matchp x y)
;;;     reverse of instp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod instp (x y)
 "(INSTP X Y)
  INSTP takes two expressions as arguments and checks whether the first
  expression is an instance of the second, i.e. whether there is a set of
  variable bindings that, when substituted into the second expression,   
  produces an expression meta-equal to the first expression.
  INSTP returns T if the check is successful, and it returns NIL otherwise."
  (if (matchpexp y x truth) t))

(defmethod instantiator (x y)
 "(INSTANTIATOR X Y)
  INSTANTIATOR takes two expressions as arguments and checks whether the first
  expression is an instance of the second, i.e. whether there is an alist of
  variable bindings that, when substituted into the second expression,   
  produces an expression meta-equal to the first expression.  If there is
  such an alist, it is returned as result; otherwise, the result is NIL."
  (matchpexp y x truth))

(defmethod matchp (x y)
 "(MATCHP X Y)
  MATCHP takes two expressions as arguments and checks whether the second
  expression is an instance of the first, i.e. whether there is a set of
  variable bindings that, when substituted into the first expression,   
  produces an expression meta-equal to the second expression.
  MATCHP returns T if the check is successful, and it returns NIL otherwise."
  (if (matchpexp x y truth) t))

(defmethod matcher (x y)
 "(MATCHER X Y)
  MATCHER takes two expressions as arguments and checks whether the second
  expression is an instance of the first, i.e. whether there is an alist of
  variable bindings that, when substituted into the first expression,   
  produces an expression meta-equal to the second expression.  If there is
  such an alist, it is returned as result; otherwise, the result is NIL."
  (matchpexp x y truth))

(defun matchpexp (x y al)
  (cond ((indvarp x) (matchpindvar x y al))
	((atom x) (cond ((atom y) (if (equalp x y) al))
                        ((eq 'quote (car y)) (if (descriptionp x (cadr y)) al))))
	((eq 'quote (car x)) (if (descriptionp y (cadr x)) al))
        ((eq 'listof (car x)) (matchplist x y al))
	(t (cond ((atom y) nil)
		 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
		 (t (matchpexpexp x y al))))))

(defun matchpindvar (x y al)
  (let (dum)
       (cond ((eq x '?*) al)
             ((setq dum (assoc x al :test #'eq)) (if (identp (cdr dum) y) al))
	     (t (acons x y al)))))

(defun matchpseqvar (x l al)
  (let (dum)
       (cond ((eq x '@*) al)
             ((setq dum (assoc x al :test #'eq))
              (if (mapand 'identp (cdr dum) l) al))
	     (t (acons x l al)))))

(defun matchplist (x y al)
  (cond ((atom y) nil)
        ((eq 'quote (car y)) (matchpdescriptionplist (cdr x) (cadr y) al))
        ((eq 'listof (car y)) (matchpexpexp (cdr x) (cdr y) al))))

(defun matchpexpexp (l m al)
  (do ((l l (cdr l)) (m m (cdr m)))
      (nil)
      (cond ((null l) (return (if (null m) al)))
            ((seqvarp (car l)) (return (matchpseqvar (car l) m al)))
            ((null m) (return nil))
            ((setq al (matchpexp (car l) (car m) al)))
            (t (return nil)))))

(defun matchpdescriptionpexp (x y al)
  (cond ((indvarp x) (matchpdescriptionpindvar x y al))
        ((atom x) (if (and (or (numberp x) (stringp x) (characterp x))
                           (equalp x y))
                      al))
	((eq 'quote (car x)) (if (equalp (cadr x) y) al))
	((eq 'listof (car x)) (matchpdescriptionplist (cdr x) y al))))

(defun matchpdescriptionpindvar (x y al)
  (cond ((eq x '?*) al)
        ((assoc x al :test #'eq)
         (if (descriptionp (cdr (assoc x al :test #'eq)) y) al))
	(t (acons x (quotify y) al))))

(defun matchpdescriptionpseqvar (x l al)
  (cond ((eq x '@*) al)
        ((assoc x al :test #'eq)
         (if (mapand 'descriptionp (cdr (assoc x al :test #'eq)) l) al))
	(t (acons x (mapcar 'quotify l) al))))

(defun matchpdescriptionplist (x y al)
  (cond ((not (listp y)) nil)
        (t (do ((l x (cdr l)) (m y (cdr m)))
               (nil)
               (cond ((null l) (return (if (null m) al)))
                     ((seqvarp (car l)) 
                      (return (matchpdescriptionpseqvar (car l) m al)))
                     ((null m) (return nil))
                     ((setq al (matchpdescriptionpexp (car l) (car m) al)))
                     (t (return nil)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (mgup p q)
;;;    determines whether p and q are unifiable with common variables
;;;    uses single, simple alist
;;;    if success, returns alist
;;;    if failure, returns nil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TLH: added optional mgu argument 
(defmethod mgup (p q &optional (mymgu truth))
 "(MGUP X Y)
  MGUP takes two expressions as arguments and checks whether they are 
  meta-unifiable.  MGUP returns T if the check is successful, and it
  returns NIL otherwise."
  (if (mguexp p q mymgu) t))

; TLH: added optional mgu argument 
; Note: don't trace mgu in Aquamacs or things go haywire.  ?!?
(defmethod mgu (x y &optional (mymgu truth))
 "(MGU X Y)
  MGU takes two expressions as arguments and checks whether they are 
  meta-unifiable.  MGU returns the unifier if the check is successful,
  and it returns NIL otherwise."
  (mguexp x y mymgu))

(defun mguexp (x y al)
  (cond ((eq x y) al)
	((indvarp x) (mguindvar x y al))
	((atom x)
         (cond ((indvarp y) (mguindvar y x al))
               ((atom y) (if (equalp x y) al))
               ((eq 'quote (car y)) (mgudescriptionpexp x (cadr y) al))))
	((eq 'quote (car x)) (mgudescriptionpexp y (cadr x) al))
        ((eq 'listof (car x)) (mgulist x y al))
	(t (cond ((indvarp y) (mguindvar y x al))
		 ((atom y) nil)
		 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
		 (t (mguexpexp x y al))))))

(defun mguindvar (x y al)
  (let (dum)
    (cond ((setq dum (assoc x al :test #'eq)) (mguexp (cdr dum) y al))
          ((eq x (setq y (mguindval y al))) al)
	  ((and *occurcheck* (mguchkp x y al)) nil)
          (t (acons x y al)))))

(defun mguindval (x al)
  (let (dum)
    (cond ((and (varp x) (setq dum (assoc x al :test #'eq))) (mguindval (cdr dum) al))
          (t x))))

(defun mguseqvar (x l al)
  (let (dum)
    (cond ((setq dum (assoc x al :test #'eq)) (mguexpexp (cdr dum) l al))
          ((eq x (car (setq l (mguseqval l al)))) al)
	  ((and *occurcheck* (mguchkplist x l al)) nil)
          (t (acons x l al)))))

(defun mguseqval (l al)
  (let (dum)
    (cond ((and (varp (car l)) (setq dum (assoc (car l) al :test #'eq)))
           (mguseqval (cdr dum) al))
          (t l))))

(defun mguchkp (p q al)
  (cond ((eq p q))
	((indvarp q) (mguchkp p (cdr (assoc q al :test #'eq)) al))
        ((seqvarp q) (mguchkplist p (cdr (assoc q al :test #'eq)) al))
	((atom q) nil)
        ((eq 'quote (car q)) nil)
	(t (mguchkplist p q al))))

(defun mguchkplist (p l al)
  (some #'(lambda (x) (mguchkp p x al)) l))

(defun mgulist (x y al)
  (cond ((indvarp y) (mguindvar y x al))
        ((atom y) nil)
        ((eq 'quote (car y)) (mgudescriptionplist (cdr x) (cadr y) al))
        ((eq 'listof (car y)) (mguexpexp (cdr x) (cdr y) al))))

(defun mguexpexp (l m al)
  (do ((l l (cdr l)) (m m (cdr m)))
      (nil)
      (cond ((null l)
             (cond ((null m) (return al))
                   ((seqvarp (car m)) (return (mguseqvar (car m) nil al)))
                   (t (return nil))))
            ((seqvarp (car l)) (return (mguseqvar (car l) m al)))
            (t (cond ((null m) (return nil))
                     ((seqvarp (car m)) (return (mguseqvar (car m) l al)))
                     ((setq al (mguexp (car l) (car m) al)))
                     (t (return nil)))))))
            
(defun mgudescriptionpexp (x y al)
  (cond ((indvarp x) (mgudescriptionpindvar x y al))
	((atom x) (if (and (or (numberp x) (stringp x) (characterp x))
                           (equalp x y))
                      al))
	((eq 'quote (car x)) (if (equalp (cadr x) y) al))
	((eq 'listof (car x)) (mgudescriptionplist (cdr x) y al))))

(defun mgudescriptionpindvar (x y al)
  (cond ((assoc x al :test #'eq)
         (mgudescriptionpexp (cdr (assoc x al :test #'eq)) y al))
	(t (acons x (quotify y) al))))

(defun mgudescriptionpseqvar (x l al)
  (cond ((assoc x al :test #'eq)
         (mgudescriptionplist (cdr (assoc x al :test #'eq)) l al))
	(t (acons x (mapcar 'quotify l) al))))

(defun mgudescriptionplist (x y al)
  (cond ((not (listp y)) nil)
        (t (do ((l x (cdr l)) (m y (cdr m)))
               (nil)
               (cond ((null l) (return (if (null m) al)))
                     ((seqvarp (car l)) 
                      (return (mgudescriptionpseqvar (car l) m al)))
                     ((null m) (return nil))
                     ((setq al (mgudescriptionpexp (car l) (car m) al)))
                     (t (return nil)))))))


(defun mgwexp (x y al)
  (cond ((eq x y) al)
	((indvarp x) (mgwindvar x y al))
	((atom x)
         (cond ((indvarp y) (mgwindvar y x al))
               ((equalp x y) al)))
	(t (cond ((atom y) nil)
		 (t (mgwexpexp x y al))))))

(defun mgwindvar (x y al)
  (let (dum)
    (cond ((eq x '?*) al)
          ((setq dum (assoc x al :test #'eq)) (mgwexp (cdr dum) y al))
          ((eq x (setq y (mguindval y al))) al)
          (t (acons x y al)))))

(defun mgwexpexp (l m al)
  (do ((l l (cdr l)) (m m (cdr m)))
      ((null l) (if (null m) al))
      (unless (setq al (mgwexp (car l) (car m) al)) (return nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; utility functions for simple alists
;;;
;;; Format: ((var . val) ... (t . t))
;;;    tail ((t . t)) allows return of empty alist without confusion with nil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric plug (x env)
 (:documentation
 "(PLUG X ENV)
  PLUG takes an expression and an alist or environment as arguments, substitutes
  the associated bindings into the expression, and returns the result.  WARNING:
  If the environment is empty, the original expression is returned, i.e. no copy
  is made in this case."))

(defmethod indval (x (al list)) (mguindval x al))

(defmethod plug (x (al list))
  (if (null (cdr al)) x (plugexp x al)))

(defun plugexp (x al)
  (cond ((indvarp x) (plugindvar x al))
	((not (listp x)) x)
	((eq 'quote (car x)) x)
	(t (do ((l x (cdr l)) (nl))
               ((null l) (nreverse nl))
               (if (seqvarp (car l))
                   (return (nreconc nl (plugseqvar (car l) al)))
                   (setq nl (cons (plugexp (car l) al) nl)))))))

(defun plugindvar (x al)
  (let (dum)
    (cond ((setq dum (assoc x al :test #'eq)) (plugexp (cdr dum) al))
          (t x))))

(defun plugseqvar (x al)
  (let (dum)
    (cond ((setq dum (assoc x al :test #'eq)) 
           (mapcar #'(lambda (x) (plugexp x al)) (cdr dum)))
	  (t (list x)))))

(defmethod stdize (x)
 "(STDIZE X)
  STDIZE takes an expression as argument and produces an equivalent 
  expression in which all variables have been given new names."
  (let (alist)
    (stdizeexp x)))

(defun stdizeexp (x)
  (cond ((varp x) (stdizevar x))
	((atom x) x)
	((eq 'quote (car x)) x)
	(t (mapcar 'stdizeexp x))))

(defun stdizevar (x)
  (cond ((eq x '?*) '?*)
        ((eq x '@*) '@*)
        ((cdr (assoc x alist :test #'eq)))
        ((indvarp x) (cdar (setq alist (acons x (newindvar) alist))))
        (t (cdar (setq alist (acons x (newseqvar) alist))))))

(defmethod plugstd (x alist)
  (if (null (cdr alist)) x (plugstdize x)))

(defun plugstdize (x)
  (cond ((indvarp x) (plugstdindvar x))
	((atom x) x)
	((eq 'quote (car x)) x)
	(t (do ((l x (cdr l)) (nl))
               ((null l) (nreverse nl))
               (if (seqvarp (car l))
                   (return (nreconc nl (plugstdseqvar (car l))))
                   (setq nl (cons (plugstdize (car l)) nl)))))))

(defun plugstdindvar (x)
  (cond ((eq x '?*) '?*)
        ((cdr (assoc x alist :test #'eq)))
        (t (cdar (setq alist (acons x (newindvar) alist))))))

(defun plugstdseqvar (x)
  (cond ((eq x '@*) (list '@*))
        ((cdr (assoc x alist :test #'eq)))
        (t (cdar (setq alist (acons x (list (newseqvar)) alist))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (identify x al y bl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod identifyp (x y)
 "(IDENTIFYP X Y)
  IDENTIFYP takes two expressions as arguments and checks whether they are 
  meta-equivalent. IDENTIFYP returns T if the check is successful, and it
  returns NIL otherwise."
 (let ((al (environment)))
   (identify x al y al)))

(defun identify (x al y bl)
  (cond ((and (eq x y) (eq al bl)))
        ((indvarp x) (identifyindvar x al y bl))
	((atom x)
	 (cond ((indvarp y) (identifyindvar y bl x al))
	       ((atom y) (equalp x y))
               ((eq 'quote (car y)) (descriptionize x al (cadr y)))))
	((eq 'quote (car x)) (descriptionize y bl (cadr x)))
        ((eq 'listof (car x)) (identifylist x al y bl))
	(t (cond ((indvarp y) (identifyindvar y bl x al))
		 ((atom y) nil)
		 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
		 (t (identifyexpexp x al y bl))))))

(defun identifyindvar (x al y bl)
  (let (dum)
    (cond ((cddr (setq dum (getbdg x al)))
	   (identify (cadr dum) (cddr dum) y bl))
          ((and (multiple-value-setq (y bl) (unifyindval y bl))
                (eq x y) (eq al bl))))))

(defun identifyseqvar (x al l bl)
  (let (dum)
    (cond ((cddr (setq dum (getbdg x al)))
	   (identifyexpexp (cadr dum) (cddr dum) l bl))
          ((and (multiple-value-setq (l bl) (unifyseqval l bl))
                (eq x (car l)) (eq al bl))))))

(defun identifylist (x al y bl)
  (cond ((indvarp y) (identifyindvar y bl x al))
        ((atom y) nil)
        ((eq 'quote (car y)) (descriptionizelist (cdr x) al (cadr y)))
        ((eq 'listof (car y)) (identifyexpexp (cdr x) al (cdr y) bl))))

(defun identifyexpexp (l al m bl)
  (do ((l l (cdr l)) (m m (cdr m)))
      (nil)
      (cond ((null l)
             (cond ((null m) (return t))
                   ((seqvarp (car m)) (identifyseqvar (car m) bl nil al))
                   (t (return nil))))
            ((seqvarp (car l)) (return (identifyseqvar (car l) al m bl)))
            ((null m) (return nil))
            ((seqvarp (car m)) (return (identifyseqvar (car m) bl l al)))
            ((identify (car l) al (car m) bl))
            (t (return nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (descriptionize x al y bl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun descriptionize (x al y)
  (cond ((indvarp x) (descriptionizeindvar x al y))
	((atom x) (if (or (numberp x) (stringp x) (characterp x)) (equalp x y)))
	((eq 'quote (car x)) (equalp (cadr x) y))
	((eq 'listof (car x)) (descriptionizelist (cdr x) al y))))

(defun descriptionizeindvar (x al y)
  (let (dum)
    (cond ((cddr (setq dum (getbdg x al)))
	   (descriptionize (cadr dum) (cddr dum) y)))))

(defun descriptionizeseqvar (x al l)
  (let (dum)
    (cond ((cddr (setq dum (getbdg x al)))
	   (descriptionizelist (cadr dum) (cddr dum) l)))))

(defun descriptionizelist (x al y)
  (cond ((not (listp y)) nil)
        (t (do ((l x (cdr l)) (m y (cdr m)))
               (nil)
               (cond ((null l) (return (null m)))
                     ((seqvarp (car l)) 
                      (return (descriptionizeseqvar (car l) al m)))
                     ((null m) (return nil))
                     ((descriptionize (car l) al (car m)))
                     (t (return nil)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (matchify x al y bl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod matchifyp (x y)
 "(MATCHIFYP X Y)
  MATCHIFYP takes two expressions as arguments and checks whether they are 
  meta-unifiable.  MATCHIFYP treats the variables in the second expression
  as constants. MATCHIFYP returns T if the check is successful, and it
  returns NIL otherwise."
  (if (matchify x (environment) y (environment)) t))

(defun matchify (x al y bl)
  (let ((alist truth))
    (cond ((matchifyexp x al y bl) alist)
	  (t (backup alist)))))

(defun matchifyexp (x al y bl)
  (cond ((and (eq x y) (eq al bl)))
        ((indvarp x) (matchifyindvar x al y bl))
	((atom x) (cond ((indvarp y) (identifyindvar y bl x al))
                        ((atom y) (equalp x y))
                        ((eq 'quote (car y)) (descriptionize x al (cadr y)))))
	((eq 'quote (car x)) (descriptionize y bl (cadr x)))
        ((eq 'listof (car x)) (matchifylist x al y bl))
	(t (cond ((indvarp y) (identifyindvar y bl x al))
		 ((atom y) nil)
		 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
		 (t (matchifyexpexp x al y bl))))))

(defun matchifyindvar (x al y bl)
  (let (dum)
    (cond ((eq x '?*))
          ((cddr (setq dum (getbdg x al)))
           (identify (cadr dum) (cddr dum) y bl))
          ((and (multiple-value-setq (y bl) (unifyindval y bl))
                (eq x y) (eq al bl)))
	  ((and *occurcheck* (unifychkp x al y bl)) nil)
	  ((null dum) (setnew x al y bl))
	  (t (setold dum y bl)))))

(defun matchifyindval (x al y bl)
  (let (dum)
    (cond ((cddr (setq dum (getbdg y bl)))
	   (matchifyexp x al (cadr dum) (cddr dum))))))

(defun matchifyseqvar (x al l bl)
  (let (dum)
    (cond ((eq x '@*))
          ((cddr (setq dum (getbdg x al)))
           (identifyexpexp (cadr dum) (cddr dum) l bl))
          ((and (multiple-value-setq (l bl) (unifyseqval l bl))
                (eq x (car l)) (eq al bl)))
	  ((and *occurcheck* (unifychkplist x al l bl)) nil)
	  ((null dum) (setnew x al l bl))
	  (t (setold dum l bl)))))

(defun matchifyseqval (x al l bl)
  (let (dum)
    (cond ((cddr (setq dum (getbdg (car l) bl)))
	   (matchifyexpexp x al (cadr dum) (cddr dum))))))

(defun matchifylist (x al y bl)
  (cond ((indvarp y) (matchifyindval x al y bl))
        ((atom y) nil)
        ((eq 'quote (car y)) (matchifydescriptionplist (cdr x) al (cadr y)))
        ((eq 'listof (car y)) (matchifyexpexp (cdr x) al (cdr y) bl))))

(defun matchifyexpexp (l al m bl)
  (do ((l l (cdr l)) (m m (cdr m)))
      (nil)
      (cond ((null l)
             (cond ((null m) (return t))
                   ((seqvarp (car m)) (identifyseqvar (car m) bl nil al))
                   (t (return nil))))
            ((seqvarp (car l)) (return (matchifyseqvar (car l) al m bl)))
            ((null m) (return nil))
            ((seqvarp (car m)) (return (matchifyseqval l al (car m) bl)))
            ((matchifyexp (car l) al (car m) bl))
            (t (return nil)))))

(defun matchifydescriptionpexp (x al y)
  (cond ((indvarp x) (matchifydescriptionpindvar x al y))
	((atom x) (if (or (numberp x) (stringp x) (characterp x)) (equalp x y)))
	((eq 'quote (car x)) (equalp (cadr x) y))
	((eq 'listof (car x)) (matchifydescriptionplist (cdr x) al y))))

(defun matchifydescriptionpindvar (x al y)
  (let (dum)
    (cond ((eq x '?*))
          ((cddr (setq dum (getbdg x al)))
	   (matchifydescriptionpexp (cadr dum) (cddr dum) y))
	  ((null dum) (setnew x al (quotify y) al))
	  (t (setold dum (quotify y) al)))))

(defun matchifydescriptionpseqvar (x al l)
  (let (dum)
    (cond ((eq x '@*))
          ((cddr (setq dum (getbdg x al)))
	   (matchifydescriptionplist (cadr dum) (cddr dum) l))
	  ((null dum) (setnew x al (mapcar 'quotify l) al))
	  (t (setold dum (mapcar 'quotify l) al)))))

(defun matchifydescriptionplist (x al y)
  (cond ((not (listp y)) nil)
        (t (do ((l x (cdr l)) (m y (cdr m)))
               (nil)
               (cond ((null l) (return (null m)))
                     ((seqvarp (car l)) 
                      (return (matchifydescriptionpseqvar (car l) al m)))
                     ((null m) (return nil))
                     ((matchifydescriptionpexp (car l) al (car m)))
                     (t (return nil)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (unify x al y bl)
;;;    determines whether x with binder al and y with binder bl are unifiable
;;;    if successful, returns a list of new bindings 
;;;    if successful, sets variables in binders
;;;    if successful, can have side effects in binders other than al and bl
;;;    if fails, returns nil and has no side effects on binders
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *unifications* 0
 "The value of *UNIFICATIONS* is the number of attempted unifications in the
  most recent proof effort.")

(defmethod unifyp (x y) 
 "(UNIFYP X Y)
  UNIFYP takes two expressions as arguments and checks whether they are 
  meta-unifiable.  UNIFYP differs from MGUP in that the variables in one
  expression are treated as distinct from the variables in the other
  expression.  UNIFYP returns T if the check is successful, and it
  returns NIL otherwise."
  (if (unify x (environment) y (environment)) t))

(defun unify (x al y bl)
  (let ((alist truth))
    (setq *unifications* (1+ *unifications*))
    (cond ((unifyexp x al y bl) alist)
	  (t (backup alist)))))

(defun unifyexp (x al y bl)
  (cond ((and (eq x y) (eq al bl)))
        ((indvarp x) (unifyindvar x al y bl))
	((atom x)
	 (cond ((indvarp y) (unifyindvar y bl x al))
	       ((atom y) (equalp x y))
               ((eq 'quote (car y)) (unifydescriptionpexp x al (cadr y)))))
	((eq 'quote (car x)) (unifydescriptionpexp y bl (cadr x)))
        ((eq 'listof (car x)) (unifylist x al y bl))
	(t (cond ((indvarp y) (unifyindvdr x al y bl))
		 ((atom y) nil)
		 ((eq 'quote (car y)) nil)
                 ((eq 'listof (car y)) nil)
		 (t (unifyexpexp x al y bl))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Transitively closing here okay since these bindings will get backed up
;;; any bindings they are dependent on.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun unifyindvar (x al y bl)
  (let (dum)
    (cond ((and (eq x y) (eq al bl)))
          ((eq x '?*))
          ((eq y '?*))
          ((cddr (setq dum (getbdg x al)))
	   (unifyexp (cadr dum) (cddr dum) y bl))
          ((and (multiple-value-setq (y bl) (unifyindval y bl))
                (eq x y) (eq al bl)))
	  ((and *occurcheck* (unifychkp x al y bl)) nil)
	  ((null dum) (setnew x al y bl))
	  (t (setold dum y bl)))))

(defun unifyindvdr (x al y bl)
  (let (dum)
    (cond ((and (eq x y) (eq al bl)))
          ((eq x '?*))
          ((eq y '?*))
          ((cddr (setq dum (getbdg y bl)))
	   (unifyexp x al (cadr dum) (cddr dum)))
          ((and (multiple-value-setq (x al) (unifyindval x al))
                (eq x y) (eq al bl)))
	  ((and *occurcheck* (unifychkp y bl x al)) nil)
	  ((null dum) (setnew y bl x al))
	  (t (setold dum x al)))))

(defun unifyindval (y bl)
  (let (dum)
    (cond ((and (indvarp y) (cddr (setq dum (getbdg y bl))))
           (unifyindval (cadr dum) (cddr dum)))
          (t (values y bl)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Transitively closing here okay since these bindings will get backed up
;;; any bindings they are dependent on.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun unifyseqvar (x al l bl)
  (let (dum)
    (cond ((and (eq x (car l)) (eq al bl)))
          ((eq x '@*))
          ((eq l '@*))
          ((cddr (setq dum (getbdg x al)))
           (unifyexpexp (cadr dum) (cddr dum) l bl))
          ((and (multiple-value-setq (l bl) (unifyseqval l bl))
                (eq x (car l)) (eq al bl)))
	  ((and *occurcheck* (unifychkplist x al l bl)) nil)
	  ((null dum) (setnew x al l bl))
	  (t (setold dum l bl)))))

(defun unifyseqval (l al)
  (let (dum)
    (cond ((and (seqvarp (car l)) (cddr (setq dum (getbdg (car l) al))))
           (unifyseqval (cadr dum) (cddr dum)))
          (t (values l al)))))

(defun unifychkp (p al q bl)
  (cond ((and (eq p q) (eq al bl)))
	((indvarp q) (if (cddr (setq q (getbdg q bl)))
                         (unifychkp p al (cadr q) (cddr q))))
        ((seqvarp q) (if (cddr (setq q (getbdg q bl)))
                         (unifychkplist p al (cadr q) (cddr q))))
	((atom q) nil)
        ((eq 'quote (car q)) nil)
	(t (unifychkplist p al q bl))))

(defun unifychkplist (p al l bl)
  (some #'(lambda (x) (unifychkp p al x bl)) l))

(defun unifylist (x al y bl)
  (cond ((indvarp y) (unifyindvar y bl x al))
        ((atom y) nil)
        ((eq 'quote (car y)) (unifydescriptionplist (cdr x) al (cadr y)))
        ((eq 'listof (car y)) (unifyexpexp (cdr x) al (cdr y) bl))))

(defun unifyexpexp (l al m bl)
  (do ((l l (cdr l)) (m m (cdr m)))
      (nil)
      (cond ((null l)
             (cond ((null m) (return t))
                   ((seqvarp (car m)) (return (unifyseqvar (car m) bl nil al)))
                   (t (return nil))))
            ((seqvarp (car l)) (return (unifyseqvar (car l) al m bl)))
            ((null m) (return nil))
            ((seqvarp (car m)) (return (unifyseqvar (car m) bl l al)))
            ((unifyexp (car l) al (car m) bl))
            (t (return nil)))))

(defun unifydescriptionpexp (x al y)
  (cond ((indvarp x) (unifydescriptionpindvar x al y))
	((atom x) (if (or (numberp x) (stringp x) (characterp x)) (equalp x y)))
	((eq 'quote (car x)) (equalp (cadr x) y))
	((eq 'listof (car x)) (unifydescriptionplist (cdr x) al y))))

(defun unifydescriptionpindvar (x al y)
  (let (dum)
    (cond ((cddr (setq dum (getbdg x al)))
	   (unifydescriptionpexp (cadr dum) (cddr dum) y))
	  ((null dum) (setnew x al (quotify y) al))
	  (t (setold dum (quotify y) al)))))

(defun unifydescriptionpseqvar (x al l)
  (let (dum)
    (cond ((cddr (setq dum (getbdg x al)))
	   (unifydescriptionplist (cadr dum) (cddr dum) l))
	  ((null dum) (setnew x al (mapcar 'quotify l) al))
	  (t (setold dum (mapcar 'quotify l) al)))))

(defun unifydescriptionplist (x al y)
  (cond ((not (listp y)) nil)
        (t (do ((l x (cdr l)) (m y (cdr m)))
               (nil)
               (cond ((null l) (return (null m)))
                     ((seqvarp (car l)) 
                      (return (unifydescriptionpseqvar (car l) al m)))
                     ((null m) (return nil))
                     ((unifydescriptionpexp (car l) al (car m)))
                     (t (return nil)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ultility functions for environments
;;;
;;; environment has one component:   ((var val . env) ...)
;;;    if no env in cddr, then cadr, if exists, is the standardized variable
;;;
;;; (backup ol)
;;;    undoes the bindings in ol by rplacding those entries to nil.
;;;
;;; (plug x al)
;;;    copies x substituting bindings for variables from al.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *debug* t)

(defclass environment ()
  ((alist :accessor alist :initform nil)))

(defmethod environment ()
 "(ENVIRONMENT)
  The subroutine ENVIRONMENT takes no arguments and returns a new variable
  binding environment."
  (if *debug* (make-instance 'environment) (list '(t t))))

(defmethod alist ((env list)) (cdr env))

(defmethod (setf alist) (al (env list)) (rplacd env al))

(defmethod variables ((env environment))
 "(VARIABLES ENV)
  VARIABLES takes an environment as argument and returns a list of variables
  with bindings in that environment."
  (do ((l (alist env) (cdr l)) (nl))
      ((null l) (nreverse nl))
      (if (cdar l) (setq nl (cons (caar l) nl)))))

(defmethod bind (x (e1 environment) y e2)
 "(BIND X E1 Y E2)
  BIND takes a variable, an environment, an expression, and another environment
  as arguments.  It binds the specified variable in its specified environment
  to have as value the sepcified expression with variable values defined in the
  second specified environment."
  (let (dum)
    (cond ((setq dum (assoc x (alist e1) :test #'eq)) (setoldbdg dum y e2))
          (t (setnewbdg x e1 y e2)))))

(defmethod unbind (x (env environment))
 "(UNBIND X ENV)
  UNBIND takes a variable and an environment as arguments and removes the
  binding of the specified variable from the specified environment."
  (let (dum)
    (if (setq dum (getbdg x env)) (rplacd dum nil))))

(defmethod binding (x (env environment))
 "(BINDING X ENV)
  BINDING takes a variable and an environmen as arguments ans returns as values
  the expression associated with the variable and the environment in which its
  variables are bound.  PLUG is a recursive version of BINDING."
  (let (dum)
    (if (setq dum (assoc x (alist env) :test #'eq))
        (values (cadr dum) (cddr dum)))))

(defun getbdg (x env)
  (assoc x (alist env) :test #'eq))

(defun setold (x y bl)
  (rplacd x (cons y bl))
  (setq alist (cons x alist)))

(defun setnew (x al y bl)
  (setq x (list* x y bl))
  (setf (alist al) (cons x (alist al)))
  (setq alist (cons x alist)))

(defun setoldbdg (v y bl)
  (rplacd v (list* y bl))
  y)

(defun setnewbdg (x al y bl)
  (setf (alist al) (cons (list* x y bl) (alist al)))
  y)

(defun backup (bl)
  (do ((l bl (cdr l)))
      ((null (cdr l)) nil)
      (rplacd (car l) nil)))


(defmethod indval (x (env environment)) (unifyindval x env))

(defmethod plug (x (alist environment))
  (if (null (alist alist)) x (plugstdexp x alist)))

(defun plugstdexp (x al)
  (cond ((indvarp x) (plugstdexpindvar x al))
	((atom x) x)
	((eq 'quote (car x)) x)
	(t (plugstdexpcdr x al))))

(defun plugstdexpcdr (x al)
  (do ((l x (cdr l)) (nl))
      ((null l) (nreverse nl))
      (if (seqvarp (car l))
          (return (nreconc nl (plugstdexpseqvar (car l) al)))
          (setq nl (cons (plugstdexp (car l) al) nl)))))

(defun plugstdexpindvar (x al)
  (let (dum)
    (cond ((eq '?* x) '?*)
          ((setq dum (getbdg x al))
           (cond ((cddr dum) (plugstdexp (cadr dum) (cddr dum)))
                 ((eq alist al) x)
                 ((cdr dum) (cadr dum))
                 (t (setoldbdg dum (newindvar) alist))))
          ((eq alist al) x)
	  (t (setnewbdg x al (newindvar) alist)))))

(defun plugstdexpseqvar (x al)
  (let (dum)
    (cond ((eq '@* x) (list x))
          ((setq dum (getbdg x al))
           (cond ((cddr dum) (plugstdexpcdr (cadr dum) (cddr dum)))
                 ((eq alist al) (list x))
                 ((cdr dum) (cadr dum))
                 (t (setoldbdg dum (list (newseqvar)) nil))))
          ((eq alist al) (list x))
          (t (setnewbdg x al (list (newseqvar)) nil)))))

(defun groundplugstdexp (x al)
  (cond ((indvarp x) (if (cddr (setq x (getbdg x al)))
                         (groundplugstdexp (cadr x) (cddr x))))
	((atom x) x)
	((eq 'quote (car x)) x)
	(t (groundplugstdcdr x al))))

(defun groundplugstdcdr (x al)
  (do ((l x (cdr l)) (ans) (nl))
      ((null l) (nreverse nl))
      (cond ((seqvarp (car l))
             (return (if (cddr (setq ans (getbdg (car l) al)))
                         (nreconc nl (groundplugstdcdr (cadr ans) (cddr ans))))))
            ((setq ans (groundplugstdexp (car l) al)) (setq nl (cons ans nl)))
            (t (return nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; unival
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod unival (x (al list))
  (let (dum)
    (cond ((not (varp x)) x)
          ((setq dum (assoc x al :test #'eq)) (unival (cdr dum) al))
          (t x))))

(defmethod unival (x (al environment))
  (let (dum)
    (cond ((not (indvarp x)) x)
          ((and (setq dum (getbdg x al)) (cdr dum))
           (unival (cadr dum) (cddr dum)))
          (t x))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; transforms.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special direction universals alist alluniversals)))

(defun newskolem () (cons (gentemp "F") universals))

(defmethod atomicp (p)
 "(ATOMICP P)
  ATOMICP takes a sentence as argument.  It returns T if the sentence is an 
  atomic sentence; otherwise, it returns NIL."
  (cond ((atom p))
        ((find (car p) '(not and or => <= <=> forall exists)
               :test #'eq) nil)
        (t t)))

(defmethod literalp (p)
 "LITERALP P)
  LITERALP takes a sentence as argument.  It returns T if the sentence is a 
  literal; otherwise, it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((member (car p) '(and or => <= <=> forall exists) :test #'eq) nil)
        (t t)))

(defmethod clausep (p)
 "(CLAUSEP P)
  CLAUSEP takes a sentence as argument.  It returns T if the sentence is a
  clause; otherwise, it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((eq 'or (car p)) (every 'literalp (cdr p)))
        ((member (car p) '(and => <= <=> forall exists) :test #'eq) nil)
        (t t)))

(defmethod alternativep (p)
 "(ALTERNATIVEP P)
  ALTERNATIVEP takes a sentence as argument.  It returns T if the sentence is 
  an alternative; otherwise, it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((eq 'and (car p)) (every 'literalp (cdr p)))
        ((member (car p) '(or => <= <=> forall exists) :test #'eq) nil)
        (t t)))


(defmethod booleanp (p)
 "(BOOLEANP P)
  BOOLEANP takes a sentence as argument.  It returns T if the sentence is in 
  boolean form; otherwise it returns NIL."
  (cond ((atom p))
        ((member (car p) '(not and or) :test #'eq) t)
        ((member (car p) '(<= <=> =>) :test #'eq) nil)
        ((member (car p) '(forall exists) :test #'eq) (booleanp (caddr p)))
        (t (every #'booleantermp (cdr p)))))

(defun booleantermp (x)
  (cond ((atom x))
        ((eq 'quote (car x)))
        ((eq 'if (car x))
         (and (booleanp (cadr x)) (every #'booleantermp (cddr x))))
        ((eq 'cond (car x))
         (do ((l (cdr x) (cdr l)))
             ((null l) t)
             (if (or (not (booleanp (caar l))) (not (booleantermp (cadar l))))
                 (return nil))))
        ((eq 'lambda (car x)) (booleantermp (caddr x)))
        ((eq 'kappa (car x)) (booleanp (caddr x)))
        ((member (car x) '(the setofall) :test #'eq)
         (and (booleantermp (cadr x)) (booleanp (caddr x))))
        (t (every #'booleantermp (cdr x)))))

(defmethod booleanize (p)
 "(BOOLEANIZE P)
  BOOLEANIZE takes a sentence as argument, converts all logical operators
  to boolean operators (i.e. NOT, AND, OR), and returns the result."
  (cond ((atom p) p)
	((eq 'not (car p)) `(not ,(booleanize (cadr p))))
	((eq 'and (car p)) (mapcar #'booleanize p))
	((eq 'or (car p)) (mapcar #'booleanize p))
	((eq '=> (car p)) (booleanforward p))
	((eq '<= (car p)) (booleanbackward p))
	((eq '<=> (car p)) `(and ,(booleanforward p) ,(booleanbackward p)))
        ((eq 'forall (car p)) (booleanquant p))
        ((eq 'exists (car p)) (booleanquant p))
        (t (mapcar 'booleanterm p))))

(defun booleanforward (p)
  (do ((l (cdr p) (cdr l)) (nl))
      ((null (cdr l)) (maksor (nreverse (cons (booleanize (car l)) nl))))
      (setq nl (cons (maknot (booleanize (car l))) nl))))

(defun booleanbackward (p)
  (maksor (cons (booleanize (cadr p)) 
                (mapcar #'(lambda (x) (maknot (booleanize x))) (cddr p)))))

(defun booleanquant (p)
  (list (car p) (booleanize (cadr p)) (booleanize (caddr p))))

(defun booleanterm (x)
  (cond ((atom x) x)
        ((eq 'quote (car x)) x)
        ((eq 'if (car x)) (booleanif x))
        ((eq 'cond (car x)) (booleancond x))
        ((eq 'lambda (car x)) (booleansetofall x))
        ((eq 'kappa (car x)) (booleansetofall x))
        ((eq 'the (car x)) (booleansetofall x))
        ((eq 'setofall (car x)) (booleansetofall x))
        (t (mapcar 'booleanterm x))))

(defun booleanif (x)
  `(if ,(booleanize (cadr x)) ,(booleanterm (cadr x))
       ,(if (cdddr x) (booleanterm (cadddr x)) 0)))

(defun booleancond (x)
  (do ((l (cdr x) (cdr l)) (nl))
      ((null l) `(cond . ,(nreverse nl)))
      (setq nl (cons (list (booleanize (caar l)) (booleanterm (cadar l)))  nl))))

(defun booleansetofall (x)
  (list (car x) (booleanterm (cadr x)) (booleanize (caddr x))))


(defmethod skolemp (p)
 "(SKOLEMP P)
  SKOLEMP takes a sentence as argument.  It returns T if the sentence is 
  skolemized (i.e. contains no explicit quantifiers); otherwise it returns NIL."
  (cond ((atom p))
        ((eq 'quote (car p)))
        ((member (car p) '(forall exists) :test #'eq) nil)
        (t (every #'skolemp (cdr p)))))

(defmethod skolemize (p)
 "(SKOLEMIZE P)
  SKOLEMIZE takes a sentence as argument, skolemizes, and returns the result."
  (let (universals alluniversals alist direction) ;****** add alluniversals NS 8/9/91 ******
    (setq universals (freevars p) direction t)
    (skolem p)))

(defmethod herbrandize (p)
  (let (universals alluniversals alist direction)
    (addexist (freevars p))
    (skolem p)))

(defun revskolem (p)
  (let ((direction (not direction)))
    (skolem p)))

(defun skolem (p)
  (cond ((atom p) p)
	((eq 'not (car p)) `(not ,(revskolem (cadr p))))
	((eq 'and (car p)) (mapcar 'skolem p))
	((eq 'or (car p)) (mapcar 'skolem p))
	((eq '=> (car p)) (skolemforward p))
	((eq '<= (car p)) (skolembackward p))
	((eq '<=> (car p)) (skolemboth p))
        ((eq 'forall (car p)) (if direction (skolemforall p) (skolemexists p)))
        ((eq 'exists (car p)) (if direction (skolemexists p) (skolemforall p)))
        (t (mapcar 'skolemterm p))))

(defun skolemforward (p)
  (cond ((null (cdr p)) p)
        (t (do ((l (cdr p) (cdr l)) (nl (list (car p))))
               ((null (cdr l)) (nreconc nl (list (skolem (car l)))))
               (setq nl (cons (revskolem (car l)) nl))))))

(defun skolembackward (p) 
  (cond ((null (cdr p)) p)
        (t (list* (car p) (skolem (cadr p)) (mapcar 'revskolem (cddr p))))))

(defun skolemboth (p)
  `(and (=> ,(revskolem (cadr p)) ,(skolem (caddr p)))
        (<= ,(skolem (cadr p)) ,(revskolem (caddr p)))))

;;; ****** rename universals that are the same as any universals in the sentence
;;; NS 8/9/91 ******
(defun skolemforall (p)
  (let ((universals universals) (alist alist))
    (setq p (rename-conflicting p)) ;****** these 2 lines are new ******
    (addalluniv (cadr p))
    (adduniv (cadr p))
    (skolem (caddr p))))

;;; ****** Rename universals that are the same as any universal in the sentence
;;; NS 8/9/91 ******
(defun rename-conflicting (p &aux vars (al '((t . t))))
  (setq vars (if (listp (cadr p)) (cadr p) (list (cadr p))))
  (dolist (x vars)
    (if (member x alluniversals :test #'eql) (push (cons x (decolonize (newindvar))) al)))
  (plug p al))

(defun decolonize (x)
  (cond ((varp x) (intern (symbol-name x)))
        ((atom x) x)
        (t (mapcar #'decolonize x))))

;;; ****** add all the universals to the list "alluniversals" NS 8/9/91 ******
(defun addalluniv (v)
  (cond ((not (listp v)) (pushnew v alluniversals :test #'eql))
	(t (dolist (x v) (pushnew x alluniversals :test #'eql)))))

(defun skolemexists (p)
  (let ((alist alist))
    (addexist (cadr p))
    (skolem (caddr p))))

(defun skolemterm (x)
  (cond ((varp x) (cond ((cdr (assoc x alist :test #'eq))) (t x)))
        ((atom x) x)
        ((eq 'quote (car x)) x)
        ((eq 'if (car x)) (skolemif x))
        ((eq 'cond (car x)) (skolemcond x))
        ((eq 'lambda (car x)) (skolemsetofall x))
        ((eq 'kappa (car x)) (skolemsetofall x))
        ((eq 'the (car x)) (skolemsetofall x))
        ((eq 'setofall (car x)) (skolemsetofall x))
        (t (mapcar 'skolemterm x))))

(defun skolemif (x)
  `(if ,(skolem (cadr x)) ,(skolemterm (caddr x))
       ,(if (cdddr x) (skolemterm (cadddr x)) 'bottom)))

(defun skolemcond (x)
  (do ((l (cdr x) (cddr l)) (nl))
      ((null l) `(cond . ,(nreverse nl)))
      (setq nl (cons (list (skolem (caar l)) (skolemterm (cadar l))) nl))))

(defun skolemsetofall (x)
  (let ((universals universals) (alist alist))
       (addbag (cadr x))
       (list (car x) (cadr x) (skolem (caddr x)))))

(defmethod frfp (p)
 "(FRFP P)
  FRFP takes a sentence as argument.  It returns T if the sentence is in 
  forward rule form; otherwise it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((member (car p) '(and or) :test #'eq) nil)
        ((eq '=> (car p)) (every #'literalp (cdr p)))
        ((member (car p) '(<= <=> forall exists) :test #'eq) nil)
        (t t)))

(defmethod brfp (p)
 "(BRFP P)
  BRFP takes a sentence as argument.  It returns T if the sentence is in 
  backward rule form; otherwise it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((member (car p) '(and or => <=>) :test #'eq) nil)
        ((eq '<= (car p)) (every #'literalp (cdr p)))
        ((member (car p) '(forall exists) :test #'eq) nil)
        (t t)))

(defmethod efrfp (p)
 "(EFRFP P)
  EFRFP takes a sentence as argument.  It returns T if the sentence is in 
  extended forward rule form; otherwise it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((member (car p) '(and or) :test #'eq) nil)
        ((eq '=> (car p))
         (and (literalp (cadr p))
              (every #'booleanp (butlast (cddr p)))
              (literalp (car (last p)))))
        ((member (car p) '(<= <=> forall exists) :test #'eq) nil)
        (t t)))

(defmethod ebrfp (p)
 "(EBRFP P)
  EBRFP takes a sentence as argument.  It returns T if the sentence is in 
  extended backward rule form; otherwise it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((member (car p) '(and or => <=>) :test #'eq) nil)
        ((eq '<= (car p)) (and (literalp (cadr p)) (every #'booleanp (cddr p))))
        ((member (car p) '(forall exists) :test #'eq) nil)
        (t t)))

(defmethod frf (p)
 "(FRF P)
  FRF takes a forward or backward implication as argument, converts it into
  a forward rule with the same literal ordering, and returns the result."
  (maksand (frfs p)))

(defun frfs (p)
  (do ((l (clausesets p) (cdr l)) (nl))
      ((null l) (nreverse nl))
      (setq nl (cons `(=> ,@(mapcar 'maknot (butlast (car l))) ,(car (last (car l)))) nl))))

(defmethod brf (p)
 "(BRF P)
  BRF takes a forward or backward implication as argument, converts it into
  a backward rule with the same literal ordering, and returns the result."
  (maksand (brfs p)))

(defun brfs (p)
  (do ((l (clausesets p) (cdr l)) (nl))
      ((null l) (nreverse nl))
      (setq nl (cons `(<= ,(caar l) . ,(mapcar 'maknot (cdar l))) nl))))

(defmethod reverse-rule (p)
 "(REVERSE-RULE P)
  REVERSE-RULE takes a forward or backward implication as argument, reverses
  its direction, and returns the result."
  (cond ((atom p) p)
        ((eq '<= (car p))
         (cond ((null (cdr p)) '(=>))
               (t (cons '=> (append (cddr p) (list (cadr p)))))))
        ((eq '=> (car p))
         (cond ((null (cdr p)) '(<=))
               ((null (cddr p)) (list '<= (cadr p)))
               (t (cons '<= (cons (car (last p)) (butlast (cdr p)))))))
        (t p)))

(defmethod contrapositives (p)
 "(CONTRAPOSITIVES P)
  CONTRAPOSITIVES takes a sentence as input and returns a list of all 
  contrapositives."
  (do ((l (brfs p) (cdr l)) (nl))
      ((null l) (nreverse nl))
      (setq nl (contrapositivesexp nil (cadar l) (cddar l) nl))
      (do ((m (cddar l) (cdr m)) (om (list (maknot (cadar l)))))
          ((null m))
          (setq nl (contrapositivesexp om (maknot (car m)) (cdr m) nl)
                om (cons (car m) om)))))

(defun contrapositivesexp (nm p m nl)
  (cond ((atom p) (adjoin (makbrfs p (revappend nm m)) nl :test #'equalp))
        ((and (listp p) (member (car p) '(= <- <--) :test #'eq))
         (list* (makbrfs p (revappend nm m))
                (makbrfs (list (car p) (caddr p) (cadr p)) (revappend nm m))
                nl))
        (t (adjoin (makbrfs p (revappend nm m)) nl :test #'equalp))))

(defun makbrfs (q l)
  (cond ((null l) q)
        (t `(<= ,q . ,l))))

(defun contras (l)
  (do ((m (cdr l) (cdr m)) (om (list (car l))) (nl (list l)))
      ((null m) (nreverse nl))
      (setq nl (cons (cons (car m) (revappend om (cdr m))) nl)
            om (cons (car m) om))))
#|
(defun adduniv (v)
  (do ((l (freevars v) (cdr l)))
      ((null l))
      (if (member (car l) universals :test #'eq)
          (setq v (if (indvarp (car l)) (newindvar) (newseqvar))
                alist (acons (car l) v alist)
                universals (cons v universals))
          (setq alist (acons (car l) (car l) alist)
                universals (cons (car l) universals)))))
|#
(defun adduniv (v)
  (do ((l (freevars v) (cdr l)))
      ((null l))
      (setq v (if (indvarp (car l)) (newindvar) (newseqvar))
            alist (acons (car l) v alist)
            universals (cons v universals))))

(defun addexist (v)
  (do ((l (freevars v) (cdr l)))
      ((null l))
      (setq alist (acons (car l) (newskolem) alist))))

(defun addbag (v)
  (do ((l (freevars v) (cdr l)))
      ((null l))
      (setq alist (acons (car l) (car l) alist)
            universals (cons v universals))))

(defun andclause (l m)
  (cond ((null l) m)
	((null (car l)) l)
	((null m) l)
	((null (car m)) m)
	(t (unionidentp l m))))

(defun orclause (c d)
  (cond ((or (null c) (null d)) nil)
	(t (do ((l c (cdr l)) (res))
	       ((null l) (nreverse res))
	       (do ((m d (cdr m)))
		   ((null m))
		   (setq res (addclause (unionidentp (car l) (car m)) res)))))))

(defun addclause (x l)
  (do ((m l (cdr m)) (nl))
      ((null m) (cons x (nreverse nl)))
      (cond ((subsetp x (car m) :test #'equalp))
            ((subsetp (car m) x :test #'equalp) (return l))
            (t (setq nl (cons (car m) nl))))))

(defun andalternative (c d)
  (cond ((or (null c) (null d)) nil)
	(t (do ((l c (cdr l)) (res))
	       ((null l) (nreverse res))
	       (do ((m d (cdr m)))
		   ((null m))
		   (setq res (addclause (unionidentp (car l) (car m)) res)))))))

(defun oralternative (l m)
  (cond ((null l) m)
	((null (car l)) l)
	((null m) l)
	((null (car m)) m)
	(t (unionidentp l m))))

(defun unionidentp (l m)
  (do ((n m (cdr n)) (nn))
      ((null n) (append l (nreverse nn)))
      (unless (find (car n) l :test #'identp) (setq nn (cons (car n) nn)))))

(defun makand (x y)
  (cond ((eq 'true x) y)
        ((eq 'false x) 'false)
        ((atom x)
         (cond ((eq 'true y) x)
               ((eq 'false y) 'false)
               ((atom y) `(and ,x ,y))
               ((eq 'and (car y)) (cons 'and (cons x (cdr y))))
               (t `(and ,x ,y))))
        ((eq 'and (car x))
         (cond ((eq 'true y) x)
               ((eq 'false y) 'false)
               ((atom y) (append x (list y)))
               ((eq 'and (car y)) (cons 'and (append (cdr x) (cdr y))))
               (t (append x (list y)))))
        (t (cond ((eq 'true y) x)
                 ((eq 'false y) 'false)
                 ((atom y) `(and ,x ,y))
                 ((eq 'and (car y)) (cons 'and (cons x (cdr y))))
                 (t `(and ,x ,y))))))

(defun makor (x y)
  (cond ((eq 'true x) 'true)
        ((eq 'false x) y)
        ((atom x)
         (cond ((eq 'true y) 'true)
               ((eq 'false y) x)
               ((atom y) `(or ,x ,y))
               ((eq 'or (car y)) (cons 'or (cons x (cdr y))))
               (t `(or ,x ,y))))
        ((eq 'or (car x))
         (cond ((eq 'true y) 'true)
               ((eq 'false y) x)
               ((atom y) (append x (list y)))
               ((eq 'or (car y)) (cons 'or (append (cdr x) (cdr y))))
               (t  (append x (list y)))))
        (t (cond ((eq 'true y) 'true)
                 ((eq 'false y) x)
                 ((atom y) `(or ,x ,y))
                 ((eq 'or (car y)) (cons 'or (cons x (cdr y))))
                 (t `(or ,x ,y))))))

(defun maknot (p)
  (cond ((atom p) (cond ((eq 'true p) 'false)
			((eq 'false p) 'true)
			(t (list 'not p))))
	((eq 'not (car p)) (cadr p))
	(t (list 'not p))))

(defun makunprovable (x)
  (cond ((atom x) `(unprovable ,x))
        ((eq 'unprovable (car x)) (cadr x))
        (t `(unprovable ,x))))

(defun maksand (l)
  (cond ((null l) 'true)
	((null (cdr l)) (car l))
	(t (cons 'and l))))

(defun maksor (l)
  (cond ((null l) 'false)
	((null (cdr l)) (car l))
	(t (cons 'or l))))

(defun makbr (q l)
  (cond ((null l) q)
        (t `(<= ,q . ,l))))

(defun makfr (q l)
  (cond ((null l) q)
        (t `(=> ,@l ,q))))

(defun maksbr (l)
  (cond ((null l) 'false)
        ((null (cdr l)) (car l))
        (t `(<= ,(car l) . ,(mapcar #'maknot (cdr l))))))

(defun maksred (l)
  (cond ((null l) 'false)
        ((null (cdr l)) (car l))
        (t (cons '<= l))))

(defmethod groundp (x)
 "(GROUNDP X)
  GROUNDP takes an expression as argument.  It returns T if the expression is
  ground; otherwise, it returns NIL."
  (cond ((atom x) (not (varp x)))
        ((eq 'quote (car x)))
	(t (every 'groundp x))))

(defmethod vars (x)
 "(VARS X)"
  (nreverse (varsexp x nil)))

(defun varsexp (x nl)
  (cond ((and (varp x) (not (member x nl :test #'eq))) (cons x nl))
	((atom x) nl)
	((eq 'quote (car x)) nl)
	(t (do ((l x (cdr l)))
               ((null l) nl)
               (setq nl (varsexp (car l) nl))))))

(defmethod freevars (x)
 "(FREEVARS X)"
  (freevarsexp x nil nil))

(defun freevarsexp (x bl fl)
  (cond ((varp x) (cond	((member x bl :test #'eq) fl)
			((member x fl :test #'eq) fl)
			(t (cons x fl))))
	((atom x) fl)
        ((eq 'quote (car x)) fl)
        ((eq 'bagofall (car x)) (freevarsexp (cadddr x) (nconc (vars (cadr x)) bl) fl))
	((member (car x) '(the setofall lambda kappa forall exists) :test #'eq)
	 (freevarsexp (caddr x) (nconc (freevars (cadr x)) bl) fl))
	(t (do ((l x (cdr l)))
               ((null l) fl)
               (setq fl (freevarsexp (car l) bl fl))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cnf.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special traceexpressions universals alist alluniversals)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Note that needless occurrences of and and or are dropped:
;;;   (and p)  ---> p
;;;   (or p)   ---> p
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod cnf (p)
 "(CNF P)
  CNF takes a sentence as argument, converts to conjunctive normal form, and
  returns the result."
  (maksand (clauses p)))

(defmethod clauses (p)
 "(CLAUSES P)
  CLAUSES takes a sentence as argument and returns the corresponding clauses."
  (mapcar 'maksor (clausesets p)))

(defun clausesets (p)
  (let (universals alist alluniversals)
    (setq universals (freevars p))
    (cnfs p)))

(defmethod cnfp (p)
 "(CNFP P)
  CNFP takes a sentence as argument.  It returns T if the sentence is in 
  conjunctive normal form; otherwise, it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((eq 'and (car p)) (every #'clausep (cdr p)))
        ((eq 'or (car p)) (every #'literalp (cdr p)))
        ((member (car p) '(=> <= <=> forall exists) :test #'eq) nil)
        (t t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cnfs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; UPDATE: all of cnfs

(defun cnfs (p)
  (cond ((atom p) (cnfsatom p))
	((eq 'not (car p)) (cnns (cadr p)))
	((eq 'and (car p)) (cnfsand p))
	((eq 'or (car p)) (cnfsor p))
 	((eq 'xor (car p)) (cnnsboth p))
	((eq '=> (car p)) (cnfsforward p))
	((eq '<= (car p)) (cnfsbackward p))
	((eq '<=> (car p)) (cnfsboth p))
	((eq 'forall (car p)) (cnfsforall p))
	((eq 'exists (car p)) (cnfsexists p))
	(t (list (list (cnfsexp p))))))

(defun cnfsatom (p)
  (cond ((eq 'true p) nil)
        ((eq 'false p) (list nil))
        (t (list (list p)))))

(defun cnfsand (p)
  (do ((l (cdr p) (cdr l)) (nl))
      ((null l) nl)
      (setq nl (andclause nl (cnfs (car l))))))

(defun cnfsor (p)
  (do ((l (cdr p) (cdr l)) (nl (list nil)))
      ((null l) nl)
      (setq nl (orclause nl (cnfs (car l))))))

(defun cnfsforward (p)
  (cond ((null (cdr p)) (list nil))
        (t (do ((l (cdr p) (cdr l)) (nl (list nil)))
               ((null (cdr l)) (orclause nl (cnfs (car l))))
               (setq nl (orclause nl (cnns (car l))))))))

(defun cnfsbackward (p)
  (cond ((null (cdr p)) (list nil))
	(t (orclause (cnfs (cadr p)) (cnnsands (cddr p))))))

(defun cnfsboth (p)
  (cond ((null (cdr p)) (list nil))
	((null (cddr p)) (cnfs (cadr p)))
	(t (andclause (orclause (cnfs (cadr p)) (cnns (caddr p)))
                      (orclause (cnns (cadr p)) (cnfs (caddr p)))))))

(defun cnfsexists (p)
  (let ((alist alist))
    (addexist (cadr p))
    (cnfs (caddr p))))

(defun cnfsforall (p)
  (let ((universals universals) (alist alist))
    (adduniv (cadr p))
    (cnfs (caddr p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (cnns p)
;;;   takes a sentence as argument
;;;   returns the clausal form of its negation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; UPDATE: all of cnns

(defun cnns (p)
  (cond ((atom p) (cond ((eq 'true p) (list nil))
                        ((eq 'cut p) (list nil))
			((eq 'false p) nil)
			(t (list (list (maknot p))))))
	((eq 'not (car p)) (cnfs (cadr p)))
	((eq 'and (car p)) (cnnsand p))
	((eq 'or (car p)) (cnnsor p))
 	((eq 'xor (car p)) (cnfsboth p))
	((eq '=> (car p)) (cnnsforward p))
	((eq '<= (car p)) (cnnsbackward p))
	((eq '<=> (car p)) (cnnsboth p))
	((eq 'exists (car p)) (cnnsexists p))
	((eq 'forall (car p)) (cnnsforall p))
	(t (list (list (maknot (cnfsexp p)))))))

(defun cnnsor (p)
  (cnnsors (cdr p)))

(defun cnnsors (l)
  (cond ((null l) nil)
        (t
         (do ((ls l (cdr ls))
              (res nil))
             ((null ls) (nreverse res))
           (setq res (andclause (cnns (car ls)) res))))))

(defun cnnsand (p)
  (cnnsands (cdr p)))

(defun cnnsands (l)
  (cond ((null l) (list nil))
        (t
         (do ((ls l (cdr ls))
              (res (list nil)))
             ((null ls) (nreverse res))
           (setq res (orclause (cnns (car ls)) res))))))

(defun cnnsforward (p)
  (cond ((null (cdr p)) nil)
	(t (cnnsforwards (cdr p)))))

(defun cnnsforwards (l)
  (cond ((null (cdr l)) (cnns (car l)))
	(t (andclause (cnfs (car l)) (cnnsforwards (cdr l))))))

(defun cnnsbackward (p)
  (cond ((null (cdr p)) nil)
        (t (andclause (cnns (cadr p)) (cnfsand (cdr p))))))

(defun cnnsboth (p)
  (cond ((null (cdr p)) nil)
	((null (cddr p)) (cnns (cadr p)))
	(t (orclause (andclause (cnns (cadr p)) (cnfs (caddr p)))
                     (andclause (cnfs (cadr p)) (cnns (caddr p)))))))

(defun cnnsexists (p)
  (let ((universals universals) (alist alist))
    (adduniv (cadr p))
    (cnns (caddr p))))

(defun cnnsforall (p)
  (let ((alist alist))
    (addexist (cadr p))
    (cnns (caddr p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Note that needless occurrences of and and or are dropped:
;;;   (and p)  ---> p
;;;   (or p)   --->  p
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod dnfp (p)
 "(DNFP P)
  DNFP takes a sentence as argument.  It returns T if the sentence is in 
  disjunctive normal form; otherwise, it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((eq 'and (car p)) (every #'literalp (cdr p)))
        ((eq 'or (car p)) (every #'alternativep (cdr p)))
        ((member (car p) '(=> <= <=> forall exists) :test #'eq) nil)
        (t t)))

(defmethod dnf (p)
 "(DNF P)
  DNF takes a sentence as argument, converts to disjunctive normal form, and
  returns the result."
  (maksor (alternatives p)))

(defmethod alternatives (p)
 "(ALTERNATIVES P)
  ALTERNATIVES takes a sentence as argument and returns the corresponding
  alternatives."
  (let (universals alist alluniversals)
    (setq universals (freevars p))
    (mapcar #'maksand (dnfs p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (dnfs p)
;;;   takes an expression as argument
;;;    returns the clausal form
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun dnfs (p)
  (cond ((atom p) (cond ((eq 'true p) (list nil))
			((eq 'false p) nil)
			(t (list (list p)))))
	((eq 'not (car p)) (dnns (cadr p)))
	((eq 'and (car p)) (dnfsand p))
	((eq 'or (car p)) (dnfsor p))
 	((eq 'xor (car p)) (dnnsboth p))
	((eq '=> (car p)) (dnfsforward p))
	((eq '<= (car p)) (dnfsbackward p))
	((eq '<=> (car p)) (dnfsboth p))
	((eq 'forall (car p)) (dnfsforall p))
	((eq 'exists (car p)) (dnfsexists p))
	(t (list (list (cnfsexp p))))))

(defun dnfsand (p)
  (dnfsands (cdr p)))

(defun dnfsands (l)
  (cond ((null l) (list nil))
	(t (andalternative (dnfs (car l)) (dnfsands (cdr l))))))

(defun dnfsor (p)
  (dnfsors (cdr p)))

(defun dnfsors (l)
  (cond ((null l) nil)
	(t (oralternative (dnfs (car l)) (dnfsors (cdr l))))))

(defun dnfsforward (p)
  (cond ((null (cdr p)) nil)
	(t (dnfsforwards (cdr p)))))

(defun dnfsforwards (l)
  (cond ((null (cdr l)) (dnfs (car l)))
	(t (oralternative (dnns (car l)) (dnfsforwards (cdr l))))))

(defun dnfsbackward (p)
  (cond ((null (cdr p)) nil)
        (t (oralternative (dnfs (cadr p)) (dnnsands (cddr p))))))

(defun dnfsboth (p)
  (cond ((null (cdr p)) nil)
	((null (cddr p)) (dnfs (cadr p)))
	(t (andalternative (oralternative (dnfs (cadr p)) (dnns (caddr p)))
                           (oralternative (dnns (cadr p)) (dnfs (caddr p)))))))

(defun dnfsexists (p)
  (let ((alist alist))
    (addexist (cadr p))
    (dnfs (caddr p))))

(defun dnfsforall (p)
  (let ((universals universals) (alist alist))
    (adduniv (cadr p))
    (dnfs (caddr p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (dnns p)
;;;   takes an expression as argument
;;;   returns the clausal form  of its negation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun dnns (p)
  (cond ((atom p) (cond ((eq 'true p) nil)
                        ((eq 'cut p) nil)
			((eq 'false p) (list nil))
			(t (list (list (maknot p))))))
	((eq 'not (car p)) (dnfs (cadr p)))
	((eq 'and (car p)) (dnnsand p))
	((eq 'or (car p)) (dnnsor p))
 	((eq 'xor (car p)) (dnfsboth p))
	((eq '=> (car p)) (dnnsforward p))
	((eq '<= (car p)) (dnnsbackward p))
	((eq '<=> (car p)) (dnnsboth p))
	((eq 'exists (car p)) (dnnsexists p))
	((eq 'forall (car p)) (dnnsforall p))
	(t (list (list (maknot (cnfsexp p)))))))

(defun dnnsor (p)
  (dnnsors (cdr p)))

(defun dnnsors (l)
  (cond ((null l) (list nil))
	(t (andalternative (dnns (car l)) (dnnsors (cdr l))))))

(defun dnnsand (p)
  (dnnsands (cdr p)))

(defun dnnsands (l)
  (cond ((null l) nil)
	(t (oralternative (dnns (car l)) (dnnsands (cdr l))))))

(defun dnnsforward (p)
  (cond ((null (cdr p)) (list nil))
	(t (dnnsforwards (cdr p)))))

(defun dnnsforwards (l)
  (cond ((null (cdr l)) (dnns (car l)))
	(t (andalternative (dnfs (car l)) (dnnsforwards (cdr l))))))

(defun dnnsbackward (p)
  (cond ((null (cdr p)) (list nil))
        (t (andalternative (dnns (cadr p)) (dnfsands (cddr p))))))

(defun dnnsboth (p)
  (cond ((null (cdr p)) (list nil))
	((null (cddr p)) (dnns (cadr p)))
	(t (oralternative (andalternative (dnns (cadr p)) (dnfs (caddr p)))
                          (andalternative (dnfs (cadr p)) (dnns (caddr p)))))))

(defun dnnsexists (p)
  (let ((universals universals) (alist alist))
    (adduniv (cadr p))
    (dnns (caddr p))))

(defun dnnsforall (p)
  (let ((alist alist))
    (addexist (cadr p))
    (dnns (caddr p))))

(defun cnfsexp (p)
  (cond ((varp p) (cond ((cdr (assoc p alist :test #'eq))) (t p)))
	((atom p) p)
        ((eq 'quote p) p)
	((member (car p) '(forall exists) :test #'eq)
	 (let ((alist alist))
	   (addbag (cadr p))
	   (list (car p) (cnfsexp (cadr p)) (cnfsexp (caddr p)))))
	(t (mapcar 'cnfsexp p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sif.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special universals alist alluniversals conditions)))

(defvar *names* t
 "*NAMES* is a variable that determines which object constants are taken
  as primitive.  Numbers are always primitive.  If the value of *NAMES* is
  a list, the elements of the list are considered primitive as well.  If the
  value is a non-list, all atoms are treated as primitives.  The default is T.")

(defvar *functionals* nil
 "*FUNCTIONALS* is a variable that determines which function constants are taken
  as primitive.  If the value of *FUNCTIONALS* is a list, the elements of the
  list are considered primitive.  If the value is a non-list, all atoms are
  treated as primitives.  The default is NIL.")

(defmethod primitivep (x)
 "(PRIMITIVEP X)
  PRIMITIVEP takes a term as argument.  It returns T if the term is primitive;
  otherwise, it returns NIL."
  (cond ((varp x))
        ((atom x) (cond ((numberp x))
                        ((stringp x))
                        ((characterp x))
                        ((eq 'pi x) nil)
                        ((not (listp *names*)))
                        ((member x *names* :test #'eq) t)))
        ((eq 'quote (car x)))
        ((eq 'if (car x)) nil)
        ((eq 'cond (car x)) nil)
        ((eq 'lambda (car x)) nil)
        ((eq 'kappa (car x)) nil)
        ((member (car x) '(the setof setofall) :test #'eq) nil)
        ((eq 'listof (car x)) (every #'primitivep (cdr x)))
        ((get (car x) 'basicval) nil)
        ((not (listp *functionals*)) (every #'primitivep (cdr x)))
        ((member (car x) *functionals* :test #'eq)
         (every #'primitivep (cdr x)))))

(defmethod pseudoprimitivep (x)
 "(PSEUDOPRIMITIVEP X)
  PSEUDOPRIMITIVEP takes a term as argument.  It returns T if the term is 
  pseudoprimitive; otherwise, it returns NIL."
  (cond ((varp x) nil)
        ((atom x) (cond ((numberp x) nil)
                        ((stringp x) nil)
                        ((characterp x) nil)
                        ((eq 'pi x))
                        ((not (listp *names*)) nil)
                        ((member x *names* :test #'eq) nil)
                        (t t)))
        ((eq 'quote (car x)) nil)
        ((eq 'if (car x)) nil)
        ((eq 'cond (car x)) nil)
        ((eq 'lambda (car x)) nil)
        ((eq 'kappa (car x)) nil)
        ((member (car x) '(the setof setofall) :test #'eq) nil)
        ((eq 'listof (car x)) nil)
        ((get (car x) 'basicval) nil)
        ((not (listp *functionals*)) nil)
        ((member (car x) *functionals* :test #'eq) nil)
        (t (every #'primitivep (cdr x)))))

(defmethod pseudosentencep (p)
 "(PSEUDOSENTENCEP P)
  PSEUDOSENTENCEP takes a sentence as argument.  It returns T if the sentence is 
  pseudoprimitive; otherwise, it returns NIL."
  (cond ((atom p) (cond ((eq 'true p) nil)
                        ((eq 'cut p) nil)
                        ((eq 'false p) nil)
                        (t t)))
        ((eq 'not (car p)) (and (atomicp (cadr p)) (pseudosentencep (cadr p))))
        ((member (car p) '(and or <= <=> => forall exists) :test #'eq) nil)
        ((get (car p) 'basic) nil)
        (t (every #'primitivep (cdr p)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Note that needless occurrences of and and or are dropped:
;;;   (and p)  ---> p
;;;   (or p)   --->  p
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod sif (p)
 "(SIF P)
  SIF takes a sentence as argument, converts to simplified interchange format,
  and returns the result."
  (maksand (mapcar #'maksor (flats p))))

(defun flats (p)
  (let (universals alist alluniversals)
    (setq universals (freevars p))
    (sifs p)))

(defmethod sifp (p)
 "(SIFP P)
  SIFP takes a sentence as argument.  It returns T if the sentence is in 
  simplified interchange format; otherwise, it returns NIL."
  (cond ((atom p))
        ((eq 'not (car p)) (atomicp (cadr p)))
        ((eq 'and (car p)) (every 'clausep (cdr p)))
        ((eq 'or (car p)) (every 'literalp (cdr p)))
        ((operatorp (car p)) nil)
        (t t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (sifs p)
;;;   takes a sentence as argument
;;;   returns the clausal form
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sifs (p)
  (cond ((atom p) (cond ((eq 'true p) nil)
                        ((eq 'cut p) nil)
			((eq 'false p) (list nil))
			(t (list (list p)))))
	((eq 'not (car p)) (sins (cadr p)))
	((eq 'and (car p)) (sifsand p))
	((eq 'or (car p)) (sifsor p))
 	((eq 'xor (car p)) (sinsboth p))
        ((eq 'execute (car p)) (list (list p)))
        ((eq 'evaluate (car p)) (list (list p)))
        ((eq 'unprovable (car p)) (list (list p)))
	((eq '=> (car p)) (sifsforward p))
	((eq '<= (car p)) (sifsbackward p))
	((eq '<=> (car p)) (sifsboth p))
	((eq 'forall (car p)) (sifsforall p))
	((eq 'exists (car p)) (sifsexists p))
        ((eq 'defobject (car p)) (sifsdefobject p))
        ((eq 'deffunction (car p)) (sifsdeffunction p))
        ((eq 'defrelation (car p)) (sifsdefrelation p))
        ((member (car p) '(= ==) :test #'eq) (sifsis p))
	(t (sifsrelsent p))))

(defun sifsand (p)
  (sifsands (cdr p)))

(defun sifsands (l)
  (cond ((null l) nil)
	(t (andclause (sifs (car l)) (sifsands (cdr l))))))

(defun sifsor (p)
  (sifsors (cdr p)))

(defun sifsors (l)
  (cond ((null l) (list nil))
	(t (orclause (sifs (car l)) (sifsors (cdr l))))))

(defun sifsforward (p)
  (cond ((null (cdr p)) (list nil))
	(t (sifsforwards (cdr p)))))

(defun sifsforwards (l)
  (cond ((null (cdr l)) (sifs (car l)))
	(t (orclause (sins (car l)) (sifsforwards (cdr l))))))

(defun sifsbackward (p)
  (cond ((null (cdr p)) (list nil))
	(t (orclause (sifs (cadr p)) (sinsands (cddr p))))))

(defun sifsboth (p)
  (cond ((null (cdr p)) nil)
	((null (cddr p)) (list nil))
	(t (andclause (orclause (sifs (cadr p)) (sins (caddr p)))
                      (orclause (sins (cadr p)) (sifs (caddr p)))))))

(defun sifsexists (p)
  (let ((alist alist))
    (addexist (cadr p))
    (sifs (caddr p))))

(defun sifsforall (p)
  (let ((universals universals) (alist alist))
    (adduniv (cadr p))
    (sifs (caddr p))))

(defun sifsdefobject (p)
  (cond ((null (cddr p)) (list p))
        ((eq ':= (caddr p)) (list (list `(= ,(cadr p) ,(cadddr p)))))
        ((eq ':conservative-axiom (caddr p)) (list p))
        (t (sifsands (cddr p)))))

(defun sifsdeffunction (p)
  (cond ((null (cddr p)) (list p))
        ((eq ':= (cadddr p))
         (list (list `(= ,(cons (cadr p) (caddr p)) ,(car (cddddr p))))))
        ((eq ':conservative-axiom (caddr p)) (list p))
        (t (sifsands (cddr p)))))

(defun sifsdefrelation (p)
  (cond ((null (cddr p)) (list p))
        ((eq ':= (cadddr p))
         (sifsboth `(<=> ,(cons (cadr p) (caddr p)) ,(maksand (cddddr p)))))
        ((eq ':conservative-axiom (caddr p)) (list p))
        (t (sifsands (cddr p)))))

(defun sifsis (p)
  (let ((conditions))
    (list (nreverse (cons (list (car p) (sifspseudo (cadr p)) (sifsexp (caddr p)))
                          conditions)))))

(defun sifsrelsent (p)
  (let ((conditions))
    (list (nreverse (cons (cons (car p) (mapcar #'sifsexp (cdr p)))
                          conditions)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (sins p)
;;;   takes a sentence as argument
;;;   returns the clausal form of its negation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sins (p)
  (cond ((atom p) (cond ((eq 'true p) (list nil))
                        ((eq 'cut p) (list nil))
			((eq 'false p) nil)
			(t (list (list (maknot p))))))
	((eq 'not (car p)) (sifs (cadr p)))
	((eq 'and (car p)) (sinsand p))
	((eq 'or (car p)) (sinsor p))
 	((eq 'xor (car p)) (sifsboth p))
	((eq '=> (car p)) (sinsforward p))
	((eq '<= (car p)) (sinsbackward p))
	((eq '<=> (car p)) (sinsboth p))
	((eq 'exists (car p)) (sinsexists p))
	((eq 'forall (car p)) (sinsforall p))
        ((member (car p) '(= ==) :test #'eq) (sinsis p))
	(t (sinsrelsent p))))

(defun sinsor (p)
  (sinsors (cdr p)))

(defun sinsors (l)
  (cond ((null l) nil)
	(t (andclause (sins (car l)) (sinsors (cdr l))))))

(defun sinsand (p)
  (sinsands (cdr p)))

(defun sinsands (l)
  (cond ((null l) (list nil))
	(t (orclause (sins (car l)) (sinsands (cdr l))))))

(defun sinsforward (p)
  (cond ((null (cdr p)) nil)
	(t (sinsforwards (cdr p)))))

(defun sinsforwards (l)
  (cond ((null (cdr l)) (sins (car l)))
	(t (andclause (sifs (car l)) (sinsforwards (cdr l))))))

(defun sinsbackward (p)
  (cond ((null (cdr p)) nil)
        (t (andclause (sins (cadr p)) (sifsands (cddr p))))))

(defun sinsboth (p)
  (cond ((null (cdr p)) (list nil))
	((null (cddr p)) nil)
	(t (orclause (andclause (sins (cadr p)) (sifs (caddr p)))
                     (andclause (sifs (cadr p)) (sins (caddr p)))))))

(defun sinsexists (p)
  (let ((universals universals) (alist alist))
    (adduniv (cadr p))
    (sins (caddr p))))

(defun sinsforall (p)
  (let ((alist alist))
    (addexist (cadr p))
    (sins (caddr p))))

(defun sinsis (p)
  (let ((conditions))
    (list (nreverse (cons (maknot (list (car p) (sifspseudo (cadr p)) (sifsexp (caddr p))))
                          conditions)))))

(defun sinsrelsent (p)
  (let ((conditions))
    (list (nreverse (cons (maknot (cons (car p) (mapcar #'sifsexp (cdr p))))
                          conditions)))))


(defun sifspseudo (x)
  (cond ((varp x) (cond ((cdr (assoc x alist :test #'eq))) (t x)))
	((atom x) x)
        ((eq 'quote (car x)) x)
        ((eq 'execute (car x)) x)
        ((eq 'evaluate (car x)) x)
        ((eq 'unprovable (car x)) x)
        ((or (eq 'listof (car x)) (eq 'setof (car x)))
         (cons (car x) (mapcar #'sifsexp (cdr x))))
        (t (cons (car x) (mapcar #'sifsexp (cdr x))))))

(defun sifsexp (x)
  (cond ((varp x) (cond ((cdr (assoc x alist :test #'eq))) (t x)))
	((atom x)
         (cond ((numberp x) x)
               ((stringp x) x)
               ((characterp x) x)
               ((eq 'pi x) (sifsterm 'pi))
               ((or (not (listp *names*)) (member x *names* :test #'eq)) x)
               (t (sifsterm x))))
        ((eq 'quote (car x)) x)
	((member (car x) '(the setofall lambda kappa) :test #'eq)
	 (let ((alist alist))
	   (addbag (cadr x))
	   (list (car x) (cnfsexp (cadr x)) (cnfsexp (caddr x)))))
        ((or (eq 'listof (car x)) (eq 'setof (car x)))
         (cons (car x) (mapcar #'sifsexp (cdr x))))
        ((get (car x) 'basicval)
         (sifsterm (cons (car x) (mapcar #'sifsexp (cdr x)))))
        ((or (not (listp *functionals*))
             (member (car x) *functionals* :test #'eq))
         (cons (car x) (mapcar #'sifsexp (cdr x))))
        (t (sifsterm (cons (car x) (mapcar #'sifsexp (cdr x)))))))

(defun sifsterm (x)
  (let ((var (newindvar)))
    (setq conditions (cons `(not (= ,x ,var)) conditions))
    var))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; utilities.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special plistarray *theories* *includers* *debug*
                      *occurcheck* *unifications* *reduction* *ancestry*
                      *consistency* *saves* *names* *functionals*
                      *start* *increment* *depth* *termination* *inferences*
                      *trace-device* traceexpressions)))

(defparameter *kif-readtable* (copy-readtable))

(let ((*readtable* *kif-readtable*))
  (set-macro-character #\,
    #'(lambda (stream char)
        (declare (ignore char))
        (list 'unquote (read stream)))))

(set-macro-character #\^
  #'(lambda (stream char)
      (declare (ignore char))
      (let ((*readtable* *kif-readtable*))
        (explist (read stream)))))

(defun explist (x)
  (cond ((atom x) (quotify x))
        ((eq 'unquote (car x)) (cadr x))
        (t (cons 'listof (mapcar #'explist x)))))


(defmacro deftheory (x &rest l)
 "(DEFTHEORY NAME DOC &REST l)
  DEFTHEORY takes a theory name, an optional documentation string, and
  a list of sentences as arguments.  It empties the specified theory,
  saves the specified sentences, and adds the specified documentation.
  DEFTHEORY is a macro that produces a call to DEFINE-THEORY."
  (if (stringp (car l))
      `(define-theory ',x ,(car l) ',(cdr l))
      `(define-theory ',x nil ',l)))

(defmethod define-theory (th doc facts)
 "(DEFINE-THEORY NAME DOC FACTS)
  DEFINE-THEORY takes a theory name, a documentation string, and
  a list of sentences as arguments.  It empties the specified theory,
  saves the specified sentences, and adds the specified documentation.
  It returns the name of the theory as value."
  (empty th)
  (setf (documentation th 'concept) doc)
  (mapc #'(lambda (x) (insert x th)) facts)
  th)

(defmacro defmore (x &rest l)
  `(definemore ',x ',l))

(defmethod definemore (th facts)
 "(DEFINEMORE NAME DOC FACTS)
  DEFINEMORE takes a theory name and a list of sentences as arguments.  It
  saves the specified sentences to the specified theory and returns the name
  of the theory as value."
  (mapc #'(lambda (x) (save x th)) facts)
  th)

(defmethod defineless (th facts)
 "(DEFINELESS NAME DOC FACTS)
  DEFINELESS takes a theory name and a list of sentences as arguments.  It
  drops the specified sentences from the specified theory and returns the name
  of the theory as value."
  (mapc #'(lambda (x) (drop x th)) facts)
  th)

(defmacro defconcept (x th &rest l)
 "(DEFCONCEPT NAME THEORY DOC &REST l)
  DEFCONCEPT takes a concept name, a documentation string, and
  a list of sentences as arguments.  It kills the concept in the
  the current theory, saves the specified sentences, and adds
  the specified documentation.  DEFCONCEPT is a macro and produces a call
  to DEFINE-CONCEPT."
  (if (stringp (car l))
      `(define-concept ',x ',th ,(car l) ',(cdr l))
      `(define-concept ',x ',th  nil ',l)))

(defmethod define-concept (obj th doc facts)
 "(DEFINE-CONCEPT NAME THEORY DOC FACTS)
  DEFINE-CONCEPT takes a concept name, a theory, a documentation string, and
  a list of sentences as arguments.  It saves the specified sentences and adds
  the specified documentation.  It return the name of the concept as value."
  (setf (documentation obj 'concept) doc)
  (mapc #'(lambda (x) (save x th)) facts)
  obj)


(defmethod load-theory (fn th &optional (g 'save))
 "(LOAD-THEORY FILENAME TH &OPTIONAL (G 'SAVE))
  LOAD-THEORY takes a filename, a theory, and a subroutine as arguments.  
  It first empties the specified theory.  It then reads the sentences
  in the specified file and uses the specified subroutine to add them to
  the specified theory.  It returns DONE as value."
  (with-open-file (f fn :direction :input)
    (empty th)
    (do ((a (read f nil) (read f nil)))
	((null a) t)
        (funcall g a th))))

(defmethod load-sentences (fn th &optional (g 'save))
 "(LOAD-SENTENCES FILENAME TH &OPTIONAL (G 'SAVE))
  LOAD-SENTENCES takes a filename, a theory, and a subroutine as arguments.  
  It reads the sentences in the specified file and uses the specified
  subroutine to add them to the specified theory.  It returns DONE as value."
  (with-open-file (f fn :direction :input)
    (do ((a (read f nil) (read f nil)))
	((null a) t)
        (funcall g a th))))

(defmethod dump-theory (th fn)
 "(DUMP-THEORY th filename)
  DUMP-THEORY takes a theory and a file name as arguments.  It writes into
  the specified file all of the sentences contained in the theory so that,
  when loaded with LOAD-THEORY, the contents of the theory will be restored.
  It returns DONE as value."
  (with-open-file (f fn :direction :output :if-exists :supersede)
    (do ((m (contents th) (cdr m)))
        ((null m) t)
        (print (car m) f))))

(defmethod demo (fn)
 "(DEMO f)
  DEMO takes a file name as argument and demonstrates the contents.  First, it
  instructs the user to type a carriage return to advance.  When the carriage
  return is typed, DEMO reads in one sexpression, prints it on the terminal,
  evaluates it, and prints the result on the terminal.  It then waits for the
  next carriage return from the user.  DEMO returns DONE as value."
  (with-open-file (f fn :direction :input)
    (fresh-line) (princ '|Type a carriage return to advance.|)
    (do ((s (read f nil 'end) (read f nil 'end)))
	((eq 'end s) t)
	(do ((c (read-char t) (read-char t)))
	    ((eql #\return c)))
	(pprint s)
	(fresh-line) (princ (eval s)))))

(defmethod show (x th &optional (f 'matchp))
 "(SHOW X THEORY (F 'matchp))
  SHOW takes an expression, a theory, and a matching subroutine as arguments.
  It prints out on the terminal all sentences in the specified theory that match
  the specified expression using the specified matcher.  It returns DONE as
  value.  NB: SHOW does NOT print out the sentences in included theories; see
  SHOW-ALL."
  (prfacts (facts x th f)))

(defmethod show-all (x th &optional (f 'matchp))
 "(SHOW-ALL X THEORY (F 'matchp))
  SHOW-ALL takes an expression, a theory, and a matching subroutine as arguments.
  It prints out on the terminal all sentences in the specified theory and it
  included theories that match the specified expression using the specified
  matcher.  It returns DONE as value."
  (prfacts (sentences x th f)))

(defun prfacts (l)
  (do ()
      ((null l) t)
      (fresh-line)
      (prin1 (car l))
      (setq l (cdr l))))

(eval-when (compile load eval)
  (proclaim '(special *naf*)))

(defmethod reset ()
 "(RESET)
  RESET resets the data structures of Epilog to their initial state and then
  returns DONE as value."
  (mapc #'empty *theories*)
  (mapc #'decludes *includers*)
  (setq plistarray (make-hash-table :test 'equal))
  (setq *debug* t)
  (setq *occurcheck* t)
  (setq *reduction* t)
  (setq *ancestry* nil)
  (setq *consistency* t)
  (setq *saves* t)
  (setq *names* t)
  (setq *naf* nil)
  (setq *functionals* nil)
  (setq *unifications* 0)
  (setq *start* 1000)
  (setq *increment* 1000)
  (setq *depth* 1000000)
  (setq *termination* nil)
  (setq *inferences* 0)
  (setq *trace-device* t)
  (setq traceexpressions nil)
  'done)

(defmethod test (fn)
 "(TEST filename)
  TEST takes a filename as argument and executes each of the tests in the
  file.  The file consists of sequence of s-expressions. The odd numbered
  s-expressions are the tests to evaluate, and the even numbered s-expressions
  are the expected results. An expected result of * means that any value is
  acceptable. The function returns the total number of errors."
  (with-open-file (f fn :direction :input)
    (do ((test) (expect) (actual) (n 0))
	(nil)
	(cond ((eq 'stop (setq test (read f nil 'stop))) (return n))
	      ((eq 'stop (setq expect (read f nil 'stop)))
	       (princ '|Early end of file for |) (princ fn)
	       (terpri) (return n))
	      ((or (equalp expect (setq actual (ignore-errors (eval test))))
                   (eq '* expect)))
	      (t (setq n (1+ n))
		 (terpri) (princ "Error in ") (princ fn)
                 (terpri) (princ test)
		 (terpri) (princ actual) (princ '| not |) (princ expect)
                 (terpri))))))

;;;; -*- Mode: Lisp; Package: (REGEXP COMMON-LISP); -*-
;;;;===========================================================================
;;;; regexp.lisp - A regular expression parser and matcher.
;;;;	(c) Sudhir Shenoy, 1996. All rights reserved.
;;;;       sshenoy@gol.com
;;;;===========================================================================
;;;; Use and copying of this software and preparation of derivative works
;;;; based upon this software are permitted, so long as the following
;;;; conditions are met:
;;;;      o no fees or compensation are charged for use, copies, or
;;;;        access to this software
;;;;      o this copyright notice is included intact.
;;;; This software is made available AS IS, and no warranty is made about
;;;; the software or its performance.
;;;;===========================================================================
;;;;
;;;; NOTE: This is my first reasonably large Common Lisp program. If you
;;;; have constructive criticism about my Lisp code / algorithm, ***PLEASE
;;;; TELL ME*** so that I can improve it.
;;;;
;;;;===========================================================================
;;;;
;;;; This package exports two functions -
;;;;
;;;; 'regcomp' takes a regular expression and parses it according to
;;;; one of two syntaxes - POSIX (new) or the old style syntax. The
;;;; old syntax is not fully supported. Specifically back-refs are not
;;;; implemented (they are recognized but are not processed). Parsing
;;;; is controlled by means of a list of flags passed to regcomp.
;;;; The following keyword arguments may be used to specify the flags
;;;;	:re-basic   = use the old RE syntax.
;;;;	:re-extended = use the (new) extended POSIX syntax (DEFAULT).
;;;;	:re-nospec  = Plain old string (no meta-characters). Using string=
;;;;			will be much faster than this !
;;;;	:re-icase   = Compile for case insensitive matches.
;;;;	:re-newline = Compile for newline sensitive matching.	By default,
;;;;		      newline is an ordinary char. With this flag, `[^' and
;;;;		      `.' never match newlines.
;;;;     A `^' anchor always matches the null string following a newline in
;;;;     addition to its normal function and `$' matches the null string
;;;;     before a newline as well as end of string.
;;;;
;;;; 'regexec' takes a string and either a compiled regular expression or
;;;; a pattern string (which is then compiled) and returns NIL if the pattern
;;;; is not found in the string. If it is found, a vector of lists is returned.
;;;; Each element of this array contains the start and end positions of the
;;;; match for each group (element 0 is the entire match).
;;;; Note that NIL is also returned when compilation of a pattern string fails.
;;;;
;;;; BUGS: At present, this code does not match an implicit NULL. For example,
;;;; the patterns "*b" and "(a|)" will not compile. The work around is to
;;;; to specify "()*b" and "(a|())" respectively. This is not a great loss
;;;; since (a) pattern 1 == "b" and 2 == "a?" and (b) we accept any number
;;;; of groups (not only 9) so putting in an additional grouping doesn't
;;;; hurt. Lisp hackers shouldn't mind an additional couple of parentheses
;;;; anyhow :-)
;;;;
;;;;===========================================================================
;;;; Change History:
;;;;
;;;; ??/??/97
;;;; Bug fix. Corrected definition of #'left-group-longer which was causing
;;;; the matching algorithm to find shorter sub-group matches than it should
;;;; have.
;;;;
;;;; 20/12/96
;;;; Implemented back-refs (finally !).
;;;; Cleaned up some group matching bugs.
;;;;
;;;; 12/12/96
;;;; Fixed bug where sometimes the shorter match was being selected. e.g.,
;;;; when (ab|a)b*c applied to "abc" returned the value #((0 3) (0 1))
;;;; insetad of #((0 3) (0 2)). Specifying the pattern as "(a|ab)b*c" gave
;;;; the correct result !
;;;; Added clause to check result of regcomp in regexec which had been
;;;; mistakenly removed in an earlier edit.
;;;;
;;;; To Do:
;;;; Add support for equivalence classes once I can figure them out :-)
;;;; Add optimizations. For example, use string compare where possible
;;;;			instead of always doing character by character matches.
;;;;			Look for sub-expressions which can be used to
;;;;			create a DFA during execution etc.
;;;; (Maybe) support the implicit NULL chars which make us flunk a few tests.
;;;;
;;;;===========================================================================

(declaim (optimize (speed 3) (compilation-speed 0)))

;;; List of valid flags for the parse and exec phases
(defparameter +compile-flags+ '(:re-extended :re-basic :re-icase
                                :re-newline :re-nospec))

;;;
;;; Global variables required to avoid long parameter lists
;;;
(proclaim '(simple-string *pattern*))
(defvar *pattern* "")			; pattern to be compiled
(proclaim '(fixnum *pat-len* *1-pat-len* *pat-idx*))
(defvar *pat-len* 0)			; its length
(defvar *1-pat-len* -1)			; one less than its length
(defvar *pat-idx* 0)			; parse scan position
(defvar *parse-flags* '())		; flags passed to regcomp

(proclaim '(fixnum *group-num*))
(defvar *group-num* 0)                  ; count of groups while compiling

(defvar *stack* nil)                    ; stack for backtracking when matching
(defvar *match* nil)                    ; best match found
(proclaim '(simple-vector *groups*))
(defvar *groups* (make-array 0))        ; match positions
(proclaim '(simple-vector *group-starts*))
(defvar *group-starts*)                 ; group match start positions

(defvar *char-match* NIL)               ; character matching rtn. to apply
(defvar *str-match* NIL)                ; string matching rtn. to apply

;;; A compiled regular expression
(defstruct compiled-re
  char-match                            ; either #'char= or char-equal
  str-match                             ; either #'string= or string-equal
  (pat (make-array 0) :type simple-vector) ; vector of node structs
  (num-groups 0 :type fixnum))          ; number of parenthesized groups

;;; A single node in the compiled RE
(defstruct node
  (type NIL)                            ; type of node - can be a character,
                                        ; bit-array or symbol
  (fwd-link NIL)                        ; next state (bypass)
  (back-link NIL))                      ; previous state (loop)

;;;======================================================================
;;; Low level utility functions / macros
;;;======================================================================

;;; Exception when we get errors
(declaim (inline set-error))
(defun set-error (error-string)
  (throw 're-parse-error (values NIL error-string)))

;;; Ensure that cond is true otherwise throw exception
(defmacro ensure-that (boolean error-string)
  `(unless ,boolean
     (set-error ,error-string)))

;;;======================================================================
;;; Pattern string scanning functions (most declaimed inline). These
;;; functions all depend on the global vars *pattern* *pat-len* *pat-idx* etc.
;;;======================================================================

;;; Have we reached end-of-pattern ?
(declaim (inline more-input))
(defun more-input ()
  (< *pat-idx* *pat-len*))

;;; Next input char
(declaim (inline peek-input))
(defun peek-input ()
  (if (< *pat-idx* *pat-len*)
    (schar *pattern* *pat-idx*)
    #\NULL))

;;; Next to next input char
(declaim (inline peek2-input))
(defun peek2-input ()
  (if (< *pat-idx* *1-pat-len*)
    (schar *pattern* (1+ *pat-idx*))
    #\NULL))

;;; Return next char and advance pointer
(declaim (inline next-char))
(defun next-char ()
  (if (< *pat-idx* *pat-len*)
    (prog1
      (schar *pattern* *pat-idx*)
      (incf *pat-idx*))
    #\NULL))

;;; Return list of next two chars w/o advancing pointer
(declaim (inline peek-next2-chars))
(defun peek-next2-chars ()
  (list (peek-input) (peek2-input)))

;;; Return T if next char is the one specified & advance pointer.
;;; If some other char, return NIL and do nothing to the pointer.
(declaim (inline skip-char))
(defun skip-char (ch)
  (if (char= (peek-input) ch)
    (progn
      (incf *pat-idx*)
      T)
    NIL))

;;; Return T if next two chars are the ones specified & advance pointer.
;;; If some other chars, return NIL and do nothing to the pointer.
(declaim (inline skip2-chars))
(defun skip2-chars (two-chars)
  (if (equal (peek-next2-chars) two-chars)
    (progn
      (incf *pat-idx* 2)
      T)
    NIL))

;;; Move pointer forward
(declaim (inline advance-input))
(defun advance-input ()
  (incf *pat-idx*))

;;; Read an integer at the current pointer posn. and advance pointer
(defun read-integer ()
  (multiple-value-bind
    (val len) (parse-integer (subseq *pattern* *pat-idx*) :junk-allowed T)
    (when val
      (incf *pat-idx* (the fixnum len)))
    val))

;;;======================================================================
;;; Character set functions - handle ranges of characters and create a
;;; bit array which has a bit set for each character allowed. This makes
;;; the resulting code valid only for character sets with values <= 128.
;;;======================================================================

;;; Make a zeroed bit vector. Appropriate bits are set for char range checks
(declaim (inline all-zero-bits))
(defun all-zero-bits ()
  (the simple-bit-vector
    (make-sequence 'bit-vector 128 :initial-element 0)))

;;; Create a bit-vector containing 1's for all chars appearing in str
(defun make-bit-array (lst)
  (let ((bary (all-zero-bits)))
    (declare (simple-bit-vector bary))
    (dolist (ch lst)
      (setf (aref bary (char-code ch)) 1))
    bary))

;;; Interpret a character class name and return a corresponding bit-vector
(defun interpret-class-name ()
  (let ((class-names #("alnum" "alpha" "blank" "cntrl" "digit" "graph"
                       "lower" "print" "punct" "space" "upper" "xdigit"))
        (class-chars #(;; alnum = alphanumeric
                       (#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M
                        #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z
                        #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
                        #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z
                        #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
                       ;; alpha = alphabetic
                       (#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M
                        #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z
                        #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
                        #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z)
                       ;; blank
                       (#\Space #\Tab)
                       ;; ctrl = Control chars (not including tab,ff,cr etc.)
                       (#\Bell #\BackSpace #\Tab #\LineFeed #\Page #\Return
                        #\Rubout
                        #.(code-char  1) #.(code-char  2) #.(code-char  3)
                        #.(code-char  4) #.(code-char  5) #.(code-char  6)
                        #.(code-char 11) #.(code-char 14) #.(code-char 15)
                        #.(code-char 16) #.(code-char 17) #.(code-char 18)
                        #.(code-char 19) #.(code-char 20) #.(code-char 21)
                        #.(code-char 22) #.(code-char 23) #.(code-char 24)
                        #.(code-char 25) #.(code-char 26) #.(code-char 27)
                        #.(code-char 28) #.(code-char 29) #.(code-char 30)
                        #.(code-char 31))
                       ;; digit
                       (#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
                       ;; graph = printable (not including space)
                       (#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M
                        #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z
                        #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
                        #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z
                        #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\! #\" #\#
                        #\$ #\% #\& #\' #\( #\) #\* #\+ #\, #\- #\. #\/ #\:
                        #\; #\< #\= #\> #\? #\@ #\[ #\\ #\] #\^ #\_ #\` #\{
                        #\| #\} #\~)
                       ;; lower = lower case alphabets
                       (#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
                        #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z)
                       ;; print = printable (including space)
                       (#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M
                        #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z
                        #\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m
                        #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z
                        #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\! #\" #\#
                        #\$ #\% #\& #\' #\( #\) #\* #\+ #\, #\- #\. #\/ #\:
                        #\; #\< #\= #\> #\? #\@ #\[ #\\ #\] #\^ #\_ #\` #\{
                        #\| #\} #\~ #\Space)
                       ;; punct = graph - alnum
                       (#\! #\" #\# #\$ #\% #\& #\' #\( #\) #\* #\+ #\, #\-
                        #\. #\/ #\: #\; #\< #\= #\> #\? #\@ #\[ #\\ #\] #\^
                        #\_ #\` #\{ #\| #\} #\~)
                       ;; space = whitespace
                       (#\Tab #\LineFeed #\Page #\Return #\Space
                        #.(code-char 11))
                       ;; upper = upper case alphabets
                       (#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J #\K #\L #\M
                        #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z)
                       ;; xdigit = hexadecimal digit chars
                       (#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9
                        #\A #\B #\C #\D #\E #\F #\a #\b #\c #\d #\e #\f)))
        str
        (pos NIL))
    (when (<= (+ *pat-idx* 5) *pat-len*)
      (setf str (subseq *pattern* *pat-idx* (+ *pat-idx* 5))
	    pos (position str class-names :test #'equal))
      (when (and (not pos) (<= (+ *pat-idx* 6) *pat-len*))
        (setf str (subseq *pattern* *pat-idx* (+ *pat-idx* 6))
              pos (position str class-names :test #'equal))))
    (when pos
      (let ((str (elt class-names pos)))
        (declare (simple-string str))
        (incf *pat-idx* (length str))))
    (if (or (not pos) (not (equal (peek-next2-chars) '(#\: #\]))))
      ;; assume this wasn't a class name at all but merely characters
      (let ((bary (all-zero-bits)))
        (setf (aref bary (char-code #\[)) 1
              (aref bary (char-code #\:)) 1)
        (when pos
          (let ((str (elt class-names pos)))
            (dotimes (i (length str))
              (setf (aref bary (char-code (char str i))) 1))))
        (do () ((not (and (more-input) (char/= (peek-input) #\]))))
          (setf (aref bary (char-code (next-char))) 1))
        bary)
      (progn
        (incf *pat-idx* 2)
        (make-bit-array (elt class-chars pos))))))

;;; A bit set of a char with lower & upper case set
(declaim (inline set-both-cases))
(defun set-both-cases (ch)
  (let ((u (char-upcase ch))
        (l (char-downcase ch))
        (a (all-zero-bits)))
    (setf (aref a (char-code l)) 1
	  (aref a (char-code u)) 1)
    a))

;;; Process an ordinary character. Simply returns it.
(declaim (inline ordinary-char))
(defun ordinary-char (ch)
  ch)

;;;  (if (and (member :re-icase *parse-flags* :test #'eq)
;;;           (alpha-char-p ch))
;;;    (list 'CHAR-SET (set-both-cases ch))
;;;    ch))

;;; Is this a set of one character ? Small optimization
(declaim (inline single-char-set?))
(defun single-char-set? (bary)
  (declare (simple-bit-vector bary))
  (let ((ch #\NULL))
    (dotimes (i (length bary))
      (when (= 1 (aref bary i))
        (if (char/= ch #\NULL)
          (return-from single-char-set? NIL)
          (setf ch (code-char i)))))
    ch))

;;; Make a bit-vector with ones in the specified range of chars
(declaim (inline make-bit-range))
(defun make-bit-range (start-ch end-ch)
  (do ((i (char-code start-ch) (1+ i))
       (bary (all-zero-bits)))
      ((> i (char-code end-ch)) bary)
    (setf (aref bary i) 1)))

;;;======================================================================
;;; Regular expression parsing routines.
;;; Handle POSIX expressions and old style expressions.
;;;======================================================================

;;; Parse "[...]"
(defun parse-bracket ()
  (let ((bit-array (all-zero-bits))
        (offset (- (char-code #\a) (char-code #\A)))
        (invert-at-end NIL))
    (declare (simple-bit-vector bit-array))
    (when (skip-char #\^)
      (setf invert-at-end T))
    (if (skip-char #\])
      (setf (aref bit-array (char-code #\])) 1)
      (if (skip-char #\-)
        (setf (aref bit-array (char-code #\-)) 1)))
    (do () ((not (and (more-input)
                (char/= (peek-input) #\])
                (not (equal (peek-next2-chars) '(#\- #\]))))))
      (bit-ior bit-array (the simple-bit-vector (parse-bracket-term)) T))
    (when (skip-char #\-)
      (setf (aref bit-array (char-code #\-)) 1))
    (unless (skip-char #\])
      (set-error "Missing right bracket `]'"))
    (when (member :re-icase *parse-flags* :test #'eq)
      (do ((i (char-code #\A) (1+ i)))
          ((= i (1+ (char-code #\z))))
        (when (= (aref bit-array i) 1)
          (if (< i (char-code #\Z))
            (setf (aref bit-array (+ i offset)) 1)
            (when (>= i (char-code #\a))
              (setf (aref bit-array (- i offset)) 1))))))
    (when invert-at-end
      (setf bit-array (bit-not bit-array)))
    (let ((ch (single-char-set? bit-array)))
      (if ch
        ch
        (list 'CHAR-SET bit-array)))))

;;; Only handles characters, character ranges and classes for now
;;; Equivalence classes are not implemented
(defun parse-bracket-term ()
  (the simple-bit-vector
    (let ((ch1 (next-char))
          (ch2 (peek-input))
          (ch3 #\NULL))
      (if (and (char= ch1 #\[) (char= ch2 #\:))
        (progn
          (advance-input)
          (interpret-class-name))
        (if (char= ch2 #\-)
          (progn
            (next-char)
	    (if (char= (peek-input) #\])
              (progn
                (make-bit-range ch1 ch1)
                (make-bit-range ch2 ch2))
	      (progn
		(setf ch3 (next-char))
		(when (or (not ch3)
			  (< (char-code ch3) (char-code ch1)))
                  (set-error
                   (format NIL "Invalid character range ~A-~A"
                           ch1 ch3)))
		(make-bit-range ch1 ch3))))
	  (make-bit-range ch1 ch1))))))

;;; Repeat an expression some bounded number of times. Simple cases
;;; like {0,1}, {0,} and {1,} are collapsed into ?,* and + respectively.
;;; Since other cases are done by macro expansion, it is conceivable that
;;; one could eventually run out of memory for nested expressions.
(defun repeat-expr (expr count1 count2)
  (declare (fixnum count1 count2))
  (let ((result '()))
    (cond ((and (= 0 count1) (= 0 count2)) ; {0,0} !!!
           '())
          ((and (= 0 count1) (= 1 count2)) ; {0,1} == ?
           (list 'ZERO-OR-ONE expr))
          ((and (= 0 count1) (= MOST-POSITIVE-FIXNUM count2)) ; {0,} == *
           (list 'ZERO-OR-MORE expr))
          ((= 0 count1)			; {0, n}
           (list 'ZERO-OR-ONE (repeat-expr expr 1 count2)))
          ((and (= 1 count1) (= 1 count2)) ; {1,1} == waste of breath
           expr)
          ((and (= 1 count1) (= MOST-POSITIVE-FIXNUM count2)) ; {1,} == +
           (list 'ONE-OR-MORE expr))
          ((= 1 count1)			; {1, n}
           (push expr result)
           (when (and (consp expr) (eq (car expr) 'GROUP))
             (setf expr (cdr expr)))
           (dotimes (i (1- count2))
             (push (list 'ZERO-OR-ONE expr) result))
           (nreverse result))
          ((= count2 MOST-POSITIVE-FIXNUM) ; {n,}
           (append (list expr) (repeat-expr (if (and (consp expr) (eq 
(car expr) 'GROUP))
                                              (cdr expr)
                                              expr)
                                            (1- count1) count2)))
          (t				; {m,n}
           (append (list expr) (repeat-expr (if (and (consp expr) (eq 
(car expr) 'GROUP))
                                              (cdr expr)
                                              expr)
                                            (1- count1) (1- count2)))))))

;;; Read a single expression possibly followed by a repetition char (?,+ or *)
(defun parse-extended-re-expr ()
  (let* ((ch (next-char))
         (expr (case ch
                 ((#\()		; start of group
                  (ensure-that (more-input) "Missing right paren `)'")
                  (if (char= (peek-input) #\))
                    (progn
                      (next-char)
                      '(GROUP))
                    (let ((lst (parse-extended-re #\))))
                      (if (not (skip-char #\)))
                        (set-error "Missing right paren `)'")
                        (cons 'GROUP lst)))))
                 ((#\^)		; beginning of line
                  'START-OF-LINE)
                 ((#\$)		; end of line
                  'END-OF-LINE)
                 ((#\|)		; error - two |s together
                  (set-error "No expression between `|' and `|'"))
                 ((#\* #\+ #\?)	; can never come here
                  (set-error
                   (format NIL "Bad repeat character ~A" ch)))
                 ((#\.)		; any character
                  (if (member :re-newline *parse-flags* :test #'eq)
                    (list 'CHAR-SET
                          (bit-not (make-bit-range #\NewLine #\NewLine)))
                    'ANY-CHAR))
                 ((#\[)		; range or symbol.
                  ;; Note: Currently only character ranges are implemented
                  (parse-bracket))
                 ((#\\)		; literal or back reference
                  (unless (more-input)
                    (set-error "Escape cannot be the last character"))
                  (let ((ch2 (next-char)))
                    (if (find ch2 "123456789")
                      ;; We check for semantic validity only in do-compile
                      (list 'BACK-REF (- (char-code ch2) (char-code #\0)))
                      (ordinary-char ch2))))
                 ((#\{)		; OK as a char unless digit follows
                  (if (and (more-input)
                           (not (digit-char-p (peek-input))))
                    (ordinary-char ch)
                    (set-error "Bad repeat count")))
                 (t			; everything else is an ordinary char
                  (ordinary-char ch)))))
    ;; We have an expression, check if it is followed by a repetition operator
    (when (more-input)
      (setf ch (peek-input))
      (when (or (find ch "*?+")
                (and (char= ch #\{)
                     (digit-char-p (peek2-input))))
        (advance-input)
        ;; Only tricky bit is that if there is a group followed
        ;; by a repetition char, it is not considered a group so
        ;; we excise the group indicator (except if it is a null group).
        (case ch
          ((#\*)		; zero or more
           (setf expr (list 'ZERO-OR-MORE expr)))
          ((#\+)		; one or more
           (setf expr (list 'ONE-OR-MORE expr)))
          ((#\?)		; zero or one
           (setf expr (list 'ZERO-OR-ONE expr)))
          ((#\{)		; repeat range
           (let* ((count1 (read-integer))
                  (count2 count1))
             (declare (fixnum count1 count2))
             (when (skip-char #\,)
               (if (digit-char-p (peek-input))
                 (progn
                   (setf count2 (read-integer))
                   (when (< count2 count1)
                     (set-error
                      (format NIL "Invalid repeat count {~A,~A}"
                              count1 count2))))
                 (setf count2 MOST-POSITIVE-FIXNUM)))
             (setf expr (repeat-expr expr count1 count2))
             (unless (skip-char #\})
               (do () ((not (and (more-input)
                           (char/= (peek-input) #\}))))
                 (advance-input))
               (set-error "Bad terminating `}'"))))))
      ;; Ensure no more repetition operators immediately after the first
      (when (more-input)
        (let ((ch (peek-input)))
          (ensure-that (not (or (find ch "+?*")
                                (and (char= ch #\{)
                                     (digit-char-p (peek2-input)))))
                       (format NIL "Bad repeat char ~A" ch)))))
    expr))

;;; Parse an extended Regular Expression (i.e. POSIX standard).
(defun parse-extended-re (stop-char)
  (do ((parsed-re '())
       (groups '())
       (done NIL))
      (done parsed-re)
    (do () ((not (and (more-input)
                (let ((ch (peek-input)))
                  (and (char/= ch #\|)
                       (char/= ch stop-char))))))
      (let ((expr (parse-extended-re-expr)))
        (unless (null expr)		; x{0,0} returns a null list
          (push expr parsed-re))))
    (ensure-that (not (null parsed-re)) "Missing OR clause")
    (setf parsed-re (nreverse parsed-re))

    (if (skip-char #\|)
      (progn
        ;; New | clause, save LHS and parse RHS
        (push parsed-re groups)	; save BRANCH clause
        (setf parsed-re '()))
      (progn
        (setf done T)
        (if (not (null groups))
          (progn
            (push parsed-re groups)
            (do ((new-parsed-re NIL))
                ((null groups) (setf parsed-re (cons 'BRANCH new-parsed-re)))
              (push (pop groups) new-parsed-re))))))))

;;; no meta characters (why would any one want this ?)
(defun parse-str ()
  (do ((parse-list NIL))
      ((not (more-input)) parse-list)
    (push (next-char) parse-list)))

;;; Parse an old-style regular expr.
(defun parse-basic-re-expr (first-time)
  (let ((ch1 (next-char))
        (ch2 #\NULL))
    (when (char= ch1 #\\)
      (unless (more-input)
        (set-error "Escape cannot be the last character"))
      (setf ch2 (next-char)))
    (when (and (char= ch1 #\\)
               (not (find ch2 "{}()123456789")))
      (setf ch1 ch2))
    (let ((expr (case ch1
                  ((#\.)
                   (if (member :re-newline *parse-flags* :test #'eq)
                     (list 'CHAR-SET
                           (bit-not (make-bit-range #\NewLine #\NewLine)))
                     'ANY-CHAR))
                  ((#\[)
                   (parse-bracket))
                  ((#\\)
                   (case ch2
                     ((#\{)
                      (set-error "Bad repeat count"))
                     ((#\()
                      (ensure-that (more-input) "Missing right paren `)'")
                      (if (equal (peek-next2-chars) '(#\\ #\)))
                        (progn
                          (next-char)
                          (next-char)
                          '(GROUP))
                        (let ((lst (parse-basic-re #\\ #\))))
                          (if (not (skip2-chars '(#\\ #\))))
                            (set-error "Missing right paren `)'")
                            (cons 'GROUP lst)))))
                     ((#\) #\})
                      (set-error
                       (format NIL "Bad right paren/brace ~A" ch2)))
                     ((#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
                      (list 'BACK-REF
                            (- (char-code ch2) (char-code #\0))))))
                  ((#\*)		; first char can legally be a *
                   (if first-time
                     (ordinary-char ch1)
                     (set-error "Bad repeat char *")))
                  (t
                   (ordinary-char ch1)))))
      ;; Check for a repetition char
      (if (skip-char #\*)
        (setf expr (list 'ZERO-OR-MORE expr))
        (if (skip2-chars '(#\\ #\{))
          (let* ((count1 (read-integer))
                 (count2 count1))
            (declare (fixnum count1 count2))
            (when (skip-char #\,)
              (if (digit-char-p (peek-input))
                (progn
                  (setf count2 (read-integer))
                  (when (< count2 count1)
                    (set-error
                     (format NIL "Invalid repeat count {~A,~A}"
                             count1 count2))))
                (setf count2 MOST-POSITIVE-FIXNUM)))
            (setf expr (repeat-expr expr count1 count2))
            (unless (skip2-chars '(#\\ #\}))
              (do () ((not (and (more-input)
                          (not (equal (peek-next2-chars) '(#\\ #\}))))))
                (advance-input))
              (set-error "Bad closing brace `}'")))))
      expr)))

;;; Parse an old style RE
(defun parse-basic-re (stop-char-1 stop-char-2)
  (let ((parse-list NIL)
        (first-time T))
    (when (skip-char #\^)
      (push 'START-OF-LINE parse-list))
    (do ((stop-list (list stop-char-1 stop-char-2)))
        ((or (not (more-input))
             (equal (peek-next2-chars) stop-list))
         (progn
           (when (equal (car parse-list) #\$) ; kludge to avoid looking ahead
             (setf (car parse-list) 'END-OF-LINE))
           (nreverse parse-list)))
      (push (parse-basic-re-expr first-time) parse-list)
      (setf first-time NIL))))

;;;======================================================================
;;; Compile the parsed list into a more convenient representation. This
;;; is an array of structs.
;;;======================================================================

;;; Extend array if necessary
(declaim (inline setf-ary))
(defun setf-ary (ary idx item)
  (declare (fixnum idx)
	   (array ary))
  (when (>= idx (length ary))
    (adjust-array ary (+ 10 (length ary))))
  (setf (aref ary idx) item))

(declaim (inline last-branch))
(defun last-branch (ary idx)
  (declare (fixnum idx))
  (decf idx)
  (do () ((not (> idx 0)))
    (when (eq (node-type (aref ary idx)) 'BRANCH)
      (return-from last-branch idx))
    (decf idx))
  (error "branch node not found"))

;;; Compile a regular expression. The input is a list given by
;;; parse-extended-re etc. This is converted into an array of node structs
;;; with forward/back pointers filled in (an array representation of a
;;; graph).
(defun do-compile (lst ary idx inside-groups)
  (declare (fixnum idx)
	   (array ary))
  (cond ((null lst) idx)
	((or (characterp lst) (stringp lst))
	 (setf-ary ary idx (make-node :type lst))
	 (incf idx))
	((or (eq lst 'ANY-CHAR)
	     (eq lst 'START-OF-LINE)
	     (eq lst 'END-OF-LINE))
	 (setf-ary ary idx (make-node :type lst))
	 (incf idx))
	((atom lst) (error "not handling ~S item" lst))
	((eq (car lst) 'CHAR-SET)
	 (setf-ary ary idx (make-node :type (cadr lst)))
	 (incf idx))
	((eq (car lst) 'ZERO-OR-ONE)
	 (let ((o-idx idx))
	   (setf idx (do-compile (cdr lst) ary idx inside-groups))
	   (if (eq (node-type (aref ary o-idx)) 'BRANCH)
             (setf o-idx (last-branch ary idx)))
	   (setf (node-fwd-link (aref ary o-idx)) (- idx o-idx))
	   idx))
	((eq (car lst) 'ZERO-OR-MORE)
	 (let ((o-idx idx))
	   (setf idx (do-compile (cdr lst) ary idx inside-groups)
		 (node-back-link (aref ary (1- idx))) (- idx o-idx 1))
	   (when (eq (node-type (aref ary o-idx)) 'BRANCH)
             (setf o-idx (last-branch ary idx)))
	   (setf (node-fwd-link (aref ary o-idx)) (- idx o-idx))
	   idx))
	((eq (car lst) 'ONE-OR-MORE)
	 (let ((o-idx idx))
	   (setf idx (do-compile (cdr lst) ary idx inside-groups)
		 (node-back-link (aref ary (1- idx))) (- idx o-idx 1))
	   idx))
	((eq (car lst) 'GROUP)
	 (let ((this-group-num (incf *group-num*)))
	   (setf-ary ary idx (make-node :type (list 'GROUP this-group-num)))
           (push this-group-num inside-groups)
	   (setf idx (do-compile (cdr lst) ary (1+ idx) inside-groups))
	   (setf-ary ary idx (make-node :type (list 'END-GROUP 
this-group-num)))
           (pop inside-groups)
	   (incf idx)))
        ((eq (car lst) 'BACK-REF)
         (if (or (> (the fixnum (cadr lst)) *group-num*)
                 (member (cadr lst) inside-groups))
           (set-error (format nil "Back reference ~D invalid." (cadr lst)))
           (progn
             (setf-ary ary idx (make-node :type (copy-list lst)))
             (incf idx))))
	((eq (car lst) 'BRANCH)
	 (let ((o-idx idx)
	       (jump-nodes NIL))
	   (dolist (term (cdr lst))
             (setf o-idx idx)
             (setf-ary ary idx (make-node :type 'BRANCH))
             (setf idx (do-compile term ary (1+ idx) inside-groups)
                   (node-fwd-link (aref ary o-idx)) (1+ (- idx o-idx)))
             (setf-ary ary idx (make-node :type 'JUMP))
             (push idx jump-nodes)
             (incf idx))
	   ;; The last branch & jump nodes to be excised
	   (setf (node-fwd-link (aref ary o-idx)) NIL)
	   (decf idx)
	   (setf (aref ary idx) NIL)
	   (pop jump-nodes)
	   ;; Fill in the jump pointers
	   (dolist (i jump-nodes)
             (setf (node-fwd-link (aref ary i)) (- idx i)))
	   idx))
	(t
	 (setf idx (do-compile (car lst) ary idx inside-groups))
	 (do-compile (cdr lst) ary idx inside-groups))))

;;; Compile a parsed RE. Takes the array produced by do-compile, puts
;;; a START state at the beginning, an END at the end and wraps it in
;;; a compiled-re struct.
(defun compile-re (lst)
  (let ((state-mc (make-array (+ 2 (length lst)) :adjustable t))
        (idx 0))
    (declare (fixnum idx))
    (setf-ary state-mc 0 (make-node :type 'START))
    (setf *group-num* 0
	  idx (do-compile lst state-mc 1 NIL))
    (setf-ary state-mc idx (make-node :type 'END))
    (adjust-array state-mc (incf idx))
    (let ((vec (make-array (length state-mc))))
      (dotimes (i (length state-mc))
        (setf (svref vec i) (aref state-mc i)))
      (make-compiled-re
       :char-match (if (member :re-icase *parse-flags* :test #'eq)
                     #'char-equal
                     #'char=)
       :str-match (if (member :re-icase *parse-flags* :test #'eq)
                    #'string-equal
                    #'string=)
       :pat vec
       :num-groups *group-num*))))

;;; Ensure we have only valid flags
(defun good-flags (lst)
  (let ((new-lst (intersection +compile-flags+ lst)))
    (if (member :re-extended new-lst :test #'eq)
      (setf new-lst (remove-if #'(lambda (x) (or (eq x :re-basic)
						 (eq x :re-nospec)))
                               new-lst))
      (if (member :re-basic new-lst :test #'eq)
        (setf new-lst (remove :re-nospec new-lst))
        new-lst))))

;;;======================================================================
;;; RE matching routines.
;;;======================================================================

;;; The main matching routine. Repeatedly calls find-match with progressively
;;; increasing starting points until we get a match or run out of
;;; characters in the string.
(defun match.regexp (str comp-re start end)
  (declare (simple-string str)
	   (fixnum start end)
	   (type compiled-re comp-re))
  (setf *char-match* (compiled-re-char-match comp-re)
        *str-match* (compiled-re-str-match comp-re))
  (let ((pat (compiled-re-pat comp-re)))
    (setf str (the simple-string (subseq str start end))
	  *groups* (make-array (1+ (compiled-re-num-groups comp-re))
			       :initial-element '(0 0))
          *group-starts* (make-array (1+ (compiled-re-num-groups comp-re))
                                     :initial-element 0)
	  *stack* nil
	  *match* nil)
    ;; Have to handle special case of null string separately
    (when (= 0 (length str))
      (find-match str 0 0 pat 0)
      (return-from match.regexp *match*))
    (do ((str-idx 0 (1+ str-idx)))
	((or (not (null *match*))
	     (> str-idx (length str)))
         *match*)
      (declare (fixnum str-idx))
      (setf *stack* nil
            *match* nil)
      (dotimes (i (length *groups*))
        (setf (svref *groups* i) (copy-list '(0 0))))
      (find-match str (length str) str-idx pat 0))))

;;; Given two matches of equal total length we should select the one that has
;;; the longer group starting from the left. This function returns true if
;;; *groups* has a longer group and all previous groups are equal length.
(defun left-group-longer ()
  (do ((i 1 (1+ i)))
      ((>= i (length *match*)) NIL)
    (let* ((s1 (the fixnum (car (svref *groups* i))))
           (e1 (the fixnum (cadr (svref *groups* i))))
           (s2 (the fixnum (car (svref *match* i))))
           (e2 (the fixnum (cadr (svref *match* i))))
           (len (the fixnum (- e1 s1)))
           (old-len (the fixnum (- e2 s2))))
      (when (or (> old-len len) (> s2 s1))
        (return-from left-group-longer NIL))
      (when (and (> len old-len) (<= s1 s2))
        (return-from left-group-longer T)))))

;;; Find match - explores all possible matches until it finds the
;;; longest match.
(defun find-match (str str-len str-idx pat curr-state)
  (declare (simple-string str)
	   (simple-vector pat)
	   (fixnum str-len str-idx curr-state))
  ;; If there are back-refs, we can't optimize the search.
  (let ((has-backrefs
         (dotimes (i (length pat))
           (when (and (consp (node-type (svref pat i)))
                      (eq (car (node-type (svref pat i))) 'BACK-REF))
             (return T)))))
    (when (find-match-aux str str-len str-idx pat curr-state)
      (if (not *match*)
        (progn
          (setf *match* (make-array (length *groups*)))
          (dotimes (i (length *groups*))
            (setf (svref *match* i)
                  (copy-list (svref *groups* i)))))
        (let ((len (- (the fixnum (cadr (svref *groups* 0)))
                      (the fixnum (car (svref *groups* 0)))))
              (old-len (- (the fixnum (cadr (svref *match* 0)))
                          (the fixnum (car (svref *match* 0))))))
          (declare (fixnum len old-len))
          (when (or (> len old-len)
                    (and (= len old-len) (left-group-longer)))
            (dotimes (i (length *groups*))
              (setf (svref *match* i)
                    (copy-list (svref *groups* i))))))))

    ;; Remove all pending paths which are certain to be shorter than
    ;; the current one to save on recursion. Without this, we run out
    ;; of stack space when given a pattern like "a*a*a*a*a*" on the
    ;; string "aaaaaaaaa". Unfortunately this doesn't work in the prescence
    ;; of back-refs.
    (when (and (not has-backrefs) *match*)
      (setf *stack*
            (remove-if #'(lambda (x)
                           (and (> (the fixnum (car x))
                                   (the fixnum (car (aref *match* 0))))
                                (< (the fixnum (cadr x)) curr-state)))
                       *stack*)))

    ;; Examine all other paths - we may find a longer match
    (if (not (null *stack*))
      (let ((branch (pop *stack*)))
        (when (caddr branch)
          ;; Restore group match info
          (let* ((group-info (caddr branch))
                 (idx (car group-info))
                 (start (cadr group-info))
                 (end (caddr group-info)))
            (setf (car (svref *groups* idx)) start
                  (cadr (svref *groups* idx)) end)))
        (find-match str str-len (car branch) pat (cadr branch))))))

;;; Match a back reference - i.e., match the chars implied by its group
;;; against the chars at the current position.
(declaim (inline match-backref))
(defun match-backref (ref-no str str-idx)
  (let* ((end (the fixnum (cadr (svref *groups* ref-no))))
         (start (the fixnum (car (svref *groups* ref-no))))
         (len (- end start)))
    (if (< len 0)
      NIL
      (if (> (+ str-idx len) (length str))
        NIL
        (funcall *str-match* str str :start1 start :end1 end
                 :start2 str-idx :end2 (+ str-idx len))))))

;;; The actual matching routine. Implemented as an iterative loop to avoid
;;; unnecessary recursion - we get enough recursion from find-match as it is.
(defun find-match-aux (str str-len str-idx pat idx)
  (declare (simple-string str)
	   (simple-vector pat)
	   (fixnum idx str-idx str-len))
  (let (node type fwd back matched
	     (last-char-sol nil)
	     (last-char-eol nil))
    (loop
      (setf node (svref pat idx)
	    type (node-type node)
	    fwd (node-fwd-link node)
	    back (node-back-link node)
	    matched (if (and (>= str-idx str-len)
			     (or (characterp type)
				 (simple-bit-vector-p type)
				 (eq type 'ANY-CHAR)))
                      (progn
                        (if (and fwd (/= (the fixnum fwd) 0))
		          (push (list str-idx
                                      (the fixnum (+ idx (the fixnum fwd))))
			        *stack*))
			;; end-of-line - backtrack
		        (return-from find-match-aux NIL))
		      (cond ((characterp type)
                             (funcall *char-match* (schar str str-idx) type))
			    ((simple-bit-vector-p type)
			     (= 1 (aref type (char-code (schar str str-idx)))))
                            ((eq type 'START-OF-LINE)
			     (and (not last-char-sol)
				  (or (= str-idx 0)
				      (char= (schar str (1- str-idx)) 
#\Newline))))
                            ((eq type 'END-OF-LINE)
			     (and (not last-char-eol)
				  (or (>= str-idx str-len)
				      (char= (schar str str-idx) #\Newline))))
                            ((and (consp type) (eq (car type) 'BACK-REF))
                             (match-backref (cadr type) str str-idx))
			    (T T))))
      (if (not matched)
        (progn
          (if fwd
            (incf idx (the fixnum fwd))
            ;; dead end - backtrack
            (return-from find-match-aux NIL)))
        (cond ((eq type 'JUMP)
	       (incf idx (the fixnum fwd)))
	      ((eq type 'BRANCH)
	       (if (node-fwd-link node)
                 (push (list str-idx
                             (the fixnum (+ idx
					    (the fixnum
                                              (node-fwd-link node)))))
                       *stack*))
	       (incf idx))
	      ((eq type 'END)
	       (setf (cdr (svref *groups* 0)) (list str-idx))
	       ;; Found a match - yippee !
	       (return-from find-match-aux T))
	      ((eq type 'START)
	       (setf (car (svref *groups* 0)) str-idx)
	       (incf idx))
	      (t
	       (when (and fwd (/= (the fixnum fwd) 0))
                 (if (and (consp type) (eq (car type) 'GROUP))
                   (push (list str-idx (the fixnum (+ idx (the fixnum fwd)))
                               (cons (cadr type)
                                     (copy-list (svref *groups* (cadr type)))))
                         *stack*)
                   (push (list str-idx (the fixnum (+ idx (the fixnum fwd))))
                         *stack*)))
	       (cond ((eq type 'START-OF-LINE) (setf last-char-sol T))
		     ((eq type 'END-OF-LINE) (setf last-char-eol T))
                     ((and (consp type) (eq (car type) 'GROUP))
                      (setf (svref *group-starts* (cadr type)) str-idx))
                     ((and (consp type) (eq (car type) 'END-GROUP))
                      (setf (car (svref *groups* (cadr type)))
                            (svref *group-starts* (cadr type))
                            (cdr (svref *groups* (cadr type))) (list str-idx)))
                     ((and (consp type) (eq (car type) 'BACK-REF))
                      (let ((ref-no (the fixnum (cadr type))))
                        (incf str-idx (- (the fixnum
                                           (cadr (svref *groups* ref-no)))
                                         (the fixnum
                                           (car (svref *groups* ref-no)))))))
		     (t (incf str-idx)))
	       (if back
                 (if (and (consp type) (eq (car type) 'END-GROUP)
                          (= (car (svref *groups* (cadr type)))
                             (cadr (svref *groups* (cadr type)))))
                   (incf idx)           ; stop infinite loop on null group
                   (progn
                     (if (and (consp type) (eq (car type) 'END-GROUP))
                       (push (list str-idx (1+ idx)
                                   (cons (cadr type)
                                         (copy-list (svref *groups* 
(cadr type)))))
                             *stack*)
                       (push (list str-idx (1+ idx)) *stack*))
                     (decf idx (the fixnum back))))
		 (incf idx))))))))

;;;======================================================================
;;; Main entry points (exported functions)
;;;======================================================================

;;; Compile a regular expression. The regular expression is parsed and
;;; a compiled version (an array of byte codes) is returned. If the parse
;;; is unsuccessful, two values NIL and an error string are returned.
;;; The POSIX compile default is :re-basic but I find :re-extended more
;;; convenient since the new syntax is easier to use.
(defun regcomp (pattern &key (parse-flags '(:re-extended)))
  "Compile a regular expression and return the compiled representation.
   Parse-flags is a list and may contain one of :re-basic, :re-extended or
   :re-nospec plus optionally :re-icase and :re-newline. The default is
   '(:re-extended) i.e., POSIX syntax."
  (declare (simple-string pattern))
  (when (string= pattern "")
    (return-from regcomp (compile-re NIL)))
  (setf parse-flags (good-flags parse-flags))
  (setf *parse-flags* parse-flags
        *pattern* pattern
        *pat-len* (length pattern)
        *1-pat-len* (1- *pat-len*)
        *pat-idx* 0)
  (catch 're-parse-error
    (let ((parsed-list (cond ((member :re-basic parse-flags :test #'eq)
                              (parse-basic-re #\NULL #\NULL))
                             ((member :re-nospec parse-flags)
                              (parse-str))
                             (t		; (member :re-extended parse-flags)
                              (parse-extended-re #\NULL)))))
      (compile-re parsed-list))))

;;; Match a string given a string, a regular expression string or its
;;; compiled representation (from regcomp).
(defun regexec (str pat &key (start 0) (end (length str))
                    (parse-flags '(:re-extended)))
  "Matches a string given a compiled regular expression. If the RE is a
  string, compiles it first. :start & :end may be optionally specified
  to denote the part of the string which is of interest. :parse-flags are
  passed to regcomp if called. Either a vector containing match positions
  or NIL (when there is no match) is returned"
  (declare (simple-string str)
           (fixnum start end))
  (when (or (> start (length str))
            (> start end))
    (return-from regexec NIL))
  ;; compile the regexp if necessary
  (when (stringp pat)
    (setf pat (regcomp pat :parse-flags parse-flags)))
  (if (null pat)
    NIL
    (match.regexp str pat start end)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


