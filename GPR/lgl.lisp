;; -*- mode: lisp; encoding: utf-8; -*-

;; Pomocné funkce
(defun cycle-list (list)
  (append (rest list) (list (first list))))

;; Body

(defclass point ()
  ((coordinates :reader coordinates :initarg :coordinates)))

(defun point (x-coordinate &rest rest-coordinates)
  (unless (every #'numberp (cons x-coordinate rest-coordinates))
    (error "The coordinates must be numbers."))
  (make-instance 'point :coordinates (cons x-coordinate rest-coordinates)))

(defun af-point (x-coordinate &rest rest-coordinates)
  (unless (= (first (last rest-coordinates)) 1)
    (error "Affine coordinates of the points must end with 1"))
  (apply 'point x-coordinate (butlast rest-coordinates)))

(defmethod dimension ((point point))
  (length (coordinates point)))

(defmethod af-coordinates ((point point))
  (append (coordinates point) '(1)))


(defmethod x ((point point))
  (first (coordinates point)))

(defmethod y ((point point))
  (unless (>= (dimension point) 2)
    (error "The point must have dimension at least two."))
  (second (coordinates point)))

(defmethod z ((point point))
  (unless (>= (dimension point) 3)
    (error "The point must have dimension at least three."))
  (third (coordinates point)))

(defmethod print-object ((p point) stream)
  (print-unreadable-object (p stream :type t :identity t)
    (format stream "~A" (coordinates p))))


;; Vektory

(defclass vect ()
  ((coordinates :reader coordinates :initarg :coordinates)))

(defun vect (x-coordinate &rest rest-coordinates)
  (unless (every #'numberp (cons x-coordinate rest-coordinates))
    (error "The coordinates must be numbers."))
  (make-instance 'vect :coordinates (cons x-coordinate rest-coordinates)))

(defun af-vect (x-coordinate &rest rest-coordinates)
  (unless (= (first (last rest-coordinates)) 0)
    (error "Affine coordinates of the points must end with 0"))
  (apply 'vect x-coordinate (butlast rest-coordinates)))

(defmethod af-coordinates ((vector vect))
  (append (coordinates vector) '(0)))

(defmethod dimension ((vector vect))
  (length (coordinates vector)))

(defmethod x ((vector vect))
  (first (coordinates vector)))

(defmethod y ((vector vect))
  (unless (>= (dimension vector) 2)
    (error "The vector must have dimension at least two."))
  (second (coordinates vector)))

(defmethod z ((vector vect))
  (unless (>= (dimension vector) 3)
    (error "The vector must have dimension at least three."))
  (third (coordinates vector)))

;; Operace s body a vektory

(defmethod minus ((p1 point) (p2 point))
  (unless (= (dimension p1) (dimension p2))
    (error "Points must have the same dimension."))
  (apply #'vect 
         (mapcar #'- 
                 (coordinates p1)
                 (coordinates p2))))

(defmethod plus ((p point) (v vect))
  (unless (= (dimension p) (dimension v))
    (error "The point must have the same dimenstion as the vector."))
  (apply #'point 
         (mapcar #'+ 
                 (coordinates p)
                 (coordinates v))))

(defmethod plus ((v1 vect) (v2 vect))
  (unless (= (dimension v1) (dimension v2))
    (error "Vectors must have the same dimenstion."))
  (apply #'vect 
         (mapcar #'+ 
                 (coordinates v1)
                 (coordinates v2))))

(defmethod mult (coef (v vect))
  (apply #'vect (mapcar (lambda (coord) (* coef coord)) (coordinates v))))

(defmethod phi ((vector vect))
  (unless (= (dimension vector) 2)
    (error "The vector must have dimension two."))
  (let ((x (x vector))
        (y (y vector)))
    (cond
     ((plusp x) (atan (/ y x))) 
     ((minusp x) (+ pi (atan (/ y x)))) 
     (t (* (signum y) (/ pi 2))))))

(defmethod rotate ((vector vect) angle &optional (rotation-vector (vect 0 0 1)))
  (unless (<= 2 (dimension vector) 3)
    (error "The vector must have dimension two or three."))
  (if (= (dimension vector) 2)
      (let ((phi (+ (phi vector) angle))
            (r (sqrt (+ (expt (x vector) 2)
                        (expt (y vector) 2)))))
        (vect (* r (cos phi))
              (* r (sin phi))))
    (progn
      (unless (= (dimension rotation-vector) 3)
        (error "rotation-vector must have dimension three."))
      (let* ((r-vector (normalize rotation-vector))
             (x (x r-vector))
             (y (y r-vector))
             (z (z r-vector))
             (vx (x vector))
             (vy (y vector))
             (vz (z vector))
             (c (cos angle))
             (s (sin angle)))
        (vect
         (+
          (* vx
             (+ 
              (* x x (- 1 c))
              c))
          (* vy
             (- 
              (* x y (- 1 c))
              (* z s)))
          (* vz
             (+
              (* x z (- 1 c))
              (* y s))))
         (+
          (* vx
             (+ (* y x (- 1 c))
                (* z s)))
          (* vy
             (+ (* y y (- 1 c))
                c))
          (* vz
             (- (* y z (- 1 c))
                (* x s))))
         (+
          (* vx
             (- (* z x (- 1 c))
                (* y s)))
          (* vy
             (+ (* z y (- 1 c))
                (* x s)))
          (* vz
             (+ (* z z (- 1 c))
                c))))))))

(defmethod cross-product ((u vect) (v vect))
  (unless (= 3 (dimension u) (dimension v))
    (error "The vectors must have dimension three."))
  (vect (- (* (y u) (z v))
           (* (z u) (y v)))
        (- (* (z u) (x v))
           (* (x u) (z v)))
        (- (* (x u) (y v))
           (* (y u) (x v)))))

(defmethod dot-product ((u1 vect) (u2 vect))
  (unless (= (dimension u1)
             (dimension u2))
    (error "The vectors must have the same dimension."))
  (reduce #'+ (mapcar #'* (coordinates u1) (coordinates u2))))

(defmethod norm ((u vect))
  (sqrt (dot-product u u)))

(defmethod normalize (u)
  (mult (/ 1 (norm u)) u))

(defmethod minus-origin ((p point))
  (minus p (apply #'point (make-list (dimension p) :initial-element 0))))

(defmethod plus-origin ((v vect))
  (plus (apply #'point (make-list (dimension v) :initial-element 0)) v))
 
(defmethod print-object ((v vect) stream)
  (print-unreadable-object (v stream :type t :identity t)
    (format stream "~A" (coordinates v))))


;; OpenGL
(defvar *inside-opengl-block* nil)
(defvar *canvas*)

(defun resize-canvas (canvas x y width height)
  (declare (ignore x y))
  (opengl:rendering-on (canvas)       
    (when (zerop height) (setf height 1))
    (opengl:gl-viewport 0 0 width height)
    (opengl:gl-matrix-mode opengl:*gl-projection*)
    (opengl:gl-load-identity)
    (with-slots (dimension) canvas
      (if (= dimension 2)
          (opengl:gl-ortho 0.0d0 (coerce width 'double-float) 0.0d0 (coerce height 'double-float) -1000.00d0 1000.0d0)
         (opengl:gl-ortho (/ (coerce width 'double-float) -2) (/ (coerce width 'double-float) 2) (/ (coerce height 'double-float) -2) (/ (coerce height 'double-float) 2) -1000.0d0 1000.0d0))))
    ;(opengl:gl-ortho 0.0d0 (coerce width 'double-float) 0.0d0 (coerce height 'double-float) -1000.00d0 1000.0d0))
    ;(opengl:gl-ortho (/ (coerce width 'double-float) -2) (/ (coerce width 'double-float) 2) (/ (coerce height 'double-float) -2) (/ (coerce height 'double-float) 2) -1000.0d0 1000.0d0))
  ;(opengl:glu-perspective (/ pi 4) (coerce (/ width height) 'double-float) 0000.01d0 1000.0d0))
  (invalidate canvas))

(defun canvas-height ()
  (capi::simple-pane-visible-height *canvas*))

(defun canvas-width ()
  (capi::simple-pane-visible-width *canvas*))

(defun display-opengl-interface (name)
  (capi:display (make-instance name)))

(defmethod clear-color ((color point))
  (opengl:gl-clear-color (coerce (x color) 'single-float)
                         (coerce (y color) 'single-float)
                         (coerce (z color) 'single-float)
                         1.0))

(defun clear-canvas ()
  (opengl:gl-clear opengl:*gl-color-buffer-bit*))
  

(defmacro render-on ((opengl-pane) &body body)
  `(opengl:rendering-on (,opengl-pane)
     (clear-color (color-point :white))
     (clear-canvas)
     (color (color-point :black))
     (opengl:gl-clear opengl:*gl-depth-buffer-bit*)
     (opengl:gl-depth-func opengl:*gl-less*)
     (when (= 3 (slot-value *canvas* 'dimension))
       (opengl:gl-enable opengl:*gl-depth-test*))
     ,@body
     (opengl:gl-flush)))

;; canvas class
(defclass opengl-canvas (opengl:opengl-pane)
  ((dimension :initform 2)
   base-stack
   current-color
   (current-normal :initform (vect 0 0 1))
   base))

#|
(defmethod initialize-instance ((canvas opengl-canvas) &key)
  (call-next-method canvas  
                    :configuration (list :rgba t :depth-buffer 16)
                    :display-callback (lambda  (canvas &rest args)
                                        (declare (ignore args))
                                        (let ((*inside-opengl-block* t)
                                              (*canvas* canvas))
                                          (render-on (canvas)
                                            (funcall #'display canvas))))
                    :resize-callback 'resize-canvas
                    :input-model `(((:button-1 :press) ,(lambda (canvas x y)
                                                          (let ((*canvas* canvas))
                                                            (funcall #'mouse-press-primary canvas (point x (- (canvas-height) y))))))
                                   ((:button-3 :press) ,(lambda (canvas x y)
                                                          (let ((*canvas* canvas))
                                                            (funcall #'mouse-press-secondary canvas (point x (- (canvas-height) y))))))
                                   (:character ,(lambda (canvas x y char)
                                                  (declare (ignore x y))
                                                  (let ((*canvas* canvas))
                                                    (funcall #'key-press canvas char)))))
                    :min-width 800
                    :min-height 600))
|#
   
(defmethod display ((canvas opengl-canvas))
  (with-slots (base-stack base dimension) canvas
    (setf base-stack nil
          base (ecase dimension
                 (2 (list (point 0 0) (vect 1 0) (vect 0 1)))
                 (3 (list (point 0 0 0) (vect 1 0 0) (vect 0 1 0) (vect 0 0 1)))))))

(defmethod display-callback ((canvas opengl-canvas) &rest args)
  (declare (ignore args))
  (let ((*inside-opengl-block* t)
        (*canvas* canvas))
    (render-on (canvas)
               (funcall #'display canvas)
               (opengl:swap-buffers canvas)))) ;pridano 25.2.16 kvuli double buffer


(defmethod key-press ((canvas opengl-canvas) char)
  (declare (ignore char))
  (invalidate canvas))

(defmethod mouse-press-primary ((canvas opengl-canvas) point)
  (declare (ignore point))
  (invalidate canvas))

(defmethod mouse-press-secondary ((canvas opengl-canvas) point)
  (declare (ignore point))
  (invalidate canvas))

(defmethod vertex-transformation ((canvas opengl-canvas) (vertex point))
  (base-vertex-transformation vertex))

(defmethod normal-transformation ((canvas opengl-canvas) (normal vect))
  (base-normal-transformation normal))

(defmethod vertex-compute-color ((canvas opengl-canvas) (vertex point))
  (with-slots (current-color) canvas
    current-color))

;; opengl macros
(defmacro with-canvas-variables ((&rest variables) &body body)
  `(with-slots ,variables *canvas* ,@body))

(defmacro display-opengl-canvas (canvas-class)
  (with-unique-names (opengl-interface)
    `(progn
       (capi:define-interface ,opengl-interface ()
         ()
         (:panes (canvas ,canvas-class
                         :configuration (list :rgba t :depth-buffer 16 :double-buffer t) ; 25.2.16 pridano double buffer kvuli linuxu
                         :display-callback 'display-callback
                           :resize-callback 'resize-canvas
                           :input-model `(((:button-1 :press) ,(lambda (canvas x y)
                                                                 (let ((*canvas* canvas))
                                                                   ;(format t "x: ~A, y: ~A, height: ~A~%" x y (canvas-height))
                                                                   (funcall #'mouse-press-primary canvas (point x (- (canvas-height) y 1)))))) ; -1 proto aby byl bod 0 0 roh vlevo dole
                                          ((:button-3 :press) ,(lambda (canvas x y)
                                                                 (let ((*canvas* canvas))
                                                                   (funcall #'mouse-press-secondary canvas (point x (- (canvas-height) y))))))
                                          (:character ,(lambda (canvas x y char)
                                                         (declare (ignore x y))
                                                         (let ((*canvas* canvas))
                                                           (funcall #'key-press canvas char)))))
                           :external-min-width 640
                           :external-min-height 480))
           (:default-initargs :title "OpenGL canvas"))
       (handler-case
           (slot-value (display-opengl-interface ',opengl-interface) 'canvas)
         (error () nil)))))
 
(defmacro define-opengl-canvas (name modules variables &body functions)
  (let ((variables-names (mapcar (lambda (variable) 
                                   (if (listp variable) (first variable)
                                     variable)) 
                                 variables)))
    `(progn
       (defclass ,name ,(or modules '(opengl-canvas))
         ,(mapcar (lambda (variable) 
                    (if (listp variable)
                        `(,(first variable) :initform ,(second variable))
                      `(,variable :initform nil)))
                  variables))
       ,@(mapcar (lambda (function)
                   (let ((function-name (first function))
                         (function-arguments (second function))
                         (function-body (rest (rest function))))
                     (unless (member function-name '(display key-press mouse-press-primary mouse-press-secondary vertex-transformation normal-transformation vertex-compute-color))
                       (error "Function name ~A is not valid." function-name))
                     (with-unique-names (canvas)
                       `(defmethod ,function-name
                                   ((,canvas ,name)  ,@function-arguments)
                          (with-canvas-variables (,@variables-names)
                            (declare (ignorable ,@variables-names))
                            ,@(when (eql function-name 'display)
                                '((call-next-method)))
                            ,@function-body
                            ,@(when (member function-name '(key-press mouse-press-primary mouse-press-secondary))
                                '((call-next-method))))))))
                 functions))))
 
(defmacro opengl-canvas (modules variables &body functions)
  (with-unique-names (opengl-canvas)
    `(progn
       (define-opengl-canvas ,opengl-canvas 
                             ,modules
                             ,variables
                             ,@functions)
       (display-opengl-canvas ,opengl-canvas))))

(editor:setup-indent "opengl-canvas" 0 2 nil)
(editor:setup-indent "define-opengl-canvas" 0 2 nil)
(editor:setup-indent "display" 0 2 nil)
(editor:setup-indent "key-press" 0 2 nil)
(editor:setup-indent "mouse-press-primary" 0 2 nil)
(editor:setup-indent "mouse-press-secondary" 0 2 nil)
(editor:setup-indent "vertex-transformation" 0 2 nil)
(editor:setup-indent "normal-transformation" 0 2 nil)
(editor:setup-indent "vertex-compute-color" 0 2 nil)

(defmacro opengl (modules &body body)
  `(opengl-canvas ,modules ()
                  (display ()
                   ,@body)))


(defmethod invalidate ((canvas opengl:opengl-pane))
  (display-callback canvas)) ;zmena 2.3.16 jako test, jestli to pomuze problemu prekresleni na linuxu
  ;(capi:apply-in-pane-process canvas #'gp:invalidate-rectangle canvas))
          

(defun color (point)
  (unless *inside-opengl-block*
    (error "The function color must be called inside opengl macros."))
  (unless (= (dimension point) 3)
    (error "The point has to have dimension three."))
  (unless (every (lambda (c) (<= 0 c 1)) (coordinates point))
    (error "Each coordinate of the point must be between 0 and 1."))
  (with-canvas-variables (current-color)
    (setf current-color point))
  (opengl:gl-color3-d (coerce (x point) 'double-float)
                      (coerce (y point) 'double-float)
                      (coerce (z point) 'double-float)))

(defun color-point (color)
  (apply #'point (rest (map 'list #'identity (color:get-color-spec color)))))

(defvar *inside-gl-block* nil)


(defun type-to-primitive (type)
  (ecase type
    (:points opengl:*gl-points*)
    (:lines opengl:*gl-lines*)
    (:line-strip opengl:*gl-line-strip*)
    (:line-loop opengl:*gl-line-loop*)
    (:polygon opengl:*gl-polygon*)
    (:quads opengl:*gl-quads*)
    (:quad-strip opengl:*gl-quad-strip*)
    (:triangles opengl:*gl-triangles*)
    (:triangle-strip opengl:*gl-triangle-strip*)
    (:triangle-fan opengl:*gl-triangle-fan*)))

(defmacro gl-block (type &body body)
  `(progn
     (unless *inside-opengl-block*
       (error "Macro gl-block must be used inside opengl macros."))
     (opengl:gl-begin ,(ecase type
                         (points opengl:*gl-points*)
                         (lines opengl:*gl-lines*)
                         (line-strip opengl:*gl-line-strip*)
                         (line-loop opengl:*gl-line-loop*)
                         (polygon opengl:*gl-polygon*)
                         (quads opengl:*gl-quads*)
                         (quad-strip opengl:*gl-quad-strip*)
                         (triangles opengl:*gl-triangles*)
                         (triangle-strip opengl:*gl-triangle-strip*)
                         (triangle-fan opengl:*gl-triangle-fan*)))
     (let ((*inside-gl-block* t))
       ,@body)
     (opengl:gl-end)))


(defmacro polygon (&body body)
  `(gl-block polygon
       ,@body))

(defmacro line-strip (&body body)
  `(gl-block line-strip
       ,@body))
  
(defmethod vertex ((vertex point))
  (unless *inside-gl-block*
    (error "The function must be called inside macro polygon."))
  (let ((dim (dimension vertex)))
    (unless (= dim (slot-value *canvas* 'dimension))
      (error "The point must have dimension ~A." (slot-value *canvas* 'dimension)))
    (with-canvas-variables (current-color)
      (let ((color current-color))
        (color (vertex-compute-color *canvas* vertex))
        (apply 
         (if (= dim 2)
             #'opengl:gl-vertex2-d
           #'opengl:gl-vertex3-d)
         (mapcar (lambda (c)
                   (coerce c 'double-float))
                 (coordinates (funcall #'vertex-transformation *canvas* vertex))))
        (color color)))))

(defmethod normal ((vector vect))
  (unless *inside-gl-block*
    (error "The function must be called inside macro polygon."))
  (unless (= 3 (slot-value *canvas* 'dimension))
    (error "The function can be used only for canvas with tree dimensional space."))
  (unless (= 3 (dimension vector))
    (error "The vector must by from three dimensional space."))
  (let ((transformed-normal (funcall #'normal-transformation *canvas* vector)))
    (with-canvas-variables (current-normal)
      (setf current-normal transformed-normal))
    (apply #'opengl:gl-normal3-d
           (mapcar (lambda (c)
                     (coerce c 'double-float))
                   (coordinates transformed-normal)))))
  
#|
(defun get-color ()
  (let ((vect (opengl:make-gl-vector :float 4)))
    (opengl:gl-get-floatv opengl:*gl-current-color* vect)
    (point (opengl:gl-vector-aref vect 0)
           (opengl:gl-vector-aref vect 1)
           (opengl:gl-vector-aref vect 2))))

(defun get-normal ()
  (let ((vect (opengl:make-gl-vector :float 3)))
    (opengl:gl-get-floatv opengl:*gl-current-normal* vect)
    (vector (opengl:gl-vector-aref vect 0)
            (opengl:gl-vector-aref vect 1)
            (opengl:gl-vector-aref vect 2))))
|#

(defmethod base-vertex-transformation ((point point))
  (unless *inside-opengl-block*
    (error "The function must be called in display callback of opengl macro."))
  (with-canvas-variables (base)
    (plus (first base)
        (reduce #'plus (mapcar #'mult (coordinates point)
                               (rest base))))))

(defmethod base-normal-transformation ((normal vect))
  (with-canvas-variables (base)
    (reduce #'plus (mapcar #'mult (coordinates normal)
                           (rest base)))))
               
(defmethod c-s-translate ((vector vect))
  (unless *inside-opengl-block*
    (error "The function must be called in display callback of opengl macro."))
  (when *inside-gl-block*
    (error "The function can not be called inside polygon macro."))
  (with-slots (base) *canvas*
    (setf (first base) (plus (first base) 
                             (reduce #'plus (mapcar #'mult 
                                                    (coordinates vector)
                                                    (rest base)))))))

(defun c-s-rotate (angle &optional (rotation-vector (vect 0 0 1)))
  (unless *inside-opengl-block*
    (error "The function must be called in display callback of opengl macro."))
  (when *inside-gl-block*
    (error "The function can not be called inside polygon macro."))
  (with-slots (base) *canvas*
    (setf (rest base)
        (mapcar (lambda (v)
                  (rotate v angle rotation-vector))
                (rest base)))))

(defun c-s-scale (&rest coefs)
  (with-slots (base dimension) *canvas*
    (when (= (length coefs) 1)
      (setf coefs (make-list dimension :initial-element (first coefs))))
    (unless *inside-opengl-block*
      (error "The function must be called in display callback of opengl macro."))
    (when *inside-gl-block*
      (error "The function can not be called inside polygon macro."))
    (unless (= dimension (length coefs))
      (error "The function expects ~A coefs or only one coef for uniform scale." dimension))
    (setf (rest base) (mapcar #'mult coefs (rest base)))))

(defun base-push ()
  (with-slots (base base-stack) *canvas*
    (push (copy-list base) base-stack)))

(defun base-pop ()
  (with-slots (base base-stack) *canvas*
    (setf base (pop base-stack))))

(defmacro with-c-s-pushed (&body body)
  `(progn
  (unless *inside-opengl-block*
    (error "Macro with-c-s-pushed must be used in display callback of opengl macro."))
  (when *inside-gl-block*
    (error "Macro with-c-s-pushed can not be used inside polygon macro."))
     (base-push)
     (unwind-protect 
         (progn
           ,@body)
       (base-pop))))


(defun arrow2 ()
  (polygon 
    (vertex (point 0 -0.05))
    (vertex (point 0 0.05))
    (vertex (point 0.8 0.05))
    (vertex (point 0.8 -0.05)))
  (polygon 
    (vertex (point 0.8 -0.1))
    (vertex (point 0.8 0.1))
    (vertex (point 1 0))))

#|
(defun arrow2 (len)
  (let* ((body-len (- len (/ len 5)))
         (thickness (/ len 30)))
      (polygon 
        (vertex (point 0 (- thickness)))
        (vertex (point 0 thickness))
        (vertex (point body-len thickness))
        (vertex (point body-len (- thickness))))
      (polygon 
        (vertex (point body-len (* 2 (- thickness))))
        (vertex (point body-len (* 2 thickness)))
        (vertex (point len 0)))))
|#

(define-opengl-canvas 2d ()
  ((step 50)
   (x-tr 0)
   (y-tr 0))
  (display ()
    (c-s-translate (vect x-tr y-tr))
    (color (color-point :red))
    (with-c-s-pushed
      (c-s-scale 100 100)
      (arrow2))
    (with-c-s-pushed
      (c-s-rotate (/ pi 2))
      (c-s-scale 100 100)
      (color (color-point :green))
      (arrow2)))
  (key-press (char)
    (case char
      (#\w (incf y-tr step))
      (#\s (decf y-tr step))
      (#\a (decf x-tr step))
      (#\d (incf x-tr step)))))


(define-opengl-canvas 3d ()
    ((dimension 3)
     (step 32)
     (x-angle 0)
     (y-angle 0)
     (z-angle 0))
  (display ()
    ;(c-s-translate (vect (/ (canvas-width) 2) (/ (canvas-height) 2))) ;neni potreba, je to zajisteno pomoci gl-ortho v resize-canvas
    (c-s-rotate x-angle (vect 1 0 0))
    (c-s-rotate y-angle (vect 0 1 0))
    (c-s-rotate z-angle (vect 0 0 1)))
  (key-press (char)
    (case char
      (#\a (incf y-angle (/ pi step)))
      (#\d (decf y-angle (/ pi step)))
      (#\q (incf z-angle (/ pi step)))
      (#\e (decf z-angle (/ pi step)))
      (#\w (incf x-angle (/ pi step)))
      (#\s (decf x-angle (/ pi step))))))

(define-opengl-canvas level ()
  ((level 0))
  (key-press (char)
    (case char
      (#\+ (incf level))
      (#\- (decf level)
           (when (< level 0)
             (setf level 0))))))
     


