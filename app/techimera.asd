(asdf:defsystem #:techimera
    :description "Exemplo de aplicação Lisp/REST a ser hospedada em K8s"
    :author "Lucas S. Vieira <lucasvieira@protonmail.com>"
    :license "MIT"
    :version "0.2.0"
    :serial t
    :depends-on (#:cffi
                 #:cl-json
                 #:ningle
                 #:clack
                 #:mito
                 #:mito-auth
                 #:ironclad
                 #:jose
                 #:closer-mop
                 #:alexandria
                 #:arrows
                 #:split-sequence)
    :components ((:file "package")
                 (:module "src"
                  :components ((:file "util")
                               (:file "database")
                               (:file "tables")
                               (:file "migration")
                               (:file "controller-base")
                               (:file "user-controller")
                               (:file "note-controller")
                               (:file "routes")
                               (:file "main")))))
