;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_bulls-eye.lisp - příklad ke kapitole 7
;;;;

#|

Vylepšení třídy bulls-eye ze souboru 04_bulls-eye.lisp o hlášení změn

|#


;;;
;;; Funkce na výpočet obsahu (procedurální)
;;;

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

(defun make-bulls-eye-circle (radius)
  (set-radius (make-instance 'circle) radius))

(defun make-bulls-eye-elem (radius squarep)
  (if squarep 
      (make-bulls-eye-square radius)
    (make-bulls-eye-circle radius)))

(defun make-bulls-eye-items (x y radius count squarep)
  (let ((items '())
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
    items))

;;;
;;; Vlastní třída bulls-eye
;;;

(defclass bulls-eye (picture)
  ((center :initform (make-instance 'point))
   (radius :initform 80) 
   (item-count :initform 7)
   (squarep :initform nil)))

;;;
;;; Vlastnosti
;;;

;; Vlastnost center je jen ke čtení
(defmethod center ((be bulls-eye))
  (slot-value be 'center))

(defmethod radius ((be bulls-eye))
  (slot-value be 'radius))

(defmethod do-set-radius ((be bulls-eye) value)
  (setf (slot-value be 'radius) value)
  (be-recompute-items be))

(defmethod set-radius ((be bulls-eye) value)
  (send-with-change be
                    'do-set-radius 'set-radius
                    `(,value)))

(defmethod item-count ((be bulls-eye))
  (slot-value be 'item-count))

(defmethod do-set-item-count ((be bulls-eye) value)
  (setf (slot-value be 'item-count) value)
  (be-recompute-items be))

(defmethod set-item-count ((be bulls-eye) value)
  (send-with-change be
                    'do-set-item-count 'set-item-count
                    `(,value)))

(defmethod squarep ((be bulls-eye))
  (slot-value be 'squarep))

(defmethod do-set-squarep ((be bulls-eye) value)
  (setf (slot-value be 'squarep) value)
  (be-recompute-items be))

(defmethod set-squarep ((be bulls-eye) value)
  (send-with-change be
                    'do-set-squarep 'set-squarep
                    `(,value)))

(defmethod be-recompute-items ((be bulls-eye))
  (set-items be 
             (make-bulls-eye-items (x (center be))
                                   (y (center be))
                                   (radius be)
                                   (item-count be)
                                   (squarep be))))

;;;
;;; Inicializace
;;;

(defmethod initialize-instance ((be bulls-eye) &key)
  (call-next-method)
  (move (center be) 148.5 105)
  (be-recompute-items be))

#|
;;; Testy
(setf w (make-instance 'window))
(setf be (make-instance 'bulls-eye))
(set-shape w be)

(set-radius be 100)

(set-item-count be 5)

(set-squarep be t)
(set-squarep be nil)
|#

