;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_button.lisp - příklad ke kapitole 10
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 07_button.lisp, pouze 
upravený na knihovnu 10.lisp.

Tlačítko s textem (vlastnost button-text). Po kliknutí levým tlačítkem myši
generuje událost ev-button-click.

Kromě standardních souborů vyžaduje načíst soubory 10_bounds.lisp 
a 10_text-shape.lisp

|#

(defclass button (picture)
  ())

;; Aby tlačítko dostávalo zprávu mouse-down
(defmethod solidp ((b button))
  t)

(defmethod mouse-down :after ((b button) (mouse-button (eql :left)) position)
  ;; Kromě klasického ev-mouse-down ve zděděné metodě generujeme novou událost
  ;; ev-button-click, pokud se kliklo levým myšítkem. Událost nemá parametry.
  ;; Druhý argument obsahuje tzv. "eql specializér". Metoda se zavolá jen
  ;; pokud je roven :left
  (send-event b 'ev-button-click))

(defmethod button-text ((b button))
  (text (first (items b))))

(defmethod recomp-frame ((b button))
  ;; Pokud není nastaveno window, tlačítko není schopné zjistit rozměry
  ;; textu a tedy své rozměry. Podrobnosti ve třídě text-shape.
  (when (window b)
    (setf (items b)
          (list (first (items b))
                (make-instance 'polygon :closedp t :items (but-poly-items b))
                (make-instance 'polygon :filledp t :color :grey90 :items (but-poly-items b))))))

(defmethod (setf button-text) (text (b button))
  (setf (text (first (items b))) text)
  (recomp-frame b))

(defmethod initialize-instance :after ((b button) &key (text "") (x 0) (y 0) (xy (list x y)))
  (setf (items b) (list (make-instance 'text-shape :text text :xy xy))))

(defmethod but-poly-items ((b button))
  (let ((left (- (left (first (items b))) 5))
        (right (+ (right (first (items b))) 5))
        (top (- (top (first (items b))) 5))
        (bottom (+ (bottom (first (items b))) 5)))
    (mapcar (lambda (x y)
              (move (make-instance 'point) x y))
            (list left right right left)
            (list top top bottom bottom))))
                            
(defmethod (setf window) :after (w (b button))
  ;; Zjištění a nastavení rozměrů tlačítka při nastavení okna.
  (recomp-frame b))

#|
(defclass test-window (window)
  ())

(defmethod ev-button-click ((w test-window) button)
  (format t "~%Button ~s clicked " button))

(setf w (make-instance 'test-window))
(setf b (make-instance 'button :x 50 :y 50 :text "Hello Universe"))
(setf (shape w) b)
(setf (button-text b) (format nil "Text~%na~%více~%řádků"))
|#