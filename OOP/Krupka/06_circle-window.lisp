;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 06_circle-window.lisp - příklad ke kapitole 6
;;;;

#|

Třída circle-window: po kliknutí se kolečko přesune pod myš

Přepisuje metodu window-mouse-down, takže okno nepokračuje
ve standardním zpracování kliknutí (neposílá se zpráva mouse-down,
negeneruje se událost ev-mouse-down).

|#

(defun make-test-circle ()
  (move (set-radius (set-thickness (set-color 
                                    (make-instance 'circle)
                                    :darkslategrey)
                                   30)
                    55)
        148 
        100))

(defclass circle-window (window)
  ())

(defmethod initialize-instance ((w circle-window) &key)
  (call-next-method)
  (set-shape w (make-test-circle)))

(defmethod window-mouse-down 
           ((w circle-window) button position)
  (when (eql button :left)
    (set-x (set-y (center (shape w))
                  (y position))
           (x position)))
  w)


#|

(make-instance 'circle-window)

|#