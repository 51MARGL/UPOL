(defun matrix2d-zero()
  (list (list 0 0 0) (list 0 0 0) (list 0 0 0)))

(defun matrix3d-zero()
  (list (list 0 0 0 0) (list 0 0 0 0) (list 0 0 0 0) (list 0 0 0 0)))

(defvar id-mtx
  (list (list 1 0 0 0) (list 0 1 0 0) (list 0 0 1 0) (list 0 0 0 1)))

(defvar 3d-matrix
  (list (list 1 0 0 0) (list 0 1 0 0) (list 0 0 1 0) (list 0 0 0 1)))


(defun m-v-matrix-set-identity ()
  (with-canvas-variables (matrix)
    (let ((raws (length matrix))
          (columns (length (first matrix))))
      (dotimes (i raws)
        (dotimes (j columns)
          (if (eq i j)
              (setf (nth j (nth i matrix)) 1)
            (setf (nth j (nth i matrix)) 0)))))))

#|
(setf q (list (list 1 2 3) (list 1 2 3) (list 1 2 3)))
(opengl-canvas (q)
  ((dimension 3))
  (display ()
    (m-v-matrix-set-identity)))
|#

(defun matrix-multiply (a b) 
  (flet ((col (mat i) (mapcar #'(lambda (row) (elt row i)) mat)) 
         (row (mat i) (elt mat i))) 
    (loop for row from 0 below (length a) 
          collect (loop for col from 0 below (length (row b 0)) 
                        collect (apply #'+ (mapcar #'* (row a row) (col b col)))))))

(defun matrix-point-multiply (matrix point)
  (apply 'af-point (mapcar #'(lambda (x) (car x)) (matrix-multiply matrix (mapcar #'(lambda (x) (list x)) (af-coordinates point))))))


;; example use: 
;(matrix-multiply '((1 2) (3 4)) '((-3 -8 3) (-2 1 4))) 

(defun m-v-matrix-translate (v)
  (with-canvas-variables (matrix)
    (let ((raws (length matrix))
          (columns (length (first matrix)))
          (u (af-coordinates v))
          (m2 3d-matrix))
      (dotimes (i raws)
        (dotimes (j columns)
           (if (eq i j) 
              (setf (nth j (nth i m2)) 1)
             (if (eq j (- columns 1))
                 (setf (nth j (nth i m2)) (nth i u))
               (setf (nth j (nth i m2)) 0)))))
      (setf matrix (matrix-multiply matrix m2)))))
           
#|
 (opengl-canvas ()
  ((dimension 3)
   (matrix 3d-matrix)) 
  (display ()
    (m-v-matrix-translate (vect -100 -100 -100))
    (polygon
      (vertex (point 0 0 0))
      (vertex (point 100 0 0))
      (vertex (point 0 100 0))))
  (vertex-transformation (vertex)
    (matrix-point-multiply matrix vertex)))
|#

(defun m-v-matrix-scale (v)
  (with-canvas-variables (matrix)
     (let ((m1 3d-matrix)
           (raws (length matrix))
          (columns (length (first matrix)))
          (u (af-coordinates v)))
       (dotimes (i raws)
        (dotimes (j columns)
          (if (eq i j)
              (setf (nth j (nth i m1)) (nth i u))
            (setf (nth j (nth i m1)) 0))))
       (setf (nth (- columns 1) (nth (- raws 1) m1)) 1)
       (setf matrix (matrix-multiply matrix m1)))))
          
#|
(opengl-canvas ()
  ((dimension 3)
   (matrix 3d-matrix)) 
  (display ()
    (m-v-matrix-scale (vect 2 2 2))
    (polygon
      (vertex (point 0 0 0))
      (vertex (point 100 0 0))
      (vertex (point 0 100 0))))
  (vertex-transformation (vertex)
    (matrix-point-multiply matrix vertex)))
|#

(defun rotation-matrix (angle &optional (rotation-vector (vect 0 0 1)))
  (let ((coords (coordinates (normalize rotation-vector)))
        (c (cos angle))
        (s (sin angle)))
  (loop for i below 4 collect
        (loop for j below 4 collect
              (cond
               ((and (<= i 2) (<= j 2))
                (+ (* (nth i coords)
                      (nth j coords)
                      (- 1 c))
                   (* (if (<= i j) 1 -1)
                      (if (= i j) c
                        (* s (nth (first (remove j (remove i '(0 1 2)))) coords))))))
               ((and (= i 3) (= j 3)) 1)
               (t 0))))))

(defun m-v-matrix-rotate (vector angle)
  (with-canvas-variables (matrix)
    (let* ((m (rotation-matrix angle vector)))
      (setf matrix (matrix-multiply matrix m)))))

#|
(opengl-canvas ()
  ((dimension 3)
   (matrix 3d-matrix)) 
  (display () 
    (m-v-matrix-translate (vect -20 -20 -20))
    (m-v-matrix-scale (vect 2 2 2))
    (m-v-matrix-rotate (vect 0 0 1) (/ pi 12))
    (polygon
      (vertex (point 0 0 0))
      (vertex (point 100 0 0))
      (vertex (point 0 100 0))))
  (vertex-transformation (vertex)
    (matrix-point-multiply matrix vertex)))
|#
