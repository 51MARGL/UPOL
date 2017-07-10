;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_bounds.lisp - příklad ke kapitole 10
;;;;


#|

Jedná se o stejný zdrojový kód jako v souboru 04_bounds.lisp, pouze 
upravený na knihovnu 10.lisp.

Rozšíření třídy shape a jejích potomků o metody left, top, right, bottom.

|#

(defmethod left ((shape shape))
  +1D++0 #| +1D++0 is double-float plus-infinity |#)

(defmethod top ((shape shape))
  +1D++0 #| +1D++0 is double-float plus-infinity |#)

(defmethod right ((shape shape))
  -1D++0 #| -1D++0 is double-float minus-infinity |#)

(defmethod bottom ((shape shape))
  -1D++0 #| -1D++0 is double-float minus-infinity |#)

(defmethod left ((shape point))
  (x shape))

(defmethod top ((shape point))
  (y shape))

(defmethod right ((shape point))
  (x shape))

(defmethod bottom ((shape point))
  (y shape))

(defmethod left ((shape circle))
  (- (x (center shape)) (radius shape)))

(defmethod top ((shape circle))
  (- (y (center shape)) (radius shape)))

(defmethod right ((shape circle))
  (+ (x (center shape)) (radius shape)))

(defmethod bottom ((shape circle))
  (+ (y (center shape)) (radius shape)))

(defmethod left ((shape compound-shape))
  ;; reduce je v tomto případě ekvivalentní s apply,
  ;; ale bezpečnější. Detaily nejsou podstatné.
  (reduce 'min 
          (mapcar 'left (items shape))
          :initial-value (call-next-method)))

(defmethod top ((shape compound-shape))
  (reduce 'min 
          (mapcar 'top (items shape))
          :initial-value (call-next-method)))

(defmethod right ((shape compound-shape))
  (reduce 'max 
          (mapcar 'right (items shape))
          :initial-value (call-next-method)))

(defmethod bottom ((shape compound-shape))
  (reduce 'max 
          (mapcar 'bottom (items shape))
          :initial-value (call-next-method)))

