;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_button.lisp - příklad ke kapitole 7
;;;;

#|

Tlačítko s textem (vlastnost button-text). Po kliknutí levým tlačítkem myši
generuje událost ev-button-click.

Kromě standardních souborů yžaduje načíst soubory 04_bounds.lisp 
a 07_text-shape.lisp

|#

(defclass button (picture)
  ())

;; Aby tlačítko dostávalo zprávu mouse-down
(defmethod solidp ((b button))
  t)

(defmethod mouse-down ((b button) mouse-button position)
  (call-next-method)
  ;; Kromě klasického ev-mouse-down ve zděděné metodě generujeme novou událost
  ;; ev-button-click, pokud se kliklo levým myšítkem. Událost nemá parametry.
  (when (eql mouse-button :left)
    (send-event b 'ev-button-click))
  b)

(defmethod button-text ((b button))
  (text (first (items b))))

(defmethod recomp-frame ((b button))
  ;; Pokud není nastaveno window, tlačítko není schopné zjistit rozměry
  ;; textu a tedy své rozměry. Podrobnosti ve třídě text-shape.
  (when (window b)
    (set-items b
               (list (first (items b))
                     (set-items (set-closedp (make-instance 'polygon)
                                             t)
                                (but-poly-items b))
                     (set-items (set-filledp (set-color (make-instance 'polygon)
                                                        :grey90)
                                             t)
                                (but-poly-items b)))))
  b)

(defmethod set-button-text ((b button) text)
  (set-text (first (items b)) text)
  (recomp-frame b))

(defmethod initialize-instance ((b button) &key)
  (call-next-method)
  (set-items b (list (make-instance 'text-shape))))

(defmethod but-poly-items ((b button))
  (let ((left (- (left (first (items b))) 5))
        (right (+ (right (first (items b))) 5))
        (top (- (top (first (items b))) 5))
        (bottom (+ (bottom (first (items b))) 5)))
    (mapcar (lambda (x y)
              (move (make-instance 'point) x y))
            (list left right right left)
            (list top top bottom bottom))))
                            
(defmethod set-window ((b button) w)
  (call-next-method)
  ;; Zjištění a nastavení rozměrů tlačítka při nastavení okna.
  (recomp-frame b))

#|
(setf w (make-instance 'window))
(setf b (move (make-instance 'button) 50 50))
(set-shape w b)
(set-button-text b "Storno")

|#