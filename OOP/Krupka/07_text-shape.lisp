;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_text-shape.lisp - příklad ke kapitole 7
;;;;

#|

text-shape - ukázka definice přímého potomka třídy shape

Třída má několik omezení. 
  - Transformace textu ovlivňují jen jeho umístění, nikoliv orientaci a velikost.
  - Metody zjišťující rozměry lze použít až když je text umístěn v okně. Je to
    proto, že knihovna micro-graphics neumí zjistit rozměry textu bez znalosti 
    okna, ve kterém je umístěn.

Kromě standardních souborů vyžaduje načíst soubor 04_bounds.lisp

|#


(defclass text-shape (shape)
  ((text :initform "")
   (position :initform (make-instance 'point))))

(defmethod text ((shape text-shape))
  (slot-value shape 'text))

(defmethod text-position ((shape text-shape))
  (slot-value shape 'position))

(defmethod initialize-instance ((shape text-shape) &key)
  (call-next-method)
  (set-delegate (text-position shape) shape)
  shape)

(defmethod do-set-text ((shape text-shape) value)
  (setf (slot-value shape 'text) value))

(defmethod set-text ((shape text-shape) value)
  (send-with-change shape
                    'do-set-text 'set-text
                    `(,value)))

(defmethod do-move ((shape text-shape) dx dy)
  (move (text-position shape) dx dy))

(defmethod do-scale ((shape text-shape) coeff center)
  (scale (text-position shape) coeff center))

(defmethod do-rotate ((shape text-shape) angle center)
  (rotate (text-position shape) angle center))

(defmethod left ((shape text-shape))
  (+ (first (mg:get-string-extent (shape-mg-window shape)
                                  (text shape)))
     (x (text-position shape))))

(defmethod top ((shape text-shape))
  (+ (second (mg:get-string-extent (shape-mg-window shape)
                                   (text shape)))
     (y (text-position shape))))

(defmethod right ((shape text-shape))
  (+ (third (mg:get-string-extent (shape-mg-window shape)
                                  (text shape)))
     (x (text-position shape))))

(defmethod bottom ((shape text-shape))
  (+ (fourth (mg:get-string-extent (shape-mg-window shape)
                                   (text shape)))
     (y (text-position shape))))

(defmethod contains-point-p ((shape text-shape) point)
  (and (<= (left shape) (x point) (right shape))
       (<= (top shape) (y point) (bottom shape))))


(defmethod do-draw ((shape text-shape)) 
  (mg:draw-string (shape-mg-window shape)
                  (text shape)
                  (x (text-position shape)) 
                  (y (text-position shape))) 
  shape)

#|

(setf ts (make-instance 'text-shape))
(set-text ts "ahoj")
(move ts 100 100)

(setf w (make-instance 'window))
(set-shape w ts)
(move ts 20 20)

(defclass my-text-shape (text-shape) ())

(defmethod mouse-down ((shape my-text-shape) button where)
  (call-next-method)
  (print "Zásah")
  shape)

(setf ts (make-instance 'my-text-shape))
(set-shape w ts)
(move ts 20 20)
(set-text ts "ahoj")

|#