#|

DOKUMENTACE
-------------------------------------------------------------------------------------------------

Pro nove tridy grafickych objektu, definovane mimo existujici soubory,
uzivatel MUSI nadefinovat ve sve tride metodu PROPERTIES,
ktera vraci seznam vlastnosti.
Pokud je to slozeny graficky objekt, tak uzivatel MUSI pridat metodu SOLIDP, ktera vrati t (TRUE).
Jinak program vypise informaci o vnorenych objektech.  

Jako priklad, v programu uz uvedena oprava pro tridu bulls-eye.

Krome standardnich souboru vyzaduje nacist soubory:
- 07_text-shape.lisp
- 07_bulls-eye.lisp

--------------------------------------------------------------------------------------------------

TŘÍDA WINDOW (MG-OBJECT)
------------------------

PREPSANE ZPRAVY

install-callbacks window:      Posílá se oknu jako součást inicializace. Slouží k instalaci zpětných
                               volání knihovny micro-graphics. Ve třídě window instaluje zpětná volání
                               :display :mouse-down a  :double-click pomocí zpráv install-display-callback 
                               install-mouse-down-callback a install-double-click-callback.

NOVE ZPRAVY

window-double-click:           Tuto zpravu okno dostane, pokud do nej uzivatel klikne mysi.
                               Metoda ve tride window zjisti, zda se kliklo dovnitr grafickeho
                               objektu v okne, ktery ma nastavenu vlastnost solidp na Pravda. Pokud ano, 
                               posle si zpravu double-click-inside-shape, jinak si pošle zprávu
                               double-click-no-shape. Není určeno k přímému volání.

install-double-click-callback: Nainstaluji prislusna zpetna volani 


TRIDA INSPECTOR-WINDOW (WINDOW)
-------------------

Trida inspector-window je potomkem tridy window.
Instanci je okno,zobrazujici informace o zvolenem objektu jineho okna.

UPRAVENE ZDEDENE VLASTNOSTI

zadne

NOVE VLASTNOSTI

inspected-window:              Prohlizene okno.(Cteni a zapis)
inspected-item:                Prohlizeny objekt.(Cteni a zapis)
text-shapes:                   Seznam textovych bloku.(Cteni)

NOVE ZPRAVY
 
set-inspected-window:          Zadava okno, ktere musi byt prohlizene.                   
set-inspected-item:            Zadava objekt, ktery musi byt prohlizen.
update-info-text:              Vypise informace o zvolenem objektu.

UPRAVENÉ ZDEDENE ZPRAVY

ev-change:                     Jestize dojde ke zmene objektu v prohlizenem okne, tak ihned 
                               vypise informaci o tom objektu.
ev-double-click:               Po dvojkliku na hodnotu vlastnosti zobrazi prohlizec dialog s dotazem na novou hodnotu.
                               Po potvrzeni vlastnost na tuto hodnotu zmeni. 

TRIDA INSPECTED-WINDOW (WINDOW)
-------------------

Trida inspected-window je potomkem tridy window.
Instanci je prohlizene okno.

UPRAVENE ZDEDENE VLASTNOSTI

zadne

NOVE VLASTNOSTI

properties:                    Seznam vsech vlastnosti.(Cteni)  

NOVE ZPRAVY
 
zadne                    

UPRAVENE ZDEDENE ZPRAVY

window-mouse-down:             Po kliknuti do prohlizeneho okna zobrazi prohlizec informace o pevnem objektu,
                               na ktery uzivatel klikl. Po kliknuti mimo vsechny objekty se zobrazi opet informace o okne.


TŘÍDA OMG-OBJECT
----------------

NOVE PRIJIMANE UDALOSTI

ev-double-click:               Peeposila udalost delegatovi.


TRIDA SHAPE (OMG-OBJECT)
------------------------

Potomky třídy shape jsou všechny třídy grafických objektů. Sama není určena k
vytváření přímých instancí.


NOVÉ VLASTNOSTI

properties:                    Seznam vsech vlastnosti.(Cteni)  

NOVE ZPRAVY

double-click:                  Objekt obdrzi tuto zpravu od okna pote, co do nej uzivatel dvojklikl mysi

TRIDA POINT (SHAPE)
-------------------

UPRAVENE ZDEDENE VLASTNOSTI

properties:                    Seznam vsech vlastnosti.(Cteni)  


TRIDA CIRCLE (SHAPE)
-------------------

UPRAVENE ZDEDENE VLASTNOSTI

properties:                    Seznam vsech vlastnosti.(Cteni)  


TRIDA POLYGON (SHAPE)
-------------------

UPRAVENE ZDEDENE VLASTNOSTI

properties:                    Seznam vsech vlastnosti.(Cteni)  

Projdete si testovaci kod na konci souboru.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce, ktera vrati pocet vlastnosti
;;; 

