(in-package #:techimera.controller)

;; Operações genéricas
(defgeneric ctl-index (type-key &optional params payload))
(defgeneric ctl-show (type-key id &optional params payload))
(defgeneric ctl-store (type-key &optional params payload))
(defgeneric ctl-update (type-key id &optional params payload))
(defgeneric ctl-delete (type-key id &optional params payload))

