#|
(opengl-canvas ()
  ((dimension 3)
   (matrix 3d-matrix)) 
  (display () 
    (m-v-matrix-translate (vect 10 0 0))
    (sphere 2))
  (vertex-transformation (vertex)
    (matrix-point-multiply matrix vertex)))
|#


(defvar projection-matrix
  `((1 ,() 0 0)
  (0 0 0 ,())
  (0 ,() 1 0)
  (0 0 0 1)))

(defvar single-matrix
  `((1 0 0 0)
  (0 1 0 0)
  (0 0 1 0)
  (0 0 0 1)))
#|
(defun m-v-matrix-project (c vect)
  (with-canvas-variables (matrix)
    (setf (nth 3 (nth 1 projection-matrix)) c)
    (setf (nth 1 (nth 0 projection-matrix)) (- (/ (x vect) (y vect))))
    (setf (nth 1 (nth 2 projection-matrix)) (- (/ (z vect) (y vect))))
    (setf matrix (matrix-multiply matrix projection-matrix))))
|#

(defun m-v-matrix-project (c vect)
  `((1 ,(- (/ (x vect) (y vect))) 0 ,(* c (/ (x vect) (y vect))))
    (0 0 0 ,c)
    (0 ,(- (/ (z vect) (y vect))) 1 ,(* c (/ (z vect) (y vect))))
    (0 0 0 1)))


#|

(opengl-canvas ()
  ((dimension 3)
   (matrix 3d-matrix)
   (angle 0)
   (scale 100)
   (proj nil)) 
  (display ()
    (m-v-matrix-rotate (vect 0 1 0) angle)
    (m-v-matrix-scale (vect scale scale scale))
    (sphere 2)
    (m-v-matrix-set-identity)
    (setf proj t)
    (m-v-matrix-rotate (vect 1 0 0) (- (/ pi 16)))
    (m-v-matrix-rotate (vect 0 1 0) angle)
    (m-v-matrix-scale (vect scale scale scale))
    (sphere 2)
    (setf proj nil)
    (m-v-matrix-set-identity))
  (vertex-compute-color (vertex)
    (with-canvas-variables (current-color)
    (if (not proj)
        current-color
      (color-point :grey))))
  (vertex-transformation (vertex)
    (if proj
          (matrix-point-multiply (matrix-multiply matrix (m-v-matrix-project -2 (vect -1 1 0))) vertex)
      (matrix-point-multiply matrix vertex)))
  (key-press (char)
        (if (eql char #\q)
            (setf scale (+ scale 10)))
        (if (eql char #\e)
            (setf scale (- scale 10)))
        (if (eql char #\r)
              (setf angle (+ angle (/ pi 16))))))


(vertex-compute-color (vertex)
    (if (not proj)
        (color-point current-color)
      (color-point :grey)))




|#