(defun properties-count (object)
  (length (properties object)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce, ktera vrati seznam hodnot vlastnosti  
;;; 

(defun properties-values (object)
  (let ((l '())
        (count (properties-count object)))
    (dotimes (i count)
      (setf l (append l (list (funcall (nth i (properties object)) object)))))
    l))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce, ktera vrati jmeno set-metody podle vlastnosti 
;;; 

(defun setter-name (property-name) 
  (find-symbol (format nil "SET-~A" property-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce, ktera vytvari textovy box
;;; 

(defun make-info-text (x y)
  (let ((text (make-instance 'text-shape)))
    (move text x y)
    (set-text text "")
    text))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce, ktera vytvari seznam textovych boxu, ktere v sobe maji informace 
;;; o jednotlive vlastosti
;;; 

(defun make-text-lines (text-box item)
  (let ((prop-count (properties-count item))
        (prop (properties item))
        (prop-val (properties-values item))
        (y 15))
    (dotimes (i prop-count)
      (set-items text-box (append 
                           (items text-box) 
                           (list (set-text (make-info-text 0 (+ 20 y)) 
                                           (format nil "~s = ~s;" 
                                                   (nth i prop)
                                                   (nth i prop-val))))))
      (setf y (+ 20 y)))
    (items text-box)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce, ktera zobrazi dialog s dotazem na novou hodnotu.
;;; 

(defun ask-value ()
  (multiple-value-list (capi:prompt-for-value "Zadejte novou hodnotu")))


;;;;
;;;; Trida shape
;;;; 

(defmethod properties ((s shape))
  '(window color thickness filledp))

;;;;
;;;; Trida point
;;;; 

(defmethod properties ((p point))
  (append (call-next-method) '(x  y  r  phi)))

;;;;
;;;; Trida circle
;;;; 

(defmethod properties ((c circle))
  (append (call-next-method) '(radius)))

;;;;
;;;; Trida polygon
;;;; 

(defmethod properties ((p polygon))
  (append (call-next-method) '(closedp)))

;;;;
;;;; Trida bulls-eye
;;;; 

(defmethod solidp ((be bulls-eye))
  t)

(defmethod properties ((be bulls-eye))
  '(window radius item-count squarep))

;;;;
;;;; Trida inspector-window
;;;; 

(defclass inspector-window (window)
  ((inspected-window :initform nil)
   (inspected-item :initform nil)))

;;;
;;; Vlastnosti
;;;

(defmethod inspected-window ((ir inspector-window))
  (slot-value ir 'inspected-window))

(defmethod inspected-item ((ir inspector-window))
  (slot-value ir 'inspected-item))

(defmethod text-shapes ((ir inspector-window))
  (items (shape ir)))

;;;
;;; Zpravy
;;;

(defmethod set-inspected-window ((ir inspector-window) id)
  (setf (slot-value ir 'inspected-window) id)
  (set-delegate id ir)
  (set-inspected-item ir id id)
  (update-info-text ir id))

(defmethod set-inspected-item ((ir inspector-window) id item)
  (setf (slot-value ir 'inspected-item) item)
  (update-info-text ir item))

(defmethod property-from-text ((ir inspector-window) clicked)
  (nth (- (position clicked (text-shapes ir)) 1) (properties (inspected-item ir))))

(defmethod update-info-text ((ir inspector-window) item)
  (let ((template (format nil "Object is ~s: ~s" (type-of item) item))
        (text-box (make-instance 'picture))
        (y 15))
    (set-items text-box (list (set-text (make-info-text 0 y) template)))
    (set-items text-box (make-text-lines text-box item))
    (set-shape ir text-box)
    ir))

(defmethod value-changing ((ir inspector-window) clicked)
  (let ((value (car (ask-value)))
        (setter (setter-name (property-from-text ir clicked))))
    (funcall setter (inspected-item ir) value)))

(defmethod ev-change ((ir inspector-window) sender message changed-obj args)
   (if (equal sender (inspected-window ir))
       (update-info-text ir changed-obj))
   (call-next-method))

(defmethod ev-double-click ((ir inspector-window) sender clicked button position)
  (if (equal (type-of clicked) 'text-shape)
      (if (not (= (position clicked (text-shapes ir)) 0))
          (value-changing ir clicked))
  (call-next-method)))

;;;
;;; Inicializace
;;;

(defmethod initialize-instance ((ir inspector-window) &key)
  (call-next-method)
  ir)

;;;;
;;;; Trida inspected-window
;;;; 

(defclass inspected-window (window)
  ())

(defmethod properties ((id inspected-window))
  '(delegate shape background))

(defmethod window-mouse-down ((id inspected-window) button position)
  (let ((shape (find-clicked-shape id position))) 
    (if shape
        (send-event id 'set-inspected-item shape)
      (send-event id 'set-inspected-item id))))

(defmethod initialize-instance ((id inspected-window) &key)
  (call-next-method)
  id)

;;;
;;; Dvojklikani
;;;

(defmethod ev-double-click ((obj omg-object) sender clicked-obj button position)
  (send-event obj 'ev-double-click clicked-obj button position))

(defmethod double-click ((shape shape) button position)
  (send-event shape 'ev-double-click shape button position))

(defmethod double-click-inside-shape ((w window) shape button position)
  (double-click shape button position)
  w)

(defmethod double-click-no-shape ((w window) button position)
  w)

(defmethod window-double-click ((w window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (double-click-inside-shape w shape button position)
      (double-click-no-shape w button position))))

(defmethod install-double-click-callback ((w window))
  (mg:set-callback 
   (mg-window w) 
   :double-click (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-double-click 
                  w
                  button 
                  (move (make-instance 'point) x y)))))

(defmethod install-callbacks ((w window))
  (install-double-click-callback w)
  (install-display-callback w)
  (install-mouse-down-callback w)
  w)


;; Testy (kazdy vyraz vyhodnocujte zvlast' tlacitkem F8):
#|
(setf inspected (make-instance 'inspected-window))
(setf pic (make-instance 'picture))
(setf x (set-thickness (move (make-instance 'point) 200 20) 10))
(setf c (set-filledp (move (set-radius (make-instance 'circle) 50) 50 150) t))
(setf p (set-filledp (set-items (make-instance 'polygon) (list 
                                                          (move (make-instance 'point) 10 10)
                                                          (move (make-instance 'point) 60 10)
                                                          (move (make-instance 'point) 60 60)
                                                          (move (make-instance 'point) 10 60))) t))
(setf be (make-instance 'bulls-eye))
(set-items pic (list be p c x))      
(set-shape inspected pic)
(setf inspector (make-instance 'inspector-window))
(set-inspected-window inspector inspected)
|#


