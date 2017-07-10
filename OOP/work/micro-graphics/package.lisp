(in-package "CL-USER")

(defpackage "MICRO-GRAPHICS" 
  (:nicknames "MG")
  (:export "DISPLAY-WINDOW" "CLOSE-WINDOW" 
           "GET-CALLBACK" "SET-CALLBACK"
           "GET-PARAM" "SET-PARAM" 
           "INVALIDATE"
           "CLEAR" "DRAW-POLYGON" "DRAW-CIRCLE" "DRAW-ELLIPSE"
           "GET-STRING-EXTENT" "DRAW-STRING" 
           "GET-SIZE" "SET-SIZE" "GET-DRAWING-SIZE"
           "GET-IMAGE-SIZE" "DRAW-IMAGE"
           "PATH"
           "PLAY-SOUND" "STOP-SOUND"
           "TRANSLATE-COLOR"
           "ADD-TIMER-CALLBACK" "REMOVE-TIMER-CALLBACK"))