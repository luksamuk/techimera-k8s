(in-package #:techimera.controller)


(defun payload-agetf (key payload)
  (cdr (assoc key payload :test #'string=)))

;; Um payload é válido quando tentarmos recuperar todos os campos
;; esperados a partir do payload e todos eles forem recuperados
;; com sucesso.
(defun valid-user-payload-p (payload)
  (every (lambda (x) (not (null x)))
         (mapcar (lambda (field) (payload-agetf field payload))
                 '("name" "mail"))))

(defmacro with-db-handler (&body body)
  `(handler-case (progn ,@body)
     (dbi.error:dbi-database-error (e)
       (util:http-response (500)
         "Internal server error: ~A" e))))

(defmethod ctl-index ((type (eql :user)) &optional params payload)
  (declare (ignore params payload))
  (with-db-handler
    (->> (mito:select-dao 'techimera.db:users)
         (mapcar #'util:dao->alist)
         json:encode-json-to-string)))

(defmethod ctl-show ((type (eql :user)) id &optional params payload)
  (declare (ignore params payload))
  (with-db-handler
    (let ((user (mito:find-dao 'techimera.db:users :id id)))
      (or (and user (util:dao->json user))
          (util:http-response (404)
            "Unknown user with ID ~a" id)))))

(defmethod ctl-store ((type (eql :user)) &optional params payload)
  (declare (ignore params))
  (with-db-handler
    (cond ((null payload)
           (util:http-response (412)
             "Missing user information"))
          ((not (valid-user-payload-p payload))
           (util:http-response (412)
             "Malformed user data: ~A" payload))
          (t (->> (mito:create-dao
                   'techimera.db:users
                   :name (payload-agetf "name" payload)
                   :mail (payload-agetf "mail" payload))
                  util:dao->json)))))

(defmethod ctl-update ((type (eql :user)) id &optional params payload)
  (declare (ignore params payload))
  (with-db-handler
    (util:http-response (501)
      "Feature not implemented")))

(defmethod ctl-delete ((type (eql :user)) id &optional params payload)
  (declare (ignore params payload))
  (with-db-handler
    (let ((user (mito:find-dao 'techimera.db:users :id id)))
      (if (null user)
          (util:http-response (404)
            "Unknown user with ID ~a" id)
          (progn
            (mito:delete-dao user)
            (util:http-response ()
              "User successfully deleted"))))))
