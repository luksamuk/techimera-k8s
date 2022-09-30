(in-package #:techimera.controller)

(defmethod ctl-index ((type (eql :note)) &optional params payload)
  (declare (ignore params payload))
  (util:http-response (501)
    "Feature not implemented"))

(defmethod ctl-show ((type (eql :note)) id &optional params payload)
  (declare (ignore params payload))
  (util:http-response (501)
    "Feature not implemented"))

(defmethod ctl-store ((type (eql :note)) &optional params payload)
  (declare (ignore params payload))
  (util:http-response (501)
    "Feature not implemented"))

(defmethod ctl-update ((type (eql :note)) id &optional params payload)
  (declare (ignore params payload))
  (util:http-response (501)
    "Feature not implemented"))

(defmethod ctl-delete ((type (eql :note)) id &optional params payload)
  (declare (ignore params payload))
  (util:http-response (501)
    "Feature not implemented"))

