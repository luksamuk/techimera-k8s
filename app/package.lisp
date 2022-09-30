(defpackage #:techimera.util
  (:nicknames #:util)
  (:use #:cl #:arrows)
  (:export #:get-env
           #:get-env-or-default
           #:get-env-int-or-default
           #:route-prepare-response
           #:http-response
           #:agetf
           #:dao->alist
           #:dao->json)
  (:documentation
   "Módulo de utilitários."))

(defpackage #:techimera.db
  (:use #:cl #:mito #:mito-auth #:arrows)
  (:export #:connect
           #:disconnect
           #:generate-tables
           #:seed-user
           #:users
           #:notes)
  (:documentation
   "Módulo de configuração do banco de dados."))

(defpackage #:techimera.controller
  (:use #:cl #:mito #:mito-auth #:arrows)
  (:export #:ctl-index
           #:ctl-show
           #:ctl-store
           #:ctl-update
           #:ctl-delete)
  (:documentation
   "Módulo para controllers da aplicação."))

(defpackage #:techimera.rest
  (:use #:cl #:arrows #:ningle)
  (:export #:start-server
           #:stop-server
           #:start
           #:stop)
  (:documentation
   "Módulo para rotas REST."))
