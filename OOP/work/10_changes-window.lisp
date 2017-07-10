;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_changes-window.lisp - příklad ke kapitole 10
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 10_changes-window.lisp, pouze 
upravený na knihovnu 10.lisp.

Třída changes-window 
Okno, které tiskne informaci o všech změnách uvnitř něj.

|#

(defclass changes-window (window)
  ())

(defmethod print-change ((w changes-window) change-type message args)
  (format t "~%Změna ~s: ~s. " change-type (cons message args)))

(defmethod changing ((w changes-window) changing-obj message args)
  (call-next-method)
  (print-change w :changing message args)
  w)

(defmethod change ((w changes-window) changing-obj message args)
  (call-next-method)
  (print-change w :change message args)
  w)

#|

(setf w (make-instance 'changes-window
                       :shape (make-instance 'circle 
                                             :center-x 50 :center-y 50 
                                             :filledp t :radius 25)))

(move (shape w) 10 0)
(setf (filledp (shape w)) nil)

Rozsáhlejší test je v souboru 10_polygon-editor.lisp

|#