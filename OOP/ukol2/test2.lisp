#|

DOKUMENTACE
-----------

TRIDA SEMAPHORE (PICTURE)
-------------------

Trida semaphore je potomkem tridy picture. 
Instance tridy semaphore simulujou semafor.

UPRAVENÉ ZDĚDĚNÉ VLASTNOSTI

zadne

NOVÉ VLASTNOSTI

semaphore-type:              Typ semaforu. 
                             Pri nastaveni vytvari spravny pocet svetel a aktualizuje fazi kazdeho svetla. (Cteni a zapis)
semaphore-phase:             Cislo aktualni faze semaforu. (Cteni a zapis)
phase-count:                 Pocet fazi semaforu. (Cteni)
lights:                      Svetla semaforu. (Cteni)
box:                         Krabice semaforu. (Cteni)
variations:                  Seznam variaci semaforu. (Cteni)
colors:                      Seznam barev. (Cteni)

NOVÉ ZPRÁVY
 
next-phase                Zasila odpovidajici spravy o zmene fazi semaforu.                    
set-semaphore-type        Nastavi typ semaforu a zada spravny pocet svetel.

UPRAVENÉ ZDĚDĚNÉ ZPRÁVY

zadne


TRIDA CROSSROADS (PICTURE)
-------------------

Trida crossroads je potomkem tridy picture. 
Instance tridy crossroads simulujou obrazek krizovatky.

UPRAVENÉ ZDĚDĚNÉ VLASTNOSTI

zadne

NOVÉ VLASTNOSTI

crossroads-phase:         Cislo aktualni faze krizovatky. (Cteni a zapis)
phase-count:              Pocet fazi krizovatky. (Cteni)

NOVÉ ZPRÁVY
 
next-phase                Zasila odpovidajici spravy o zmene fazi krizovatky.                    

UPRAVENÉ ZDĚDĚNÉ ZPRÁVY

zadne


Projdete si testovaci kod na konci souboru.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce na vytvareni bodu pro polygon, linii pro krizovatku,   
;;; svetel pro semafor, obdelniku pro semafor.
;;;

