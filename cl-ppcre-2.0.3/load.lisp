;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-
;;; $Header: /usr/local/cvsrep/cl-ppcre/cl-ppcre.asd,v 1.49 2009/10/28 07:36:15 edi Exp $

;;; This ASDF system definition was kindly provided by Marco Baringer.

;;; Copyright (c) 2002-2009, Dr. Edmund Weitz.  All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package :cl-user)

(defpackage :cl-ppcre-asd
  (:use :cl))
(in-package :cl-ppcre-asd)
(load (cl-user::loadfn "packages"))
(load (cl-user::loadfn "specials"))
(load (cl-user::loadfn "util"))
(load (cl-user::loadfn "errors"))
(load (cl-user::loadfn "charset"))
(load (cl-user::loadfn "charmap"))
(load (cl-user::loadfn "chartest"))
(load (cl-user::loadfn "lexer"))
(load (cl-user::loadfn "parser"))
(load (cl-user::loadfn "regex-class"))
(load (cl-user::loadfn "regex-class-util"))
(load (cl-user::loadfn "convert"))
(load (cl-user::loadfn "optimize"))
(load (cl-user::loadfn "closures"))
(load (cl-user::loadfn "repetition-closures"))
(load (cl-user::loadfn "scanner"))
(load (cl-user::loadfn "api"))

(in-package :cl-user)


#|
(defsystem :cl-ppcre-test
  :depends-on (:cl-ppcre :flexi-streams)
  :components ((:module "test"
                        :serial t
                        :components ((:file "packages")
                                     (:file "tests")
                                     (:file "perl-tests")))))

(defmethod perform ((o test-op) (c (eql (find-system :cl-ppcre))))
  (operate 'load-op :cl-ppcre-test)
  (funcall (intern (symbol-name :run-all-tests) (find-package :cl-ppcre-test))))
|#