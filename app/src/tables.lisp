(in-package #:techimera.db)

(defparameter *tables* '(users notes))

(deftable users ()
  ((name :col-type (:varchar 200)
         :initarg :name
         :accessor user-name)
   (mail :col-type (:varchar 64)
         :initarg :mail
         :accessor user-mail))
  (:unique-keys mail)
  (:documentation
   "Representa a tabela `user` no banco de dados."))

(deftable notes ()
  ((user :col-type users
         :initarg :user
         :accessor note-user)
   (text :col-type (:varchar 1024)
         :initarg :text
         :accessor note-text))
  (:documentation
   "Representa a tabela `note` no banco de dados."))
