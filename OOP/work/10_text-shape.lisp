;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_text-shape.lisp - příklad ke kapitole 10
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 07_text-shape.lisp, pouze 
upravený na knihovnu 10.lisp.

text-shape - ukázka definice přímého potomka třídy shape

Třída má několik omezení. 
  - Transformace textu ovlivňují jen jeho umístění, nikoliv orientaci a velikost.
  - Metody zjišťující rozměry lze použít až když je text umístěn v okně. Je to
    proto, že knihovna micro-graphics neumí zjistit rozměry textu bez znalosti 
    okna, ve kterém je umístěn.

Kromě standardních souborů vyžaduje načíst soubor 04_bounds.lisp

|#


(defclass text-shape (shape)
  ((text :initform "" :accessor text :initarg :text)
   (position :reader text-position)))

(defmethod initialize-instance :after ((shape text-shape) 
                                       &key (x 0) (y 0) (xy (list x y)))
  (setf (slot-value shape 'position)
        (make-instance 'point :xy xy))
  (setf (delegate (text-position shape)) shape))

(defmethod (setf text) :around (value (shape text-shape))
  (with-change (shape (setf text) `(,value ,shape))
    (call-next-method)))

(defmethod move ((shape text-shape) dx dy)
  (move (text-position shape) dx dy))

(defmethod scale ((shape text-shape) coeff center)
  (scale (text-position shape) coeff center)
  shape)

(defmethod rotate ((shape text-shape) angle center)
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

(setf ts (make-instance 'text-shape :text "ahoj" :x 100 :y 100))

(setf w (make-instance 'window :shape ts))
(move ts 20 20)

;; test hit-testingu

(defclass my-text-shape (text-shape) ())

(defmethod mouse-down :after ((shape my-text-shape) button where)
  (print "Zásah"))

(change-class ts 'my-text-shape)

;; a zkusit klikat

|#