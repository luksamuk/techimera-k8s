(in-package #:techimera.util)

(defun get-env (x)
  #+(or abcl clasp clisp ecl xcl) (ext:getenv x)
  #+allegro (sys:getenv x)
  #+clozure (ccl:getenv x)
  #+gcl (system:getenv x)
  #+genera nil
  #+lispworks (lispworks:environment-variable x)
  #+sbcl (sb-ext:posix-getenv x))

(defun get-env-or-default (variable default)
  (or (get-env variable) default))

(defun get-env-int-or-default (variable default)
  (let ((value (get-env variable)))
    (if value (parse-integer value) default)))

(defmacro route-prepare-response (response-object
                                  &optional
                                    (http-code 200)
                                    (type "application/json"))
  `(progn
     (setf (lack.response:response-headers ,response-object)
           (append
            (lack.response:response-headers ,response-object)
            (list :content-type ,type)))
     (setf (lack.response:response-status ,response-object)
           ,http-code)))

(defmacro http-response ((&optional (http-code 200) res) &body body)
  `(progn (route-prepare-response
           ,(or res 'ningle:*response*)
           ,http-code
           "application/json")
          (json:encode-json-to-string
           ,(cond ((null body) `(list '(:message . "OK")))
                  ((consp (first body)) (first body)) ; todo: subformats
                  ((and (stringp (first body))
                        (= (length body) 1))
                   `(list '(:message . ,(first body))))
                  (t `(list (cons :message
                                  (format nil ,@body))))))))

(defmacro agetf (key alist)
  `(cdr (assoc ,key ,alist)))

(defun class-table-p (class)
  (let ((class (if (typep class 'symbol)
                   (find-class class)
                   class)))
    (typep class 'mito.dao.table:dao-table-class)))

(defun table-get-raw-columns (class)
  (unless (class-table-p class)
    (error "~a is not a table class" class))
  (let* ((class (if (typep class 'symbol)
                    (find-class class)
                    class)))
    (->> class
         closer-mop:class-direct-superclasses
         (cons class)
         (mapcar #'closer-mop:class-direct-slots)
         alexandria:flatten
         (remove-if-not
          (lambda (slot)
            (typep slot
                   'mito.dao.column:dao-table-column-class)))
         (mapcar #'closer-mop:slot-definition-name))))

(defun symbol->keyword (symbol)
  (unless (symbolp symbol)
    (error "~a is not of type SYMBOL" symbol))
  (intern (format nil "~a" symbol) :keyword))

(defun table-get-lispy-columns (class)
  (mapcar #'symbol->keyword
          (table-get-raw-columns class)))

(defparameter *non-register-columns*
  '(:created-at :updated-at :id :password-hash :password-salt))

(defun table-get-lispy-register-columns (class)
  (remove-if (lambda (slot)
               (member slot *non-register-columns* :test #'eql))
             (table-get-lispy-columns class)))

(defun dao->alist (dao)
  (let ((class (type-of dao)))
    (loop for field in (table-get-lispy-columns class)
       for getter-sym =
         (case field
           (:id 'mito:object-id)
           (:created-at    'mito:object-created-at)
           (:updated-at    'mito:object-updated-at)
           (:password-hash 'mito-auth:password-hash)
           (:password-salt 'mito-auth:password-salt)
           (otherwise
            (intern (string-upcase
                     (concatenate 'string
                                  (format nil "~a" class)
                                  "-"
                                  (format nil "~a" field)))
                    :techimera.db)))
       collect (cons field (funcall getter-sym dao)))))


(defun dao->json (dao)
  (json:encode-json-to-string
   (dao->alist dao)))
