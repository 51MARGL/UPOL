;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_changes-window.lisp - příklad ke kapitole 7
;;;;

#|

Třída changes-window 
Okno, které tiskne informaci o všech změnách uvnitř něj.

Test vyžaduje načtení souboru 07_bulls-eye.lisp a současně testuje třídu 
bulls-eye.

|#

(defclass changes-window (window)
  ())

(defmethod print-change ((w changes-window) change-type message changing-obj args)
  (format t "~%Změna ~s: ~s. " change-type (cons message (cons changing-obj args))))

(defmethod changing ((w changes-window) message changing-obj args)
  (call-next-method)
  (print-change w :changing message changing-obj args)
  w)

(defmethod change ((w changes-window) message changing-obj args)
  (call-next-method)
  (print-change w :change message changing-obj args)
  w)



(setf w (make-instance 'changes-window))
(set-shape w (make-instance 'bulls-eye))

(move (shape w) 10 0)
(set-squarep (shape w) t)

