(in-package "CL-USER")

(defsystem lisp-gl ()
  :members ("lgl")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(load (current-pathname "opengl/load"))

(compile-system 'lisp-gl :load t)