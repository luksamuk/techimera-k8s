(in-package #:techimera.db)

(setf mito:*mito-logger-stream* t)

;; Usa o parâmetro *tables* definido em tables.lisp.
;; As tabelas desse mesmo arquivo precisam ter sido carregadas.

(defun ensure-tables ()
  (mapcar #'mito:ensure-table-exists *tables*))

(defun migrate-tables ()
  (mapcar #'mito:migrate-table *tables*))

(defun get-migration-expressions ()
  (loop for table in *tables*
        for expr = (mito:migration-expressions table)
        when expr collect (list table expr)))

(defun get-table-definitions ()
  (loop for table in *tables*
        for expr = (mito:table-definition table)
        collect (list table expr)))

(defun generate-tables ()
  (ensure-tables)
  (migrate-tables))

(defun generate-seed-daos (seeds)
  (loop for seed in seeds
        collect (make-instance
                 'users
                 :name (util:agetf :name seed)
                 :mail (util:agetf :mail seed))))

(defun generate-seeds ()
  (generate-seed-daos
   '(((:name      . "Fulano da Silva")
      (:mail      . "fulano@exemplo.com"))
     ((:name      . "Ciclano da Silva")
      (:mail      . "ciclano@exemplo.com")))))

(defun seed-user ()
  (mapcar #'mito:insert-dao (generate-seeds)))
