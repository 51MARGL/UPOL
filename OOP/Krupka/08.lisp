;; -*- mode: lisp; encoding: utf-8; -*-
;;;END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 08.lisp - Prototypový systém
;;;;

#|

DOKUMENTACE
-----------

Objektové rozšíření Lispu založené na prototypovém přístupu. S objekty se 
komunikuje zásadně posíláním zpráv. Nové objekty se vytvářejí klonováním
existujících.

Objekty mají ve slotech hodnoty nebo metody. Zprávy zasílané objektům musí mít
stejné jméno jako některý ze slotů objektu nebo nějakého jeho předka. Pokud je
ve slotu hodnota, je výsledkem zaslání zprávy objektu tato hodnota (parametry
zprávy se ignorují). Je-li ve slotu metoda, je výsledkem zaslání zprávy hodnota
vrácená metodou (spuštěnou s argumenty zprávy).

Syntax zasílání zprávy:

[object &optional message arg1 &rest args]

object:   objekt
message:  zpráva, default je symbol self
arg1:     první argument
args      další argumenty ve tvaru plistu (name1 val1 name2 val2 ...)

Metoda je funkce s lambda-seznamem (self arg1 &rest args)
První argument je sice povinný, ale při posílání zprávy může být nevyužit.
args je opět plist. Nejjednodušší způsob definice metody je napsat ji takto:

(lambda (self arg1 &key)
  ... )

Tím se ignorují další argumenty. arg1 je vždy třeba napsat, i když zpráva 
nemá parametr.

Základním objektem je objekt, uložený v globální proměnné object. Ostatní
objekty se vytvářejí jeho klonováním. Další prototypy se typicky také umisťují
do globálních proměnných.

Druhým základním objektem je objekt nihil. Představuje neexistující hodnotu.

Poznámka k principu zapouzdření: všechny sloty objektů jsou veřejné, tj. uživatel
může objektu poslat libovolnou zprávu, která je jménem slotu objektu nebo jeho
předka. Princip zapouzdření je ovšem plně respektován, protože k objektům se
přistupuje pouze zasíláním zpráv (takže např. je možné změnit vnitřní reprezentaci
objektu).

Zprávy objektu object
-----------------------

super        Vrací bezprostředního předka objektu.
set-super superobj    
             Nastaví bezprostředního předka příjemce na superobj.
name         Název objektu. Pro účely lepší orientace.
set-name     Nastavení názvu objektu.
clone        Vytvoří nový objekt naklonováním příjemce. Nový objekt má pouze slot
             super, nastavený na příjemce zprávy.
add-field field-name value
             Přidá slot daného názvu s hodnotou. Pokud hodnota není metoda, přidá
             i příslušný setter. Metodu později přestaneme používat (field-name
             není objekt).
is-nihil     Vrací, zda je příjemce totožný s objektem nihil 
equals obj   Vrací zda je příjemce totožný s objektem obj.
is obj       Vrací zda je příjemce totožný s objektem obj nebo je jeho potomkem.

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Definice prototypového systému
;;;

;; Zabránění dlouhému tisku.
(setf *print-length* 10) ;v tisknutém seznamu bude max 10 prvků
(setf *print-level* 5) ;seznamy se tisknou max. do hloubky 5
(setf *print-circle* t) ;žádný objekt netiskne víckrát, nahrazuje značkou

#|
Objekt je seznam (object nil . plist), kde object je symbol OBJECT, plist je plist
slotů objektu. Nil na druhém místě je kvůli snadnějšímu prohlížení v inspektoru 
jako plist. Později tam místo nil dáme něco užitečnějšího.
|#

