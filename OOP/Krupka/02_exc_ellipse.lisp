;; (:file "02.lisp" :pos 1)
;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; M. Krupka: Objektové programování
;;;;
;;;; Kapitola 2, Objekty a třídy
;;;; Řešení úloh ze cvičení
;;;;

(defun point-distance (pt1 pt2)
  (sqrt (+ (expt (- (slot-value pt1 'x)
                    (slot-value pt2 'x))
                 2)
           (expt (- (slot-value pt1 'y)
                    (slot-value pt2 'y))
                 2))))

(defclass ellipse ()
  ((focal-point-1 :initform (make-instance 'point))   ;ohnisko 1
   (focal-point-2 :initform (make-instance 'point))   ;ohnisko 2
   (major-semiaxis :initform 1)))                     ;délka hlavní poloosy

(defmethod focal-point-1 ((e ellipse))
  (slot-value e 'focal-point-1))

(defmethod focal-point-2 ((e ellipse))
  (slot-value e 'focal-point-2))

(defmethod focal-points-distance ((e ellipse))
  (point-distance (focal-point-1 e)
                  (focal-point-2 e)))

(defmethod major-semiaxis ((e ellipse))
  (slot-value e 'major-semiaxis))

(defmethod set-major-semiaxis ((e ellipse) value)
  (setf (slot-value e 'major-semiaxis) value)
  e)

(defmethod minor-semiaxis ((e ellipse))
  (sqrt (- (expt (major-semiaxis e) 2)
           (expt (/ (focal-points-distance e) 2) 2))))

(defmethod set-minor-semiaxis ((e ellipse) value)
  (set-major-semiaxis e
                      (sqrt (+ (expt value 2)
                               (expt (/ (focal-points-distance e) 2) 2))))
  e)

(defmethod current-center ((e ellipse))
  (let ((result (make-instance 'point)))
    (setf (slot-value result 'x)
          (/ (+ (slot-value (focal-point-1 e) 'x)
                (slot-value (focal-point-2 e) 'x))
             2)
          (slot-value result 'y)
          (/ (+ (slot-value (focal-point-1 e) 'y)
                (slot-value (focal-point-2 e) 'y))
             2))
    result))

(defmethod eccentricity ((e ellipse))
  (/ (focal-points-distance e) (major-semiaxis e) 2))

;;; Metoda to-ellipse třídy circle

(defmethod to-ellipse ((c circle))
  (let ((center (slot-value c 'center))
        (result (make-instance 'ellipse)))
    (setf (slot-value (focal-point-1 result) 'x) (slot-value center 'x)
          (slot-value (focal-point-1 result) 'y) (slot-value center 'y)
          (slot-value (focal-point-2 result) 'x) (slot-value center 'x)
          (slot-value (focal-point-2 result) 'y) (slot-value center 'y))
    (set-major-semiaxis result (slot-value c 'radius))))                  ;vrací result
          
