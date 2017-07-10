;; -*- mode: lisp; encoding: utf-8; -*-


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; light.lisp - příklad ke kapitole 4
;;;;

#|

DOKUMENTACE
-----------

Třída light je potomkem třídy circle. Její instance představují kulaté světlo,
které lze zapnout a vypnout. 

UPRAVENÉ ZDĚDĚNÉ VLASTNOSTI

color:      Nenastavovat, je určena pouze ke čtení.

NOVÉ VLASTNOSTI

on-color:   Barva zapnutého světla.
off-color:  Barva vypnutého světla.
onp:        Logická hodnota "světlo je zapnuté"

UPRAVENÉ ZDĚDĚNÉ ZPRÁVY

žádné

NOVÉ ZPRÁVY

set-on      Zapne světlo (bez parametru)
set-off     Vypne světlo (bez parametru)
toggle      Zapnuté světlo vypne, vypnuté zapne (bez parametru)

Projděte si testovací kód na konci souboru.
|#

(defclass light (circle)
  ((onp :initform t)
   (on-color :initform :red)
   (off-color :initform :grey)))

(defmethod onp ((l light))
  (slot-value l 'onp))

(defmethod ensure-color ((l light))
  (set-color l 
             (slot-value l (if (onp l)
                               'on-color
                             'off-color))))

(defmethod initialize-instance ((l light) &key)
  (call-next-method)
  (set-filledp l t)
  (ensure-color l))

(defmethod set-onp ((l light) value)
  (setf (slot-value l 'onp) value)
  (ensure-color l))

(defmethod set-on ((l light))
  (set-onp l t))

(defmethod set-off ((l light))
  (set-onp l nil))

(defmethod toggle ((l light))
  (set-onp l (not (onp l))))

(defmethod on-color ((l light))
  (slot-value l 'on-color))

(defmethod set-on-color ((l light) value)
  (setf (slot-value l 'on-color) value)
  (ensure-color l))

(defmethod off-color ((l light))
  (slot-value l 'off-color))

(defmethod set-off-color ((l light) value)
  (setf (slot-value l 'off-color) value)
  (ensure-color l))

#|
;; Testy třídy light (každý výraz vyhodnocujte zvlášť tlačítkem F8):

(setf w (make-instance 'window))

(setf light (move (set-radius (make-instance 'light)
                              10)
                  0 0))

(set-shape w light)
(redraw w)

(toggle light)
(redraw w)

(set-on-color light :green)
(redraw w)

|#