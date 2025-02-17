
(defparameter *data* '((p a a) (p a b) (q b c) (q b d)))

(defparameter *knowledge* '((<= (r ?x ?z) (p ?x ?y) (q ?y ?z)) (=> (p ?x ?y) (q ?y ?z) (s ?x ?z))))

(defun lookup (x queries al results)
  (cond ((null queries) (cons (plug x al) results))
        (t (do ((l *data* (cdr l)) (bl))
               ((null l) results)
               (when (setq bl (matchpexp (car queries) (car l) al))
                 (setq results (lookup x (cdr queries) bl results)))))))

(defun evaluate (x queries al results)
  (cond ((null queries) (cons (plug x al) results))
        (t (do ((l *data* (cdr l)) (bl))
               ((null l) results)
               (when (setq bl (mguexp (car queries) (car l) al))
                 (setq results (evaluate x (cdr queries) bl results))))
           (do ((l *knowledge* (cdr l)) (rule) (bl))
               ((null l) results)
               (setq rule (stdize (car l)))
               (when (setq bl (mguexp (cadr rule) (car queries) al))
                 (setq results (evaluate x (append (cddr rule) (cdr queries)) bl results))))
           results)))

(defun evaluater (x queries al history results)
  (cond ((null queries) (cons (plug x al) results))
        (t (do ((l *data* (cdr l)) (bl))
               ((null l) results)
               (when (setq bl (mguexp (car queries) (car l) al))
                 (setq results (evaluater x (cdr queries) bl history results))))
           (do ((l *knowledge* (cdr l)) (rule) (bl) (ql) (hl))
               ((null l) results)
               (setq rule (stdize (car l)))
               (when (and (eq (car rule) '<=)
                          (setq bl (mguexp (cadr rule) (car queries) al)))
                 (setq ql (append (cddr rule) (cdr queries)))
                 (setq hl (cons (cons (car queries) bl) history))
                 (setq results (evaluater x ql bl hl results))))
           results)))

(defun add (p)
  (do ((l *data* (cdr l)))
      ((null l) (setq *data* (nconc *data* (list p))))
      (when (equalp p (car l)) (return 'done))))

(defun augment (p)
  (cond ((lookup t (list p) truth nil) 'done)
        (t (setq *data* (nconc *data* (list p)))
           (do ((l *knowledge* (cdr l)) (rule) (bl))
               ((null l) 'done)
               (setq rule (stdize (car l)))
               (when (setq bl (mgu (cadr rule) p))
                 (do ((m (evaluate (car (last rule)) (butlast (cddr rule)) bl nil) (cdr m)))
                     ((null m) 'done)
                     (augment (car m))))))))
