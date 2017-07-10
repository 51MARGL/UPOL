;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k učebnímu textu M. Krupka: Objektové programování
;;;;
;;;; Kapitola 10, knihovna OMG, verze 2.0
;;;;

#| 
Před načtením souboru načtěte knihovnu micro-graphics
Pokud při načítání (kompilaci) dojde k chybě 
"Reader cannot find package MG",
znamená to, že knihovna micro-graphics není načtená.
|#

#|

DOKUMENTACE
-----------

Obecně je knihovna stejná jako 07.lisp. V implementaci jsou využity
pokročilejší možnosti Lispu. Hlavní úpravy:

- volba :initarg u některých slotů kvůli jednoduššímu vytváření objektů
- metoda initialize-instance přijímá &key parametry z make-instance
  (některé z nich jsou rovnou :initarg slotů, jiné ne; popis viz níže)
- volba :accessor nebo :reader u některých slotů, aby nebylo nutné definovat 
  metody pro vlastnosti objektů. Nastavitelné lastnosti jsou nyní místa, 
  takže k nastavování se používá (setf (vlastnost objekt) ...) místo 
  (set-vlastnost objekt ...) (nekompatibilní změna!)
- kde to bylo možné, místo (call-next-method) použity :before nebo :after
  metody 
- zrušeny metody do-..., místo nich použity kombinace metod (primární a
  :around metody). (nekompatibilní změna!)


MOŽNÉ &KEY PARAMETRY FUNKCE MAKE-INSTANCE
-----------------------------------------

TŘÍDA OMG-OBJECT

:delegate  delegát


TŘÍDA SHAPE

:color      barva
:thickness  tloušťka pera
:filledp    zda výplň
:window     okno


TŘÍDA POINT

:x         kartézská souřadnice x
:y         kartézská souřadnice y
:xy        seznam (x y) - má přednost před předchozími
:r         polární souřadnice r (default 0) - má přednost před předchozími,
           pokud je uvedeno společně s :phi
:phi       polární souřadnice phi (default 0) - má přednost před předchozími,
           pokud je uvedeno společně s :r


TŘÍDA CIRCLE

:center-x  x-ová souřadnice středu (default: 0)
:center-y  y-ová souřadnice středu (default: 0)
:center-xy souřadnice středu ve tvaru (x y) - má přednost před 
           :center-x a :center-y
:radius    poloměr


TŘÍDA COMPOUND-SHAPE

:items     seznam prvků


TŘÍDA PICTURE

nic


TŘÍDA POLYGON

:closedp  vlastnost closedp
:items    jako v compound-shape, každý prvek navíc může být seznam (x y)


TŘÍDA WINDOW

:background  barva pozadí
:shape       grafický objekt (default nil)
|#

;;;
;;; Třída omg-object
;;;

(defclass omg-object () 
  ((delegate :initform nil :accessor delegate :initarg :delegate)
   (change-level :reader change-level)))

