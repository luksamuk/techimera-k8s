(in-package #:techimera.rest)

(defparameter *router* (make-instance 'ningle:<app>))

(defmacro defroute (path method (params) &body body)
  `(setf (route *router* ,path :method ,method)
         (lambda (,params) ,@body)))

(defmacro get-payload ()
  `(lack.request:request-body-parameters ningle:*request*))

;;; ===== Rotas ===== ;;;

;; Root
(defroute "/" :GET (params)
  (declare (ignore params))
  (util:http-response (200)
    "Hello world from GET request!"))

(defroute "/" :POST (params)
  (declare (ignore params))
  (util:http-response (200)
    "Hello world from POST request!"))

;; User
(defroute "/user" :GET (params)
  (techimera.controller:ctl-index :user params))

(defroute "/user/:id" :GET (params)
  (techimera.controller:ctl-show :user (util:agetf :id params) params))

(defroute "/user" :POST (params)
  (techimera.controller:ctl-store :user params (get-payload)))

(defroute "/user/:id" :PUT (params)
  (techimera.controller:ctl-update :user (util:agetf :id params) params))

(defroute "/user/:id" :DELETE (params)
  (techimera.controller:ctl-delete :user (util:agetf :id params) params))

(defroute "/user/seed" :POST (params)
  (declare (ignore params))
  (techimera.db:seed-user)
  (techimera.controller:ctl-index :user params))

;; Note
(defroute "/note" :GET (params)
  (techimera.controller:ctl-index :note params))

(defroute "/note/:id" :GET (params)
  (techimera.controller:ctl-show :note (util:agetf :id params) params))

(defroute "/note" :POST (params)
  (techimera.controller:ctl-store :note params (get-payload)))

(defroute "/note/:id" :PUT (params)
  (techimera.controller:ctl-update :note (util:agetf :id params) params))

(defroute "/note/:id" :DELETE (params)
  (techimera.controller:ctl-delete :note (util:agetf :id params) params))
