;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; bulls-eye.lisp - příklad ke kapitole 4
;;;;

#|

DOKUMENTACE
-----------

Třída bulls-eye je potomkem třídy picture. Zobrazuje daný počet soustředných
kruhů nebo čtverců střídavé barvy - terč. Parametry terče lze nastavovat.

UPRAVENÉ ZDĚDĚNÉ VLASTNOSTI

items:      Nenastavovat, je určena pouze ke čtení.

NOVÉ VLASTNOSTI

center:     Geometrický střed, instance třídy point. Defaultně o souřadnicích
            148.5 a 105. Jen ke čtení.
radius:     Poloměr. Pokud je terč čtvercový, je poloměr polovina délky 
            úhlopříčky. Defaultní hodnota: 80.
item-count: Počet kruhů nebo čtverců. Defaultní hodnota je 7.
squarep:    Booleovská hodnota určující, zda je terč kruhový, nebo čtvercový.
            Default: nil.

UPRAVENÉ ZDĚDĚNÉ ZPRÁVY

žádné

NOVÉ ZPRÁVY

žádné.

|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(defun make-bulls-eye-elem (radius squarep)
  (if squarep 
      (make-bulls-eye-square radius)
    (set-radius (make-instance 'circle) radius)))

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

(defmethod set-radius ((be bulls-eye) value)
  (setf (slot-value be 'radius) value)
  (be-recompute-items be))

(defmethod item-count ((be bulls-eye))
  (slot-value be 'item-count))

(defmethod set-item-count ((be bulls-eye) value)
  (setf (slot-value be 'item-count) value)
  (be-recompute-items be))

(defmethod squarep ((be bulls-eye))
  (slot-value be 'squarep))

(defmethod set-squarep ((be bulls-eye) value)
  (setf (slot-value be 'squarep) value)
  (be-recompute-items be))

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


;;; Testy
(setf w (make-instance 'window))
(setf be (make-instance 'bulls-eye))
(set-shape w be)
(redraw w)

(set-radius be 100)
(redraw w)

(set-item-count be 5)
(redraw w)

(set-squarep be t)
(redraw w)




