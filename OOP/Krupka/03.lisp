;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k učebnímu textu M. Krupka: Objektové programování
;;;;
;;;; Kapitola 3, Zapouzdření a polymorfismus
;;;;

#|
Před načtením souboru načtěte knihovnu micro-graphics
Pokud při načítání (kompilaci) dojde k chybě 
"Reader cannot find package MG",
znamená to, že knihovna micro-graphics není načtená.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída point
;;;

(defclass point () 
  ((x :initform 0) 
   (y :initform 0)
   (color :initform :black) 
   (thickness :initform 1) 
   (window :initform nil)))


;;;
;;; Vlastnosti x, y, r, phi
;;;

(defmethod x ((point point))
  (slot-value point 'x))

(defmethod y ((point point))
  (slot-value point 'y))

(defmethod set-x ((point point) value)
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (setf (slot-value point 'x) value)
  point)

(defmethod set-y ((point point) value)
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (setf (slot-value point 'y) value)
  point)

(defmethod r ((point point)) 
  (let ((x (slot-value point 'x)) 
        (y (slot-value point 'y))) 
    (sqrt (+ (* x x) (* y y)))))

(defmethod phi ((point point)) 
  (let ((x (slot-value point 'x)) 
        (y (slot-value point 'y))) 
    (cond ((> x 0) (atan (/ y x))) 
          ((< x 0) (+ pi (atan (/ y x)))) 
          (t (* (signum y) (/ pi 2))))))

(defmethod set-r-phi ((point point) r phi) 
  (setf (slot-value point 'x) (* r (cos phi)) 
        (slot-value point 'y) (* r (sin phi))) 
  point)

(defmethod set-r ((point point) value) 
  (set-r-phi point value (phi point)))

(defmethod set-phi ((point point) value) 
  (set-r-phi point (r point) value))


;;;
;;; Vlastnosti související s kreslením: color, thickness
;;;

(defmethod color ((pt point)) 
  (slot-value pt 'color)) 

(defmethod set-color ((pt point) value) 
  (setf (slot-value pt 'color) value)
  pt) 

(defmethod thickness ((pt point)) 
  (slot-value pt 'thickness)) 

(defmethod set-thickness ((pt point) value) 
  (setf (slot-value pt 'thickness) value)
  pt)

;;;
;;; Práce s oknem
;;;

(defmethod window ((pt point)) 
  (slot-value pt 'window))

(defmethod set-window ((pt point) value) 
  (setf (slot-value pt 'window) value)
  pt)

(defmethod shape-mg-window ((pt point))
  (when (window pt)
    (mg-window (window pt))))


;;;
;;; Kreslení
;;;

;; U bodu kreslíme kruh s poloměrem rovným thickness

(defmethod set-mg-params ((pt point)) 
  (let ((mgw (shape-mg-window pt)))
    (mg:set-param mgw :foreground (color pt)) 
    (mg:set-param mgw :filledp t))
  pt)

(defmethod do-draw ((pt point)) 
  (mg:draw-circle (shape-mg-window pt) 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)

(defmethod draw ((pt point))
  (set-mg-params pt)
  (do-draw pt))


;;;
;;; Geometrické transformace
;;;

(defmethod move ((pt point) dx dy)
  (set-x pt (+ (x pt) dx))
  (set-y pt (+ (y pt) dy))
  pt)

(defmethod rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-phi pt (+ (phi pt) angle))
    (move pt cx cy)
    pt))

(defmethod scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-r pt (* (r pt) coeff))
    (move pt cx cy)
    pt))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída circle
;;;

(defclass circle () 
  ((center :initform (make-instance 'point)) 
   (radius :initform 1)
   (color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (window :initform nil)))


;;;
;;; Základní vlastnosti
;;;

(defmethod radius ((c circle))
  (slot-value c 'radius))

(defmethod set-radius ((c circle) value)
  (when (< value 0)
    (error "Circle radius should be a non-negative number"))
  (setf (slot-value c 'radius) value)
  c)

(defmethod center ((c circle))
  (slot-value c 'center))


;;;
;;; Vlastnosti související s kreslením
;;;

(defmethod color ((c circle))
  (slot-value c 'color))

(defmethod set-color ((c circle) value)
  (setf (slot-value c 'color) value)
  c)

(defmethod thickness ((c circle))
  (slot-value c 'thickness))

(defmethod set-thickness ((c circle) value)
  (setf (slot-value c 'thickness) value)
  c)

(defmethod filledp ((c circle))
  (slot-value c 'filledp))

(defmethod set-filledp ((c circle) value)
  (setf (slot-value c 'filledp) value)
  c)


;;;
;;; Práce s oknem
;;;

(defmethod window ((c circle))
  (slot-value c 'window))

(defmethod set-window ((c circle) value)
  (setf (slot-value c 'window) value)
  c)

(defmethod shape-mg-window ((c circle))
  (when (window c)
    (mg-window (window c))))


;;;
;;; Kreslení
;;;

(defmethod set-mg-params ((c circle))
  (let ((mgw (shape-mg-window c)))
    (mg:set-param mgw :foreground (color c))
    (mg:set-param mgw :thickness (thickness c))
    (mg:set-param mgw :filledp (filledp c)))
  c)

(defmethod do-draw ((c circle))
  (mg:draw-circle (shape-mg-window c)
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)

(defmethod draw ((c circle))
  (set-mg-params c)
  (do-draw c))


;;;
;;; Geometrické transformace
;;;

(defmethod move ((c circle) dx dy)
  (move (center c) dx dy)
  c)

(defmethod rotate ((c circle) angle center)
  (rotate (center c) angle center)
  c)

(defmethod scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (set-radius c (* (radius c) coeff))
  c)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída picture
;;;

(defclass picture ()
  ((items :initform '())
   (window :initform nil)))


;;;
;;; Vlastnost items
;;;

(defmethod items ((pic picture)) 
  (copy-list (slot-value pic 'items)))

(defmethod set-items ((pic picture) value) 
  (unless (every (lambda (elem) 
                   (or (typep elem 'point) 
                       (typep elem 'circle) 
                       (typep elem 'picture)
		       (typep elem 'polygon)))
                 value)
    (error "Invalid picture element type."))
  (setf (slot-value pic 'items) 
        (copy-list value))
  (set-window pic (window pic))
  pic)


;;;
;;; Práce s oknem
;;;

(defmethod window ((pic picture))
  (slot-value pic 'window))

(defmethod set-window ((shape picture) value)
  (dolist (item (items shape))
    (set-window item value))
  (setf (slot-value shape 'window) value)
  shape)

(defmethod shape-mg-window ((p picture))
  (when (window p)
    (mg-window (window p))))

;;;
;;; Kreslení
;;;

(defmethod draw ((pic picture))
  (dolist (item (reverse (items pic)))
    (draw item))
  pic)


;;;
;;; Geometrické transformace
;;;

(defmethod move ((pic picture) dx dy)
  (dolist (item (items pic))
    (move item dx dy))
  pic)

(defmethod rotate ((pic picture) angle center)
  (dolist (item (items pic))
    (rotate item angle center))
  pic)

(defmethod scale ((pic picture) coeff center)
  (dolist (item (items pic))
    (scale item coeff center))
  pic)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída polygon
;;;

(defclass polygon ()
  ((items :initform '())
   (color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (closedp :initform t)
   (window :initform nil)))


;;;
;;; Vlastnost items
;;;

(defmethod items ((poly polygon)) 
  (copy-list (slot-value poly 'items)))

(defmethod set-items ((poly polygon) value) 
  (unless (every (lambda (elem) 
                   (typep elem 'point)) 
                 value)
    (error "Items of polygon should be points."))
  (setf (slot-value poly 'items) 
        (copy-list value))
  poly)


;;;
;;; Vlastnosti pro kreslení
;;;

(defmethod color ((p polygon))
  (slot-value p 'color))

(defmethod set-color ((p polygon) value)
  (setf (slot-value p 'color) value)
  p)

(defmethod thickness ((p polygon))
  (slot-value p 'thickness))

(defmethod set-thickness ((p polygon) value)
  (setf (slot-value p 'thickness) value)
  p)

(defmethod closedp ((p polygon))
  (slot-value p 'closedp))

(defmethod set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value)
  p)

(defmethod filledp ((p polygon))
  (slot-value p 'filledp))

(defmethod set-filledp ((p polygon) value)
  (setf (slot-value p 'filledp) value)
  p)


;;;
;;; Práce s oknem
;;;

(defmethod window ((p polygon))
  (slot-value p 'window))

(defmethod set-window ((p polygon) value)
  (setf (slot-value p 'window) value)
  p)

(defmethod shape-mg-window ((shape polygon))
  (when (window shape)
    (mg-window (window shape))))


;;; 
;;; Kreslení
;;;

(defmethod set-mg-params ((poly polygon)) 
  (let ((mgw (shape-mg-window poly)))
    (mg:set-param mgw :foreground (color poly)) 
    (mg:set-param mgw :thickness (thickness poly)) 
    (mg:set-param mgw :filledp (filledp poly))
    (mg:set-param mgw :closedp (closedp poly)))
  poly)

(defmethod do-draw ((poly polygon)) 
  (let (coordinates)
    (dolist (point (reverse (items poly)))
      (setf coordinates (cons (y point) coordinates))
            coordinates (cons (x point) coordinates))
    (mg:draw-polygon (shape-mg-window poly) 
                     coordinates))
  poly)

(defmethod draw ((poly polygon)) 
  (set-mg-params poly) 
  (do-draw poly))


;;;
;;; Geometrické transformace
;;;

(defmethod move ((poly polygon) dx dy)
  (dolist (item (items poly))
    (move item dx dy))
  poly)

(defmethod rotate ((poly polygon) angle center)
  (dolist (item (items poly))
    (rotate item angle center))
  poly)

(defmethod scale ((poly polygon) coeff center)
  (dolist (item (items poly))
    (scale item coeff center))
  poly)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída window
;;;

(defclass window ()
  ((mg-window :initform (mg:display-window))
   (shape :initform nil)
   (background :initform :white)))


;;;
;;; Vlastnosti
;;;

(defmethod mg-window ((window window))
  (slot-value window 'mg-window))

(defmethod shape ((w window))
  (slot-value w 'shape))

(defmethod set-shape ((w window) shape)
  (when shape
    (set-window shape w))
  (setf (slot-value w 'shape) shape)
  w)

(defmethod background ((w window))
  (slot-value w 'background))

(defmethod set-background ((w window) color)
  (setf (slot-value w 'background) color)
  w)


;;;
;;; Vykreslování
;;;

(defmethod redraw ((window window))
  (let ((mgw (mg-window window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window))))
  window)



;;;;
;;;;
;;;;
;;;;
;;;;
;;;;
;;;;



(defun point-distance (pt1 pt2)
  (sqrt (+ (expt (- (slot-value pt1 'x)
                    (slot-value pt2 'x))
                 2)
           (expt (- (slot-value pt1 'y)
                    (slot-value pt2 'y))
                 2))))

(defclass ellipse ()
  ((focal-point-1 :initform (make-instance 'point))   ;ohnisko 1
   (focal-point-2 :initform (make-instance 'point))   ;ohnisko 2
   (major-semiaxis :initform 1)
   (color :initform :black)
   (thickness :initform 3)
   (filledp :initform nil)
   (window :initform nil)))                     ;délka hlavní poloosy

(defmethod focal-point-1 ((e ellipse))
  (slot-value e 'focal-point-1))

(defmethod focal-point-2 ((e ellipse))
  (slot-value e 'focal-point-2))

(defmethod focal-points-distance ((e ellipse))
  (point-distance (focal-point-1 e)
                  (focal-point-2 e)))

(defmethod major-semiaxis ((e ellipse))
  (slot-value e 'major-semiaxis))

(defmethod set-major-semiaxis ((e ellipse) value)
  (unless (>= value (/ (focal-points-distance e) 2))
    (error ""))
  (setf (slot-value e 'major-semiaxis) value)
  e)

(defmethod minor-semiaxis ((e ellipse))
  (sqrt (- (expt (major-semiaxis e) 2)
           (expt (/ (focal-points-distance e) 2) 2))))

(defmethod set-minor-semiaxis ((e ellipse) value)
  (unless (>= value 0)
    (error ""))
  (set-major-semiaxis e
                      (sqrt (+ (expt value 2)
                               (expt (/ (focal-points-distance e) 2) 2))))
  e)

(defmethod current-center ((e ellipse))
  (let ((result (make-instance 'point)))
    (setf (slot-value result 'x)
          (/ (+ (slot-value (focal-point-1 e) 'x)
                (slot-value (focal-point-2 e) 'x))
             2)
          (slot-value result 'y)
          (/ (+ (slot-value (focal-point-1 e) 'y)
                (slot-value (focal-point-2 e) 'y))
             2))
    result))

(defmethod eccentricity ((e ellipse))
  (/ (focal-points-distance e) (major-semiaxis e) 2))

;;; Metoda to-ellipse třídy circle

(defmethod to-ellipse ((c circle))
  (let ((center (slot-value c 'center))
        (result (make-instance 'ellipse)))
    (setf (slot-value (focal-point-1 result) 'x) (slot-value center 'x)
          (slot-value (focal-point-1 result) 'y) (slot-value center 'y)
          (slot-value (focal-point-2 result) 'x) (slot-value center 'x)
          (slot-value (focal-point-2 result) 'y) (slot-value center 'y))
    (set-major-semiaxis result (slot-value c 'radius))))        





;;;
;;; Vlastnosti související s kreslením
;;;

(defmethod color ((e ellipse))
  (slot-value e 'color))

(defmethod set-color ((e ellipse) value)
  (setf (slot-value e 'color) value)
  e)

(defmethod thickness ((e ellipse))
  (slot-value e 'thickness))

(defmethod set-thickness ((e ellipse) value)
  (setf (slot-value e 'thickness) value)
  e)

(defmethod filledp ((e ellipse))
  (slot-value e 'filledp))

(defmethod set-filledp ((e ellipse) value)
  (setf (slot-value e 'filledp) value)
  e)


;;;
;;; Práce s oknem
;;;

(defmethod window ((e ellipse))
  (slot-value e 'window))

(defmethod set-window ((e ellipse) value)
  (setf (slot-value e 'window) value)
  e)

(defmethod shape-mg-window ((e ellipse))
  (when (window e)
    (mg-window (window e))))


;;;
;;; Kreslení
;;;

(defmethod set-mg-params ((e ellipse))
  (let ((mgw (shape-mg-window e)))
    (mg:set-param mgw :foreground (color e))
    (mg:set-param mgw :thickness (thickness e))
    (mg:set-param mgw :filledp (filledp e)))
  c)

(defmethod do-draw ((e ellipse))
  (mg:draw-ellipse (shape-mg-window e)
                   (x (current-center e))
                   (y (current-center e))
                   (major-semiaxis e)
                   (minor-semiaxis e)
                   0)
  e)

(defmethod draw ((e ellipse))
  (set-mg-params e)
  (do-draw e))


