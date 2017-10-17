(defun triangle ()
    (let ((triangle (list 
                 (point 1 0 0)
                 (point 0 1 0)
                 (point 0 0 1))))
    triangle))

(defun sphere (level)
  (subdivision (list (point 1 0 0) (point 0 1 0) (point 0 0 1)) level)
  
  (subdivision (list (point 1 0 0) (point 0 1 0) (point 0 0 -1)) level)

  (subdivision (list (point -1 0 0) (point 0 1 0) (point 0 0 -1)) level)

  (subdivision (list (point -1 0 0) (point 0 1 0) (point 0 0 1)) level)

  (subdivision (list (point 1 0 0) (point 0 -1 0) (point 0 0 1)) level)

  (subdivision (list (point 1 0 0) (point 0 -1 0) (point 0 0 -1)) level)

  (subdivision (list (point -1 0 0) (point 0 -1 0) (point 0 0 -1)) level)

  (subdivision (list (point -1 0 0) (point 0 -1 0) (point 0 0 1)) level))

(defun center (points)
  (let ((a (car points))
        (b (cadr points)))
    (point (/ (+ (x a) (x b)) 2) (/ (+ (y a) (y b)) 2) (/ (+ (z a) (z b)) 2))))

(defun subdivisiontr ()
  (let ((tr (triangle)))
      (color (color-point :red))
      (polygon 
        (vertex (car tr))
        (vertex (center (list (car tr) (cadr tr))))
        (vertex (center (list (car tr) (caddr tr)))))
      (color (color-point :green))
      (polygon 
        (vertex (center (list (car tr) (cadr tr))))
        (vertex (cadr tr))
        (vertex (center (list (cadr tr) (caddr tr)))))
      (color (color-point :blue))
      (polygon 
        (vertex (center (list (cadr tr) (caddr tr))))
        (vertex (caddr tr))
        (vertex (center (list (car tr) (caddr tr)))))
      (color (color-point :yellow))
      (polygon 
        (vertex (center (list (cadr tr) (caddr tr))))
        (vertex (center (list (car tr) (caddr tr))))
        (vertex (center (list (car tr) (cadr tr)))))))
         
#|    
(opengl (3d)
(with-c-s-pushed 
      (c-s-scale 20 20 20)
      (subdivisiontr)))
|#

(defun subdivision (tr level)
  (if (> level 0)
      (progn
       (color (color-point :red))
       (subdivision (list  
         (car tr)
         (plus-origin (normalize (minus-origin (center (list (car tr) (cadr tr))))))
         (plus-origin (normalize (minus-origin (center (list (car tr) (caddr tr))))))) (- level 1))
       (color (color-point :green))
       (subdivision (list  
         (plus-origin (normalize (minus-origin (center (list (car tr) (cadr tr))))))
         (cadr tr)
         (plus-origin (normalize (minus-origin (center (list (cadr tr) (caddr tr))))))) (- level 1))
       (color (color-point :blue))
       (subdivision (list  
         (plus-origin (normalize (minus-origin (center (list (cadr tr) (caddr tr))))))
         (caddr tr)
         (plus-origin (normalize (minus-origin (center (list (car tr) (caddr tr))))))) (- level 1))
       (color (color-point :yellow))
       (subdivision (list  
         (plus-origin (normalize (minus-origin (center (list (cadr tr) (caddr tr))))))
         (plus-origin (normalize (minus-origin (center (list (car tr) (caddr tr))))))
         (plus-origin (normalize (minus-origin (center (list (car tr) (cadr tr))))))) (- level 1)))
    (polygon 
      (vertex (car tr))
      (vertex (cadr tr))
      (vertex (caddr tr)))))


#| 
(opengl (3d)
(with-c-s-pushed 
      (c-s-scale 20 20 20)
      (subdivision (triangle) 1)))
|# 