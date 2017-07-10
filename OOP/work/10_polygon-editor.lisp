;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_polygon-editor.lisp - příklad ke kapitole 10
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 07_polygon-editor.lisp, pouze 
upravený na knihovnu 10.lisp.

polygon-editor - příklad komplexnějšího použití knihovny omg

Kromě standardních souborů vyžaduje načíst soubory:
- 10_bounds.lisp
- 10_text-shape.lisp
- 10_button.lisp

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

(defmethod initialize-instance :around ((c polygon-canvas) &rest args)
  ;; inicializujeme s našimi items:
  (apply #'call-next-method
         c
         :items (list (make-instance 'polygon :closedp nil)
                        (make-instance 'polygon 
                                       :color :light-blue :filledp t
                                       :items '((0 0) (200 0) (200 150) (0 150))))
         args))

(defmethod mouse-down :after ((c polygon-canvas) (button (eql :left)) where)
  (setf (items (canvas-polygon c))
        (cons where (items (canvas-polygon c)))))

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
    (setf (text (info-text e))
          (format nil 
                  "Počet bodů: ~s; closedp: ~s; filledp: ~s; bounds: ~s
color: ~s"
                  (length (items p))
                  (closedp p)
                  (filledp p)
                  (list (left p) (top p) (right p) (bottom p))
                  (color p)))))

(defmethod initialize-instance :after ((e polygon-editor) &key)
  (setf (items e)
        (list
         (make-instance 'polygon-canvas)
         (make-instance 'button :text "Přepnout closedp")
         (make-instance 'button :text "Přepnout filledp")
         (make-instance 'button :text "Změnit barvu")
         (make-instance 'button :text "Vymazat")
         (make-instance 'text-shape)))
  (scale (editor-canvas e) 2.5 (make-instance 'point))
  (update-info-text e))

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

(defmethod (setf window) :after (w (e polygon-editor))
  (update-buttons e)
  (update-info-position e))

(defmethod ev-button-click ((e polygon-editor) sender)
  (cond ((eql sender (closedp-button e))
         (setf (closedp (editor-polygon e))
               (not (closedp (editor-polygon e)))))
        ((eql sender (filledp-button e))
         (setf (filledp (editor-polygon e))
               (not (filledp (editor-polygon e)))))
        ((eql sender (color-button e))
         (setf (color (editor-polygon e))
               (random-color)))
        ((eql sender (clear-button e))
         (setf (items (editor-polygon e)) '()))))

(defmethod ev-change :after ((e polygon-editor) sender changed-obj message args)
  (when (eql changed-obj (editor-polygon e))
    (update-info-text e)))

#|

(setf w (make-instance 'window))

(setf (shape w) (make-instance 'polygon-canvas))
(setf (shape w) (make-instance 'polygon-editor))

;; Tento test vyžaduje načíst soubor 10_changes-window.lisp

(setf w (make-instance 'changes-window))
(setf (shape w) (make-instance 'polygon-editor))

|#
