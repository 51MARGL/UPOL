;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_click-circle.lisp - příklad ke kapitole 10
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 06_click-circle.lisp, pouze 
upravený na knihovnu 10.lisp.

Třída click-circle. Kolečko po kliknutí levým tlačítkem změní barvu.

|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))


(defclass click-circle (circle) 
  ()
  (:default-initargs :filledp t))

(defmethod mouse-down :after ((circ click-circle) (button (eql :left)) position) 
  (setf (color circ) (random-color)))


#|

(defun make-test-click-circle ()
  (make-instance 'click-circle :radius 45))

(setf w (make-instance 'window :shape (move (make-test-click-circle) 148 100)))
(setf c (move (make-test-click-circle) 150 100))
(setf (shape w) c)

(setf circles (make-instance 'picture :items
      (list (move (make-test-click-circle) 103 55)
            (move (make-test-click-circle) 193 55)
            (move (make-test-click-circle) 103 145)
            (move (make-test-click-circle) 193 145))))
(setf (shape w) circles)

|#