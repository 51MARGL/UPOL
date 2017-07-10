;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 07_polygon-editor.lisp - příklad ke kapitole 7
;;;;

#|

polygon-editor - ukázka komplexnějšího příkladu použití knihovny omg

Kromě standardních souborů vyžaduje načíst soubory:
- 04_bounds.lisp
- 07_text-shape.lisp
- 07_button.lisp

|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; polygon-canvas
;;;

(defclass polygon-canvas (picture)
  ())

(defmethod canvas-polygon ((c polygon-canvas))
  (first (items c)))

(defmethod canvas-background ((c polygon-canvas))
  (second (items c)))

(defmethod solidp ((c polygon-canvas))
  t)

;;
;; Jednoduchá ochrana seznamu prvků objektů polygon-canvas.
;;

(defmethod check-item ((c polygon-canvas) item)
  (unless (typep item 'polygon)
    (error "Canvas items must be polygons")))

(defmethod check-items ((c polygon-canvas) item-list)
  (call-next-method)
  (unless (= (length item-list) 2)
    (error "Invalid count of canvas items")))

(defmethod initialize-instance ((c polygon-canvas) &key)
  (call-next-method)
  (set-items c (list (set-closedp (make-instance 'polygon) nil)
                     (set-items (set-filledp (set-color (make-instance 'polygon)
                                                        :light-blue)
                                             t)
                                (mapcar (lambda (x y)
                                          (move (make-instance 'point)
                                                x
                                                y))
                                        '(0 200 200 0)
                                        '(0 0 150 150))))))

(defmethod mouse-down ((c polygon-canvas) button where)
  (call-next-method)
  (when (eql button :left)
    (set-items (canvas-polygon c)
               (cons where (items (canvas-polygon c))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; polygon-editor
;;;
;;; Používá nahoře definovaný polygon-canvas, který ovšem rovněž funguje
;;; samostatně.
;;;

(defclass polygon-editor (picture)
  ())

(defmethod editor-canvas ((e polygon-editor))
  (first (items e)))

(defmethod editor-polygon ((e polygon-editor))
  (canvas-polygon (editor-canvas e)))

(defmethod closedp-button ((e polygon-editor))
  (second (items e)))

(defmethod filledp-button ((e polygon-editor))
  (third (items e)))

(defmethod color-button ((e polygon-editor))
  (fourth (items e)))

(defmethod clear-button ((e polygon-editor))
  (fifth (items e)))

(defmethod info-text ((e polygon-editor))
  (sixth (items e)))

(defmethod update-info-text ((e polygon-editor))
  (let ((p (editor-polygon e)))
    (set-text (info-text e)
              (format nil 
                      "Počet bodů: ~s; closedp: ~s; filledp: ~s; bounds: ~s"
                      (length (items p))
                      (closedp p)
                      (filledp p)
                      (list (left p) (top p) (right p) (bottom p))))
    e))

(defmethod initialize-instance ((e polygon-editor) &key)
  (call-next-method)
  (set-items e
             (list
              (scale (make-instance 'polygon-canvas) 2.5 (make-instance 'point))
              (make-instance 'button)
              (make-instance 'button)
              (make-instance 'button)
              (make-instance 'button)
              (make-instance 'text-shape)))
  (set-button-text (closedp-button e) "Přepnout closedp")
  (set-button-text (filledp-button e) "Přepnout filledp")
  (set-button-text (color-button e) "Změnit barvu")
  (set-button-text (clear-button e) "Vymazat")
  (update-info-text e)
  e)

(defun update-ed-button (button prev-button canvas)
  (let ((c-bottom (bottom canvas)))
    ;; Vždy rozdíl nová-pozice - stará-pozice
    (move button
          (- (+ (if prev-button (right prev-button) 0)
                5)
             (left button))
          (- (+ c-bottom 5)
             (top button)))))

(defmethod update-buttons ((e polygon-editor))
  "Nastavení správné polohy tlačítek. Volá se z set-window. (a funguje jedině když je okno nastaveno)"
  (let ((c (editor-canvas e)))
    (update-ed-button (closedp-button e) nil c)
    (update-ed-button (filledp-button e) (closedp-button e) c)
    (update-ed-button (color-button e) (filledp-button e) c)
    (update-ed-button (clear-button e) (color-button e) c)
    (update-ed-button (info-text e) (clear-button e) c))
  e)

(defmethod update-info-position ((e polygon-editor))
  (let ((text (info-text e))
        (btn (closedp-button e)))
    (move text
          (- (left btn) (left text))
          (- (+ (bottom btn) 5)
             (top text))))
  e)

(defmethod set-window ((e polygon-editor) w)
  (call-next-method)
  (update-buttons e)
  (update-info-position e)
  e)

(defmethod ev-button-click ((e polygon-editor) sender)
  (cond ((eql sender (closedp-button e))
         (set-closedp (editor-polygon e)
                      (not (closedp (editor-polygon e)))))
        ((eql sender (filledp-button e))
         (set-filledp (editor-polygon e)
                      (not (filledp (editor-polygon e)))))
        ((eql sender (color-button e))
         (set-color (editor-polygon e)
                    (random-color)))
        ((eql sender (clear-button e))
         (set-items (editor-polygon e) '()))))

(defmethod ev-change ((e polygon-editor) sender message changed-obj args)
  (call-next-method)
  (when (eql sender (editor-canvas e))
    (update-info-text e)))

#|

(setf w (make-instance 'window))

(set-shape w (make-instance 'polygon-canvas))

(set-shape w (make-instance 'polygon-editor))

|#
