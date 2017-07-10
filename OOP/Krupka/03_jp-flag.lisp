;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Japonská vlajka
;;;;
;;;; příklad ke kapitole 3
;;;;

(defun jp-flag-items ()
  (let ((circle (make-instance 'circle))
        (poly1 (make-instance 'polygon))
        (poly2 (make-instance 'polygon)))
    (set-radius circle 36)
    (move circle 110 80)
    (set-filledp circle t)
    (set-color circle :red)

    (set-items poly1 (mapcar (lambda (coords)
                               (apply #'move (make-instance 'point) coords))
                             '((20 20) (200 20) (200 140) (20 140))))
    (set-items poly2 (mapcar (lambda (coords)
                               (apply #'move (make-instance 'point) coords))
                             '((20 20) (200 20) (200 140) (20 140))))
    (set-color poly2 :white)
    (set-filledp poly2 t)

    (list circle poly1 poly2)))

(defun display-jp-flag ()
  (let ((w (make-instance 'window))
        (shape (make-instance 'picture)))
    (set-background w :skyblue)
    (set-items shape (jp-flag-items))
    (set-shape w shape)
    (redraw w)
    w))


;; Testy: (vyhodnocujte postupně každý řádek)

(setf w (display-jp-flag))
(move (shape w) 10 10)
(redraw w)
(setf center (make-instance 'point))
(move center 10 10)
(scale (shape w) 2 center)
(redraw w)
(rotate (shape w) (/ pi 4) center)
(redraw w)

