;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_cwa.lisp - příklad ke kapitole 10
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 07_cwa.lisp, pouze 
upravený na knihovnu 10.lisp.

Třída circle-with-arrow. 
Jednoduchá ukázka použití objektu jako tlačítka.

Kromě standardních souborů vyžaduje načíst soubor 10_click-circle.lisp

|#

(defun make-arrow (color)
  (make-instance 'polygon
                 :filledp t :closedp t :color color
                 :items '((0 -30) (0 -15) (30 -15) (30 15) (0 15) (0 30) (-30 0))))

(defun cwa-items ()
  (list (make-instance 'click-circle :radius 40 :filledp t :center-xy '(148 60))
        (move (rotate (make-arrow :blue)
                      (/ pi 2)
                      (make-instance 'point))
              148
              150)))

(defclass circle-with-arrow (picture)
  ())

(defmethod initialize-instance :after ((pic circle-with-arrow) &key)
  (setf (items pic) (cwa-items)))

(defmethod cwa-circle ((p circle-with-arrow))
  (first (items p)))

(defmethod cwa-arrow ((p circle-with-arrow))
  (second (items p)))

(defmethod ev-mouse-down :before ((p circle-with-arrow) sender origin button position)
  (when (eql sender (cwa-arrow p))
    (move (cwa-circle p) 0 -10)))

#|
(setf w (make-instance 'window :shape (make-instance 'circle-with-arrow)))
|#