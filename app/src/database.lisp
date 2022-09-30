(in-package #:techimera.db)

(defparameter *host*
  (techimera.util:get-env-or-default "PGSQL_HOST" "127.0.0.1"))
(defparameter *port*
  (techimera.util:get-env-int-or-default "PGSQL_PORT" 5432))
(defparameter *username*
  (techimera.util:get-env-or-default "PGSQL_USER" "postgres"))
(defparameter *database*
  (techimera.util:get-env-or-default "PGSQL_DATABASE" "techimera"))

(defun connect ()
  (format t "~&Connecting user ~A to PostgreSQL on ~A:~A/~A...~&"
          *username* *host* *port* *database*)
  (mito:connect-toplevel
   :postgres
   :host *host*
   :username *username*
   :database-name *database*
   :password (techimera.util:get-env-or-default "PGSQL_PASSWORD" "postgres")
   :port *port*))

(defun disconnect ()
  (format t "~&Disconnecting from database...~&")
  (mito:disconnect-toplevel))

