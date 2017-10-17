(defun mysq ()
  (let ((square (polygon 
                 (vertex (point 0 0))
                 (vertex (point 1 0))
                 (vertex (point 1 1))
                 (vertex (point 0 1)))))
    square))

(defun branches(current-depth n) 
  (if (= current-depth n) ()
    (with-c-s-pushed 
      (c-s-translate (vect 0.23 0.95))
      (c-s-scale 0.5 0.5)
      (with-c-s-pushed 
        (c-s-rotate (/ pi 3))
        (mysq)
        (branches (+ current-depth 1) n))
      (with-c-s-pushed 
        (mysq)
        (branches (+ current-depth 1) n))
      (with-c-s-pushed 
        (c-s-translate (vect 0.6 0.1))
        (c-s-rotate (- (/ pi 3)))
        (mysq)
        (branches (+ current-depth 1) n)))))


(defun tree (n)
  (with-c-s-pushed 
    (c-s-translate (vect 300 20))
    (c-s-scale 30 150)
    (mysq)
    (branches 1 n)))
#|
(opengl-canvas ()
  ((color :red))
  (display ()
    (tree 3)))
|#