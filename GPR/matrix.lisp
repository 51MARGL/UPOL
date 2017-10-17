(defun matrix2d-zero()
  (list (list 0 0 0) (list 0 0 0) (list 0 0 0)))

(defun matrix3d-zero()
  (list (list 0 0 0 0) (list 0 0 0 0) (list 0 0 0 0) (list 0 0 0 0)))

(defun m-v-matrix-set-identity ()
  (with-canvas-variables (matrix)
    (let ((raws (length matrix))
          (columns (length (car matrix))))
      (dotimes (i raws)
        (dotimes (j columns)
          (if (eq i j) (setf (nth j (nth i matrix)) 1)
            (setf (nth j (nth i matrix)) 0)))))))
    
#|
 (setf q (list (list 1 2 0) (list 2 3 0) (list 1 2 1)))
(opengl-canvas (q)
  ((dimension 3))
  (display ()
    (m-v-matrix-set-identity q)))
|#

(defun matrix-multiply (m1 m2)
  (let ((matrix1 m1)
        (matrix2 m2))
    (mapcar
     (lambda (row)
       (apply #'mapcar
              (lambda (&rest column)
                (apply #'+ (mapcar #'* row column))) matrix2)) matrix1)))
 
;(matrix-multiply '((1 2) (3 4)) '((-3 -8 3) (-2 1 4)))

(defun m-v-matrix-translate (v)
  (with-canvas-variables (m1)
  (let ((matrix (matrix2d-zero))
          (raws (length m1))
          (columns (length (car m1)))
          (u (af-coordinates v)))
      (dotimes (i raws)
        (dotimes (j columns)
          (if (eq i j) (setf (nth j (nth i matrix)) 1)
            (if (eq j (- columns 1))
                (setf (nth j (nth i matrix)) (nth i u))
              (setf (nth j (nth i matrix)) 0)))))
      (matrix-multiply matrix m1))))


#|
(setf v (vect 1 2))
(opengl-canvas (q)
  ((dimension 3))
  (display ()
    (m-v-matrix-translate v q)
    (subdivision (triangle) 1)))
|#


(defun m-v-matrix-set-scale (v)
  (with-canvas-variables (matrix)
    (let ((raws (length matrix))
          (columns (length (car matrix))))
      (dotimes (i raws)
        (dotimes (j columns)
          (if (eq i j) (setf (nth j (nth i matrix)) (nth i v))
            (setf (nth j (nth i matrix)) 0)))))))

#|
(setf v (list 1 2))
(opengl-canvas (q)
  ((dimension 3))
  (display ()
    (m-v-matrix-scale v q)))
|#