(defun cross-points (l)
  (mapcar (lambda (coords)
            (apply #'move (make-instance 'point) coords))
         l))

(defun make-road ()
  (let ((line1 (make-instance 'polygon))
        (line2 (make-instance 'polygon))
        (line3 (make-instance 'polygon))
        (line4 (make-instance 'polygon))
        (rect1 (make-instance 'polygon))
        (rect2 (make-instance 'polygon))
        (rect3 (make-instance 'polygon))
        (rect4 (make-instance 'polygon))
        (rect5 (make-instance 'polygon))
        (rect6 (make-instance 'polygon))
        (rect7 (make-instance 'polygon))
        (rect8 (make-instance 'polygon))
        (road (make-instance 'picture)))
    (set-items line1 (cross-points '((20 200) (200 200) (200 20) (200 200))))
    (set-items line2 (cross-points '((480 200) (300 200) (300 20) (300 200))))
    (set-items line3 (cross-points '((20 300) (200 300) (200 480) (200 300))))
    (set-items line4 (cross-points '((480 300) (300 300) (300 480) (300 300))))
    (set-items rect1 (cross-points '((100 210) (40 210) (40 220) (100 220))))
    (set-items rect2 (cross-points '((100 230) (40 230) (40 240) (100 240))))
    (set-items rect3 (cross-points '((100 250) (40 250) (40 260) (100 260))))
    (set-items rect4 (cross-points '((100 270) (40 270) (40 280) (100 280))))
    (set-items rect5 (cross-points '((210 460) (210 400) (220 400) (220 460))))
    (set-items rect6 (cross-points '((230 460) (230 400) (240 400) (240 460))))
    (set-items rect7 (cross-points '((250 460) (250 400) (260 400) (260 460))))
    (set-items rect8 (cross-points '((270 460) (270 400) (280 400) (280 460))))
    (set-items road 
               (list line1 line2 line3 line4 rect1 rect2 rect3 rect4 rect5 rect6 rect7 rect8))))

(defun make-light (place color)
  (move
   (set-radius (set-on-color (make-instance 'light) color)
               (* 1/2 3/4 30))
   (* 1/2 30) (+ (* 1/2 30) (* place 30))))

(defun make-box (count)
  (let ((value (* count 30)))
    (cross-points `((0 0) (30 0) (30 ,value) (0 ,value)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Globalni promena, ktera popisuje ruzne typy semaforu
;;; 

(defvar *variations*
  '(:pedestrian ((:red :green) ((t nil) (nil t)))
    :vehicle ((:red :yellow :green) ((t nil nil) (t t nil) (nil nil t) (nil t nil)))))

;;;;
;;;; Trida semaphore
;;;; 

(defclass semaphore (picture)
  ((semaphore-type :initform nil)
   (semaphore-phase :initform nil)))

;;;
;;; Vlastnosti
;;;

(defmethod semaphore-type ((sm semaphore))
  (slot-value sm 'semaphore-type))

(defmethod semaphore-phase ((sm semaphore))
  (slot-value sm 'semaphore-phase))

(defmethod set-semaphore-phase ((sm semaphore) value)
  (set-next-phase sm value))

(defmethod phase-count ((sm semaphore))
  (length (phase-variations sm)))

(defmethod lights ((sm semaphore))
  (let ((l '())
        (it (items sm)))
    (dotimes (i (length it))
      (if (eq (type-of (nth i it)) 'picture)
          (setf l (items (nth i it)))))
    l))

(defmethod light-count ((sm semaphore))
  (length (colors sm)))

(defmethod box ((sm semaphore))
  (let ((it (items sm)))
    (dotimes (i (length it))
      (if (eq (type-of (nth i it)) 'polygon)
          (return (nth i it))))))

(defmethod variations ((sm semaphore))
  (cadr (member (semaphore-type sm) *variations*)))

(defmethod colors ((sm semaphore))
  (car (variations sm)))

(defmethod phase-variations ((sm semaphore))
  (cadr (variations sm)))

(defmethod phase-variation ((sm semaphore))
  (let ((variations (phase-variations sm)))
    (nth (mod (semaphore-phase sm) (length variations)) variations)))

;;;
;;; Zpravy
;;;

(defmethod set-semaphore-type ((sm semaphore) type)
  (setf (slot-value sm 'semaphore-type) type)
  (set-lights sm (light-count sm)))
  
(defmethod set-semaphore-phase-help ((sm semaphore) value)
  (setf (slot-value sm 'semaphore-phase) value))

(defmethod make-lights ((sm semaphore) count)
  (let ((res nil))
    (dotimes (i count)
      (setf res (cons (make-light i (nth i (colors sm))) res)))
    (reverse res)))

(defmethod set-lights ((sm semaphore) count)
  (let ((box (make-instance 'polygon))
        (lights (make-instance 'picture)))
    (set-items box (make-box count))
    (set-items lights (make-lights sm count))
    (set-items sm (list lights box))
    (set-next-phase sm 0))
  sm)

(defmethod set-light-phase ((sm semaphore))
  (dolist (l-p (mapcar #'cons (lights sm)
                       (phase-variation sm)))
    (set-onp (car l-p) (cdr l-p))))

(defmethod set-next-phase ((sm semaphore) new-phase)
  (set-semaphore-phase-help sm new-phase)
  (set-light-phase sm)
  sm)

(defmethod next-phase ((sm semaphore))
  (set-next-phase sm (+ (semaphore-phase sm) 1)))

;;;
;;; Inicializace
;;;

(defmethod initialize-instance ((sm semaphore) &key (semaphore-type :pedestrian))
  (call-next-method)
  (set-semaphore-type sm semaphore-type)
  (set-filledp (box sm) t))

;;;;
;;;; Trida crossroads
;;;; 

(defclass crossroads (picture) 
  ((crossroads-phase :initform 0)))

;;;
;;; Vlastnosti
;;;

(defmethod crossroads-phase ((cr crossroads))
  (slot-value cr 'crossroads-phase))

(defmethod set-crossroads-phase ((cr crossroads) value)
  (if (= (crossroads-phase cr) 0)
      (setf (slot-value cr 'crossroads-phase) value)
    (dotimes (i (phase-count cr))
      (if (= value (crossroads-phase cr))
          (return cr)
        (next-phase cr)))))

(defmethod phase-count ((cr crossroads))
  4)

;;;
;;; Zpravy
;;;
  
(defmethod set-crossroads-phase-help ((cr crossroads) value)
  (setf (slot-value cr 'crossroads-phase) value))

(defmethod need-toggle ((cr crossroads))
  (or (= (crossroads-phase cr) 2)
      (= (crossroads-phase cr) 4)
      1))

(defmethod crossroad-phase-update ((cr crossroads))
  (if (< (crossroads-phase cr) (phase-count cr))
      (set-crossroads-phase-help cr (+ (crossroads-phase cr) 1))
    (set-crossroads-phase-help cr 1)))

(defmethod next-veh-phase ((cr crossroads))
  (dolist (item (items cr))
    (if (typep item 'semaphore)
        (if (eq (semaphore-type item) :vehicle)
            (next-phase item)))))

(defmethod next-ped-phase ((cr crossroads))
  (dolist (item (items cr))
    (if (typep item 'semaphore)
        (if (eq (semaphore-type item) :pedestrian)
            (if (eq (need-toggle cr) 1)
                (next-phase item))))))

(defmethod next-phase ((cr crossroads))
  (next-veh-phase cr)
  (crossroad-phase-update cr)
  (next-ped-phase cr)
  cr)

;;;
;;; Inicializace
;;;

(defmethod initialize-instance ((cr crossroads) &key)
  (call-next-method)
  (let ((sm-veh (make-instance 'semaphore :semaphore-type :vehicle))
        (sm-veh2 (make-instance 'semaphore :semaphore-type :vehicle))
        (sm-ped (make-instance 'semaphore))
        (sm-ped2 (make-instance 'semaphore))
        (road (make-road)))
    (move sm-veh 320 320) 
    (move sm-veh2 320 160) 
    (set-semaphore-phase (rotate sm-veh2 (/ (- Pi) 2) (move (make-instance 'point) 335 175)) 2)
    (move sm-ped 100 130)
    (move sm-ped2 130 360)
    (set-semaphore-phase (rotate sm-ped2 (/ (- Pi) 2) (move (make-instance 'point) 145 375)) 1)
    (set-items cr (list road sm-veh sm-veh2 sm-ped sm-ped2)))
  (set-crossroads-phase cr 1)
  cr)


;; Testy (kazdy vyraz vyhodnocujte zvlast` tlacitkem F8):
#|
(setf w (make-instance 'window))
(setf cr (make-instance 'crossroads)) 
(set-shape w cr)

(next-phase cr)
|#

