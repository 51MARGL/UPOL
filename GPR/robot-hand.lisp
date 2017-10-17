(defun mysq ()
  (let ((square (polygon 
                 (vertex (point 0 0))
                 (vertex (point 1 0))
                 (vertex (point 1 1))
                 (vertex (point 0 1)))))
    square))

(defun robot ()
  (let ((angle pi))
    (opengl-canvas ()
      ((color :red))
      (display ()
        (color (color-point color))
        (with-c-s-pushed
          (c-s-translate (vect 100 200))
          (c-s-scale 100 30)
          (c-s-rotate ( - (/ pi 4)))
          (mysq))
        (with-c-s-pushed
          (c-s-translate (vect 180 130))
          (c-s-rotate (/ angle 4))
          (with-c-s-pushed
            (c-s-scale 100 30)
            (mysq))
          (with-c-s-pushed
            (c-s-translate (vect 100 0))
            (c-s-rotate (/ pi 6))
            (with-c-s-pushed
              (c-s-scale 30 30)
              (mysq))
            (with-c-s-pushed
              (c-s-translate (vect 30 20))
              (c-s-scale 5 15)
              (c-s-rotate (- (/ pi 2)))
              (mysq))
            (with-c-s-pushed
              (c-s-translate (vect 30 27))
              (c-s-scale 5 15)
              (c-s-rotate (- (/ pi 2)))
              (mysq))
            (with-c-s-pushed
              (c-s-translate (vect 30 14))
              (c-s-scale 5 15)
              (c-s-rotate (- (/ pi 2)))
              (mysq))
            (with-c-s-pushed
              (c-s-translate (vect 30 7))
              (c-s-scale 5 15)
              (c-s-rotate (- (/ pi 2)))
              (mysq))
            (with-c-s-pushed
              (c-s-translate (vect 5 20))
              (c-s-scale 10 30)
              (c-s-rotate (- (/ pi 6)))
              (mysq)))))
      (key-press (char)
        (if (eql char #\+)
            (setf angle (+ (/ pi 2) pi)))
        (if (eql char #\-)
            (setf angle pi))))))
      
    