(in-package #:techimera.rest)

(defparameter *server-handler* nil)

(defparameter *server-address*
  (techimera.util:get-env-or-default "APP_HOST" "0.0.0.0"))

(defparameter *server-port*
  (techimera.util:get-env-int-or-default "APP_PORT" 9000))

;; Depende de *router*, declarado em routes.lisp

(defun start-server ()
  "Inicia o servidor HTTP."
  (unless *server-handler*
    (setf *server-handler*
          (clack:clackup
           *router*
           :address *server-address*
           :port *server-port*
           :server :woo
           :use-default-middlewares nil))))

(defun stop-server ()
  "Encerra o servidor HTTP."
  (when *server-handler*
    (clack:stop *server-handler*)
    (setf *server-handler* nil)
    t))

(defun start ()
  "Inicia o back-end, conectando ao banco de dados e iniciando o servidor HTTP."
  (format t "~&Conectando ao BD...~&")
  (techimera.db:connect)
  (format t "~&Gerando e atualizando tabelas...~&")
  (techimera.db:generate-tables)
  (format t "~&Iniciando servidor HTTP...~&")
  (start-server))

(defun stop ()
  "Encerra o servidor HTTP e a conexão com o banco de dados."
  (stop-server)
  (techimera.db:disconnect))


