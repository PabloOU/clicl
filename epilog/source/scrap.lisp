;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (c) Copyright 1997-2005 by Michael Genesereth.  All rights reserved.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstant *epilog-version* 5.0
  "The value of this variable is the version of Minilog currently loaded.")

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
;;; defprop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro defprop (x y z)
  `(setf (get ',x ',z) ',y))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; dssq
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro dssq (x l)
  `(rassoc ,x ,l :test #'eq))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; generator
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
;;; kwote
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro kwote (x)
  (list 'quote x))

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

(defmethod itemp ((x number))
  (numindexp x *numbers*))

(defmethod item ((x number))
  (numindexee x *numbers*))

(defmethod itemize ((x number))
  (let (*thing*)
    (setq *numbers* (numindexit x *numbers*))
    *thing*))

(defmethod unitemize ((x number))
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
;;; theory
;;; addcontent, remcontent, contents, clearcontent
;;; *theories*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *theories* nil
 "*THEORIES* has as value a list of all theories that contain sentences.")

(defclass theory ()
  ((content   :accessor content   :initarg :content   :initform nil)
   (extensions :accessor extensions :initarg :extensions :initform nil)
   (intensions :accessor intensions :initarg :intensions :initform nil)
   (includees :accessor includees :initarg :includees :initform nil)
   (includers :accessor includers :initarg :includers :initform nil)
   (doc       :accessor doc       :initarg :doc       :initform "")))

(defmethod extensions (x)
  (declare (ignore x))
  nil)

(defmethod extensions ((th symbol))
  (get th 'extensions))

(defmethod (setf extensions) (rels (th symbol))
  (setf (get th 'extensions) rels))

(defmethod intensions (x)
  (declare (ignore x))
  nil)

(defmethod intensions ((th symbol))
  (get th 'intensions))

(defmethod (setf intensions) (rels (th symbol))
  (setf (get th 'intensions) rels))

(defgeneric extension (rel th)
 (:documentation
 "(EXTENSION R TH)
  EXTENSION takes a relation and a theory as arguments.  It includes the specified
relation on the list of relations fully stored within the specified theory.  The
upshot of this is that a sentence using this relation will be deemed false unless
it is known to be true."))

(defmethod extension (rel th)
  (setf (extensions th) (adjoin rel (extensions th))))

(defgeneric unextension (rel th)
 (:documentation
 "(UNEXTENSION R TH)
  UNEXTENSION takes a relation and a theory as arguments.  It removes the specified
relation from the list of relations fully stored within the specified theory.  See
EXTENSION."))

(defmethod unextension (rel th)
  (setf (extensions th) (delete rel (extensions th))))

(defgeneric intension (rel th)
 (:documentation
 "(INTENSION R TH)
  INTENSION takes a relation and a theory as arguments.  It includes the specified
relation on the list of relations fully stored within the specified theory.  The
upshot of this is that a sentence using this relation will be deemed false unless
it is known to be true."))

(defmethod intension (rel th)
  (setf (intensions th) (adjoin rel (intensions th))))

(defgeneric unintension (rel th)
 (:documentation
 "(UNINTENSION R TH)
  UNINTENSION takes a relation and a theory as arguments.  It removes the specified
relation from the list of relations fully stored within the specified theory.  See
INTENSION."))

(defmethod unintension (rel th)
  (setf (intensions th) (delete rel (intensions th))))

(defmethod documentation ((th theory) &optional type)
  (declare (ignore type))
  (doc th))

(defmethod (setf documentation) (doc (th theory) &optional type)
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
;;; save, drop, kill, facts, sentences
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special alist)))

(defmethod save (p th &optional (f 'samep))
 "(SAVE P TH &OPTIONAL (F 'SAMEP))
  SAVE takes as argument a sentence, a theory, and an equivalence
  checker.  If the theory contains a sentence that is equivalent (according
  to the specified equivalence checker), nothing happens, and SAVE returns NIL.
  Otherwise, the specified sentence is added to the end of the theory."
  (saveth p th f))

(defmethod drop (p th &optional (f 'samep))
 "(DROP P TH &OPTIONAL (F 'SAMEP))
  DROP takes as argument a sentence, a theory, and an equivalence
  checker.  It removes from the specified theory all sentences equivalent
  to the specified sentence (according to the specified equivalence 
  checker).  It returns T as value."
  (dropth p th f))

(defmethod kill (p th &optional (f 'samep))
 "(KILL P TH &OPTIONAL (F 'SAMEP))
  KILL takes as argument an expression, a theory, and an equivalence
  checker.  It removes from the specified theory all sentences that 
  contain a subexpression equivalent to the specified expression (according 
  to the specified equivalence checker).  It returns T as value."
  (killth p th f))

(defmethod facts (x th &optional (f 'matchp))
 "(FACTS X TH &OPTIONAL (F 'MATCHP))
  FACTS takes as arguments an expression, a theory, an equivalence checker.
  It returns a list of all sentences in the specified theory that contain
  a subexpression equivalent to the specified expression (according to the 
  specified equivalence checker).  If no such sentences are found, it 
  returns NIL."
  (factsth x (indexps x th) f))

(defmethod facts (x (sents list) &optional (f 'matchp))
  (factsth x sents f))

(defmethod sentences (x th &optional (f 'matchp))
 "(SENTENCES X TH &OPTIONAL (F 'MATCHP))
  SENTENCES takes as arguments an expression, a theory, an equivalence checker.
  It returns a list of all sentences in the specified theory and its included
  theories that contain a subexpression equivalent to the specified expression
  (according to the specified equivalence checker).  If no such sentences are
  found, it returns NIL."
  (nconc (facts x th f)
         (mapcan #'(lambda (th) (sentences x th f)) (includees th))))

(defmethod words (th)
 "(WORDS TH)
  WORDS takes a theory as argument and returns a list of all words contained
  is that theory's contents."
  (if (contents th) (getwords (contents th) nil)))

(defun getwords (x nl)
  (cond ((atom x) (if (not (varp x)) (adjoin x nl) nl))
        (t (do ((l x (cdr l)))
               ((null l) nl)
               (setq nl (getwords (car l) nl))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; truep, truex, trues, trueg
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod truep (p th &optional (f 'matchp))
 "(TRUEP P TH &OPTIONAL (F 'MATCHP))
  TRUEP takes as argument a sentence, a theory, and an equivalence
  checker.  It returns T if there is an equivalent sentence in the 
  specified theory (according to the specified equivalence checker) and
  otherwise returns NIL."
  (truex t p th f))

(defmethod truex (x p th &optional (f 'matchp))
 "(TRUEX X P TH &OPTIONAL (F 'MATCHP))
  TRUEX takes as argument an expression, a sentence, a theory, and an
  equivalence checker.  It uses the equivalence checker to determine if there 
  is an equivalent sentence in the theory and, if so, returns a copy of
  the expression with variables replaced by values from the first successful
  equivalence check.  Otherwise, it returns NIL."
  (cond ((eq 'samep f) (truexsamep x p th))
        ((eq 'matchp f) (truexmatchp x p th))
        ((eq 'mgup f) (truexmgup x p th))
        ((eq 'unifyp f) (truexunifyp x p th))
        (t (truexother x p th f))))

(defun truexsamep (x p th)
  (do ((l (indexps p th) (cdr l)) (al))
      ((null l) nil)
      (if (setq al (samelist p (car l))) (return (plug x al)))))

(defun truexmatchp (x p th)
  (do ((l (indexps p th) (cdr l)) (al))
      ((null l) nil)
      (if (setq al (matcher p (car l))) (return (plug x al)))))

(defun truexmgup (x p th)
  (do ((l (indexps p th) (cdr l)) (al))
      ((null l) nil)
      (if (setq al (mgu p (car l))) (return (plug x al)))))

(defun truexunifyp (x p th)
  (do ((l (indexps p th) (cdr l)) (al (environment)) (bl (environment)))
      ((null l) nil)
      (let ((alist al))
        (if (unify p alist (car l) bl) (return (plugstdexp x alist))))))

(defun truexother (x p th f)
  (do ((l (indexps p th) (cdr l)))
      ((null l) nil)
      (if (funcall f p (car l)) (return x))))

(defmethod trues (x p th &optional (f 'matchp))
 "(TRUES X P TH &OPTIONAL (F 'MATCHP))
  TRUES takes as argument an expression, a sentence, a theory, and an
  equivalence checker.  It uses the equivalence checker to find all equivalent
  sentences in the theory and returns a list of copies of the specified
  expression with variables replaced by values from the successful equivalence
  checks.  It returns NIL if no equivalent expressions are found."
  (getall (truegth x p th f)))

(defmethod trueg (x p th &optional (f 'matchp))
 "(TRUEG X P TH &OPTIONAL (F 'MATCHP))
  TRUEG takes as arguments an expression, a sentence, a theory, and an optional 
  equivalence checker.  It returns a generator that uses the equivalence checker
  to determine if there is an equivalent sentence in the theory.  Each time the
  generator is called, it returns a copy of the expression with variables
  replaced by values from a successful equivalence check.  When all instances
  have been enumerated, the generator returns NIL."
  (truegth x p th f))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; knownp, knownx, knowns, knowng
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod knownp (p th &optional (f 'matchp))
 "(KNOWNP P TH &OPTIONAL (F 'MATCHP))
  KNOWNP takes as argument a sentence, a theory, and an equivalence
  checker.  It returns T if there is an equivalent sentence in the 
  specified theory or its included theories (according to the specified
  equivalence checker) and otherwise returns NIL."
  (funcall (knowngdb t p th f)))

(defmethod knownx (x p th &optional (f 'matchp))
 "(KNOWNX X P TH &OPTIONAL (F 'MATCHP))
  KNOWNX takes as argument an expression, a sentence, a theory, and an
  equivalence checker.  It uses the equivalence checker to determine if there 
  is an equivalent sentence in the theory or its included theories and, if so,
  returns a copy of the expression with variables replaced by values from the
  first successful equivalence check.  Otherwise, it returns NIL."
  (cond ((truex x p th f))
        (t (do ((l (includees th) (cdr l)) (dum))
               ((null l) nil)
               (when (setq dum (knownx x p (car l) f)) (return dum))))))

(defmethod knowns (x p th &optional (f 'matchp))
 "(KNOWNS X P TH &OPTIONAL (F 'MATCHP))
  KNOWNS takes as argument an expression, a sentence, a theory, and an
  equivalence checker.  It uses the equivalence checker to find all equivalent
  sentences in the theory and its included theories and returns a list of copies
  of the specified expression with variables replaced by values from the successful
  equivalence checks.  It returns NIL if no equivalent expressions are found."
  (getall (knowngdb x p th f)))

(defmethod knowng (x p th &optional (f 'matchp))
 "(KNOWNG X P TH &OPTIONAL (F 'MATCHP))
  KNOWNG takes as argument an expression, a sentence, a theory, and an
  equivalence checker and returns a generator as value.  On each call, the
  generator uses the specified equivalence checker to determine if there is an
  equivalent sentence in the theory or its included theories and, if so,
  returns a copy of the expression with variables replaced by values from the
  first successful equivalence check.  When all such instances have been
  enumerated, the generator returns NIL."
  (knowngdb x p th f))

(defun knowngdb (x p th f)
  (let ((cont (trueg x p th f)) (flag) (ths))
    #'(lambda ()
        (do ((ans))
            ((setq ans (funcall cont)) (return ans))
            (cond ((and (not flag) (setq flag t ths (includees th)) nil))
                  ((null ths) (return nil))
                  (t (setq cont (knowngdb x p (car ths) f) ths (cdr ths))))))))

(defmethod setval (x y th &optional (f 'samep))
 "(SETVAL X Y TH &OPTIONAL (F 'SAMEP))
  SETVAL takes an expression <x>, and expression <y>, a theory, and a matcher
  as arguments.  It deletes from the specified theory all sentences of the
  form (= <u> <v>), where <u> is equivalent to <x> according to the specified
  matcher, and then saves (= <x> <y>).  SETVAL returns <y> as value."
  (remvalth x th f)
  (insert `(= ,x ,y) th)
  y)

(defmethod remval (x th &optional (f 'samep))
 "(REMVAL X TH &OPTIONAL (F 'SAMEP))
  REMVAL takes an expression <x>, a theory, and a matcher as arguments.  It 
  deletes from the specified theory all sentences of the form (= <u> <v>),
  where <u> is equivalent to <x> according to the specified matcher.  REMVAL
  returns T as value."
  (remvalth x th f))

(defmethod getval (x th &optional (f 'matchp))
 "(GETVAL X TH &OPTIONAL (F 'MATCHP))
  GETVAL takes an expression <x>, a theory, and a matcher as arguments.  It
  examines the specified theory for a sentence of the form (= <u> <v>), where
  <u> is equivalent to <x> according to the specified matcher.  If it finds one,
  it returns an appropriate instance of <v>.  Otherwise, it returns NIL."
  (getvalth x th f))

(defmethod value (x th &optional (f 'matchp))
 "(VALUE X TH &OPTIONAL (F 'MATCHP))
  VALUE takes an expression, a theory, and a matcher as arguments.  It uses
  GETVAL on the  specified theory and its included theories until it finds a
  value.  If no value is found, VALUE returns NIL."
  (valuedb x th f))

(defun valuedb (x th f)
  (cond ((getval x th f))
        (t (do ((l (includees th) (cdr l)) (ans))
               ((null l) nil)
               (if (setq ans (valuedb x (car l) f)) (return ans))))))


(defun saveth (p th f)
  (do ((l (indexps p th) (cdr l)))
      ((null l) (insert p th))
      (if (funcall f p (car l)) (return nil))))

;;; Note that DROPTH drops all sentences equivalent to P.  This
;;; is more expensive than it need be if facts are added with the
;;; same equivalence checker used for removal.  But it is nice this way.

(defun dropth (p th f)
  (do ((l (indexps p th) (cdr l)))
      ((null l) t)
      (if (funcall f p (car l)) (uninsert (car l) th))))

(defun killth (x th f)
  (do ((l (indexps x th) (cdr l)))
      ((null l) t)
      (if (partp x (car l) f) (uninsert (car l) th))))

(defun factsth (x sents f)
  (do ((l sents (cdr l)) (nl))
      ((null l) (nreverse nl))
      (if (partp x (car l) f) (setq  nl (cons (car l) nl)))))

(defun truegth (x p th f)
  (cond ((eq 'samep f) (truegsamep x p th))
        ((eq 'matchp f) (truegmatchp x p th))
        ((eq 'mgup f) (truegmgup x p th))
        ((eq 'unifyp f) (truegunifyp x p th))
        (t (truegother x p th f))))

(defun truegsamep (x p th)
  (let ((l (indexps p th)))
    #'(lambda ()
        (do ((q) (al))
            ((null l) nil)
            (setq q (car l) l (cdr l))
            (if (setq al (samelist p q)) (return (plug x al)))))))

(defun truegmatchp (x p th)
  (let ((l (indexps p th)))
    #'(lambda ()
        (do ((q) (al))
            ((null l) nil)
            (setq q (car l) l (cdr l))
            (if (setq al (matcher p q)) (return (plug x al)))))))

(defun truegmgup (x p th)
  (let ((l (indexps p th)))
    #'(lambda ()
        (do ((q) (al))
            ((null l) nil)
            (setq q (car l) l (cdr l))
            (if (setq al (mgu p q)) (return (plug x al)))))))

(defun truegunifyp (x p th)
  (let ((l (indexps p th)) (al (environment)) (bl (environment)))
    #'(lambda ()
        (do ((q) (alist al))
            ((null l) nil)
            (setq q (car l) l (cdr l))
            (if (unify p alist q bl) (return (plugstdexp x alist)))))))

(defun truegother (x p th f)
  (let ((l (indexps p th)))
    #'(lambda ()
        (do ((q))
            ((null l) nil)
            (setq q (car l) l (cdr l))
            (if (funcall f p q) (return x))))))

(defun remvalth (x th f)
  (do ((l (indexps x th) (cdr l)))
      ((null l) t)
      (if (and (listp (car l)) (eq '= (caar l)) (funcall f x (cadar l)))
          (uninsert (car l) th))))

(defun getvalth (x th f)
  (cond ((eq 'samep f) (getvalsamep x th))
        ((eq 'instp f) (getvalinstp x th))
        ((eq 'mgup f) (getvalmgup x th))
        ((eq 'unifyp f) (getvalunifyp x th))
        (t (getvalother x th f))))

(defun getvalsamep (x th)
  (do ((l (indexps x th) (cdr l)) (al))
      ((null l) nil)
      (if (and (listp (car l)) (eq '= (caar l))
               (setq al (samelist (cadar l) x)))
          (return (plug (caddar l) al)))))

(defun getvalinstp (x th)
  (do ((l (indexps x th) (cdr l)) (al))
      ((null l) nil)
      (if (and (listp (car l)) (eq '= (caar l))
               (setq al (instantiator x (cadar l))))
          (return (plug (caddar l) al)))))

(defun getvalmgup (x th)
  (do ((l (indexps x th) (cdr l)) (al))
      ((null l) nil)
      (if (and (listp (car l)) (eq '= (caar l))
               (setq al (mgu x (cadar l))))
          (return (plug (caddar l) al)))))

(defun getvalunifyp (x th)
  (do ((l (indexps x th) (cdr l)) (al (environment)) (alist (environment)) (ol))
      ((null l) nil)
      (if (and (listp (car l)) (eq '= (caar l))
               (setq ol (unify x al (cadar l) alist)))
          (return (prog1 (plugstdexp (caddar l) alist) (backup ol))))))

(defun getvalother (x th f)
  (do ((l (indexps x th) (cdr l)))
      ((null l) nil)
      (if (and (listp (car l)) (eq '= (caar l))
               (funcall f x (cadar l))) 
          (return (caddar l)))))

;;; Yes, the quote case is expensive.
;;; Should fix some day.

(defun partp (x y f)
  (cond ((funcall f x y))
        ((atom y) nil)
        ((eq 'quote (car y))
         (cond ((atom (cadr y)) nil)
               (t (partp x (cons 'list (mapcar 'quotify (cadr y))) f))))
        (t (some #'(lambda (z) (partp x z f)) y))))

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
(defprop makestring basicval basicval)
(defprop symbolize basicval basicval)
(defprop convertfromstring basicval basicval)
(defprop nomination basicval basicval)
(defprop denotation basicval basicval)

(defun makestring (x)
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
(defprop real-number realp basic)
(defprop complex-number complexp basic)
(defprop isanumber numberp basic)
(defprop natural naturalp basic)
(defprop rational-number rationalp basic)
;(defprop positive positivep basic)
;(defprop negative negativep basic)
(defprop zero zeropp basic)
(defprop odd-integer odd-integerp basic)
(defprop even-integer even-integerp basic)
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

(defun odd-integerp (x) (and (integerp x) (oddp x)))

(defun even-integerp (x) (and (integerp x) (evenp x)))

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


(defprop isacharacter characterp basic)
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


(defprop isastring stringp basic)
(defprop substring substringp basic)
(defprop stringgreater strgreaterp basic)
(defprop stringless strlessp basic)
(defprop stringmatchall stringmatchallp basic)
(defprop stringmatchany stringmatchanyp basic)
(defprop stringmatchphrase stringmatchphrasep basic)

(defun substringp (x y)
  (and (stringp x) (stringp y) (search x y :test #'char-equal)))

(defun strgreaterp (x y)
  (stringgreaterp x y))

(defun stringgreaterp (x y)
  (if (and (stringp x) (stringp y)) (string-greaterp x y)))

(defun strlessp (x y)
  (stringlessp x y))

(defun stringlessp (x y)
  (if (and (stringp x) (stringp y)) (string-lessp x y)))

(defun strmatches (pat str)
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
;;; matcher
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(defun newindvar () (gensym "?"))

(defun newseqvar () (gensym "@"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (identp x y)
;;;    determines whether x and y are equal but handles quote
;;;    if success, returns t
;;;    if failure, returns nil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod identp (x y)
 "(IDENTP X Y)
  IDENTP takes two expressions as arguments and checks whether they are 
  meta-equal.  IDENTP returns T if the check is successful, and it
  returns NIL otherwise."
  (cond ((atom x) (cond ((atom y) (equalp x y))
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

(defmethod mgup (p q)
 "(MGUP X Y)
  MGUP takes two expressions as arguments and checks whether they are 
  meta-unifiable.  MGUP returns T if the check is successful, and it
  returns NIL otherwise."
  (if (mguexp p q truth) t))

(defmethod mgu (x y)
 "(MGU X Y)
  MGU takes two expressions as arguments and checks whether they are 
  meta-unifiable.  MGU returns the unifier if the check is successful,
  and it returns NIL otherwise."
  (mguexp x y truth))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; inference
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special *theory* *names* *functionals*
              alist level tracecalls tracefacts traceexpressions)))

(defvar *reduction* t
 "*REDUCTION* determines whether or not reductions are performed.  The default
  is T.")

(defvar *ancestry* nil
 "*ANCESTRY* determines whether or not various inference routines save and
  check ancestries in processing subgoals.  The default is NIL.")

(defparameter *saves* nil
 "*SAVES* is a variable that determines which literals are saved in forward
  chaining.  If the value of *SAVES* is a list, then a derived literal is saved
  if and only if its primary logical constant, function constant, or relation
  constant is an item on this list.  If the value is anything other than a list,
  all derived literals are saved.")

(defvar *start* 10
 "*START* is the initial depth cutoff for iterative deepening.")

(defvar *increment* 10
 "*INCREMENT* is the amount by which the depth cutoff is incremented on each
  round of iterative deepening.")

(defvar *depth* 1000000
 "*DEPTH* has as value a positive integer indicating the depth of search for
  iterative deepening.  Its default is 1000000.")

(defvar *termination* nil
 "*TERMINATION* records whether the most recent depth-limited search attempt
  ended because of a depth cutoff.")

(defvar *inferences* 0
 "*INFERENCES* records the number of inference steps in the current inference
  process.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; assume, forget
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod assume (p *theory*)
 "(ASSUME P *THEORY*)
  ASSUME takes a sentence and a theory as arguments.  The sentence is assumed
  to be a literal.  ASSUME uses model elimination to derive conclusions from the
  specified sentence and the sentences in the specified theory and its included
  theories.  The search is bottom-up, depth-first, and statically-ordered and
  uses *DEPTH* as a depth limit.  If it derives a literal with relation constant
  on the list *SAVES*, it saves the literal it derives into the specified theory.
  ASSUME returns T as value."
  (let ((alist (environment)) (level 0) tracecalls)
    (setq *termination* nil)
    (assumedepth p alist 1)
    t))

(defun assumedepth (p al depth)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        (t (if traceexpressions (tracesave p al))
           (assumeexp p al depth)
           (if traceexpressions (tracedone p al)))))

(defun assumeexp (p al depth)
  (cond ((atom p) (assumeexpexit p al depth))
        ((eq 'and (car p)) 
         (mapc #'(lambda (x) (assumedepth x al depth)) (cdr p)))
        ((eq 'or (car p))
         (assumeexps '(failure) p (mapcar #'maknot (butlast (cdr p))) al depth))
        (t (assumeexpexit p al depth))))

(defun assumeexpexit (p al depth)
  (setq p (plugstdexp p al))
  (cond ((knownp p *theory* 'samep) nil)
        ((and (listp p) (eq 'execute (car p))) (ignore-errors (eval (cadr p))))
        ((and (listp p) (eq 'evaluate (car p))) (ignore-errors (apply (caadr p) (cdadr p))))
        ((and (savep p) (insert p *theory*) nil))
        (t (assumedb p al depth *theory*))))

(defun savep (p)
  (or (not (listp *saves*)) (member (operator p) *saves* :test #'eq)))

(defun assumedb (p al depth th)
  (cond ((assumeth p al depth th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (assumedb p al depth (car l))))))

(defun assumeth (p al depth th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment)) (ans))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '=>) (not (null (cddar l)))
                 (setq ol (unify (cadar l) bl p al)))
        (if tracefacts (tracefact (car l)))
        (setq ans (assumeexps '(failure) (car l) (butlast (cddar l)) bl depth))
        (backup ol)
        (if ans (return ans)))))

(defmethod envindexps (p al th)
 "(ENVINDEXPS P ENV TH)
  ENVINDEXPS takes an expression, an environment, and a theory as arguments and
  returns a list of sentences in the specified theory containing a component
  that could potentially unify with the specified expression in the specified
  environment.  ENVINDEXPS is used by all inference subroutines.  Users are free
  to redefine ENVINDEXPS to implement specialized subroutines.  The default
  implementation (INDEXPS P TH) ignores the environment."
  (declare (ignore al))
  (indexps p th))

(defun assumeexps (next rule pl al depth)
  (cond ((null pl) (assumedepth (car (last rule)) al (1+ depth))
         (profail nil next))
        ((eq 'cut (car pl)) (assumeexps next rule (cdr pl) al depth) t)
        ((finddepth (car pl) al depth nil
                    next `(assumeexps ,rule ,(cdr pl) ,al ,depth)))))


(defun discard (x th)
 "(DISCARD X TH)
  DISCARD takes an expression and a theory as arguments and forgets all
  sentences containing an instance of the specified expression from the
  specified theory."
  (do ((l (facts x th) (cdr l)))
      ((null l) t)
      (forget (car l) th)))

(defmethod forget (p th)
 "(FORGET P TH)
  FORGET takes a sentence and a theory as arguments.  The sentence is assumed
  to be a literal.  FORGET uses model elimination to derive conclusions from the
  specified sentence and the sentences in the specified theory and its included
  theories.  The search is bottom-up, depth-first, and statically-ordered and
  uses *DEPTH* as a depth limit.  If it derives a literal with relation constant
  on the list *SAVES*, it drops the literal it derives from the specified theory.
  FORGET returns T as value."
  (let ((alist (environment)) (*theory* 'forget) (level 0) tracecalls)
    (setq *termination* nil)
    (decludes 'forget)
    (empty 'forget)
    (includes *theory* th)
    (forgetdepth p alist 1)
    t))

(defun forgetdepth (p al depth)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        (t (if traceexpressions (tracedrop p al))
           (forgetexp p al depth)
           (if traceexpressions (tracedone p al)))))

(defun forgetexp (p al depth)
  (cond ((atom p) (forgetexpexit p al depth))
        ((eq 'and (car p)) 
         (mapc #'(lambda (x) (forgetdepth x al depth)) (cdr p)))
        (t (forgetexpexit p al depth))))

(defun forgetexpexit (p al depth)
  (setq p (plugstdexp p al))
  (cond ((truep p *theory* 'samep) nil)
        ((and (savep p) (uninsert p (car (includees *theory*)))
              (insert p *theory*) nil))    ;;; bug here
        (t (forgetdb p al depth *theory*))))

(defun forgetdb (p al depth th)
  (cond ((forgetth p al depth th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (forgetdb p al depth (car l))))))

(defun forgetth (p al depth th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment)) (ans))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '=>) (not (null (cddar l)))
                 (setq ol (unify (cadar l) bl p al)))
        (if tracefacts (tracefact (car l)))
        (setq ans (forgets '(failure) (car l) (butlast (cddar l)) bl depth))
        (backup ol)
        (if ans (return ans)))))

(defun forgets (next rule pl al depth)
  (cond ((null pl) (forgetdepth (car (last rule)) al (1+ depth))
         (profail nil next))
        ((eq 'cut (car pl)) (forgets next rule (cdr pl) al depth) t)
        ((finddepth (car pl) al depth nil
                    next `(forgets ,rule ,(cdr pl) ,al ,depth)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; findp, findx, finds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod findp (p th)
 "(FINDP P TH)
  FINDP takes a sentence and a theory as arguments.  It tries to prove the
  sentence from the specified theory and its included theories using model
  elimination.  The search is done in iterative deepening fashion, controlled by
  the variables *START*, *INCREMENT*, and *DEPTH*.  If FINDP is able to prove
  the sentence, it returns T; otherwise, it returns NIL."
 (oldfindx t p th))

(defmethod findx (x p th)
 "(FINDX X P *THEORY*)
  FINDX takes as argument a term, a sentence, and a theory.  It tries to prove
  the specified sentence from the specified theory and its included theories
  using the model elimination.  The search is done in iterative deepening
  fashion, controlled by the variables *START*, *INCREMENT*, and *DEPTH*.  If
  FINDX is able to prove the sentence, it returns a copy of the specified term
  with variables replaced by values obtained during the proof process.  If it
  fails to prove the sentence, the value is NIL."
 (oldfindx x p th))

(defmethod finds (x p *theory*)
 "(FINDS X P *THEORY*)
  FINDS takes as argument a term, a sentence, and a theory.  It tries to
  prove the specified sentence from the specified theory and its included
  theories using model elimination.  The search is depth-first and
  statically-ordered and uses *DEPTH* as a depth limit.  If FINDS succeeds
  in proving the sentence, it returns a list of copies of the specified term,
  one for each way the sentence can be proved.  In each copy, the variables are
  replaced by values obtained during the proof process.  If the sentence cannot
  be proved, FINDS returns NIL."
 (oldfinds x p th))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; defcontratheory
;;; define-contratheory
;;; fullinsert
;;; fullprovep
;;; fullprovex
;;; fullproves
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special traceexpressions *answers* *consequences*)))

(defparameter *limit* 1000000000)
(defparameter *answer* nil)
(defparameter *answers* nil)
(defparameter *naf* nil)

(defmacro deffulltheory (x &rest l)
  `(define-fulltheory ',x ',l))

(defun define-fulltheory (th facts)
  (empty th)
  (dolist (p facts) (fullassume p th))
  th)

(defmacro defcontratheory (x &rest l)
  `(define-contratheory ',x ',l))

(defun define-contratheory (th facts)
  (empty th)
  (dolist (p facts) (fullinsert p th))
  th)

(defun fullinsert (p th)
  (dolist (x (contrapositives p)) (save x th))
  p)

(defun fullprovep (p th)
  (fullprovex 't p th))

(defun fullprovex (*thing* p th)
  (let (alist *theory* *answer* (*ancestry* t))
    (setq *unifications* 0)
    (setq *inferences* 0)
    (setq *termination* nil)
    (setq p (adjust *thing* (order *thing* p)))
    (setq alist (environment))
    (setq *theory* (make-instance 'theory))
    (includes *theory* th)
    (dolist (x (contrapositives `(<= (answer ,*thing*) ,p))) (save x *theory*))
    (do ((old *depth*) (*depth* (min *start* *depth*) (+ *depth* *increment*)))
        ((> *depth* old) nil)
        (fullone `(answer ,*thing*) nil alist 1 (list (list (list `(answer ,*thing*)) alist 1)))
        (cond (*answer* (return t))
              ((not *termination*) (return nil))
              (t (setq *termination* nil))))
    (decludes *theory*)
    (empty *theory*)
    *answer*))

(defun fullproves (*thing* p th)
  (let (alist *theory* *answers* (*ancestry* t))
    (setq *unifications* 0)
    (setq *inferences* 0)
    (setq *termination* nil)
    (setq p (adjust  *thing* (order *thing* p)))
    (setq alist (environment))
    (setq *theory* (make-instance 'theory))
    (includes *theory* th)
    (dolist (x (contrapositives `(<= (answer ,*thing*) ,p))) (save x *theory*))
    (fullall `(answer ,*thing*) nil alist 1 (list (list (list `(answer ,*thing*)) alist 1)))
    (decludes *theory*)
    (empty *theory*)
    (nreverse (uniquify *answers*))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullassume
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *obsessions* nil)

(defun obsessionp (p)
  (or (not (listp *obsessions*)) (find (operator p) *obsessions* :test #'eq)))

(defun fullassume (p *theory*)
  (let (alist level tracecalls)
    (setq *termination* nil)
    (setq *unifications* 0)
    (setq alist (environment))
    (setq level 0)
    (fullassumedepth p alist 1)
    'done))

(defun fullassumedepth (p al depth)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        (t (fullsave p al depth)
           (fullassumeexp p al depth)
           (fulldone p al depth))))

(defun fullassumeexp (p al depth)
  (cond ((atom p) (fullassumeexpexit p al depth))
        ((eq 'and (car p))
         (mapc #'(lambda (x) (fullassumedepth x al depth)) (cdr p)))
        (t (fullassumeexpexit p al depth))))

(defun fullassumeexpexit (p al depth)
  (setq p (plugstdexp p al))
  (cond ((knownp p *theory* #'samep) nil)
        ((atom p) (fullassumers p al depth))
        ((eq 'execute (car p)) (ignore-errors (eval (cadr p))))
        ((eq 'evaluate (car p)) (ignore-errors (apply (caadr p) (cdadr p))))
        (t (fullassumers p al depth))))

(defun fullassumers (p al depth)
  (when (savep (operator p)) (insert p *theory*))
  (unless (obsessionp (operator p)) (fullassumedb p al depth *theory*)))

(defun fullassumedb (p al depth th)
  (cond ((fullassumeth p al depth th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (fullassumedb p al depth (car l))))))

(defun fullassumeth (p al depth th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment)) (*thing*) (*answers*) (dum))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '<=))
        (do ((m (cddar l) (cdr m)) (om))
            ((null m))
            (when (setq ol (unify (car m) bl p al))
              (if tracefacts (tracefact (car l)))
              (setq dum (maksand (revappend om (cdr m))))
              (setq *thing* (cadar l) *answers* nil)
              (dolist (q (fullallknownspecials dum bl depth))
                (fullassumedepth q alist (1+ depth)))
              (backup ol))
            (setq om (cons (car m) om))))))

(defun fullallknownspecials (dum bl depth)
  (cond ((eq dum 'true) (list (plugstdexp *thing* bl)))
        (t (let ((alist bl))
             (fullallknowndb dum (list dum) bl (1+ depth) nil *theory*)
             (nreverse *answers*)))))

(defun fullassumeth (p al depth th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment)) (*thing*) (*answers*) (dum))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '<=))
        (do ((m (cddar l) (cdr m)) (om))
            ((null m))
            (when (setq ol (unify (car m) bl p al))
              (if tracefacts (tracefact (car l)))
              (setq dum (maksand (revappend om (cdr m))))
              (dolist (q (fullallspecials (cadar l) dum bl depth))
                (fullassumedepth q alist (1+ depth)))
              (backup ol))
            (setq om (cons (car m) om))))))

(defun fullallspecials (*thing* dum alist depth)
  (let (*answers*)
    (fullall dum (list dum) alist (1+ depth) nil)
    (nreverse (uniquify *answers*))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullfindp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullfindp (p th)
  (fullfindx 't p th))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullprovablep
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullprovablep (p *theory*)
  (let (alist)
    (setq alist (environment))
    (fulloneprovabledb p (list p) alist 1 nil *theory*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullfindx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullfindx (*thing* p *theory*)
  (let (alist *answer*)
    (setq *unifications* 0)
    (setq *inferences* 0)
    (setq *termination* nil)
    (setq alist (environment))
    (when (fullone p (list p) alist 0 nil) *answer*)))

(defun fullone (p pl al depth cont)
  (setq *inferences* (1+ *inferences*))
  (fullcall p al depth)
  (cond ((>= *inferences* *limit*) (setq *termination* t) (fullstop (car pl) al depth))
        ((>= depth *depth*) (setq *termination* t) (fullstop (car pl) al depth))
        (t (fulloneexp p pl al depth cont))))

(defun fulloneexp (p pl al depth cont)
  (cond ((atom p) (fulloneconstant p pl al depth cont))
        ((eq 'not (car p)) (fulloneunprovable p pl al depth cont))
        ((eq 'and (car p)) (fulloneand p pl al depth cont))
        ((eq 'or (car p)) (fulloneor p pl al depth cont))
        ((eq 'oneof (car p)) (fulloneoneof p pl al depth cont))
        ((eq 'member (car p)) (fullonemember p pl al depth cont))
        ((eq 'same (car p)) (fullonesame p pl al depth cont))
        ((eq 'distinct (car p)) (fullonedistinct p pl al depth cont))
	((eq 'ground (car p)) (fulloneground p pl al depth cont))
	((eq 'nonground (car p)) (fullonenonground p pl al depth cont))
	((eq 'primitive (car p)) (fulloneprimitive p pl al depth cont))
	((eq 'nonprimitive (car p)) (fullonenonprimitive p pl al depth cont))
	((eq '== (car p)) (fullonevalue p pl al depth cont))
	((eq 'value (car p)) (fullonevalue p pl al depth cont))
        ((eq 'execute (car p)) (fulloneexecute p pl al depth cont))
        ((eq 'evaluate (car p)) (fulloneevaluate p pl al depth cont))
        ((eq 'provable (car p)) (fulloneprovabledb p pl al depth cont *theory*))
        ((eq 'bagofall (car p)) (fullonebagofall p pl al depth cont))
        ((eq 'unprovable (car p)) (fulloneunprovable p pl al depth cont))
        ((eq 'choose (car p)) (fullonechoose p pl al depth cont))
        ((eq 'stringmatch (car p)) (fullonestrmatch p pl al depth cont))
	((get (car p) 'basicval) (fullonebasicvalue p pl al depth cont))
        ((get (car p) 'basic) (fullonebasic p pl al depth cont))
        (t (fulloners p pl al depth cont))))

(defun fulloneconstant (p pl al depth cont)
  (cond ((eq 'true p) (fullonelast pl al depth cont))
        ((eq 'false p) (fullfail (car pl) al depth))
        (t (fulloners p pl al depth cont))))

(defun fulloneand (p pl al depth cont)
  (cond ((null (cdr p)) (fullonelast pl al depth cont))
        ((fullone (cadr p) (cdr p) al depth (cons (list pl al depth) cont)))
        (t (fullfail (car pl) al depth))))

(defun fulloneor (p pl al depth cont)
  (setq cont (cons (list pl al depth) cont))
  (do ((l (cdr p) (cdr l)))
      ((null l) (fullfail (car pl) al depth))
      (when (fullone (car l) (list (car l)) al depth cont)
        (return t))))

(defun fulloneoneof (p pl al depth cont)
  (when (seqvarp (caddr p)) (setq p (plug p al)))
  (do ((l (cddr p) (cdr l)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (cond ((not (setq ol (unify (cadr p) al (car l) al))))
            ((fulloneexit pl al depth cont) (backup ol) (return t))
            (t (backup ol)))))

(defun fullonemember (p pl al depth cont)
  (when (seqvarp (caddr p)) (setq p (plug p al)))
  (do ((l (cdaddr p) (cdr l)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (cond ((not (setq ol (unify (cadr p) al (car l) al))))
            ((fulloneexit pl al depth cont) (backup ol) (return t))
            (t (backup ol)))))

(defun fullonesame (p pl al depth cont)
  (let (ol)
    (cond ((setq ol (unify (cadr p) al (caddr p) al))
           (prog1 (fullonelast pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullonedistinct (p pl al depth cont)
  (let (ol)
    (cond ((setq ol (unify (cadr p) al (caddr p) al))
           (backup ol) (fullfail (car pl) al depth))
          (t (fullonelast pl al depth cont)))))

(defun fulloneground (p pl al depth cont)
  (cond ((and (groundp (plug (cadr p) al))) (fullonelast pl al depth cont))
        (t (fullfail (car pl) al depth))))

(defun fulloneprimitive (p pl al depth cont)
  (cond ((primitivep (plug (cadr p) al)) (fullonelast pl al depth cont))
        (t (fullfail (car pl) al depth))))

(defun fullonevalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (cadr p) y (caddr p))
    (cond ((atom x))
          ((eq 'bagofall (car x))
           (setq x (cons 'listof (fullfinds (cadr x) (caddr x) *theory*))))
          ((and (groundp x) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))))
    (cond ((setq ol (unify x al y al))
           (prog1 (fullonelast pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fulloneexecute (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (eval (cadr p)))
                  (fullonelast pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (eval (cadr p))))))
                (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,(mapcar #'quotify values)) al)))
           (prog1 (fullonelast pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fulloneevaluate (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((evals (cadr p)) (fullonelast pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (evals (cadr p))))
                (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,values) al)))
           (prog1 (fullonelast pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun evals (x)
  (cond ((atom x) (ignore-errors (list (eval x))))
        (t (ignore-errors (multiple-value-list (apply (car x) (cdr x)))))))

(defun fulloneunprovable (p pl al depth cont)
  (cond ((fullone (cadr p) (cdr p) al depth nil) (fullfail (car pl) al depth))
        (t (fullonelast pl al depth cont))))

(defun fullonechoose (p pl al depth cont)
  (let (x ol)
    (setq p (plugstdexp p al))
    (setq x (findx (cadr p) (caddr p) *theory*))
    (cond ((and (not (null x)) (setq ol (unify (cadr p) alist x alist)))
           (prog1 (fullonelast pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fulloneunprovable (p pl al depth cont)
  (cond ((fullone (cadr p) (cdr p) al depth nil) (fullfail (car pl) al depth))
        (t (fullonelast pl al depth cont))))

(defun fullonebagofall (p pl al depth cont)
  (fullonevalue `(value ,(butlast p) ,(cadddr p)) pl al depth cont))

(defun fullonestrmatch (p pl al depth cont)
  (fulloneexp `(execute (strmatches ,(cadr p) ,(caddr p)) ? . ,(cdddr p)) pl al depth cont))

(defun fullonebasicvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (butlast p) y (car (last p)))
    (when (and (groundp x) (every #'primitivep (cdr x)))
      (setq x (funcall (get (car x) 'basicval) x)))
    (cond ((setq ol (unify x al y al))
           (prog1 (fullonelast pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullonebasic (p pl al depth cont)
  (setq p (plug p al))
  (cond ((and (groundp p) (apply (get (car p) 'basic) (cdr p)))
         (fullonelast pl al depth cont))
        (t (fullfail (car pl) al depth))))

(defun fulloners (p pl al depth cont)
  (cond ((and *ancestry* (fulloneancestor p al cont)) (fullfail (car pl) al depth))
        ((and *reduction* (fullonereduce p pl al depth cont)))
        ((fullonedb p pl al depth cont *theory*))
        (t (fullfail (car pl) al depth))))

(defun fulloneancestor (p al cont)
  (do ((l (cdr cont) (cdr l)))
      ((null l) nil)
      (if (identify (caaar l) (cadar l) p al) (return t))))

(defun fullonereduce (p pl al depth cont)
  (do ((l cont (cdr l)) (ol))
      ((null l))
      (cond ((not (setq ol (unify (maknot (caaar l)) (cadar l) p al))))
            ((fulloneexit pl al depth cont) (backup ol) (return t))
            (t (backup ol)))))

(defun fullonedb (p pl al depth cont th)
  (cond ((fulloneth p pl al depth cont th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (when (fullonedb p pl al depth cont (car l)) (return t))))))

(defun fulloneth (p pl al depth cont th)
  (do ((l (envindexps p al th) (cdr l)) (bl (environment)) (ol))
      ((null l))
      (cond ((and (listp (car l)) (eq '<= (caar l)) (null (cddar l)))
             (cond ((not (setq ol (unify (cadar l) bl p al))))
                   ((fulloneexit pl al depth cont) (backup ol) (return t))
                   ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol))))
            ((and (listp (car l)) (eq '<= (caar l)))
             (cond ((not (setq ol (unify (cadar l) bl p al))))
                   ((fullone (caddar l) (cddar l) bl
                             (1+ depth) (cons (list pl al depth) cont))
                    (backup ol) (return  t))
                   (t (backup ol))))
            ((setq ol (unify (car l) bl p al))
             (cond ((fulloneexit pl al depth cont) (backup ol) (return t))
                   ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol)))))))

(defun fulloneprovabledb (p pl al depth cont th)
  (cond ((fulloneprovableth p pl al depth cont th))
        (t (do ((l (includees th) (cdr l)))
               ((null l))
               (when (fulloneprovableth p pl al depth cont (car l)) (return t))))))

(defun fulloneprovableth (p pl al depth cont th)
  (do ((l (envindexps p al th) (cdr l)) (bl (environment)) (ol))
      ((null l))
      (cond ((and (listp (car l)) (eq '<= (caar l)) (null (cddar l)))
             (cond ((not (setq ol (unify (cadar l) bl p al))))
                   ((fulloneexit pl al depth cont) (backup ol) (return t))
                   ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol))))
            ((and (listp (car l)) (eq '<= (caar l)))
             (cond ((not (setq ol (unify (cadar l) bl p al))))
                   ((fullone (caddar l) (cddar l) bl
                             (1+ depth) (cons (list pl al depth) cont))
                    (backup ol) (return  t))
                   (t (backup ol)))))))

(defun fulloneexit (pl al depth cont)
  (let (ans)
    (fullexit (car pl) al depth)
    (cond ((cdr pl) (setq ans (fullone (cadr pl) (cdr pl) al depth cont)))
          (cont (setq ans (fulloneexit (caar cont) (cadar cont) (caddar cont) (cdr cont))))
          (t (setq *answer* (plugstdexp *thing* alist) ans t)))
    (if ans t (fullredo (car pl) al depth))))

(defun fullonelast (pl al depth cont)
  (fullexit (car pl) al depth)
  (cond ((cdr pl) (fullone (cadr pl) (cdr pl) al depth cont))
        (cont (fulloneexit (caar cont) (cadar cont) (caddar cont) (cdr cont)))
        (t (setq *answer* (plugstdexp *thing* alist)))))

(defun fullcall (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Call: | p) nil)))

(defun fullexit (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Exit: | p) nil)))

(defun fullredo (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Redo: | p) nil)))

(defun fullfail (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Fail: | p) nil)))

(defun fullstop (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Stop: | p) nil)))

(defun fullsave (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Save: | p) nil)))

(defun fulldrop (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Drop: | p) nil)))

(defun fulldone (p al depth)
  (cond ((not traceexpressions) nil)
        ((find (setq p (plugstdexp p al)) traceexpressions :test #'instp)
         (tracemessage depth '|Done: | p) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullfinds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullfinds (*thing* p *theory* &optional (*filter* #'failure))
  (let (alist *answers*)
    (setq *unifications* 0)
    (setq *inferences* 0)
    (setq *termination* nil)
    (setq alist (environment))
    (fullall p (list p) alist 0 nil)
    (nreverse (uniquify *answers*))))

(defun fullall (p pl al depth cont)
  (setq *inferences* (1+ *inferences*))
  (fullcall p al depth)
  (cond ((>= *inferences* *limit*) (setq *termination* t) (fullstop (car pl) al depth))
        ((>= depth *depth*) (setq *termination* t) (fullstop (car pl) al depth))
        (t (fullallexp p pl al depth cont))))

(defun fullallexp (p pl al depth cont)
  (cond ((atom p) (fullallconstant p pl al depth cont))
        ((eq 'not (car p)) (fullallunprovable (cadr p) pl al depth cont))
        ((eq 'and (car p)) (fullalland p pl al depth cont))
        ((eq 'or (car p)) (fullallor p pl al depth cont))
        ((eq 'oneof (car p)) (fullalloneof p pl al depth cont))
        ((eq 'member (car p)) (fullallmember p pl al depth cont))
        ((eq 'same (car p)) (fullallsame p pl al depth cont))
        ((eq 'distinct (car p)) (fullalldistinct p pl al depth cont))
	((eq 'ground (car p)) (fullallground p pl al depth cont))
	((eq 'nonground (car p)) (fullallnonground p pl al depth cont))
	((eq 'primitive (car p)) (fullallprimitive p pl al depth cont))
	((eq 'nonprimitive (car p)) (fullallnonprimitive p pl al depth cont))
	((eq '== (car p)) (fullallvalue p pl al depth cont))
	((eq 'value (car p)) (fullallvalue p pl al depth cont))
        ((eq 'execute (car p)) (fullallexecute p pl al depth cont))
        ((eq 'evaluate (car p)) (fullallevaluate p pl al depth cont))
        ((eq 'knows (car p)) (fullallknows p pl al depth cont))
        ((eq 'unprovable (car p)) (fullallunprovable p pl al depth cont))
        ((eq 'choose (car p)) (fullallchoose p pl al depth cont))
        ((eq 'bagofall (car p)) (fullallbagofall p pl al depth cont))
        ((eq 'strmatch (car p)) (fullallstrmatch p pl al depth cont))
	((get (car p) 'basicval) (fullallbasicvalue p pl al depth cont))
        ((get (car p) 'basic) (fullallbasic p pl al depth cont))
        ((funcall *filter* (car p)) (fullallknowndb p pl al depth cont *theory*))
        (t (fullallrs p pl al depth cont))))

(defun fullallconstant (p pl al depth cont)
  (cond ((eq 'true p) (fullalllast pl al depth cont))
        ((eq 'false p) (fullfail (car pl) al depth))
        (t (fullallrs p pl al depth cont))))

(defun fullalland (p pl al depth cont)
  (cond ((null (cdr p)) (fullalllast pl al depth cont))
        ((fullall (cadr p) (cdr p) al depth (cons (list pl al depth) cont)))
        (t (fullfail (car pl) al depth))))

(defun fullallor (p pl al depth cont)
  (setq cont (cons (list pl al depth) cont))
  (do ((l (cdr p) (cdr l)))
      ((null l) (fullfail (car pl) al depth))
      (fullall (car l) (list (car l)) al depth cont)))

(defun fullalloneof (p pl al depth cont)
  (when (seqvarp (caddr p)) (setq p (plug p al)))
  (do ((l (cddr p) (cdr l)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (when (setq ol (unify (cadr p) al (car l) al))
        (fullallexit pl al depth cont)
        (backup ol))))

(defun fullallmember (p pl al depth cont)
  (when (seqvarp (caddr p)) (setq p (plug p al)))
  (do ((l (cdaddr p) (cdr l)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (when (setq ol (unify (cadr p) al (car l) al))
        (fullallexit pl al depth cont)
        (backup ol))))

(defun fullallsame (p pl al depth cont)
  (let (ol)
    (cond ((setq ol (unify (cadr p) al (caddr p) al))
           (fullalllast pl al depth cont)
           (backup ol))
          (t (fullfail p al depth)))))

(defun fullalldistinct (p pl al depth cont)
  (let (ol)
    (cond ((setq ol (unify (cadr p) al (caddr p) al))
           (backup ol) (fullfail p al depth))
          (t (fullalllast pl al depth cont)))))

(defun fullallground (p pl al depth cont)
  (setq p (plug p al))
  (if (groundp p) (fullallexit pl al depth cont)))

(defun fullallprimitive (p pl al depth cont)
  (setq p (plug p al))
  (if (primitivep p) (fullallexit pl al depth cont)))

(defun fullallvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (cadr p) y (caddr p))
    (cond ((atom x))
          ((eq 'bagofall (car x))
           (setq x (cons 'listof (fullfinds (cadr x) (caddr x) *theory*))))
          ((and (groundp x) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))))
    (cond ((setq ol (unify x al y al))
           (prog1 (fullallexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullallexecute (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (eval (cadr p))) (fullallexit pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (eval (cadr p))))))
                (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,(mapcar #'quotify values)) al)))
           (prog1 (fullallexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullallevaluate (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (apply (caadr p) (cdadr p))) (fullallexit pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (apply (caadr p) (cdadr p))))))
                (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,values) al)))
           (prog1 (fullallexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullallknows (p pl al depth cont)
  (let (agent)
    (fullallknowndb p pl al depth cont *theory*)
    (setq agent (plugstdexp (cadr p) al) p (caddr p))
    (do ((l (newindexps p al agent) (cdr l)) (bl (environment)) (ol))
        ((null l) (fullfail (car pl) al depth))
        (when (setq ol (unify (car l) bl p al))
          (fullalllast pl al depth cont)
          (cond ((subolp ol (alist bl)) (backup ol) (return nil))
                (t (backup ol)))))))

(defmethod newindexps (p al th)
  (envindexps p al th))

(defmethod newindexps (p al (th symbol))
  (cond ((and (boundp th) (not (symbolp (symbol-value th))))
         (newindexps p al (symbol-value th)))
        (t (call-next-method p al th))))

(defun fullallunprovable (p pl al depth cont)
  (cond ((fullone (cadr p) (cdr p) al depth nil) (fullfail (car pl) al depth))
        (t (fullalllast pl al depth cont))))

(defun fullallchoose (p pl al depth cont)
  (let (x ol)
    (setq p (plugstdexp p al))
    (setq x (findx (cadr p) (caddr p) *theory*))
    (cond ((and (not (null x)) (setq ol (unify (cadr p) alist x alist)))
           (prog1 (fullallexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullallbagofall (p pl al depth cont)
  (fullallvalue `(value ,(butlast p) ,(cadddr p)) pl al depth cont))

(defun fullallstrmatch (p pl al depth cont)
  (fullallexp `(execute (strmatches ,(cadr p) ,(caddr p)) ? . ,(cdddr p)) pl al depth cont))

(defun fullallbasicvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (butlast p) y (car (last p)))
    (when (and (groundp x) (every #'primitivep (cdr x)))
      (setq x (funcall (get (car x) 'basicval) x)))
    (cond ((setq ol (unify x al y al))
           (prog1 (fullallexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullallbasic (p pl al depth cont)
  (setq p (plug p al))
  (cond ((and (groundp p) (apply (get (car p) 'basic) (cdr p))
              (fullallexit pl al depth cont)))
        (t (fullfail (car pl) al depth))))

(defun fullallrs (p pl al depth cont)
  (cond ((and *ancestry* (fullallancestor p al cont)) (fullfail (car pl) al depth))
        ((and (numberp *ancestry*) (fullallnumber p al cont 0))
         (setq *termination* t) (fullfail (car pl) al depth))
        ((and *reduction* (fullallreduce p pl al depth cont)))
        ((fullalldb p pl al depth cont *theory*))
        (t (fullfail (car pl) al depth))))

(defun fullallancestor (p al cont)
  (do ((l cont (cdr l)))
      ((null l) nil)
      (if (identify (caaar l) (cadar l) p al) (return t))))

(defun fullallnumber (p al cont n)
  (let (ol)
    (cond ((numgeqp n *ancestry*))
          ((null cont) nil)
          ((atom p)
           (fullallnumber p al (cdr cont) (if (eq p (caaar cont)) (1+ n) n)))
          ((setq ol (unify p al (caaar cont) (cadar cont)))
           (prog1 (fullallnumber p al (cdr cont) (1+ n)) (backup ol)))
          (t (fullallnumber p al (cdr cont) n)))))

(defun fullallreduce (p pl al depth cont)
  (do ((l cont (cdr l)) (ol))
      ((null l))
      (when (setq ol (unify (maknot (caaar l)) (cadar l) p al))
        (fullallexit pl al depth cont)
        (backup ol))))

(defun fullalldb (p pl al depth cont th)
  (fullallth p pl al depth cont th)
  (do ((l (includees th) (cdr l)))
      ((null l))
      (fullalldb p pl al depth cont (car l))))

(defun fullallth (p pl al depth cont th)
  (do ((l (envindexps p al th) (cdr l)) (bl (environment)) (ol))
      ((null l))
      (cond ((and (listp (car l)) (eq '<= (caar l)) (null (cddar l)))
             (when (setq ol (unify (cadar l) bl p al))
               (fullallexit pl al depth cont)
               (cond ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol)))))
            ((and (listp (car l)) (eq '<= (caar l)))
             (when (setq ol (unify (cadar l) bl p al))
               (fullall (caddar l) (cddar l) bl
                        (1+ depth) (cons (list pl al depth) cont))
               (backup ol)))
            ((setq ol (unify (car l) bl p al))
             (fullallexit pl al depth cont)
             (cond ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol)))))))

(defun fullallknowndb (p pl al depth cont th)
  (fullallknownth p pl al depth cont th)
  (do ((l (includees th) (cdr l)))
      ((null l))
      (fullallknowndb p pl al depth cont (car l))))

(defun fullallknownth (p pl al depth cont th)
  (do ((l (newindexps p al th) (cdr l)) (bl (environment)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (when (setq ol (unify (car l) bl p al))
        (fullallexit pl al depth cont)
        (cond ((subolp ol (alist bl)) (backup ol) (return nil))
              (t (backup ol))))))

(defun fullallexit (pl al depth cont)
  (fullexit (car pl) al depth)
  (cond ((cdr pl) (fullall (cadr pl) (cdr pl) al depth cont))
        (cont (fullallexit (caar cont) (cadar cont) (caddar cont) (cdr cont)))
        (t (setq *answers* (cons (plugstdexp *thing* alist) *answers*))))
  (fullredo (car pl) al depth))

(defun fullalllast (pl al depth cont)
  (fullexit (car pl) al depth)
  (cond ((cdr pl) (fullall (cadr pl) (cdr pl) al depth cont))
        (cont (fullallexit (caar cont) (cadar cont) (caddar cont) (cdr cont)))
        (t (setq *answers* (cons (plugstdexp *thing* alist) *answers*)) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; *gamma*
;;; *delta*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *gamma* (make-instance 'theory))

(defmethod envindexps (p al (th (eql *gamma*)))
  (cond ((varp p) (contents th))
        ((atom p) (indexees p th))
        ((find (car p) '(believes knows exportable importable))
         (envindexps (caddr p) al th))
        (t (do ((l (cdr p) (cdr l)) (dum))
               ((null l) (indexps (car p) th))
               (setq dum (unival (car l) al))
               (cond ((varp dum))
                     ((atom dum) (return (indexees dum th))))))))

(defmethod indexps (p (th (eql *gamma*)))
  (cond ((varp p) (contents th))
        ((atom p) (indexees p th))
        ((find (car p) '(believes knows exportable importable)) (indexps (caddr p) th))
        (t (do ((l (cdr p) (cdr l)))
               ((null l) (indexps (car p) th))
               (cond ((varp (car l)))
                     ((atom (car l)) (return (indexees (car l) th))))))))


(defparameter *delta* (make-instance 'theory))

(defmethod indexps (p (th (eql *delta*)))
  (cond ((varp p) (contents th))
        ((atom p) (indexees p th))
        ((find (car p) '(believes knows exportable importable)) (indexps (caddr p) th))
        (t (do ((l (cdr p) (cdr l)))
               ((null l) (indexps (car p) th))
               (cond ((varp (car l)))
                     ((atom (car l)) (return (indexees (car l) th))))))))

(defmethod indexps (p (th (eql *delta*)))
  (cond ((varp p) (contents th))
        ((atom p) (indexees p th))
        ((find (car p) '(pos neg plus minus)) (indexps (cadr p) th))
        (t (do ((l (cdr p) (cdr l)))
               ((null l) (indexps (car p) th))
               (cond ((varp (car l)))
                     ((atom (car l)) (return (indexees (car l) th))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullupdate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullupdate (p theory &optional (obssession  #'failure) (specialty #'failure))
  (fullretract (maknot p) theory obssession specialty)
  (fullassert p theory obssession specialty)
  'done)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullassert
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *specialty* #'failure)
(defparameter *obsession* #'failure)

(defun fullasserts (facts th &optional (obsession  #'failure) (specialty #'failure))
  (dolist (p facts) (fullassert p th obsession specialty)))

(defun fullassert (p *theory* &optional (*obsession*  #'failure) (*specialty* #'failure))
  (let (alist level tracecalls)
    (setq *termination* nil)
    (setq *unifications* 0)
    (setq alist (environment))
    (setq level 0)
    (fullassertdepth p alist 1)
    'done))

(defun fullassertdepth (p al depth)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        (t (fullsave p al depth)
           (fullassertexp p al depth)
           (fulldone p al depth))))

(defun fullassertexp (p al depth)
  (cond ((atom p) (fullassertexpexit p al depth))
        ((eq 'and (car p))
         (mapc #'(lambda (x) (fullassertdepth x al depth)) (cdr p)))
        (t (fullassertexpexit p al depth))))

(defun fullassertexpexit (p al depth)
  (setq p (plugstdexp p al))
  (cond ((knownp p *theory* #'samep) nil)
        ((atom p) (fullassertrs p al depth))
        ((eq 'execute (car p)) (ignore-errors (eval (cadr p))))
        ((eq 'evaluate (car p)) (ignore-errors (apply (caadr p) (cdadr p))))
        (t (fullassertrs p al depth))))

(defun fullassertrs (p al depth)
  (cond ((funcall *obsession* (operator p)) (insert p *theory*))
        (t (when (funcall *specialty* (operator p)) (insert p *theory*))
           (fullassertdb p al depth *theory*))))

(defun fullassertdb (p al depth th)
  (cond ((fullassertth p al depth th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (fullassertdb p al depth (car l))))))

(defun fullassertth (p al depth th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment)) (*thing*) (*answers*) (dum))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '<=))
        (do ((m (cddar l) (cdr m)) (om))
            ((null m))
            (when (setq ol (unify (car m) bl p al))
              (if tracefacts (tracefact (car l)))
              (setq dum (maksand (revappend om (cdr m))))
              (setq *thing* (cadar l) *answers* nil)
              (let ((alist bl) (*filter* *specialty*))
                (fullall dum (list dum) bl (1+ depth) nil))
              (dolist (q *answers*) (fullassertdepth q alist (1+ depth)))
              (backup ol))
            (setq om (cons (car m) om))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullretract
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *conclusions* nil)

(defun fullretracts (facts th &optional (obsession  #'failure) (specialty #'failure))
  (dolist (p facts) (fullretract p th obsession specialty)))

(defun fullretract (p *theory* &optional (*obsession*  #'failure) (*specialty* #'failure))
  (let (conclusions)
    (setq conclusions (fullconclusions (list p) *theory* *obsession* *specialty*))
    (when (funcall *specialty* (operator p)) (drop p *theory*))
    (dolist (q conclusions)
      (unless (fullprovablep q *theory*) (drop q *theory*)))
    'done))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullassertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullassertions (facts *theory* &optional (*obsession*  #'failure) (*specialty* #'failure))
  (decludes *gamma*)
  (includes *gamma* *theory*)
  (empty *gamma*)
  (fullasserts facts *gamma* *obsession* *specialty*)
  (contents *gamma*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullconclusions - version without indexing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fullconclusions (facts *theory* &optional (*obsession*  #'failure) (*specialty* #'failure))
  (let (*conclusions* alist (level 0) tracecalls)
    (setq *termination* nil)
    (setq *unifications* 0)
    (setq alist (environment))
    (dolist (p facts) (fullconclusionsdepth p 0))
    (nreverse *conclusions*)))

(defun fullconclusionsdepth (p depth)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        (t (fulldrop p alist depth)
           (fullconclusionsexp p depth)
           (fulldone p alist depth))))

(defun fullconclusionsexp (p depth)
  (cond ((atom p) (fullconclusionstest p depth))
        ((eq 'and (car p))
         (mapc #'(lambda (x) (fullconclusionsdepth x depth)) (cdr p)))
        (t (fullconclusionstest p depth))))

(defun fullconclusionstest (p depth)
  (cond ((find p *conclusions* :test #'equalp))
        (t (when (funcall *specialty* (operator p))
             (setq *conclusions* (cons p *conclusions*)))
           (fullconclusionsdb p depth *theory*))))

(defun fullconclusionsdb (p depth th)
  (fullconclusionsth p depth th)
  (dolist (th (includees th)) (fullconclusionsdb p depth th) nl))

(defun fullconclusionsth (p depth th)
  (do ((l (indexps p th) (cdr l)) (ol) (bl (environment)) (*thing*) (*answers*) (dum))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '<=))
        (do ((m (cddar l) (cdr m)) (om))
            ((null m))
            (when (setq ol (unify (car m) bl p alist))
              (if tracefacts (tracefact (car l)))
              (setq dum (maksand (revappend om (cdr m))))
              (setq *thing* (cadar l) *answers* nil)
              (let ((alist bl) (*filter* *specialty*))
                (fullall dum (list dum) bl (1+ depth) nil))
              (dolist (q *answers*) (fullconclusionsdepth q (1+ depth)))
              (backup ol))
            (setq om (cons (car m) om))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|
(defparameter *foo* (make-instance 'fullserver :name 'foo))

(define-theory *foo* ""
  '((p a) (q a) (r a) (p b) (r b)
    (s a b) (s a c) (t a) (s d e) (t d)
    (u a b) (v b c) (w a c)
    (i a) (m a)
    (<= (r ?x) (p ?x))
    (<= (r ?x) (q ?x))
    (<= (t ?x) (s ?x ?y))
    (<= (w ?x ?z) (u ?x ?y) (v ?y ?z))
    (<= (j ?x) (i ?x))
    (<= (k ?x) (i ?x))
    (<= (m ?x) (j ?x) (k ?x))))

(fullassertions '((p c)) *foo* #'failure #'success)
((p c) (r c))

(fullassertions '((s b b)) *foo* #'failure #'success)
((s b b) (t b))

(fullassertions '((u b b)) *foo* #'failure #'success)
((u b b) (w b c))

(fullassertions '((i b)) *foo* #'failure #'(lambda (x) (find x '(i m))))
((i b) (m b))

(fullretractions '((p a)) *foo* #'failure #'success)
((p a))

(fullretractions '((p b)) *foo* #'failure #'success)
((p b) (r b))

(fullretractions '((s a b)) *foo* #'failure #'success)
((s a b))

(fullretractions '((s d e)) *foo* #'failure #'success)
((s d e) (t d))

(fullretractions '((i a)) *foo* #'failure #'(lambda (x) (find x '(i m))))
((i a) (m a))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fullsupports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod fullsupports (p *theory* &optional (*filter* #'failure))
  (let (alist *residue* *answers*)
    (setq *unifications* 0)
    (setq *inferences* 0)
    (setq *termination* nil)
    (setq alist (environment))
    (fullsupportsdepth p (list p) alist 0 nil)
    (nreverse (uniquify (mapcar #'maksand *answers*)))))

(defun fullsupportsdepth (p pl al depth cont)
  (setq *inferences* (1+ *inferences*))
  (fullcall p al depth)
  (cond ((>= *inferences* *limit*) (setq *termination* t) (fullstop (car pl) al depth))
        ((>= depth *depth*) (setq *termination* t) (fullstop (car pl) al depth))
        (t (fullsupportsexp p pl al depth cont))))

(defun fullsupportsexp (p pl al depth cont)
  (cond ((atom p) (fullsupportsconstant p pl al depth cont))
        ((eq 'not (car p)) (fullsupportsnot (cadr p) pl al depth cont))
        ((eq 'and (car p)) (fullsupportsand p pl al depth cont))
        ((eq 'or (car p)) (fullsupportsor p pl al depth cont))
        ((eq 'oneof (car p)) (fullsupportsoneof p pl al depth cont))
        ((eq 'member (car p)) (fullsupportsmember p pl al depth cont))
        ((eq 'same (car p)) (fullsupportssame p pl al depth cont))
        ((eq 'distinct (car p)) (fullsupportsdistinct p pl al depth cont))
	((eq 'ground (car p)) (fullsupportsground p pl al depth cont))
	((eq 'nonground (car p)) (fullsupportsnonground p pl al depth cont))
	((eq 'primitive (car p)) (fullsupportsprimitive p pl al depth cont))
	((eq 'nonprimitive (car p)) (fullsupportsnonprimitive p pl al depth cont))
	((eq '== (car p)) (fullsupportsvalue p pl al depth cont))
	((eq 'value (car p)) (fullsupportsvalue p pl al depth cont))
        ((eq 'execute (car p)) (fullsupportsexecute p pl al depth cont))
        ((eq 'evaluate (car p)) (fullsupportsevaluate p pl al depth cont))
        ((eq 'knows (car p)) (fullsupportsknows p pl al depth cont))
        ((eq 'unprovable (car p)) (fullsupportsunprovable p pl al depth cont))
        ((eq 'choose (car p)) (fullsupportschoose p pl al depth cont))
        ((eq 'bagofall (car p)) (fullsupportsbagofall p pl al depth cont))
        ((eq 'strmatch (car p)) (fullsupportsstrmatch p pl al depth cont))
	((get (car p) 'basicval) (fullsupportsbasicvalue p pl al depth cont))
        ((get (car p) 'basic) (fullsupportsbasic p pl al depth cont))
        ((funcall *filter* (car p)) (fullsupportsknowndb p pl al depth cont *theory*))
        (t (fullsupportsrs p pl al depth cont))))

(defun fullsupportsnot (p pl al depth cont)
  (cond ((atom p) (fullsupportsnotconstant p pl al depth cont))
        ((eq 'not (car p)) (fullsupportsexp (cadr p) pl al depth cont))
        ((eq 'and (car p)) (fullsupportsnotand p pl al depth cont))
        ((eq 'or (car p)) (fullsupportsnotor p pl al depth cont))
        ((eq 'oneof (car p)) nil)
        ((eq 'same (car p)) nil)
        ((eq 'distinct (car p)) nil)
	((eq 'ground (car p)) nil)
	((eq 'nonground (car p)) nil)
	((eq 'primitive (car p)) nil)
	((eq 'nonprimitive (car p)) nil)
	((eq '== (car p)) (fullsupportsnotvalue p pl al depth cont))
	((eq 'value (car p)) (fullsupportsnotvalue p pl al depth cont))
        ((eq 'execute (car p)) (fullsupportsnotexecute p pl al depth cont))
        ((eq 'evaluate (car p)) (fullsupportsnotevaluate p pl al depth cont))
        ((eq 'knows (car p)) (fullsupportsnotknows p pl al depth cont))
        ((eq 'unprovable (car p)) (fullsupportsexp (cadr p) pl al depth cont))
        ((eq 'choose (car p)) (fullsupportsnotchoose p pl al depth cont))
        ((eq 'bagofall (car p)) (fullsupportsnotbagofall p pl al depth cont))
        ((eq 'strmatch (car p)) (fullsupportsnotstrmatch p pl al depth cont))
	((get (car p) 'basicval) (fullsupportsnotbasicvalue p pl al depth cont))
        ((get (car p) 'basic) (fullsupportsnotbasic p pl al depth cont))
        (t (fullsupportsrs `(not ,p) pl al depth cont))))

(defun fullsupportsconstant (p pl al depth cont)
  (cond ((eq 'true p) (fullsupportslast pl al depth cont))
        ((eq 'false p) (fullfail (car pl) al depth))
        (t (fullsupportsrs p pl al depth cont))))

(defun fullsupportsnotconstant (p pl al depth cont)
  (cond ((eq 'true p) (fullfail (car pl) al depth))
        ((eq 'false p) (fullsupportslast pl al depth cont))
        (t (fullsupportsrs `(not ,p) pl al depth cont))))

(defun fullsupportsand (p pl al depth cont)
  (cond ((null (cdr p)) (fullsupportslast pl al depth cont))
        ((fullsupportsdepth (cadr p) (cdr p) al depth (cons (list pl al depth) cont)))
        (t (fullfail (car pl) al depth))))

(defun fullsupportsnotand (p pl al depth cont)
  (setq cont (cons (list pl al depth) cont))
  (do ((l (cdr p) (cdr l)))
      ((null l) (fullfail (car pl) al depth))
      (fullsupportsdepth (maknot (car l)) (list (maknot (car l))) al depth cont)))

(defun fullsupportsor (p pl al depth cont)
  (setq cont (cons (list pl al depth) cont))
  (do ((l (cdr p) (cdr l)))
      ((null l) (fullfail (car pl) al depth))
      (fullsupportsdepth (car l) (list (car l)) al depth cont)))

(defun fullsupportsnotor (p pl al depth cont)
  (cond ((null (cdr p)) (fullsupportslast pl al depth cont))
        ((fullsupportsdepth (maknot (cadr p)) (mapcar #'maknot (cdr p)) al depth
                  (cons (list pl al depth) cont)))
        (t (fullfail (car pl) al depth))))

(defun fullsupportsoneof (p pl al depth cont)
  (when (seqvarp (caddr p)) (setq p (plug p al)))
  (do ((l (cddr p) (cdr l)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (when (setq ol (unify (cadr p) al (car l) al))
        (fullsupportsexit pl al depth cont)
        (backup ol))))

(defun fullsupportsmember (p pl al depth cont)
  (when (seqvarp (caddr p)) (setq p (plug p al)))
  (do ((l (cdaddr p) (cdr l)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (when (setq ol (unify (cadr p) al (car l) al))
        (fullsupportsexit pl al depth cont)
        (backup ol))))

(defun fullsupportssame (p pl al depth cont)
  (let (ol)
    (when (setq ol (unify (cadr p) al (caddr p) al))
      (fullsupportsexit pl al depth cont)
      (backup ol))))

(defun fullsupportsdistinct (p pl al depth cont)
  (if (unify (cadr p) al (caddr p) al) nil (fullsupportsexit pl al depth cont)))

(defun fullsupportsground (p pl al depth cont)
  (setq p (plug p al))
  (if (groundp p) (fullsupportsexit pl al depth cont)))

(defun fullsupportsnonground (p pl al depth cont)
  (setq p (plug p al))
  (if (groundp p) nil (fullsupportsexit pl al depth cont)))

(defun fullsupportsprimitive (p pl al depth cont)
  (setq p (plug p al))
  (if (primitivep p) (fullsupportsexit pl al depth cont)))

(defun fullsupportsnonprimitive (p pl al depth cont)
  (setq p (plug p al))
  (if (primitivep p) nil (fullsupportsexit pl al depth cont)))

(defun fullsupportsvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (cadr p) y (caddr p))
    (cond ((atom x))
          ((eq 'bagofall (car x))
           (setq x (cons 'listof (fullfinds (cadr x) (caddr x) *theory*))))
          ((and (groundp x) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))))
    (cond ((setq ol (unify x al y al))
           (prog1 (fullsupportsexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullsupportsnotvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (cadr p) y (caddr p))
    (cond ((atom x))
          ((eq 'bagofall (car x))
           (setq x (cons 'listof (fullfinds (cadr x) (caddr x) *theory*))))
          ((and (groundp x) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))))
    (cond ((setq ol (unify x al y al)) (backup ol) (fullfail (car pl) al depth))
          (t (fullsupportsexit pl al depth cont)))))

(defun fullsupportsexecute (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (eval (cadr p))) (fullsupportsexit pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (eval (cadr p))))))
                (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,(mapcar #'quotify values)) al)))
           (prog1 (fullsupportsexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullsupportsnotexecute (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (not (eval (cadr p)))) (fullsupportsexit pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (eval (cadr p))))))
                (not (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,(mapcar #'quotify values)) al)))
           (fullsupportsexit pl al depth cont)))
          (t (backup ol) (fullfail (car pl) al depth)))))          

(defun fullsupportsevaluate (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (apply (caadr p) (cdadr p))) (fullsupportsexit pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (apply (caadr p) (cdadr p))))))
                (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,values) al)))
           (prog1 (fullsupportsexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullsupportsnotevaluate (p pl al depth cont)
  (let (values ol)
    (setq p (plug p al))
    (cond ((null (cddr p))
           (cond ((ignore-errors (not (apply (caadr p) (cdadr p)))) (fullsupportsexit pl al depth cont))
                 (t (fullfail (car pl) al depth))))
          ((and (car (setq values (ignore-errors (multiple-value-list (apply (caadr p) (cdadr p))))))
                (not (setq ol (matchify `(listof . ,(cddr p)) al `(listof . ,values) al))))
           (fullsupportsexit pl al depth cont))
          (t (backup ol) (fullfail (car pl) al depth)))))

(defun fullsupportsknows (p pl al depth cont)
  (let (agent)
    (fullsupportsknowndb p pl al depth cont *theory*)
    (setq agent (plugstdexp (cadr p) al) p (caddr p))
    (do ((l (newindexps p al agent) (cdr l)) (bl (environment)) (ol))
        ((null l) (fullfail (car pl) al depth))
        (when (setq ol (unify (car l) bl p al))
          (fullsupportslast pl al depth cont)
          (cond ((subolp ol (alist bl)) (backup ol) (return nil))
                (t (backup ol)))))))

(defun fullsupportsnotknows (p pl al depth cont)
  (let (agent)
    (fullsupportsknowndb `(not ,p) pl al depth cont *theory*)
    (setq agent (plugstdexp (cadr p) al) p (caddr p))
    (do ((l (newindexps p al agent) (cdr l)) (bl (environment)) (ol))
        ((null l)  (fullsupportslast pl al depth cont))
        (when (setq ol (unify (car l) bl p al))
          (backup ol)
          (return (fullfail (car pl) al depth))))))

(defun fullsupportsunprovable (p pl al depth cont)
  (cond ((fullone (cadr p) (cdr p) al depth nil) (fullfail (car pl) al depth))
        (t (fullsupportslast pl al depth cont))))

(defun fullsupportschoose (p pl al depth cont)
  (let (x ol)
    (setq p (plugstdexp p al))
    (setq x (findx (cadr p) (caddr p) *theory*))
    (cond ((and (not (null x)) (setq ol (unify (cadr p) alist x alist)))
           (prog1 (fullsupportsexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullsupportsnotchoose (p pl al depth cont)
  (setq p (plugstdexp p al))
  (cond ((findp (caddr p) *theory*) (fullfail (car pl) al depth))
        (t (fullsupportsexit pl al depth cont))))

(defun fullsupportsbagofall (p pl al depth cont)
  (fullsupportsvalue `(value ,(butlast p) ,(cadddr p)) pl al depth cont))

(defun fullsupportsnotbagofall (p pl al depth cont)
  (fullsupportsnotvalue `(value ,(butlast p) ,(cadddr p)) pl al depth cont))

(defun fullsupportsstrmatch (p pl al depth cont)
  (fullsupportsexp `(execute (strmatches ,(cadr p) ,(caddr p)) ? . ,(cdddr p)) pl al depth cont))

(defun fullsupportsnotstrmatch (p pl al depth cont)
  (fullsupportsnot `(execute (strmatches ,(cadr p) ,(caddr p)) ? . ,(cdddr p)) pl al depth cont))

(defun fullsupportsbasicvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (butlast p) y (car (last p)))
    (when (and (groundp x) (every #'primitivep (cdr x)))
      (setq x (funcall (get (car x) 'basicval) x)))
    (cond ((setq ol (unify x al y al))
           (prog1 (fullsupportsexit pl al depth cont) (backup ol)))
          (t (fullfail (car pl) al depth)))))

(defun fullsupportsnotbasicvalue (p pl al depth cont)
  (let (x y ol)
    (setq p (plug p al) x (butlast p) y (car (last p)))
    (when (and (groundp x) (every #'primitivep (cdr x)))
      (setq x (funcall (get (car x) 'basicval) x)))
    (cond ((setq ol (unify x al y al)) (backup ol) (fullfail (car pl) al depth))
          (t (fullsupportsexit pl al depth cont)))))

(defun fullsupportsbasic (p pl al depth cont)
  (setq p (plug p al))
  (cond ((and (groundp p) (apply (get (car p) 'basic) (cdr p))
              (fullsupportsexit pl al depth cont)))
        (t (fullfail (car pl) al depth))))

(defun fullsupportsnotbasic (p pl al depth cont)
  (setq p (plug p al))
  (cond ((and (groundp p) (not (apply (get (car p) 'basic) (cdr p)))
              (fullsupportsexit pl al depth cont)))
        (t (fullfail (car pl) al depth))))

(defun fullsupportsrs (p pl al depth cont)
  (cond ((and *ancestry* (fullsupportsancestor p al cont)) (fullfail (car pl) al depth))
        ((and (numberp *ancestry*) (fullsupportsnumber p al cont 0))
         (setq *termination* t) (fullfail (car pl) al depth))
        ((and *reduction* (fullsupportsreduce p pl al depth cont)))
        ((fullsupportsdb p pl al depth cont *theory*))
        (t (fullfail (car pl) al depth))))

(defun fullsupportsancestor (p al cont)
  (do ((l cont (cdr l)))
      ((null l) nil)
      (if (identify (caaar l) (cadar l) p al) (return t))))

(defun fullsupportsnumber (p al cont n)
  (let (ol)
    (cond ((numgeqp n *ancestry*))
          ((null cont) nil)
          ((atom p)
           (fullsupportsnumber p al (cdr cont) (if (eq p (caaar cont)) (1+ n) n)))
          ((setq ol (unify p al (caaar cont) (cadar cont)))
           (prog1 (fullsupportsnumber p al (cdr cont) (1+ n)) (backup ol)))
          (t (fullsupportsnumber p al (cdr cont) n)))))

(defun fullsupportsreduce (p pl al depth cont)
  (do ((l cont (cdr l)) (ol))
      ((null l))
      (when (setq ol (unify (maknot (caaar l)) (cadar l) p al))
        (fullsupportsexit pl al depth cont)
        (backup ol))))

(defun fullsupportsdb (p pl al depth cont th)
  (fullsupportsth p pl al depth cont th)
  (do ((l (includees th) (cdr l)))
      ((null l))
      (fullsupportsdb p pl al depth cont (car l))))

(defun fullsupportsth (p pl al depth cont th)
  (do ((l (envindexps p al th) (cdr l)) (bl (environment)) (ol))
      ((null l))
      (cond ((and (listp (car l)) (eq '<= (caar l)) (null (cddar l)))
             (when (setq ol (unify (cadar l) bl p al))
               (fullsupportsexit pl al depth cont)
               (cond ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol)))))
            ((and (listp (car l)) (eq '<= (caar l)))
             (when (setq ol (unify (cadar l) bl p al))
               (fullsupportsdepth (caddar l) (cddar l) bl
                        (1+ depth) (cons (list pl al depth) cont))
               (backup ol)))
            ((setq ol (unify (car l) bl p al))
             (cond ((find (car l) *residue* :test #'equalp)
                    (fullsupportslast pl al depth cont))
                   (t (let ((*residue* (cons (car l) *residue*)))
                        (fullsupportslast pl al depth cont))))
             (cond ((subolp ol (alist bl)) (backup ol) (return nil))
                   (t (backup ol)))))))

(defun fullsupportsknowndb (p pl al depth cont th)
  (fullsupportsknownth p pl al depth cont th)
  (do ((l (includees th) (cdr l)))
      ((null l))
      (fullsupportsknowndb p pl al depth cont (car l))))

(defun fullsupportsknownth (p pl al depth cont th)
  (do ((l (newindexps p al th) (cdr l)) (bl (environment)) (ol))
      ((null l) (fullfail (car pl) al depth))
      (when (setq ol (unify (car l) bl p al))
        (fullsupportsexit pl al depth cont)
        (cond ((subolp ol (alist bl)) (backup ol) (return nil))
              (t (backup ol))))))

(defun fullsupportsexit (pl al depth cont)
  (fullexit (car pl) al depth)
  (cond ((cdr pl) (fullsupportsdepth (cadr pl) (cdr pl) al depth cont))
        (cont (fullsupportsexit (caar cont) (cadar cont) (caddar cont) (cdr cont)))
        (t (setq *answers* (cons (reverse *residue*) *answers*))))
  (fullredo (car pl) al depth))

(defun fullsupportslast (pl al depth cont)
  (fullexit (car pl) al depth)
  (cond ((cdr pl) (fullsupportsdepth (cadr pl) (cdr pl) al depth cont))
        (cont (fullsupportsexit (caar cont) (cadar cont) (caddar cont) (cdr cont)))
        (t (setq *answers* (cons (reverse *residue*) *answers*)) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; oldfindx, oldfinds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun oldfindx (x p *theory*)
  (do ((old *depth*) (*depth* (min *start* *depth*) (+ *depth* *increment*))
       (alist (environment)) (level 0) (tracecalls))
      ((> *depth* old) nil)
      (setq *termination* nil *inferences* 0 *unifications* 0)
      (cond ((finddepth p alist 1 nil '(failure) '(identity))
             (return (plugstdexp x alist)))
            ((not *termination*) (return nil)))))

(defun oldfinds (x p *theory*)
  (let ((alist (environment)) (level 0) tracecalls)
    (setq *termination* nil *inferences* 0 *unifications* 0)
    (do ((next (finddepth p alist 1 nil '(failure) '(identity)) (profail nil next))
         (nl))
        ((null next) (nreverse (uniquify nl)))
        (setq nl (cons (plugstdexp x alist) nl)))))

(defmethod findanswer (s th)
  (decludes 'epitheory)
  (empty 'epitheory)
  (includes 'epitheory th)
  (mapc #'(lambda (x) (save x 'epitheory)) s)
  (findx '(@l) `(answer @l) 'epitheory))

(defmethod findanswers (s th)
  (decludes 'epitheory)
  (empty 'epitheory)
  (includes 'epitheory th)
  (mapc #'(lambda (x) (save x 'epitheory)) s)
  (finds '(@l) `(answer @l) 'epitheory))


(defmethod findval (x th)
 "(FINDVAL X TH)
  is equivalent to (FINDX '?? `(AND (= ,X ??) (PRIMITIVE ??)) TH)."
  (findx '?? `(and (= ,x ??) (primitive ??)) th))

(defmethod findvals (x th)
 "(FINDVALS X TH)
  is equivalent to (FINDS '?? `(AND (= ,X ??) (PRIMITIVE ??)) TH)�."
  (finds '?? `(and (= ,x ??) (primitive ??)) th))

(defmethod mapone (rel args th)
 "(MAPONE FUN ARGS TH)"
  (do ((l args (cdr l)) (nl))
      ((null l) (nreverse nl))
      (setq nl (cons (findx '?y (list rel (car l) '?y) th) nl))))

(defmethod mapall (rel args th)
 "(MAPALL FUN ARGS TH)"
  (do ((l args (cdr l)) (nl))
      ((null l) (nreverse nl))
      (setq nl (cons (finds '?y (list rel (car l) '?y) th) nl))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; findg
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod findg (x p th)
 "(FINDG X P *THEORY*)
  FINDG takes as argument a term, a sentence, and a theory.  It returns a
  continuation that on each call tries to prove the specified sentence from the
  specified theory and its included theories.  The search is done in iterative
  deepening fashion, controlled by the variables *START*, *INCREMENT*, and
  *DEPTH*.  If the continuation is able to prove the sentence, it returns a copy
  of the specified term with variables replaced by values obtained during the
  proof process.  After each successful attempt, the continuation can be called
  again to get the next answer.  Once all answers have been enumerated, the
  continuation returns NIL."
  (let* ((al (environment))
         (cont `(procall (finddepth ,p ,al 1 nil (failure) (identity))))
         (tcs) (inferences 0) (unifications 0))
    #'(lambda ()
        (let ((*theory* th) (alist al) (level 0) (tracecalls tcs))
          (setq *termination* nil *inferences* inferences *unifications* unifications)
          (when (setq cont (profail nil cont))
            (setq tcs tracecalls inferences *inferences* unifications *unifications*)
            (plugstdexp x alist))))))


(defun finddepth (p al depth stack next done)
  (setq *inferences* (1+ *inferences*))
  (cond ((numgreaterp depth *depth*) (setq *termination* t) (profail nil next))
        ((and traceexpressions
              (protracecall p al done)
              (setq next `(protracefail ,next ,done))
              (setq done `(protraceexit ,done)) nil))
        (t (findexp p al depth stack next done))))

(defun findexp (p al depth stack next done)
  (cond ((atom p) (findconst p al depth stack next done))
        ((eq 'not (car p)) (findnotexp (cadr p) al depth stack next done))
        ((eq 'and (car p)) (findand p al depth stack next done))
        ((eq 'or (car p)) (findor p al depth stack next done))
	((eq 'oneof (car p)) (findoneof p al next done))
	((eq 'same (car p)) (findsame p al next done))
	((eq 'distinct (car p)) (finddistinct p al next done))
	((eq 'ground (car p)) (findground p al next done))
	((eq 'nonground (car p)) (findnonground p al next done))
	((eq 'primitive (car p)) (findprimitive p al next done))
	((eq 'nonprimitive (car p)) (findnonprimitive p al next done))
	((eq '== (car p)) (findvalue p al next done))
	((eq 'value (car p)) (findvalue p al next done))
	((eq 'execute (car p)) (findexecute p al next done))
	((eq 'evaluate (car p)) (findevaluate p al next done))
	((eq 'unprovable (car p)) (findunprovable (cadr p) al next done))
	((eq 'choose (car p)) (findchoose p al next done))
	((eq 'bagofall (car p)) (findbagofall p al next done))
	((eq 'stringmatch (car p)) (findstringmatch p al next done))
	((get (car p) 'basicval) (findbasicvalue p al depth stack next done))
	((get (car p) 'basic) (findbasic p al depth stack next done))
	(t (findcallfail p al depth stack next done))))

(defun findnotexp (p al depth stack next done)
  (cond ((atom p) (findnotconst p al depth stack next done))
        ((eq 'not (car p)) (finddepth (cadr p) al depth stack next done))
        ((eq 'and (car p)) (findornot p al depth stack next done))
        ((eq 'or (car p)) (findandnot p al depth stack next done))
	((eq 'oneof (car p)) (profail nil next))
	((eq 'same (car p)) (profail nil next))
	((eq 'distinct (car p)) (profail nil next))
	((eq 'ground (car p)) (profail nil next))
	((eq 'nonground (car p)) (profail nil next))
	((eq 'primitive (car p)) (profail nil next))
	((eq 'nonprimitive (car p)) (profail nil next))
	((eq '== (car p)) (findnotvalue p al next done))
	((eq 'value (car p)) (findnotvalue p al next done))
	((eq 'execute (car p)) (findnotexecute p al next done))
	((eq 'evaluate (car p)) (findnotevaluate p al next done))
	((eq 'unprovable (car p)) (finddepth (cadr p) al depth stack next done))
	((eq 'bagofall (car p)) (findnotbagofall p al next done))
	((eq 'stringmatch (car p)) (profail nil next))
        ((get (car p) 'basicval) (findnotbasicvalue p al depth stack next done))
        ((get (car p) 'basic) (findnotbasic p al depth stack next done))
        ((extensionalp p al) (findunknown p al next done))
        ((intensionalp p al) (findunprovable p al next done))
        (t (findcallfail `(not ,p) al depth stack next done))))

(defun findconst (p al depth stack next done)
  (cond ((eq 'true p) (proexit next done))
        ((eq 'cut p) (proexit next done))
        ((eq 'false p) (profail nil next))
        (t (findcallfail p al depth stack next done))))

(defun findnotconst (p al depth stack next done)
  (cond ((eq 'true p) (profail nil next))
        ((eq 'cut p) (profail nil next))
        ((eq 'false p) (proexit next done))
        (t (findcallfail `(not ,p) al depth stack next done))))


(defun findand (p al depth stack next done)
  (cond ((null (cdr p)) (proexit next done))
        (t (findands next (cdr p) al depth stack done))))

(defun findands (ans pl al depth stack done)
  (cond ((null pl) (proexit ans done))
        ((eq 'cut (car pl))
         (findands `(procut ,depth ,ans) (cdr pl) al depth stack done))
        (t (finddepth (car pl) al depth stack
                      ans `(findands ,(cdr pl) ,al ,depth ,stack ,done)))))

(defun procut (ans depth next)
  (cond (ans (profail ans next))
        (t (profail (1- depth) next))))

(defun findandnot (p al depth stack next done)
  (cond ((null (cdr p)) (proexit next done))
        (t (finddepth `(not ,(cadr p)) al depth stack
                      next `(findandnots ,(cddr p) ,al ,depth ,stack ,done)))))

(defun findandnots (ans pl al depth stack done)
  (cond ((null pl) (proexit ans done))
        ((eq 'cut (car pl))
         (findandnots `(procut ,ans ,done) (cdr pl) al depth stack done))
        (t (finddepth `(not ,(car pl)) al depth stack
                      ans `(findandnots ,(cdr pl) ,al ,depth ,stack ,done)))))

(defun findor (p al depth stack next done)
  (findors nil (cdr p) al depth stack next done))

(defun findors (ans pl al depth stack next done)
  (cond ((not (null ans)) (profail ans next))
        ((null pl) (profail nil next))
        (t (finddepth (car pl) al depth stack
                      `(findors ,(cdr pl) ,al ,depth ,stack ,next ,done) done))))

(defun findornot (p al depth stack next done)
  (findornots nil (cdr p) al depth stack next done))

(defun findornots (ans pl al depth stack next done)
  (cond ((not (null ans)) (profail ans next))
        ((null pl) (profail nil next))
        (t (finddepth `(not ,(car pl)) al depth stack
                      `(findornots ,(cdr pl) ,al ,depth ,stack ,next ,done) done))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Same is equals but succeeds only on unifiable terms.
;;; Distinct is true of all pairs of objects
;;; but epilog succeeds only in those cases where the arguments are different
;;; This is why there is no (not (distinct <x> <y>))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun findoneof (p al next done)
  (findoneofnext nil (cadr p) (cddr p) al nil next done))

(defun findoneofnext (ans x xl al ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null xl) (profail nil next))
        ((setq ol (unify x al (car xl) al))
         (proexit `(findoneofnext ,x ,(cdr xl) ,al ,ol ,next ,done) done))
        (t (findoneofnext nil x (cdr xl) al nil next done))))
          

(defun findsame (p al next done)
  (let ((ol))
    (cond ((setq ol (unify (caddr p) al (cadr p) al))
           (proexit `(findvaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun finddistinct (p al next done)
  (let ((ol))
    (cond ((setq ol (unify (caddr p) al (cadr p) al))
           (backup ol) (profail nil next))
          (t (proexit next done)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Note that both primitive and nonprimitive are true of all objects
;;; but Epilog succeeds only on terms that are primitive or nonprimitive.
;;; This is why (nonprimitive <x>) is not (not (primitive <x>))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun findground (p al next done)
  (if (chkgroundp (cadr p) al) (proexit next done) (profail nil next)))

(defun findnonground (p al next done)
  (if (chkgroundp (cadr p) al) (profail nil next) (proexit next done)))

(defun findprimitive (p al next done)
  (if (chkprimitivep (cadr p) al) (proexit next done) (profail nil next)))

(defun findnonprimitive (p al next done)
  (if (chkprimitivep (cadr p) al) (profail nil next) (proexit next done)))

(defun chkgroundp (x al)
  (cond ((indvarp x)
         (cond ((null (cddr (setq x (getbdg x al)))) nil)
               ((chkgroundp (cadr x) (cddr x)))))
        ((atom x))
	((eq 'quote (car x)))
        (t (chkgroundcdr (cdr x) al))))

(defun chkgroundcdr (x al)
  (do ((l x (cdr l)) (ans))
      ((null l) t)
      (cond ((seqvarp (car l))
             (cond ((null (cddr (setq ans (getbdg (car l) al)))) (return nil))
                   ((chkgroundcdr (cadr ans) (cddr ans)))
                   (t (return nil))))
            ((chkgroundp (car l) al))
            (t (return nil)))))

(defun chkprimitivep (x al)
  (cond ((indvarp x)
         (cond ((null (cddr (setq x (getbdg x al)))))
               ((chkprimitivep (cadr x) (cddr x)))))
        ((atom x) (cond ((numberp x))
                        ((stringp x))
                        ((characterp x))
                        ((eq 'pi x) nil)
                        ((not (listp *names*)))
                        ((member x *names* :test #'eq) t)))
	((eq 'quote (car x)))
        ((eq 'listof (car x)) (chkprimitivepcdr (cdr x) al))
        ((get (car x) 'basicval) nil)
        ((not (listp *functionals*)) (chkprimitivepcdr (cdr x) al))
        ((member (car x) *functionals* :test #'eq)
         (chkprimitivepcdr (cdr x) al))))

(defun chkprimitivepcdr (x al)
  (do ((l x (cdr l)) (ans))
      ((null l) t)
      (cond ((seqvarp (car l))
             (cond ((null (cddr (setq ans (getbdg (car l) al)))))
                   ((chkprimitivepcdr (cadr ans) (cddr ans)))
                   (t (return nil))))
            ((chkprimitivep (car l) al))
            (t (return nil)))))

(defun findunprovable (p al next done)
  (cond ((findp (plugstdexp p al) *theory*) (profail nil next))
        (t (proexit next done))))

(defun findunknown (p al next done)
  (cond ((knownp (plugstdexp p al) *theory*) (profail nil next))
        (t (proexit next done))))

(defparameter *intensions* nil)

(defun intensionp (r th)
  (cond (*intensions*)
        ((find r (intensions th)))
        (t (some #'(lambda (x) (intensionp r x)) (includees th)))))

(defun extensionp (r th)
  (cond ((find r (extensions th)))
        (t (some #'(lambda (x) (extensionp r x)) (includees th)))))

(defun extensionalp (p al)
  (and (find (car p) (extensions *theory*)) (chkprimitivepcdr (cdr p) al)))

(defun intensionalp (p al)
  (and (find (car p) (intensions *theory*)) (chkprimitivepcdr (cdr p) al)))

(defun findchoose (p al next done)
  (let (x ol)
    (setq p (plugstdexp p al))
    (setq x (findx (cadr p) (caddr p) *theory*))
    (if (and (not (null x)) (setq ol (unify (cadr p) alist x alist)))
        (proexit `(findvaluenext ,ol ,next) done)
        (profail nil next))))

(defun findbagofall (p al next done)
  (findvalue `(value ,(butlast p) ,(cadddr p)) al next done))

(defun findnotbagofall (p al next done)
  (findnotvalue `(value ,(butlast p) ,(cadddr p)) al next done))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Not clear whether it should go on to database in case of nongroundprimitive.
;;; basic goes on; value does not.  This is weird.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun findvalue (p al next done)
  (let ((x (findbasicval (cadr p) al)) (y (caddr p)) (ol))
    (if (and (not (null x)) (setq ol (unify y al x al)))
        (proexit `(findvaluenext ,ol ,next) done)
        (profail nil next))))

(defun findvaluenext (ans ol next)
  (backup ol)
  (profail ans next))

(defun findnotvalue (p al next done)
  (let ((x (findbasicval (cadr p) al)) (y (caddr p)) (ol))
    (cond ((null x) (profail nil next))
          ((setq ol (unify y al x al)) (backup ol) (profail nil next))
          (t (proexit next done)))))

(defun findstringmatch (p al next done)
  (let (pat str dum ol)
    (cond ((and (setq pat (groundplugstdexp (cadr p) al)) (primitivep pat)
                (setq str (groundplugstdexp (caddr p) al)) (primitivep str)
                (car (setq dum (multiple-value-list (strmatches pat str))))
                (setq ol (unify (cdddr p) al (cdr dum) al)))
               (proexit `(findvaluenext ,ol ,next) done))
          (t (profail nil next)))))

;;; needless inefficiency here.  Just needs to check atom and car.

(defun findbasicval (x al)
  (let (dum)
    (cond ((null (setq dum (plugstdexp x al))) nil)
          ((atom dum) (if (and (groundp dum) (primitivep dum)) dum))
          ((eq 'execute (car dum))
           (multiple-value-setq (x dum)
             (ignore-errors (values (eval (cadr dum)))))
           (unless dum (quotify x)))
          ((eq 'evaluate (car dum))
           (multiple-value-setq (x dum)
             (ignore-errors (values (apply (caadr dum) (cdadr dum)))))
           (unless dum (quotify x)))
          ((eq 'choose (car dum))
           (findx (cadr dum) (caddr dum) *theory*))
          ((eq 'bagofall (car dum))
           (cons 'listof (finds (cadr dum) (caddr dum) *theory*)))
          ((and (get (car dum) 'basicval)
                (every 'primitivep (cdr dum))
                (groundp dum))
           (funcall (get (car dum) 'basicval) dum))
          ((and (groundp dum) (primitivep dum)) dum))))

(defun findexecute (p al next done)
  (let (arg values ol)
    (setq arg (plugstdexp (cadr p) al))
    (cond ((null (cddr p)) (findvalue `(value ,p 't) al next done))
          ((and (car (setq values (ignore-errors (multiple-value-list (eval arg)))))
                (setq ol (unify (cddr p) al (mapcar #'quotify values) alist)))
           (proexit `(findvaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun findnotexecute (p al next done)
  (let (arg values ol)
    (setq arg (plugstdexp (cadr p) al))
    (cond ((null (cddr p)) (findnotvalue `(value ,p 't) al next done))
          ((and (car (setq values (ignore-errors (multiple-value-list (eval arg)))))
                (setq ol (unify (cddr p) al (mapcar #'quotify values) alist)))
           (backup ol)
           (profail nil next))
          (t (proexit next done)))))

(defun findevaluate (p al next done)
  (let (arg values ol)
    (setq arg (plugstdexp (cadr p) al))
    (cond ((null (cddr p)) (findvalue `(value ,p t) al next done))
          ((and (car (setq values (evals arg)))
                (setq ol (unify (cddr p) al values alist)))
           (proexit `(findvaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun findnotevaluate (p al next done)
  (let (arg values ol)
    (setq arg (plugstdexp (cadr p) al))
    (cond ((null (cddr p)) (findnotvalue `(value ,p t) al next done))
          ((and (car (setq values (ignore-errors (multiple-value-list (apply (car arg) (cdr arg))))))
                (setq ol (unify (cddr p) al values alist)))
           (backup ol)
           (profail nil next))
          (t (proexit next done)))))

(defun findbasic (p al depth stack next done)
  (let (ans)
    (cond ((and (setq ans (groundplugstdexp p al))
                (every #'primitivep (cdr ans)))
           (if (apply (get (car ans) 'basic) (cdr ans))
               (proexit next done)
               (profail nil next)))
          (t (findcallfail p al depth stack next done)))))

(defun findbasicvalue (p al depth stack next done)
  (let ((x (butlast p)) (y (car (last p))) (ol))
    (cond ((and (setq x (groundplugstdexp x al)) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))
           (if (and (not (null x)) (setq ol (unify y al x al)))
               (proexit `(findvaluenext ,ol ,next) done)
               (profail nil next)))
          (t (findcallfail p al depth stack next done)))))

(defun findnotbasic (p al depth stack next done)
  (let (ans)
    (cond ((and (setq ans (groundplugstdexp p al))
                (every #'primitivep (cdr ans)))
           (if (not (apply (get (car ans) 'basic) (cdr ans)))
               (proexit next done)
               (profail nil next)))
          (t (findcallfail `(not ,p) al depth stack next done)))))

(defun findnotbasicvalue (p al depth stack next done)
  (let ((x (butlast p)) (y (car (last p))) (ol))
    (cond ((and (setq x (groundplugstdexp x al)) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))
           (cond ((null x) (profail nil next))
                 ((setq ol (unify y al x al)) (backup ol) (profail nil next))
                 (t (proexit next done))))
          (t (findcallfail `(not ,p) al depth stack next done)))))


(defun findcallfail (p al depth stack next done)
  (findrs p al depth stack `(findcallfailnext ,depth ,next) done))

(defun findcallfailnext (ans depth next)
  (cond ((null ans) (profail nil next))
        ((eql ans depth) (profail nil next))
        (t (profail ans next))))

(defun findrs (p al depth stack next done)
  (cond ((and *ancestry* (findancestor p al stack)) (profail nil next))
        (*reduction* ;;; (and *reduction* (or (atom p) (not (eq 'not (car p)))))
         (findrsloop nil p al depth stack stack nil next done))
        (t (finddb p al depth stack *theory* next done))))

(defun findancestor (p al stack)
  (do ((l stack (cdr l)))
      ((null l) nil)
      (if (identify (caar l) (cdar l) p al) (return t))))

(defun findrsloop (ans p al depth stack sl ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null sl) (finddb p al depth stack *theory* next done))
        ((setq ol (unify (maknot (caar sl)) (cdar sl) p al))
         (proexit `(findrsloop ,p ,al ,depth ,stack ,(cdr sl) ,ol ,next ,done)
                  done))
        (t (findrsloop nil p al depth stack (cdr sl) ol next done))))

(defun finddb (p al depth stack th next done)
  (findth p al depth stack th
          `(finddbs ,p ,al ,depth ,stack ,(includees th) ,next ,done) done))

(defun finddbs (ans p al depth stack tl next done)
  (cond ((not (null ans)) (profail ans next))
        ((null tl) (profail nil next))
        (t (finddb p al depth stack (car tl)
                   `(finddbs ,p ,al ,depth ,stack ,(cdr tl) ,next ,done) done))))

(defun findth (p al depth stack th next done)
 (findths nil p al depth stack (envindexps p al th) (environment) nil next done))

;;; ground test in rule case would save work but it is expensive.
;;; note that subset test not good in rule case cause subgoals may bind vars.
;;; we should allow *saves* to work here when caching problem solved.
;;; note that the subolp check is very narrow
;;; note that the subolp action terminates in this theory only!  should cut.

(defun findths (ans p al depth stack fl bl ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null fl) (profail nil next))
        ((and (listp (car fl)) (eq (caar fl) '<=))
         (cond ((setq ol (unify (cadar fl) bl p al))
                (setq next `(findths ,p ,al ,depth ,stack ,(cdr fl) ,bl ,ol ,next ,done))
                (cond (*ancestry* (setq stack (acons p al stack)))
                      (*reduction* ;;; (not (atom p)) (eq 'not (car p)))
                       (setq stack (acons p al stack))))
                (findand (cons 'and (cddar fl)) bl (1+ depth) stack next done))
               (t (findths nil p al depth stack (cdr fl) bl ol next done))))
        ((setq ol (unify (car fl) bl p al))
         (if (not (subolp ol (alist bl)))
             (setq next `(findths ,p ,al ,depth ,stack ,(cdr fl) ,bl ,ol ,next ,done)))
         (proexit next done))
        (t (findths nil p al depth stack (cdr fl) bl nil next done))))

(defun subolp (l1 l2)
  (do ((l l1 (cdr l)))
      ((null (cdr l)) t)
      (if (not (member (car l) l2 :test #'eq)) (return nil))))


(defun failure (&rest l)
  (declare (ignore l))
  nil)

(defun proexit (next done)
  (if traceexpressions (setq next `(protraceredo ,next ,done)))
  (if done (apply (car done) next (cdr done)) next))

(defun profail (ans next)
  (if next (apply (car next) ans (cdr next))))

(defun procall (ans next)
  (declare (ignore ans))
  (if next (apply (car next) (cdr next))))

(defun protracecall (p al done)
  (setq p (plugstdexp p al))
  (when (memp p traceexpressions 'instp)
        (tracemessage level '|Call: | p)
        (setq tracecalls (acons done p tracecalls))
        (setq level (1+ level))))

(defun protraceexit (ans done)
  (let (dum)
    (when (setq dum (assoc done tracecalls :test #'eq))
      (setq level (1- level))
      (tracemessage level '|Exit: | (plugstdexp (cdr dum) alist)))
    (proexit ans done)))

(defun protraceredo (ans next done)
  (let (dum)
    (when (setq dum (assoc done tracecalls :test #'eq))
      (tracemessage level '|Redo: | (cdr dum))
      (setq level (1+ level)))
    (profail ans next)))

(defun protracefail (ans next done)
  (let (dum)
    (when (setq dum (assoc done tracecalls :test #'eq))
      (setq tracecalls (cdr tracecalls))
      (setq level (1- level))
      (tracemessage level '|Fail: | (cdr dum)))
    (profail ans next)))


(defparameter *trace-device* t
 "*TRACE-DEVICE* is the device to which inference trace information is
  printed.  The default is T, which directs all inference routines to print
  traces on the terminal.")

(defvar traceexpressions nil)

(defvar tracefacts nil)

(defvar tracecalls nil)

(defmethod trace-expression (&rest l)
 "(TRACE-EXPRESSION &REST l)
  TRACE-EXPRESSION takes any number of expressions as arguments.  It sets up 
  data structures so that various proof procedures print out appropriate
  messages whenever they examine expressions that are instances of the specified
  expressions.  If no arguments are passed to TRACE-EXPRESSION, the result is a 
  list of currently traced expressions.  Otherwise, the value is DONE."
  (cond ((null l) traceexpressions)
	(t (mapc 'traceexp l)
           t)))

(defun traceexp (x)
  (if (not (memp x traceexpressions 'samep))
      (setq traceexpressions (cons x traceexpressions))))

(defmethod untrace-expression (&rest l)
 "(UNTRACE-EXPRESSION &REST l)
  UNTRACE-EXPRESSION takes any number of expressions as arguments.  It eliminates
  the specified expressions from the data structures set up by TRACE-EXPRESSION
  and thus turns off the corresponding tracing.  If no arguments are passed to 
  UNTRACE-EXPRESSION, all traced expressions are deleted, and a list of the those 
  expressions is returned as value.  Otherwise, the value is DONE."
  (cond ((null l) (mapc 'untraceexp traceexpressions))
	(t (mapc 'untraceexp l)))
  t)

(defun untraceexp (x)
  (setq traceexpressions (delone x traceexpressions 'samep)))

(defmethod trace-fact (&rest l)
 "(TRACE-FACT &REST l)
  TRACE-FACT takes any number of expressions as arguments.  It sets up 
  data structures so that various proof procedures print out appropriate
  messages whenever they use database facts that are instances of the specified
  expressions.  If no arguments are passed to TRACE-FACT, the result is a 
  list of currently traced expressions.  Otherwise, the value is DONE."
  (cond ((null l) tracefacts)
	(t (mapc 'tracefactoid l)
           t)))

(defun tracefactoid (x)
  (if (not (memp x tracefacts 'samep))
      (setq tracefacts (cons x tracefacts))))

(defmethod untrace-fact (&rest l)
 "(UNTRACE-FACT &REST l)
  UNTRACE-FACT takes any number of expressions as arguments.  It eliminates
  the specified expressions from the data structures set up by TRACE-FACT
  and thus turns off the corresponding tracing.  If no arguments are passed to 
  UNTRACE-FACT, all traced expressions are deleted, and a list of the those 
  expressions is returned as value.  Otherwise, the value is DONE."
  (cond ((null l) (mapc 'untracefact tracefacts))
	(t (mapc 'untracefact l)))
  t)

(defun untracefact (x)
  (setq tracefacts (delone x tracefacts 'samep)))

(defun tracesave (p al)
  (setq p (plugstdexp p al))
  (when (memp p traceexpressions 'instp)
        (tracemessage level '|Save: | p)
        (setq level (1+ level))))

(defun tracedrop (p al)
  (setq p (plugstdexp p al))
  (when (memp p traceexpressions 'instp)
        (tracemessage level '|Drop: | p)
        (setq level (1+ level))))

(defun tracedone (p al)
  (setq p (plugstdexp p al))
  (when (memp p traceexpressions 'instp)
        (setq level (1- level))
        (tracemessage level '|Done: | p)))

(defun tracefact (x)
  (when (memp x tracefacts 'instp)
        (tracemessage level "Fact: " x)))

(defun tracemessage (n pr p)
  (fresh-line *trace-device*)
  (tracespaces n) (princ pr *trace-device*) (princ p *trace-device*))

(defun tracespaces (n)
  (do ((i 1 (1+ i)))
      ((> i n))
      (princ " | " *trace-device*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; uniquify
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *uniquify* 'macintoshway)
(defparameter *uniquify* 'safeway)

(defun uniquificate (ol)
  (uniquify (copy-list ol)))

(defun uniquify (ol)
  (cond ((eq 'safeway *uniquify*) (safeway ol))
        ((eq 'fastway *uniquify*) (fastway ol))
        ((eq 'hash *uniquify*) (hashway ol))
        (*uniquify* (remove-duplicates ol :test #'equalp))
        (t ol)))

(defun safeway (ol)
  (do ((l ol (cdr l)) (i 1 (1+ i)))
      ((null l))
      (rplaca l (cons (car l) i)))
  (setq ol (sort ol #'leqp))
  (do ((l ol))
      ((null (cdr l)) ol)
      (cond ((equalp (caar l) (caadr l)) (rplacd l (cddr l)))
            (t (setq l (cdr l)))))
  (setq ol (sort ol #'< :key #'cdr))
  (do ((l ol (cdr l)) (i 1 (1+ i)))
      ((null l) ol)
      (rplaca l (caar l))))

(defun hashway (ol)
  (cond ((null ol) ol)
        (t (let ((table (make-hash-table :test #'equal :size (length ol))))
             (setf (gethash (car ol) table) t)
             (do ((l ol) )
                 ((null (cdr l)) ol)
                 (cond ((gethash (cadr l) table) (rplacd l (cddr l)))
                       (t (setf (gethash (cadr l) table) t) (setq l (cdr l)))))))))

(defun fastway (ol)
  (setq ol (sort ol #'leqp))
  (do ((l ol))
      ((null (cdr l)) ol)
      (cond ((equalp (car l) (cadr l)) (rplacd l (cddr l)))
            (t (setq l (cdr l))))))

(defun leqp (x y)
  (find (compare x y) '(lt eq)))

(defun geqp (x y)
  (find (compare x y) '(gt eq)))

(defun compare (x y)
  (cond ((atom x)
         (cond ((atom y) (compareatoms x y))
               (t 'lt)))
        ((atom y) 'gt)
        (t (do ((l x (cdr l)) (m y (cdr m)) (dum))
               ((atom l) (if (atom m) (compareatoms l m) 'lt))
               (cond ((null m) (return 'gt))
                     ((eq 'eq (setq dum (compare (car l) (car m)))))
                     (t (return dum)))))))

(defun compareatoms (x y)
  (cond ((equalp x y) 'eq)
        ((numberp x) (if (and (numberp y) (> x y)) 'gt 'lt))
        ((or (characterp x) (stringp x) (symbolp x))
         (cond ((numberp y) 'gt)
               ((or (characterp y) (stringp y) (symbolp y))
                (if (string< x y) 'lt 'gt))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; reduction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special *theory* *filter* *test*
                      *start* *increment* *depth* *termination*
                      alist level tracecalls tracefacts traceexpressions)))

(defparameter *consistency* t)

(defmethod reductions (p *theory* &optional (*filter* #'basep) (*test* #'success))
  (let ((alist (environment)) (*reduction*) (level 0) tracecalls)
    (setq *termination* nil *inferences* 0 *unifications* 0)
    (setq p (list p '@l))
    (do ((next (reductiondepth p alist 1 nil '(failure) '(success)) (profail nil next))
         (rule) (nl))
        ((null next) (nreverse nl))
        (setq rule (plugstdexp `(<= ,p . ,(nreverse *reduction*)) alist))
        (if (every #'(lambda (x) (funcall *test* x)) (cddr rule))
            (setq nl (adjoin rule nl :test #'equal))))))

(defmethod nonreductions (p *theory* &optional (*filter* #'basep) (*test* #'success))
  (let ((alist (environment)) (*reduction*) (level 0) tracecalls)
    (setq *termination* nil *inferences* 0 *unifications* 0)
    (setq p `(not ,(list p '@l)))
    (do ((next (reductiondepth p alist 1 nil '(failure) '(success)) (profail nil next))
         (rule) (nl))
        ((null next) (nreverse nl))
        (setq rule (plugstdexp `(<= ,p . ,(nreverse *reduction*)) alist))
        (if (every #'(lambda (x) (funcall *test* x)) (cddr rule))
            (setq nl (adjoin rule nl :test #'equal))))))

(defun reductiondepth (p al depth stack next done)
  (setq *inferences* (1+ *inferences*))
  (cond ((numgreaterp depth *depth*) (setq *termination* t) (profail nil next))
        ((and traceexpressions
              (protracecall p al done)
              (setq next `(protracefail ,next ,done))
              (setq done `(protraceexit ,done)) nil))
        (t (reductionexp p al depth stack next done))))

(defun reductionexp (p al depth stack next done)
  (cond ((atom p) (reductionconst p al depth stack next done))
        ((eq 'not (car p)) (reductionnotexp (cadr p) al depth stack next done))
        ((eq 'and (car p)) (reductionand p al depth stack next done))
        ((eq 'or (car p)) (reductionor p al depth stack next done))
	((eq 'oneof (car p)) (reductionassumption nil p al next done))
	((eq 'same (car p)) (reductionsame p al next done))
	((eq 'distinct (car p)) (reductiondistinct p al next done))
	((eq 'ground (car p)) (reductionground p al next done))
	((eq 'nonground (car p)) (reductionnonground p al next done))
	((eq 'primitive (car p)) (reductionprimitive p al next done))
	((eq 'nonprimitive (car p)) (reductionnonprimitive p al next done))
	((eq '== (car p)) (reductionvalue p al next done))
	((eq 'value (car p)) (reductionvalue p al next done))
	((eq 'execute (car p)) (reductionassumption nil p al next done))
	((eq 'evaluate (car p)) (reductionassumption nil p al next done))
	((eq 'unprovable (car p)) (reductionunprovable p al next done))
	((eq 'bagofall (car p)) (reductionbagofall p al next done))
	((eq 'stringmatch (car p)) (reductionstringmatch p al next done))
	((get (car p) 'basicval) (reductionbasicvalue p al next done))
	((get (car p) 'basic) (reductionbasic p al next done))
	(t (reductioncallfail p al depth stack next done))))

(defun reductionnotexp (p al depth stack next done)
  (cond ((atom p) (reductionnotconst p al depth stack next done))
        ((eq 'not (car p)) (reductiondepth (cadr p) al depth stack next done))
        ((eq 'and (car p)) (reductionornot p al depth stack next done))
        ((eq 'or (car p)) (reductionandnot p al depth stack next done))
	((eq 'oneof (car p)) (profail nil next))
	((eq 'same (car p)) (profail nil next))
	((eq 'distinct (car p)) (profail nil next))
	((eq 'ground (car p)) (profail nil next))
	((eq 'nonground (car p)) (profail nil next))
	((eq 'primitive (car p)) (profail nil next))
	((eq 'nonprimitive (car p)) (profail nil next))
	((eq '== (car p)) (reductionnotvalue p al next done))
	((eq 'value (car p)) (reductionnotvalue p al next done))
	((eq 'execute (car p)) (reductionassumption nil `(not ,p) al next done))
	((eq 'evaluate (car p)) (reductionassumption nil `(not ,p) al next done))
	((eq 'unprovable (car p)) (reductionexp (cadr p) al depth stack next done))
	((eq 'bagofall (car p)) (reductionnotbagofall p al next done))
	((eq 'stringmatch (car p)) (profail nil next))
        ((get (car p) 'basicval) (reductionnotbasicvalue p al next done))
        ((get (car p) 'basic) (reductionnotbasic p al next done))
        ((intensionp (car p) *theory*) (reductionunprovable `(not ,p) al next done))
        (t (reductioncallfail `(not ,p) al depth stack next done))))

(defun reductionconst (p al depth stack next done)
  (cond ((eq 'true p) (proexit next done))
        ((eq 'cut p) (proexit next done))
        ((eq 'false p) (profail nil next))
        (t (reductioncallfail p al depth stack next done))))

(defun reductionnotconst (p al depth stack next done)
  (cond ((eq 'true p) (profail nil next))
        ((eq 'cut p) (profail nil next))
        ((eq 'false p) (proexit next done))
        (t (reductioncallfail `(not ,p) al depth stack next done))))


(defun reductionand (p al depth stack next done)
  (cond ((null (cdr p)) (proexit next done))
        (t (reductionands next (cdr p) al depth stack done))))

(defun reductionands (ans pl al depth stack done)
  (cond ((null pl) (proexit ans done))
        ((eq 'cut (car pl))
         (reductionands `(procut ,depth ,ans) (cdr pl) al depth stack done))
        (t (reductiondepth (car pl) al depth stack
                      ans `(reductionands ,(cdr pl) ,al ,depth ,stack ,done)))))

(defun reductionandnot (p al depth stack next done)
  (cond ((null (cdr p)) (proexit next done))
        (t (reductiondepth `(not ,(cadr p)) al depth stack
                      next `(reductionandnots ,(cddr p) ,al ,depth ,stack ,done)))))

(defun reductionandnots (ans pl al depth stack done)
  (cond ((null pl) (proexit ans done))
        ((eq 'cut (car pl))
         (reductionandnots `(procut ,ans ,done) (cdr pl) al depth stack done))
        (t (reductiondepth `(not ,(car pl)) al depth stack
                      ans `(reductionandnots ,(cdr pl) ,al ,depth ,stack ,done)))))

(defun reductionor (p al depth stack next done)
  (reductionors nil (cdr p) al depth stack next done))

(defun reductionors (ans pl al depth stack next done)
  (cond ((not (null ans)) (profail ans next))
        ((null pl) (profail nil next))
        (t (reductiondepth (car pl) al depth stack
                      `(reductionors ,(cdr pl) ,al ,depth ,stack ,next ,done) done))))

(defun reductionornot (p al depth stack next done)
  (reductionornots nil (cdr p) al depth stack next done))

(defun reductionornots (ans pl al depth stack next done)
  (cond ((not (null ans)) (profail ans next))
        ((null pl) (profail nil next))
        (t (reductiondepth `(not ,(car pl)) al depth stack
                      `(reductionornots ,(cdr pl) ,al ,depth ,stack ,next ,done) done))))

(defun reductionassumption (ans p al next done)
  (cond (ans (profail next done))
        ((setq p (assumablep p al))
         (reductionassume p next done))
        (t (profail nil next))))

(defun reductionassume (p next done)
  (cond ((or (not *consistency*)
             (not (or (rebuttalp p *reduction*) (rebuttheoryp p *theory*)))
             (consistentp p *reduction*))
         (setq *reduction* (cons p *reduction*))
         (proexit `(reductionnext ,next) done))
        (t (profail nil next))))

(defun reductionnext (ans next)
  (setq *reduction* (cdr *reduction*))
  (profail ans next))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Note that both primitive and nonprimitive are true of all objects
;;; but Epilog succeeds only on terms that are primitive or nonprimitive.
;;; This is why (nonprimitive <x>) is not (not (primitive <x>))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun reductionground (p al next done)
  (cond ((chkgroundp (cadr p) al) (proexit next done))
        (t (reductionassumption nil p al next done))))

(defun reductionnonground (p al next done)
  (cond ((chkgroundp (cadr p) al) (profail nil next))
        (t (reductionassumption nil p al next done))))

(defun reductionprimitive (p al next done)
  (cond ((chkprimitivep (cadr p) al)
         (if (chkgroundp (cadr p) al) (proexit next done)
             (reductionassumption nil p al next done)))
        (t (profail nil next))))

(defun reductionnonprimitive (p al next done)
  (cond ((chkprimitivep (cadr p) al) (profail nil next))
        (t (proexit next done))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Same is equals but succeeds only on unifiable terms.
;;; Distinct is true of all pairs of objects
;;; but epilog succeeds only in those cases where the arguments are different
;;; This is why there is no (not (distinct <x> <y>))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun reductionsame (p al next done)
  (let ((ol))
    (cond ((setq ol (unify (caddr p) al (cadr p) al))
           (proexit `(reductionvaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun reductiondistinct (p al next done)
  (let ((ol))
    (cond ((setq ol (unify (caddr p) al (cadr p) al))
           (backup ol)
           (if (cdr ol) (reductionassumption nil p al next done)
               (profail nil next)))
          (t (proexit next done)))))


(defun reductionvalue (p al next done)
  (let ((x (reductionbasicval (cadr p) al)) (y (caddr p)) (ol))
    (cond ((or (null x) (not (chkprimitivep y al)))
           (reductionassumption nil p al next done))
          ((setq ol (unify y al x al))
           (proexit `(reductionvaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun reductionvaluenext (ans ol next)
  (backup ol)
  (profail ans next))

(defun reductionnotvalue (p al next done)
  (let ((x (reductionbasicval (cadr p) al)) (y (caddr p)) (ol))
    (cond ((null x) (reductionassumption nil `(not ,p) al next done))
          ((setq ol (unify y al x al)) (backup ol) (profail nil next))
          (t (proexit next done)))))

;;; needless inefficiency here.  Just needs to check atom and car.

(defun reductionbasicval (x al)
  (setq x (plugstdexp x al))
  (cond ((atom x) (if (and (groundp x) (primitivep x)) x))
        ((eq 'execute (car x)) nil)
        ((eq 'evaluate (car x)) nil)
        ((and (get (car x) 'basicval)
              (groundp x)
              (every #'primitivep (cdr x)))
         (funcall (get (car x) 'basicval) x))
        ((and (groundp x) (primitivep x)) x)))

(defun reductionunprovable (p al next done)
  (let (rl)
    (setq p (plugstdexp (cadr p) al))
    (setq rl (residues t p *theory* *filter* *test*))
    (cond ((null rl) (proexit next done))
          ((eq 'true (maksor rl)) (profail nil next))
          (t (reductionassume `(unprovable ,(maksor rl)) next done)))))

(defun reductionbagofall (p al next done)
  (let (rl)
    (setq p (plugstdexp p al))
    (setq rl (residues (cadr p) (caddr p) *theory* *filter* *test*))
    (cond ((null rl) (profail nil next))
          ((eq 'true (maksor rl)) (proexit next done))
          (t  (setq *reduction* (cons `(bagofall ,(cadr p) ,(maksor rl) ,(cadddr p)) *reduction*))
              (proexit `(reductionnext ,next) done)))))

(defun reductionnotbagofall (p al next done)
  (let (rl)
    (setq p (plugstdexp p al))
    (setq rl (residues (cadr p) (caddr p) *theory* *filter* *test*))
    (cond ((null rl) (profail nil next))
          ((eq 'true (maksor rl)) (proexit next done))
          (t (reductionassume `(not (bagofall ,(cadr p) ,(maksor rl) ,(cadddr p))) next done)))))

(defun reductionstringmatch (p al next done)
  (let (pat str dum ol)
    (cond ((and (setq pat (groundplugstdexp (cadr p) al)) (primitivep pat)
                (setq str (groundplugstdexp (caddr p) al)) (primitivep str))
           (if (and (car (setq dum (multiple-value-list (strmatches pat str))))
                    (setq ol (unify (cdddr p) al (cdr dum) al)))
               (proexit `(findvaluenext ,ol ,next) done)
               (profail nil next)))
          (t (reductionassumption nil p al next done)))))

(defun reductionbasicvalue (p al next done)
  (let ((x (butlast p)) (y (car (last p))) (ol))
    (cond ((and (setq x (groundplugstdexp x al)) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))
           (if (and (not (null x)) (setq ol (unify y al x al)))
               (proexit `(reductionvaluenext ,ol ,next) done)
               (profail nil next)))
          (t (reductionassumption nil p al next done)))))

(defun reductionbasic (p al next done)
  (let (ans)
    (cond ((and (setq ans (groundplugstdexp p al))
                (every 'primitivep (cdr ans)))
           (if (apply (get (car ans) 'basic) (cdr ans))
               (proexit next done)
               (profail nil next)))
          (t (reductionassumption nil p al next done)))))

(defun reductionnotbasicvalue (p al next done)
  (let ((x (butlast p)) (y (car (last p))) (ol))
    (cond ((and (setq x (groundplugstdexp x al)) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))
           (cond ((null x) (profail nil next))
                 ((setq ol (unify y al x al)) (backup ol) (profail nil next))
                 (t (proexit next done))))
          (t (reductionassumption nil `(not ,p) al next done)))))

(defun reductionnotbasic (p al next done)
  (let (ans)
    (cond ((and (setq ans (groundplugstdexp p al))
                (every #'primitivep (cdr ans)))
           (if (not (apply (get (car ans) 'basic) (cdr ans)))
               (proexit next done)
               (profail nil next)))
          (t (reductionassumption nil `(not ,p) al next done)))))


(defun reductioncallfail (p al depth stack next done)
  (let (dum)
    (cond ((funcall *filter* (operator p))
           (cond ((and (groundishp (setq dum (plugstdexp p al)))
                       (knownp dum *theory*))
                  (proexit next done))
                 ((funcall *test* (setq dum (plugstdexp p al)))
                  (reductionassume dum next done))
                 (t (profail nil next))))
          (t (reductionrs p al depth stack
                        `(reductioncallfailnext ,depth ,next) done)))))

(defun reductioncallfailnext (ans depth next)
  (cond ((null ans) (profail nil next))
        ((eql ans depth) (profail nil next))
        (t (profail ans next))))

(defun reductionrs (p al depth stack next done)
  (cond ((and *ancestry* (reductionancestor p al stack next done)))
        ((and (numberp *ancestry*) (reductionnumber p al stack 0))
         (reductionassumption nil p al next done))
        (*reduction* ;;; (or (atom p) (not (eq 'not (car p)))))
         (reductionrsloop nil p al depth stack stack nil next done))
        (t (reductiondb p al depth stack *theory* next done))))

(defun reductionnumber (p al stack n)
  (let (ol)
    (cond ((numgeqp n *ancestry*))
          ((null stack) nil)
          ((atom p)
           (reductionnumber p al (cdr stack) (if (eq p (caar stack)) (1+ n) n)))
          ((setq ol (unify p al (caar stack) (cdar stack)))
           (prog1 (reductionnumber p al (cdr stack) (1+ n)) (backup ol)))
          (t (reductionnumber p al (cdr stack) n)))))

(defun reductionancestor (p al stack next done)
  (do ((l stack (cdr l)))
      ((null l) nil)
      (cond ((identify (caar l) (cdar l) p al) (return (profail nil next)))
            ((eq (operator (caar l)) (operator p))
             (setq p (plugstdexp p al))
             (setq *reduction* (cons p *reduction*))
             (return (proexit `(residuenext ,next) done))))))

(defun reductionrsloop (ans p al depth stack sl ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null sl) (reductiondb p al depth stack *theory* next done))
        ((setq ol (unify (maknot (caar sl)) (cdar sl) p al))
         (proexit `(reductionrsloop ,p ,al ,depth ,stack ,(cdr sl) ,ol ,next ,done)
                  done))
        (t (reductionrsloop nil p al depth stack (cdr sl) ol next done))))

(defun reductiondb (p al depth stack th next done)
  (reductionth p al depth stack th
          `(reductiondbs ,p ,al ,depth ,stack ,(includees th) ,next ,done) done))

(defun reductiondbs (ans p al depth stack tl next done)
  (cond ((not (null ans)) (profail ans next))
        ((null tl) (profail nil next))
        (t (reductiondb p al depth stack (car tl)
                   `(reductiondbs ,p ,al ,depth ,stack ,(cdr tl) ,next ,done) done))))

(defun reductionth (p al depth stack th next done)
 (reductionths nil p al depth stack (envindexps p al th) (environment) nil next done))

;;; ground test in rule case would save work but it is expensive.
;;; note that subset test not good in rule case cause subgoals may bind vars.
;;; we should allow *saves* to work here when caching problem solved.

(defun reductionths (ans p al depth stack fl bl ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null fl) (profail nil next))
        ((and (listp (car fl)) (eq (caar fl) '<=))
         (cond ((setq ol (unify (cadar fl) bl p al))
                (setq next `(reductionths ,p ,al ,depth ,stack ,(cdr fl) ,bl ,ol ,next ,done))
                (cond (*ancestry* (setq stack (acons p al stack)))
                      (*reduction* ;;; (not (atom p)) (eq 'not (car p)))
                       (setq stack (acons p al stack))))
                (reductionand (cons 'and (cddar fl)) bl (1+ depth) stack next done))
               (t (reductionths nil p al depth stack (cdr fl) bl ol next done))))
        ((setq ol (unify (car fl) bl p al))
         (if (not (subolp ol (alist bl)))
             (setq next `(reductionths ,p ,al ,depth ,stack ,(cdr fl) ,bl ,ol ,next ,done)))
         (proexit next done))
        (t (reductionths nil p al depth stack (cdr fl) bl nil next done))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; residue.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *residue* nil)

(defmethod residue (x p *theory* &optional (*filter* #'basep) (*test* #'success))
 "(RESIDUE P *THEORY* &OPTIONAL (*TEST* #'FAILURE))
  RESIDUE takes as argument a term, sentence, a theory, and two unary
  predicates.  It finds one residue for the specified sentence by applying
  model elimination to the information in the specified theory and its included
  theories.  The search is done in iterative deepening fashion, controlled by
  the variables *START*, *INCREMENT*, and *DEPTH*.  RESIDUE returns as value
  the first residue for the specified sentence that satisfies the two
  predicates.  The first predicate is a test on the operator of each literal in 
  each residue; the second predicate is a test on the entire literal.  If there
  are no residues, the value is NIL."
  (do ((old *depth*) (*depth* (min *start* *depth*) (+ *depth* *increment*))
       (alist (environment)) (*residue* nil) (level 0) (tracecalls) (rl))
      ((> *depth* old) nil)
      (setq *termination* nil *inferences* 0 *unifications* 0)
      (setq x (vars x))
      (cond ((residuedepth p alist 1 nil '(failure) '(success))
             (setq rl (nreverse (plugstdexp *residue* alist)))
             (do ((l (vars p) (cdr l)) (dum))
                 ((null l))
                 (if (not (eq (setq dum (plugstdexp (car l) alist)) (car l)))
                   (setq rl (cons `(same ,(car l) ,dum) rl))))
             (if (every #'(lambda (x) (funcall *test* x)) rl)
                 (return (maksand rl))))
            ((not *termination*) (return nil)))))

(defmethod residues (x p *theory* &optional (*filter* #'basep) (*test* #'success))
 "(RESIDUES P *THEORY* &OPTIONAL (*TEST* #'FAILURE))
  RESIDUES takes as argument a term, sentence, a theory, and two unary
  predicates.  It finds all residues for the specified sentence by applying
  model elimination to the information in the specified theory and its included
  theories.  The search is done in iterative deepening fashion, controlled by
  the variables *START*, *INCREMENT*, and *DEPTH*.  RESIDUES returns as value a
  list of all residues for the specified sentence that satisfy the two
  predicates.  The first predicate is a test on the operator of each literal in 
  each residue; the second predicate is a test on the entire literal.  If there
  are no residues, the value is NIL."
  (let ((alist (environment)) (*residue*) (level 0) tracecalls)
    (setq *termination* nil *inferences* 0 *unifications* 0)
    (setq x (vars x))
    (do ((next (residuedepth p alist 1 nil '(failure) '(success)) (profail nil next))
         (rl) (nl))
        ((null next) (nreverse nl))
        (setq rl (nreverse (plugstdexp *residue* alist)))
        (do ((l (vars p) (cdr l)) (dum))
            ((null l))
            (if (not (eq (setq dum (plugstdexp (car l) alist)) (car l)))
                (setq rl (cons `(same ,(car l) ,dum) rl))))
        (if (every #'(lambda (x) (funcall *test* x)) rl)
            (setq nl (adjoin (maksand rl) nl :test #'equal))))))

(defun success (&rest l)
  (or (car l) t))


(defun residuedepth (p al depth stack next done)
  (setq *inferences* (1+ *inferences*))
  (cond ((numgreaterp depth *depth*) (setq *termination* t) (profail nil next))
        ((and traceexpressions
              (protracecall p al done)
              (setq next `(protracefail ,next ,done))
              (setq done `(protraceexit ,done)) nil))
        (t (residueexp p al depth stack next done))))

(defun residueexp (p al depth stack next done)
  (cond ((atom p) (residueconst p al depth stack next done))
        ((eq 'not (car p)) (residuenotexp (cadr p) al depth stack next done))
        ((eq 'and (car p)) (residueand p al depth stack next done))
        ((eq 'or (car p)) (residueor p al depth stack next done))
	((eq 'oneof (car p)) (residueassumption nil p al next done))
	((eq 'same (car p)) (residuesame p al next done))
	((eq 'distinct (car p)) (residuedistinct p al next done))
	((eq 'ground (car p)) (residueground p al next done))
	((eq 'nonground (car p)) (residuenonground p al next done))
	((eq 'primitive (car p)) (residueprimitive p al next done))
	((eq 'nonprimitive (car p)) (residuenonprimitive p al next done))
	((eq '== (car p)) (residuevalue p al next done))
	((eq 'value (car p)) (residuevalue p al next done))
	((eq 'execute (car p)) (residueassumption nil p al next done))
	((eq 'evaluate (car p)) (residueassumption nil p al next done))
	((eq 'unprovable (car p)) (residueunprovable p al next done))
	((eq 'bagofall (car p)) (residuebagofall p al next done))
	((eq 'stringmatch (car p)) (residuestringmatch p al next done))
	((get (car p) 'basicval) (residuebasicvalue p al next done))
	((get (car p) 'basic) (residuebasic p al next done))
	(t (residuecallfail p al depth stack next done))))

(defun residuenotexp (p al depth stack next done)
  (cond ((atom p) (residuenotconst p al depth stack next done))
        ((eq 'not (car p)) (residuedepth (cadr p) al depth stack next done))
        ((eq 'and (car p)) (residueornot p al depth stack next done))
        ((eq 'or (car p)) (residueandnot p al depth stack next done))
	((eq 'oneof (car p)) (profail nil next))
	((eq 'same (car p)) (profail nil next))
	((eq 'distinct (car p)) (profail nil next))
	((eq 'ground (car p)) (profail nil next))
	((eq 'nonground (car p)) (profail nil next))
	((eq 'primitive (car p)) (profail nil next))
	((eq 'nonprimitive (car p)) (profail nil next))
	((eq '== (car p)) (residuenotvalue p al next done))
	((eq 'value (car p)) (residuenotvalue p al next done))
	((eq 'execute (car p)) (residueassumption nil `(not ,p) al next done))
	((eq 'evaluate (car p)) (residueassumption nil `(not ,p) al next done))
	((eq 'unprovable (car p)) (residueexp (cadr p) al depth stack next done))
	((eq 'bagofall (car p)) (residuenotbagofall p al next done))
	((eq 'stringmatch (car p)) (profail nil next))
        ((get (car p) 'basicval) (residuenotbasicvalue p al next done))
        ((get (car p) 'basic) (residuenotbasic p al next done))
        ((intensionp (car p) *theory*) (residueunprovable `(not ,p) al next done))
        (t (residuecallfail `(not ,p) al depth stack next done))))

(defun residueconst (p al depth stack next done)
  (cond ((eq 'true p) (proexit next done))
        ((eq 'cut p) (proexit next done))
        ((eq 'false p) (profail nil next))
        (t (residuecallfail p al depth stack next done))))

(defun residuenotconst (p al depth stack next done)
  (cond ((eq 'true p) (profail nil next))
        ((eq 'cut p) (profail nil next))
        ((eq 'false p) (proexit next done))
        (t (residuecallfail `(not ,p) al depth stack next done))))


(defun residueand (p al depth stack next done)
  (cond ((null (cdr p)) (proexit next done))
        (t (residueands next (cdr p) al depth stack done))))

(defun residueands (ans pl al depth stack done)
  (cond ((null pl) (proexit ans done))
        ((eq 'cut (car pl))
         (residueands `(procut ,depth ,ans) (cdr pl) al depth stack done))
        (t (residuedepth (car pl) al depth stack
                      ans `(residueands ,(cdr pl) ,al ,depth ,stack ,done)))))

(defun residueandnot (p al depth stack next done)
  (cond ((null (cdr p)) (proexit next done))
        (t (residuedepth `(not ,(cadr p)) al depth stack
                      next `(residueandnots ,(cddr p) ,al ,depth ,stack ,done)))))

(defun residueandnots (ans pl al depth stack done)
  (cond ((null pl) (proexit ans done))
        ((eq 'cut (car pl))
         (residueandnots `(procut ,ans ,done) (cdr pl) al depth stack done))
        (t (residuedepth `(not ,(car pl)) al depth stack
                      ans `(residueandnots ,(cdr pl) ,al ,depth ,stack ,done)))))

(defun residueor (p al depth stack next done)
  (residueors nil (cdr p) al depth stack next done))

(defun residueors (ans pl al depth stack next done)
  (cond ((not (null ans)) (profail ans next))
        ((null pl) (profail nil next))
        (t (residuedepth (car pl) al depth stack
                      `(residueors ,(cdr pl) ,al ,depth ,stack ,next ,done) done))))

(defun residueornot (p al depth stack next done)
  (residueornots nil (cdr p) al depth stack next done))

(defun residueornots (ans pl al depth stack next done)
  (cond ((not (null ans)) (profail ans next))
        ((null pl) (profail nil next))
        (t (residuedepth `(not ,(car pl)) al depth stack
                      `(residueornots ,(cdr pl) ,al ,depth ,stack ,next ,done) done))))


(defmethod basep (r)
 "BASEP takes a symbol as argument and determines whether it is a predefined
  relation.  If so, it returns T; otherwise, it returns NIL."
  (or (find r '(oneof same distinct ground nonground primitive nonprimitive
                == value execute evaluate unprovable stringmatch))
      (get r 'basic)
      (get r 'basicval)))

(defun assumablep (p al)
  (when (and (funcall *filter* (operator p))
             (funcall *test* (setq p (plugstdexp p al))))
    p))

(defun residueassumption (ans p al next done)
  (cond (ans (profail next done))
        ((setq p (assumablep p al))
         (residueassume p next done))
        (t (profail nil next))))

(defun residueassume (p next done)
  (cond ((or (not *consistency*)
             (not (or (rebuttalp p *residue*) (rebuttheoryp p *theory*)))
             (consistentp p *residue*))
         (setq *residue* (cons p *residue*))
         (proexit `(residuenext ,next) done))
        (t (profail nil next))))

(defun rebuttheoryp (p th)
  (cond ((rebuttalp p (indexees (operator p) th)))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (if (rebuttheoryp p (car l)) (return t))))))

(defun rebuttalp (p l)
  (cond ((and (listp p) (eq 'not (car p)))
         (find (operator p) l :test #'arguesp))
        (t (find (operator p) l :test #'rebutsp))))

(defun arguesp (r p)
  (or (eq r p)
      (and (listp p)
           (or (eq r (car p))
               (and (eq '<= (car p))
                    (or (eq r (cadr p))
                        (and (listp (cadr p)) (eq r (caadr p)))))))))

(defun rebutsp (r p)
  (and (listp p)
       (or (and (eq 'not (car p)) 
                (or (eq r (cadr p)) (and (listp (cadr p)) (eq r (caadr p)))))
           (and (eq '<= (car p))
                (listp (setq p (cadr p))) (eq 'not (car p))
                (or (eq r (cadr p)) (and (listp (cadr p)) (eq r (caadr p))))))))

(defun consistentp (p res)
  (let (traceexpressions)
    (cond ((basep (operator p)))
          ((null (setq res (remove-if #'(lambda (x) (basep (operator x))) res))))
          ((consisp `(<= ,(maknot p) . ,res) *theory*) nil)
          (t t))))

(defun consisp (p th)
  (let ((cs (clausesets (maknot `(forall ,(vars p) ,p)))))
    (decludes 'epitheory)
    (empty 'epitheory)
    (includes 'epitheory th)
    (mapc #'(lambda (x) (save (car x) 'epitheory)) (cdr cs))
    (findp (maknot (caar cs)) 'epitheory)))

(defun residuenext (ans next)
  (setq *residue* (cdr *residue*))
  (profail ans next))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Note that both primitive and nonprimitive are true of all objects
;;; but Epilog succeeds only on terms that are primitive or nonprimitive.
;;; This is why (nonprimitive <x>) is not (not (primitive <x>))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun residueground (p al next done)
  (cond ((chkgroundp (cadr p) al) (proexit next done))
        (t (residueassumption nil p al next done))))

(defun residuenonground (p al next done)
  (cond ((chkgroundp (cadr p) al) (profail nil next))
        (t (residueassumption nil p al next done))))

(defun residueprimitive (p al next done)
  (cond ((chkprimitivep (cadr p) al)
         (if (chkgroundp (cadr p) al) (proexit next done)
             (residueassumption nil p al next done)))
        (t (profail nil next))))

(defun residuenonprimitive (p al next done)
  (cond ((chkprimitivep (cadr p) al) (profail nil next))
        (t (proexit next done))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Same is equals but succeeds only on unifiable terms.
;;; Distinct is true of all pairs of objects
;;; but epilog succeeds only in those cases where the arguments are different
;;; This is why there is no (not (distinct <x> <y>))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun residuesame (p al next done)
  (let ((ol))
    (cond ((setq ol (unify (caddr p) al (cadr p) al))
           (proexit `(residuevaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun residuedistinct (p al next done)
  (let ((ol))
    (cond ((setq ol (unify (caddr p) al (cadr p) al))
           (backup ol)
           (if (cdr ol) (residueassumption nil p al next done)
               (profail nil next)))
          (t (proexit next done)))))


(defun residuevalue (p al next done)
  (let ((x (residuebasicval (cadr p) al)) (y (caddr p)) (ol))
    (cond ((or (null x) (not (chkprimitivep y al)))
           (residueassumption nil p al next done))
          ((setq ol (unify y al x al))
           (proexit `(residuevaluenext ,ol ,next) done))
          (t (profail nil next)))))

(defun residuevaluenext (ans ol next)
  (backup ol)
  (profail ans next))

(defun residuenotvalue (p al next done)
  (let ((x (residuebasicval (cadr p) al)) (y (caddr p)) (ol))
    (cond ((null x) (residueassumption nil `(not ,p) al next done))
          ((setq ol (unify y al x al)) (backup ol) (profail nil next))
          (t (proexit next done)))))

;;; needless inefficiency here.  Just needs to check atom and car.

(defun residuebasicval (x al)
  (setq x (plugstdexp x al))
  (cond ((atom x) (if (and (groundp x) (primitivep x)) x))
        ((eq 'execute (car x)) nil)
        ((eq 'evaluate (car x)) nil)
        ((and (get (car x) 'basicval)
              (groundp x)
              (every #'primitivep (cdr x)))
         (funcall (get (car x) 'basicval) x))
        ((and (groundp x) (primitivep x)) x)))

(defun residueunprovable (p al next done)
  (let (rl)
    (setq p (plugstdexp (cadr p) al))
    (setq rl (residues t p *theory* *filter* *test*))
    (cond ((null rl) (proexit next done))
          ((eq 'true (maksor rl)) (profail nil next))
          (t (residueassume `(unprovable ,(maksor rl)) next done)))))

(defun residuebagofall (p al next done)
  (let (rl)
    (setq p (plugstdexp p al))
    (setq rl (residues (cadr p) (caddr p) *theory* *filter* *test*))
    (cond ((null rl) (profail nil next))
          ((eq 'true (maksor rl)) (proexit next done))
          (t  (setq *residue* (cons `(bagofall ,(cadr p) ,(maksor rl) ,(cadddr p)) *residue*))
              (proexit `(residuenext ,next) done)))))

(defun residuenotbagofall (p al next done)
  (let (rl)
    (setq p (plugstdexp p al))
    (setq rl (residues (cadr p) (caddr p) *theory* *filter* *test*))
    (cond ((null rl) (profail nil next))
          ((eq 'true (maksor rl)) (proexit next done))
          (t (residueassume `(not (bagofall ,(cadr p) ,(maksor rl) ,(cadddr p))) next done)))))

(defun residuestringmatch (p al next done)
  (let (pat str dum ol)
    (cond ((and (setq pat (groundplugstdexp (cadr p) al)) (primitivep pat)
                (setq str (groundplugstdexp (caddr p) al)) (primitivep str))
           (if (and (car (setq dum (multiple-value-list (strmatches pat str))))
                    (setq ol (unify (cdddr p) al (cdr dum) al)))
               (proexit `(findvaluenext ,ol ,next) done)
               (profail nil next)))
          (t (residueassumption nil p al next done)))))

(defun residuebasicvalue (p al next done)
  (let ((x (butlast p)) (y (car (last p))) (ol))
    (cond ((and (setq x (groundplugstdexp x al)) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))
           (if (and (not (null x)) (setq ol (unify y al x al)))
               (proexit `(residuevaluenext ,ol ,next) done)
               (profail nil next)))
          (t (residueassumption nil p al next done)))))

(defun residuebasic (p al next done)
  (let (ans)
    (cond ((and (setq ans (groundplugstdexp p al))
                (every 'primitivep (cdr ans)))
           (if (apply (get (car ans) 'basic) (cdr ans))
               (proexit next done)
               (profail nil next)))
          (t (residueassumption nil p al next done)))))

(defun residuenotbasicvalue (p al next done)
  (let ((x (butlast p)) (y (car (last p))) (ol))
    (cond ((and (setq x (groundplugstdexp x al)) (every #'primitivep (cdr x)))
           (setq x (funcall (get (car x) 'basicval) x))
           (cond ((null x) (profail nil next))
                 ((setq ol (unify y al x al)) (backup ol) (profail nil next))
                 (t (proexit next done))))
          (t (residueassumption nil `(not ,p) al next done)))))

(defun residuenotbasic (p al next done)
  (let (ans)
    (cond ((and (setq ans (groundplugstdexp p al))
                (every #'primitivep (cdr ans)))
           (if (not (apply (get (car ans) 'basic) (cdr ans)))
               (proexit next done)
               (profail nil next)))
          (t (residueassumption nil `(not ,p) al next done)))))


(defun residuecallfail (p al depth stack next done)
  (let (dum)
    (cond ((funcall *filter* (operator p))
           (cond ((and (groundishp (setq dum (plugstdexp p al)))
                       (knownp dum *theory*))
                  (proexit next done))
                 ((funcall *test* (setq dum (plugstdexp p al)))
                  (residueassume dum next done))
                 (t (profail nil next))))
          (t (residuers p al depth stack
                        `(residuecallfailnext ,depth ,next) done)))))

(defun groundishp (x)
  (cond ((eq x '?*))
        ((varp x) nil)
        ((atom x))
        ((eq 'quote (car x)))
	(t (every 'groundishp x))))

(defun residuecallfailnext (ans depth next)
  (cond ((null ans) (profail nil next))
        ((eql ans depth) (profail nil next))
        (t (profail ans next))))

(defun residuers (p al depth stack next done)
  (cond ((and *ancestry* (residueancestor p al stack)) (profail nil next))
        ((and (numberp *ancestry*) (residuenumber p al stack 0))
         (residueassumption nil p al next done))
        (*reduction* ;;; (or (atom p) (not (eq 'not (car p)))))
         (residuersloop nil p al depth stack stack nil next done))
        (t (residuedb p al depth stack *theory* next done))))

(defun residuenumber (p al stack n)
  (let (ol)
    (cond ((numgeqp n *ancestry*))
          ((null stack) nil)
          ((atom p)
           (residuenumber p al (cdr stack) (if (eq p (caar stack)) (1+ n) n)))
          ((setq ol (unify p al (caar stack) (cdar stack)))
           (prog1 (residuenumber p al (cdr stack) (1+ n)) (backup ol)))
          (t (residuenumber p al (cdr stack) n)))))

(defun residueancestor (p al stack)
  (do ((l stack (cdr l)))
      ((null l) nil)
      (if (identify (caar l) (cdar l) p al) (return t))))

(defun residuersloop (ans p al depth stack sl ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null sl) (residuedb p al depth stack *theory* next done))
        ((setq ol (unify (maknot (caar sl)) (cdar sl) p al))
         (proexit `(residuersloop ,p ,al ,depth ,stack ,(cdr sl) ,ol ,next ,done)
                  done))
        (t (residuersloop nil p al depth stack (cdr sl) ol next done))))

(defun residuedb (p al depth stack th next done)
  (residueth p al depth stack th
          `(residuedbs ,p ,al ,depth ,stack ,(includees th) ,next ,done) done))

(defun residuedbs (ans p al depth stack tl next done)
  (cond ((not (null ans)) (profail ans next))
        ((null tl) (profail nil next))
        (t (residuedb p al depth stack (car tl)
                   `(residuedbs ,p ,al ,depth ,stack ,(cdr tl) ,next ,done) done))))

(defun residueth (p al depth stack th next done)
 (residueths nil p al depth stack (envindexps p al th) (environment) nil next done))

;;; ground test in rule case would save work but it is expensive.
;;; note that subset test not good in rule case cause subgoals may bind vars.
;;; we should allow *saves* to work here when caching problem solved.

(defun residueths (ans p al depth stack fl bl ol next done)
  (backup ol)
  (cond ((not (null ans)) (profail ans next))
        ((null fl) (profail nil next))
        ((and (listp (car fl)) (eq (caar fl) '<=))
         (cond ((setq ol (unify (cadar fl) bl p al))
                (setq next `(residueths ,p ,al ,depth ,stack ,(cdr fl) ,bl ,ol ,next ,done))
                (cond (*ancestry* (setq stack (acons p al stack)))
                      (*reduction* ;;; (not (atom p)) (eq 'not (car p)))
                       (setq stack (acons p al stack))))
                (residueand (cons 'and (cddar fl)) bl (1+ depth) stack next done))
               (t (residueths nil p al depth stack (cdr fl) bl ol next done))))
        ((setq ol (unify (car fl) bl p al))
         (if (not (subolp ol (alist bl)))
             (setq next `(residueths ,p ,al ,depth ,stack ,(cdr fl) ,bl ,ol ,next ,done)))
         (proexit next done))
        (t (residueths nil p al depth stack (cdr fl) bl nil next done))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; consequences.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special *theory* *test* *names* *functionals*
                      *start* *increment* *depth* *termination*
                      alist level tracecalls tracefacts traceexpressions)))

(defparameter *consequences* nil)

(defmethod consequences (p *theory* &optional (*test* #'failure))
 "(CONSEQUENCES P *THEORY*)
  CONSEQUENCES takes a sentence and a theory as arguments.  The sentence is
  assumed to be a literal.  CONSEQUENCES uses model elimination to derive
  conclusions from the specified sentence and the sentences in the specified
  theory and its included theories.  The search is bottom-up, depth-first, and
  statically-ordered and uses *DEPTH* as a depth limit.  If it derives a literal
  with relation constant on the list *SAVES*, it saves the literal it derives
  on a list and returns that list as value."
  (let ((alist (environment)) (*consequences*) (level 0) tracecalls)
    (setq *termination* nil)
    (consequencedepth p alist 1)
    (nreverse *consequences*)))

(defun consequencedepth (p al depth)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        (t (if traceexpressions (tracesave p al))
           (consequenceexp p al depth)
           (if traceexpressions (tracedone p al)))))

(defun consequenceexp (p al depth)
  (cond ((atom p) (consequenceexpexit p al depth))
        ((eq 'and (car p)) 
         (mapc #'(lambda (x) (consequencedepth x al depth)) (cdr p)))
        (t (consequenceexpexit p al depth))))

(defun consequenceexpexit (p al depth)
  (setq p (plugstdexp p al))
  (cond ((knownp p *theory* 'samep) nil)
;        ((and (listp p) (eq 'execute (car p))) (ignore-errors (eval (cadr p))))
        ((and (consequence p al) nil))
        ((and (savep p) (insert p *theory*) nil))
        (t (consequencedb p al depth *theory*))))

(defun consequence (p al)
  (setq p (plugstdexp p al))
  (when (funcall *test* (operator p))
    (setq *consequences* (cons p *consequences*))))

(defun consequencedb (p al depth th)
  (cond ((consequenceth p al depth th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (consequencedb p al depth (car l))))))

(defun consequenceth (p al depth th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment)) (ans))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '=>) (not (null (cddar l)))
                 (setq ol (unify (cadar l) bl p al)))
        (if tracefacts (tracefact (car l)))
        (setq ans (consequents '(failure) (car l) (butlast (cddar l)) bl depth))
        (backup ol)
        (if ans (return ans)))))

(defun consequents (next rule pl al depth)
  (cond ((null pl) (consequencedepth (car (last rule)) al (1+ depth))
         (profail nil next))
        ((eq 'cut (car pl)) (consequents next rule (cdr pl) al depth) t)
        ((finddepth (car pl) al depth nil
                    next `(consequents ,rule ,(cdr pl) ,al ,depth)))))


(defparameter *newconsequences* nil)

(defmethod newconsequences (p th *filter* *test*)
 "(NEWCONSEQUENCES P *THEORY*)
  NEWCONSEQUENCES takes a sentence and a theory as arguments.  The sentence is
  assumed to be ground literal or a conjunction of ground literals.  NEWCONSEQUENCES
  uses model elimination to derive
  conclusions from the specified sentence and the sentences in the specified
  theory and its included theories.  The search is bottom-up, depth-first, and
  statically-ordered and uses *DEPTH* as a depth limit.  If it derives a literal
  with relation constant on the list *SAVES*, it saves the literal it derives
  on a list and returns that list as value."
  (let ((alist (environment)) (*theory* (make-instance 'theory))
        (*newconsequences*) (level 0) tracecalls)
    (setq *termination* nil)
    (unwind-protect
      (progn (newsave p *theory*)
             (includes *theory* th)
             (newconsequencedepth p alist 'true 1 nil))
      (progn (decludes *theory*)
             (empty *theory*)))
    (nreverse *newconsequences*)))

(defun newsave (p th)
  (cond ((atom p) (save p th))
        ((eq 'and (car p)) (mapc #'(lambda (x) (newsave x th)) (cdr p)))
        (t (save p th))))

(defun newconsequencedepth (p al res depth stack)
  (cond ((numgreaterp depth *depth*) (setq *termination* t) nil)
        ((find (operator p) (cdr stack)) nil)
        (t (if traceexpressions (tracesave p al))
           (newconsequenceexp p al res depth stack)
           (if traceexpressions (tracedone p al)))))

(defun newconsequenceexp (p al res depth stack)
  (cond ((atom p) (newconsequencedb p al res depth stack *theory*))
        ((eq 'and (car p)) 
         (mapc #'(lambda (x) (newconsequencedepth x al res depth stack)) (cdr p)))
        ((funcall *test* (operator p))
         (cond ((eq res 'false))
               ((eq res 'true)
                (setq *newconsequences*
                      (adjoin (plugstdexp p al) *newconsequences* :test #'equalp)))
               (t (setq *newconsequences*
                        (cons (plugstdexp `(=> ,res ,p) al) *newconsequences*))))
         (newconsequencedb p al res depth stack *theory*))
        (t (newconsequencedb p al res depth stack *theory*))))  

(defun newconsequencedb (p al rl depth stack th)
  (cond ((newconsequenceth p al rl depth stack th))
        (t (do ((l (includees th) (cdr l)))
               ((null l) nil)
               (newconsequencedb p al rl depth stack (car l))))))

(defun newconsequenceth (p al rl depth stack th)
  (do ((l (envindexps p al th) (cdr l)) (ol) (bl (environment))
       (antecedent) (consequent))
      ((null l))
      (when (and (listp (car l)) (eq (caar l) '=>) (not (null (cddar l)))
                 (setq ol (unify (cadar l) bl p al)))
        (if tracefacts (tracefact (car l)))
        (setq antecedent (plugstdexp (maksand (butlast (cddar l))) bl))
        (setq consequent (plugstdexp (car (last (car l))) bl))
        (newconsequence antecedent consequent al rl depth stack)
        (backup ol))))

(defun newconsequence (antecedent consequent al rl depth stack)
  (do ((l (residues (vars consequent) antecedent *theory* *filter*) (cdr l)))
      ((null l) rl)
      (newconsequencedepth consequent al (makand rl (car l))
                           (1+ depth) (cons (operator consequent) stack))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; transforms.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (compile load eval)
  (proclaim '(special direction universals alist alluniversals)))

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

(defun newskolem () (cons (gensym "F") universals))

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
  (do ((l (cdr p) (cdr l)) (nl (list nil)))
      ((null (cdr l)) (orclause nl (cnfs (car l))))
      (setq nl (orclause nl (cnns (car l))))))

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
	(t (andclause (cnns (car l)) (cnnsors (cdr l))))))

(defun cnnsand (p)
  (cnnsands (cdr p)))

(defun cnnsands (l)
  (cond ((null l) (list nil))
	(t (orclause (cnns (car l)) (cnnsands (cdr l))))))

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
                        ((eq 'cut p) (list nil))
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

(defmethod rules (p)
 "(RULES P)
  RULES takes a sentence as argument and returns a list of equivalent rules in
  simplified interchange format."
  (mapcar #'rulify (clausesets p)))

(defun rulify (l)
  (maksbr (nconc (nreverse (car (flats (car l))))
                 (car (flats (maksor (cdr l)))))))

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
                      *saves* *names* *functionals*
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
  (setq *functionals* nil)
  (setq *unifications* 0)
  (setq *start* 1000)
  (setq *increment* 1000)
  (setq *depth* 1000000)
  (setq *termination* nil)
  (setq *inferences* 0)
  (setq *trace-device* t)
  (setq traceexpressions nil)
  t)

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

;;;;


(defparameter *baserelations* nil)
(defparameter *materializations* nil)
(defparameter *subscriptions* nil)

(defun baserelation (r)
  (setq *baserelations* (adjoin r *baserelations*))
  'done)

(defun nonbaserelation (r)
  (setq *baserelations* (delete r *baserelations*))
  'done)

(defun baserelations ()
  *baserelations*)

(defun materialize (r th)
  (saveall (list r '@l) (list r '@l) th)
  (setq *materializations* (adjoin r *materializations*))
  'done)

(defun dematerialize (r th)
  (dropall (list r '@l) (list r '@l) th)
  (setq *materializations* (delete r *materializations*))
  'done)

(defun materializations ()
  *materializations*)

(defun subscribe (r th)
  (let (dum)
    (cond ((setq dum (assoc th *subscriptions*))
           (rplacd dum (adjoin r (cdr dum))))
          (t (setq *subscriptions* (acons th (list r) *subscriptions*))))
    'done))

(defun unsubscribe (r th)
  (let (dum)
    (when (setq dum (assoc th *subscriptions*))
      (rplacd dum (delete r (cdr dum))))
    'done))

(defun subscriptions (th)
  (cdr (assoc th *subscriptions*)))

;;;;

(defun planoneprimitive (x p al)
  `(if ,(cons 'primitivep (mapcar #'(lambda (x) (makresult x al)) (cdr p)))
     ,(makresult x al)))

(defun planonenonprimitive (x p al)
  `(unless ,(cons 'primitivep (mapcar #'(lambda (x) (makresult x al)) (cdr p)))
     ,(makresult x al)))

(defun planonevalue (x p al)
  (cond ((every #'atom (cdr p))
         (planonebasicval x (append (cadr p) (cddr p)) al))
        (t (planoneexp x (flatten p) al))))

(defun planonenotvalue (x p al)
  (cond ((every #'atom (cdr p))
         (planonenotbasicval x (append (cadr p) (cddr p)) al))
        (t (setq p (nreverse (flatten p)))
           (rplaca p (maknot (car p)))
           (setq p (nreverse p))
           (planoneexp x p al))))

(defun planallprimitive (x p al where)
  `(if ,(cons 'primitivep (mapcar #'(lambda (x) (makresult x al)) (cdr p)))
     ,(planalldone x al where)))

(defun planallnonprimitive (x p al where)
  `(unless ,(cons 'primitivep (mapcar #'(lambda (x) (makresult x al)) (cdr p)))
     ,(planalldone x al where)))

(defun planallvalue (x p al where)
  (cond ((every #'atom (cdr p))
         (planallbasicval x (append (cadr p) (cddr p)) al where))
        (t (planallexp x (flatten p) al where))))

;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;