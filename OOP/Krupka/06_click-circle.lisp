;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 06_click-circle.lisp - příklad ke kapitole 6
;;;;

#|

Třída click-circle. Kolečko po kliknutí změní barvu.

|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))


(defclass click-circle (circle) ())

(defmethod mouse-down ((circ click-circle) button position) 
  (set-color circ (random-color)) 
  (call-next-method))


#|

(defun make-test-click-circle ()
  (set-filledp (set-radius (make-instance 'click-circle)
                           45)
               t))

(setf w (make-instance 'window))
(setf c (move (make-test-click-circle) 148 100))
(set-shape w c)

(setf circles (make-instance 'picture))
(set-items circles
           (list (move (make-test-click-circle) 103 55)
                 (move (make-test-click-circle) 193 55)
                 (move (make-test-click-circle) 103 145)
                 (move (make-test-click-circle) 193 145)))
(set-shape w circles)

|#