(defmethod initialize-instance :around ((obj omg-object) &key)
  ;; Manuálně zabráníme hlášení změn ve všech :before, :after a primárních metodách:
  (setf (slot-value obj 'change-level) 1)
  (call-next-method)
  (setf (slot-value obj 'change-level) 0)
  obj)
  
(defmethod inc-change-level ((obj omg-object))
  (incf (slot-value obj 'change-level))
  obj)

(defmethod dec-change-level ((obj omg-object))
  (decf (slot-value obj 'change-level))
  obj)

(defun has-method-p (object message arguments)
  (and (fboundp message)              ;je se symbolem message 
                                      ;svázána zpráva (funkce)?
       (compute-applicable-methods    ;vypočte seznam metod
        (symbol-function message)     ;pro zprávu svázanou s message
        (cons object arguments))))    ;s danými argumenty

;; posílání událostí: send-event

(defmethod send-event ((object omg-object) event 
		       &rest event-args)
  (let ((delegate (delegate object)))
    (if (and delegate 
             (has-method-p delegate event (cons object event-args)))
        (apply event delegate object event-args)
      object)))

(defmethod change ((object omg-object) message args)
  (if (= (change-level object) 0)
      (send-event object 'ev-change message args)
    object))

(defmethod changing ((object omg-object) message args)
  (if (= (change-level object) 0)
      (send-event object 'ev-changing message args)
    object))

(defun call-with-change (body-function object function-name args)
  (let (result)
    (when (changing object function-name args)
      (unwind-protect
          (progn (inc-change-level object)
            (setf result (funcall body-function)))
        (dec-change-level object))
      (change object function-name args))
    result))

(defmacro with-change ((object function-name arguments) &body body)
  `(call-with-change (lambda () ,@body)
                     ,object
                     ',function-name
                     ,arguments))

;; základní události

(defmethod ev-change 
           ((obj omg-object) sender msg args)
  (change obj msg args))

(defmethod ev-changing 
           ((obj omg-object) sender msg args)
  (changing obj msg args))

(defmethod ev-mouse-down ((obj omg-object) sender clicked-obj button position)
  (send-event obj 'ev-mouse-down clicked-obj button position))

;;;
;;; Třída shape
;;;

(defclass shape (omg-object)
  ((color :initform :black :accessor color :initarg :color)
   (thickness :initform 1 :accessor thickness :initarg :thickness)
   (filledp :initform nil :accessor filledp :initarg :filledp)
   (window :initform nil :accessor window)))

(defmethod shape-mg-window ((shape shape))
  (when (window shape)
    (mg-window (window shape))))

(defmethod (setf color) :around (value (shape shape)) 
  (with-change (shape (setf color) `(,value ,shape))
    (call-next-method)))

(defmethod (setf thickness) :around (value (shape shape))
  (with-change (shape (setf thickness) `(,value))
    (call-next-method)))

(defmethod (setf filledp) :around (value (shape shape))
  (with-change (shape (setf filledp) `(,value ,shape))
    (call-next-method)))

(defmethod move ((shape shape) dx dy)
  shape)

(defmethod move :around ((shape shape) dx dy)
  (with-change (shape move `(,shape ,dx ,dy))
    (call-next-method)))

(defmethod rotate ((shape shape) angle center)
  shape)

(defmethod rotate :around ((shape shape) angle center)
  (with-change (shape rotate `(shape ,angle ,center))
    (call-next-method)))

(defmethod scale ((shape shape) coeff center)
  shape)

(defmethod scale :around ((shape shape) coeff center)
  (with-change (shape scale `(,shape ,coeff ,center))
    (call-next-method)))

(defmethod set-mg-params ((shape shape)) 
  (let ((mgw (shape-mg-window shape)))
    (mg:set-param mgw :foreground (color shape)) 
    (mg:set-param mgw :filledp (filledp shape))
    (mg:set-param mgw :thickness (thickness shape)))
  shape)

(defmethod do-draw ((shape shape)) 
  shape)

(defmethod draw ((shape shape))
  (set-mg-params shape)
  (do-draw shape))


;;; Práce s myší

(defmethod solidp ((shape shape))
  t)

(defmethod solid-shapes ((shape shape))
  (if (solidp shape)
      (list shape)
    (solid-subshapes shape)))

(defmethod solid-subshapes ((shape shape))
  (error "Method has to be rewritten."))

(defmethod contains-point-p ((shape shape) point)
  nil)

(defmethod mouse-down ((shape shape) button position)
  (send-event shape 'ev-mouse-down shape button position))

;;;
;;; Třída point
;;;

(defclass point (shape) 
  ((x :initform 0 :accessor x :initarg :x) 
   (y :initform 0 :accessor y :initarg :y)))

(defmethod initialize-instance :after ((pt point) &key xy r phi)
  (when xy 
    (setf (x pt) (first xy)
          (y pt) (second xy)))
  (when (and r phi)
    (set-r-phi pt r phi)))

(defmethod (setf x) :around (value (point point))
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (with-change (point (setf x) `(,value ,point))
    (call-next-method)))

(defmethod (setf y) :around (value (point point))
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (with-change (point (setf y) `(,value ,point))
    (call-next-method)))

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
  (setf (x point) (* r (cos phi)))
  (setf (y point) (* r (sin phi))))

(defmethod set-r-phi :around ((point point) r phi) 
  (with-change (point set-r-phi `(,point ,r ,phi))
    (call-next-method)))

(defmethod (setf r) (value (point point))
  (set-r-phi point value (phi point)))

(defmethod (setf r) :around (value (point point)) 
  (with-change (point (setf r) `(,value ,point))
    (call-next-method)))

(defmethod (setf phi) (value (point point))
  (set-r-phi point (r point) value))

(defmethod (setf phi) :around (value (point point)) 
  (with-change (point (setf phi) `(,value ,point))
    (call-next-method)))

(defmethod set-mg-params :after ((pt point))
  (mg:set-param (shape-mg-window pt) :filledp t))

(defmethod do-draw ((pt point)) 
  (mg:draw-circle (shape-mg-window pt) 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)

(defmethod move ((pt point) dx dy)
  (incf (x pt) dx)
  (incf (y pt) dy)
  pt)

(defmethod rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (incf (phi pt) angle)
    (move pt cx cy)
    pt))

(defmethod scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (setf (r pt) (* (r pt) coeff))
    (move pt cx cy)
    pt))

;; Práce s myší

;; Pomocné funkce (vzdálenost bodů)

(defun sqr (x)
  (expt x 2))

(defun point-sq-dist (pt1 pt2)
  (+ (sqr (- (x pt1) (x pt2)))
     (sqr (- (y pt1) (y pt2)))))

(defun point-dist (pt1 pt2)
  (sqrt (point-sq-dist pt1 pt2)))

(defmethod contains-point-p ((shape point) point)
  (<= (point-dist shape point) 
      (thickness shape)))

;;;
;;; Třída circle
;;;

(defclass circle (shape) 
  ((center :reader center) 
   (radius :initform 1 :accessor radius :initarg :radius)))

(defmethod initialize-instance :after ((c circle) 
                                       &key (center-x 0) (center-y 0)
                                            (center-xy (list center-x center-y)))
  (setf (slot-value c 'center)
        (make-instance 'point
                       :xy center-xy
                       :delegate c)))

(defmethod (setf radius) :around (value (c circle))
  (when (< value 0)
    (error "Circle radius should be a non-negative number"))
  (with-change (c (setf radius) `(,value ,c))
    (call-next-method)))

(defmethod do-draw ((c circle))
  (mg:draw-circle (shape-mg-window c)
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)

(defmethod move ((c circle) dx dy)
  (move (center c) dx dy))

(defmethod rotate ((c circle) angle center)
  (rotate (center c) angle center))

(defmethod scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (setf (radius c) (* (radius c) coeff)))

;; Práce s myší

(defmethod contains-point-p ((circle circle) point)
  (let ((dist (point-dist (center circle) point))
        (half-thickness (/ (thickness circle) 2)))
    (if (filledp circle)
        (<= dist (radius circle))
      (<= (- (radius circle) half-thickness)
          dist
          (+ (radius circle) half-thickness)))))


;;;
;;; Třída compound-shape
;;;

(defclass compound-shape (shape)
  (items))

(defmethod initialize-instance :after ((cs compound-shape) &key items)
  (setf (items cs) items))

(defmethod items ((shape compound-shape)) 
  (copy-list (slot-value shape 'items)))

(defmethod broadcast ((shape compound-shape) function)
  (dolist (item (items shape))
    (funcall function item)))

(defmethod check-item ((shape compound-shape) item)
  (error "Abstract method."))

(defmethod check-items ((shape compound-shape) item-list)
  (dolist (item item-list)
    (check-item shape item)))

(defmethod (setf items) (value (shape compound-shape))
  (setf (slot-value shape 'items) (copy-list value))
  (broadcast shape (lambda (x) (setf (delegate x) shape))))

(defmethod (setf items) :around (value (shape compound-shape))
  (check-items shape value)
  (with-change (shape (setf items) `(,value ,shape))
    (call-next-method)))

(defmethod move ((shape compound-shape) dx dy)
  (broadcast shape (lambda (item) (move item dx dy))))

(defmethod rotate ((shape compound-shape) angle center)
  (broadcast shape (lambda (item) (rotate item angle center))))

(defmethod scale ((shape compound-shape) coeff center)
  (broadcast shape (lambda (item) (scale item coeff center))))


;;;
;;; Třída picture
;;;

(defclass picture (compound-shape)
  ())

(defmethod check-item ((pic picture) item)
  (unless (typep item 'shape)
    (error "Invalid picture element type."))
  pic)

(defmethod (setf items) :after (value (shape picture))
  (broadcast shape (lambda (item) 
                     (setf (window item) (window shape)))))

(defmethod draw ((pic picture))
  (dolist (item (reverse (items pic)))
    (draw item))
  pic)

(defmethod (setf window) :before (value (shape picture))
  (broadcast shape (lambda (item) 
                     (setf (window item) value))))

;; Práce s myší

(defmethod solidp ((pic picture))
  nil)

(defmethod solid-subshapes ((shape picture))
  (mapcan 'solid-shapes (items shape)))

(defmethod contains-point-p ((pic picture) point)
  (find-if (lambda (item)
	     (contains-point-p item point))
	   (items pic)))


;;;
;;; Třída polygon
;;;

(defclass polygon (compound-shape)
  ((closedp :initform t :accessor closedp :initarg :closedp)))

(defmethod check-item ((poly polygon) item)
  (unless (or (typep item 'point)
              ;; jen pro zajímavost specifikace typu "seznam dvou čísel":
              (typep item '(cons number (cons number null))))
    (error "Invalid polygon element type."))
  poly)

(defmethod make-poly-item ((item point))
  item)

(defmethod make-poly-item ((item list))
  (make-instance 'point :xy item))

(defmethod (setf items) (items (p polygon))
  (call-next-method (mapcar 'make-poly-item items) p))

(defmethod (setf closedp) :around (value (p polygon))
  (with-change (p (setf closedp) `(,value ,p))))

(defmethod set-mg-params ((poly polygon)) 
  (call-next-method)
  (mg:set-param (shape-mg-window poly) 
                :closedp
                (closedp poly))
  poly)

(defmethod do-draw ((poly polygon)) 
  (let (coordinates)
    (dolist (point (reverse (items poly)))
      (setf coordinates (cons (y point) coordinates)
            coordinates (cons (x point) coordinates)))
    (mg:draw-polygon (shape-mg-window poly) 
                     coordinates))
  poly)

;;
;; contains-point-p pro polygon je trochu složitější
;; (není třeba rozumět detailům)
;;

(defun scalar-product (v1 v2)
  (apply '+ (mapcar '* v1 v2)))

(defun scalar-mult (k v)
  (mapcar (lambda (x) (* k x))
          v))

(defun vec-+ (v1 &rest vectors)
  (apply 'mapcar '+ v1 vectors))

(defun vec-- (v1 &rest vectors)
  (apply 'mapcar '- v1 vectors))

(defun vec-= (v1 v2)
  (every '= v1 v2))

(defun vec-sq-len (v)
  (scalar-product v v))

(defun vec-near-p (v1 v2 tolerance)
  (<= (vec-sq-len (vec-- v1 v2))
      (expt tolerance 2)))

(defun pt-in-seg-p (pt x1 x2 tolerance)
  "Zjisti, zda je bod pt na usecce [x1 x2]."
  (let* ((u (vec-- x2 x1))
         (v (vec-- x1 pt))
         (uu (scalar-product u u)))
    (if (zerop uu)
        (vec-near-p pt x1 tolerance)
      (let ((k (- (/ (scalar-product u v) uu))))
        (and (<= 0 k 1)
             (vec-near-p pt (vec-+ x1 (scalar-mult k u)) tolerance))))))

(defun point-in-segs-p (pt tolerance &optional pt1 pt2 &rest points)
  (and pt1 
       pt2
       (or (pt-in-seg-p pt pt1 pt2 tolerance)
           (apply 'point-in-segs-p pt tolerance pt2 points))))

(defun vert-between-p (pt pt1 pt2)
  (let ((pty (second pt))
        (pt1y (second pt1))
        (pt2y (second pt2)))
    (declare (number pty pt1y pt2y))
    (declare (optimize (speed 3) (safety 0)))
    (or (< pt1y pty pt2y)
        (> pt1y pty pt2y)
        ;;u mensiho z pt1y, pt2y umoznime i rovnost
        (and (/= pt1y pt2y)
             (= (min pt1y pt2y) pty)))))

(defun horiz-right-p (pt pt1 pt2)
  (destructuring-bind (ptx pty pt1x pt1y pt2x pt2y) (append pt pt1 pt2)
    (< (+ (* (- pt1x pt2x) 
             (/ (- pty pt2y)
                (- pt1y pt2y)))
          pt2x)
       ptx)))

(defun intersects-p (pt pt1 pt2)
  (and (vert-between-p pt pt1 pt2)
       (horiz-right-p pt pt1 pt2)))

(defun count-intersections (pt &optional pt1 pt2 &rest points)
  (if (and pt1 pt2)
       (+ (if (intersects-p pt pt1 pt2) 1 0)
          (apply 'count-intersections pt pt2 points))
    0))

(defun point-in-poly-p (pt ignore &rest points)
  (declare (ignore ignore))
  (oddp (apply 'count-intersections pt points)))

(defun point-x-y (point)
  (list (x point) (y point)))

(defmethod contains-point-p ((poly polygon) point)
  (let ((items (items poly)))
    (apply (if (filledp poly) 'point-in-poly-p 'point-in-segs-p) 
           (point-x-y point)
           (thickness poly)
           (mapcar 'point-x-y (if (or (closedp poly) (filledp poly))
                                  (append (last items) items)
                                items)))))


;;;
;;; Třída window
;;;

(defclass window (omg-object)
  ((mg-window :initform (mg:display-window) :reader mg-window)
   (shape :initform nil :reader shape)
   (background :initform :white :accessor background
               :initarg :background)))

(defmethod (setf shape) (shape (w window))
  (when shape
    (setf (window shape) w)
    (setf (delegate shape) w))
  (setf (slot-value w 'shape) shape))

(defmethod (setf shape) :around (shape (w window))
  (with-change (w (setf shape) `(,shape ,w))
    (call-next-method)))

(defmethod (setf background) :around (color (w window))
  (with-change (w (setf background) `(,color ,w))
    (call-next-method)))

(defmethod invalidate ((w window))
  (mg:invalidate (mg-window w))
  w)

(defmethod change :after ((w window) function args)
  (invalidate w))

(defmethod redraw ((window window))
  (let ((mgw (mg-window window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window))))
  window)


;; Klikání

(defmethod find-clicked-shape ((w window) position)
  (when (shape w)
    (find-if (lambda (shape) (contains-point-p shape position))
             (solid-shapes (shape w)))))

(defmethod mouse-down-inside-shape ((w window) shape button position)
  (mouse-down shape button position)
  w)

(defmethod mouse-down-no-shape ((w window) button position)
  w)

(defmethod window-mouse-down ((w window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (mouse-down-inside-shape w shape button position)
      (mouse-down-no-shape w button position))))


;; Inicializace

(defmethod install-display-callback ((w window))
  (mg:set-callback (mg-window w)
		   :display (lambda (mgw)
                              (declare (ignore mgw))
                              (redraw w)))
  w)

(defmethod install-mouse-down-callback ((w window))
  (mg:set-callback 
   (mg-window w) 
   :mouse-down (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-mouse-down 
                  w
                  button 
                  (move (make-instance 'point) x y))))
  w)

(defmethod install-callbacks ((w window))
  (install-display-callback w)
  (install-mouse-down-callback w)
  w)

(defmethod initialize-instance :after ((w window) &key shape)
  (setf (shape w) shape)
  (install-callbacks w))

#|

(setf ground (make-instance 'polygon
                            :filledp t
                            :color :green3
                            :items '((0 155) (297 155) (297 275) (0 275))))

(setf tree (make-instance 'picture
                          :items 
                          (list (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(83 63)
                                               :radius 11)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(82 75)
                                               :radius 18)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(67 90)
                                               :radius 15)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(90 97)
                                               :radius 20)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(75 110)
                                               :radius 25)

                                (make-instance 'polygon
                                               :color :brown4
                                               :filledp t
                                               :items '((70 173) (77 75) (85 75) (90 175))))))

(setf sun (make-instance 'circle 
                         :center-xy '(225 38)
                         :radius 18
                         :color :gold
                         :filledp t))

(setf ravens (make-instance 'picture
                            :items (list (make-instance 'polygon
                                                        :filledp nil
                                                        :closedp nil
                                                        :thickness 4
                                                        :color :grey23
                                                        :items '((233 53) (245 47) (252 51) (260 48) (270 57)))
                                         (make-instance 'polygon
                                                        :filledp nil
                                                        :closedp nil
                                                        :thickness 4
                                                        :color :grey23
                                                        :items '((203 73) (215 67) (222 71) (230 68) (240 77)))
                                         (make-instance 'polygon
                                                        :filledp nil
                                                        :closedp nil
                                                        :thickness 4
                                                        :color :grey23
                                                        :items '((183 58) (195 52) (202 56) (210 53) (220 62))))))

(make-instance 'window
               :background :skyblue
               :shape (make-instance 'picture
                                     :items (list ravens sun tree ground)))

(move sun 0 50)
(rotate tree pi (make-instance 'point :x 90 :y 97))
(setf (color ground) :black)

|#