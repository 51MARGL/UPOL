;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Vylepšený terč
;;;;
;;;; příklad ke kapitole 3
;;;;

(defun make-bulls-eye-square (radius)
  (let ((tl (make-instance 'point))
        (tr (make-instance 'point))
        (bl (make-instance 'point))
        (br (make-instance 'point))
        (half-side (/ radius (sqrt 2)))
        (result (make-instance 'polygon)))
    (set-items result
               (list (move tl (- half-side) (- half-side))
                     (move tr half-side (- half-side))
                     (move br half-side half-side)
                     (move bl (- half-side) half-side)))))

(defun make-bulls-eye-elem (radius squarep)
  (if squarep 
      (make-bulls-eye-square radius)
    (set-radius (make-instance 'circle) radius)))

(defun make-bulls-eye (x y radius count squarep)
  (let ((result (make-instance 'picture))
        (items '())
        (step (/ radius count))
	(blackp t)
        elem)
    (dotimes (i count)
      (setf elem (set-filledp 
                    (set-color 
                     (make-bulls-eye-elem (- radius (* i step)) squarep)
                     (if blackp :black :light-blue)) 
                    t))
      (move elem x y)
      (setf items (cons elem items)
            blackp (not blackp)))
    (set-items result items)))


;; Testy: (vyhodnocujte postupně každý řádek)

(setf w (make-instance 'window))
(setf shape1 (make-bulls-eye 148.5 105 80 7 nil))
(set-shape w shape1)
(redraw w)

(setf shape2 (make-bulls-eye 148.5 105 80 7 t))
(set-shape w shape2)
(redraw w)

(setf center (move (make-instance 'point) 148.5 105))
(setf pic (make-instance 'picture))
(set-items pic (list (move (scale shape1 0.8 center) 70 0)
                     (move (scale (rotate shape2 (/ pi 4) center) 0.8 center) -70 0)))

(set-shape w pic)
(redraw w)