;; Objekt object
(defvar object)
(setf object (list 'object nil))

;; Vytvoření objektu:
(defun make-object ()
  (list 'object nil 'super object))

;; Objekt nihil
(defvar nihil)
(setf nihil (make-object))


;; Pomocná funkce, vrací plist slotů a hodnot objektu.
(defun object-plist (obj)
  (cddr obj))

;; Pomocná funkce, nastavuje plist slotů a hodnot objektu.
(defun set-object-plist (obj new-plist)
  (setf (cddr obj) new-plist))

;; Zjištění hodnoty slotu field. Pokud není slot nalezen v objektu obj, pokračuje
;; rekurzivně v hledání v předcích. Pokud není slot nalezen nikde, vyvolá chybu.
;; Vrací dvě hodnoty: hodnotu slotu a vlastníka slotu (objekt, v němž byl slot
;; nalezen)
(defun field-value (obj field)
  ;; field-not-found může být libovolný objekt, o kterém si jsme jisti,
  ;; že je jedinečný (nemůže být prvkem slotu)
  (let* ((field-not-found (gensym "FIELD-NOT-FOUND"))
         (result (getf (object-plist obj) field field-not-found)))
    (if (eql result field-not-found)
        (let ((super-object (field-value obj 'super)))
          (if (eql nihil super-object)
              (error "Field ~s not found." field)
            (field-value super-object field)))
      ;; Vrácení dvou hodnot:
      (values result obj))))

;; Nastavování hodnoty slotu. Nastavuje se přímo v objektu obj, takže se předkův 
;; slot přepíše. Neexistuje-li, slot se vytvoří.
(defun set-field-value (obj field value)
  (let ((plist (object-plist obj)))
    (setf (getf plist field) value)
    (set-object-plist obj plist))
  obj)

(defun setter-name (field-name)
  (intern (format nil "SET-~a" field-name) (symbol-package field-name)))

#|
(setter-name 'field)
|#

;; Vrací metodu pro nastavení slotu jménem field-name
(defun setter-method (field-name)
  (lambda (self arg1 &key)
    (set-field-value self field-name arg1)))

;; Přidání setter-slotu pro slot daného názvu
;; Ve slotu je metoda s argumenty receiver a arg1, což je nastavovaná hodnota
(defun add-setter-field (obj field-name)
  (set-field-value obj
                   (setter-name field-name)
                   (setter-method field-name)))

;; Zjištění, zda je hodnota metoda:
(defun methodp (value)
  (functionp value))

;; Zavolání metody s danými argumenty
(defun call-meth (method self arg1 &rest args)
  (apply method self arg1 args))

;; Přidání slotu do objektu s hodnotou. Pokud není hodnotou metoda,
;; přidá i setter.
(defun add-field (obj field-name value)
  (set-field-value obj field-name value)
  (unless (methodp value)
    (add-setter-field obj field-name))
  obj)

(defun remove-field (obj field-name)
  (let ((plist (object-plist obj)))
    (remf plist field-name)
    (remf plist (setter-name field-name))
    (set-object-plist obj plist)
    obj))

;; Posílání zpráv. Funkce send rozlišuje mezi příjemcem zprávy (receiver)
;; a vlastníkem metody (owner).
(defun send (receiver &optional (message 'self) arg1 
                      &rest args 
                      &key (self receiver) &allow-other-keys)
  (if message
      ;; Zachycení obou hodnot vrácených funkcí field-value
      ;; Budou lexikálně navázány na proměnné value a owner
      (multiple-value-bind (value owner)
          (field-value receiver message)
        (if (methodp value)
            (apply 'call-meth value self arg1 :owner owner :allow-other-keys t args)
          value))
    receiver))

#|
Tady končí základní definice systému.

Inicializace objektu object a nihil:
|#

(add-field object 'add-field (lambda (self arg1 &key (value nihil))
                               (add-field self arg1 value)))

#|
object
|#

(send object 'add-field 'super :value nihil)
(send object 'add-field 'name :value "OBJECT")

#|
(send object 'name)
(send nihil 'name)
(send nihil 'test)
|#

(send nihil 'set-name "NIHIL")
(send object 'add-field 'is-nihil :value nil)
(send nihil 'set-is-nihil t)

#|
(send object 'name)
(send nihil 'name)
(send object 'is-nihil)
(send nihil 'is-nihil)
|#

#|
DRUHÁ FÁZE: syntax pro posílání zpráv
|#

;; Modifikace syntaxe Lispu, aby rozuměl hranatým závorkám.
;; výraz [obj message x y z ...] se přečte jako (send obj message x y z ...)
;; Je ale třeba vyhodnocovat v Listeneru, F8 apod. na tyto výrazy nefunguje.
(defun left-brack-reader (stream char)
  (declare (ignore char))
  (let ((list (read-delimited-list #\] stream t)))
    ;; název zprávy (druhý prvek seznamu) kvotujeme
    (when (second list)
      (setf list (list* (first list) (list 'quote (second list)) (cddr list))))
    (cons 'send list)))

(set-macro-character #\[ 'left-brack-reader)

(defun right-brack-reader (stream char)
  (declare (ignore stream char))
  (error "Non-balanced #\\] encountered."))

(set-macro-character #\] 'right-brack-reader)

;; Hack, aby editor rozuměl hranatým a složeným závorkám
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\[ #\{) 2)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\] #\}) 3)

#|
[[nihil super] name]
|#

[object add-field 'self :value (lambda (self arg1 &key)
                                 self)]

#|
[[nihil self] name]
[nihil]
|#

[object add-field 'equals :value (lambda (self arg1 &key)
                                   (eql self arg1))]
[object add-field 'remove-field :value (lambda (self arg1 &key)
                                         (remove-field self arg1))]
[object add-field 'clone :value (lambda (self arg1 &key)
                                  [(make-object) set-super self])]
[object add-field 'is :value (lambda (self arg1 &key)
                               (and (not [self is-nihil]) ;ukončení rekurze
                                    (or [self equals arg1]
                                        [[self super] is arg1])))]

                                       
#|
[object equals object]
[nihil equals nihil]
[nihil equals object]
(setf obj1 [[object clone] set-name "NEW-OBJECT"])
[obj1 remove-field 'name]
[obj1 name]
[[object clone] is object]
[nihil is nihil]
(setf obj2 [object clone])
[obj2 is object]
(setf obj3 [object clone])
[obj3 is obj2]
|#

