;; -*- mode: lisp; encoding: utf-8; -*-
;;;END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 09.lisp - Prototypy: všechno je objekt
;;;;

#|

Interpret prototypového jazyka

|#


#|
Úprava 1. prosince:
Přidána funkce arg1-field a upravena funkce call-standard-method.
Slot metody pro první argument nyní může mít libovolný název začínající na "ARG1".
Pokud není název při vytvoření metody stanoven a metoda je s prvním argumentem 
zavolána, vytvoří se stejně jako v minulé verzi slot arg1.

Důvodem úpravy byla možnost překrytí názvu slotu pro první argument u 
lexikálně vnořených metod.
|#

#|

TERMINOLOGIE
------------

OBJEKT            je cokoliv. Objekty se dělí na DATOVÉ a METODY. Všechny objekty
                  (kromě primitiv) mají sloty.
DATOVÝ OBJEKT     je objekt bez kódu. Je to buď STANDARDNÍ OBJEKT, nebo EXTERNÍ
                  OBJEKT.
STANDARDNÍ OBJEKT je seznam (object nil . names-and-values).
EXTERNÍ OBJEKT    je cokoliv jiného kromě lispové funkce.

METODA            je objekt určený k vyhodnocení. Pokud je ve slotu, místo vrácení
                  se spustí. Metoda je vždy buď STANDARDNÍ METODA nebo PRIMITIVUM.
STANDARDNÍ METODA je seznam (object code . names-and-values), kde code není nil.
PRIMITIVUM        je lispová funkce. Musí mít lambda-seznam (self arg1 &key ...).
METODA OBJEKTU    je metoda, která je uložena ve slotu datového objektu. Pokud je
                  metoda standardní, má mezi sloty slot owner, jehož hodnotou je 
                  onen datový objekt.

INLINE OBJEKT     je objekt, který vznikl načtením ze zdrojového textu. Buď pomocí
                  {}-syntaxe, nebo jako LITERÁL.
LITERÁL           je externí objekt vzniklý přímo načtením ze zdrojového textu.
                  Typicky je to číslo nebo řetězec.

|#

#|

Definice prototypového systému

|#

;; Zabránění dlouhému tisku.
(setf *print-length* 10) ;v tisknutém seznamu bude max 10 prvků
(setf *print-level* 5)   ;seznamy se tisknou max. do hloubky 5
(setf *print-circle* t)  ;žádný objekt se netiskne víckrát, nahrazuje se značkou
                         ;(mj. brání zacyklení při tisku)

;; Proměnnou *nihil* potřebujeme ve field-value. Základní objekty jinak definujeme
;; později.
(defvar *nihil*)

;; Pomocné funkce, vracejí a nastavují plist slotů a hodnot objektu.
;; Jsou napsány jako metody, abychom je mohli definovat i pro jiné reprezentace
;; objektů.
;; (cons je třída všech tečkových párů, tzv. system-class, instance nejsou
;; "standardní", nemají sloty a nevytvářejí se pomocí make-instance, nicméně
;; lze pro ně psát metody.
(defmethod object-plist ((obj cons))
  (cddr obj))

;; Pomocná funkce, nastavuje plist slotů a hodnot objektu.
(defmethod set-object-plist ((obj cons) new-plist)
  (setf (cddr obj) new-plist))

;; Pomocné funkce, vrací resp. nastavují kód objektu.
(defmethod object-code ((obj cons))
  (second obj))

(defmethod set-object-code ((obj cons) code)
  (setf (second obj) code))

;; Zjištění, zda je hodnota metoda, tedy primitivum nebo objekt s kódem:
(defun methodp (value)
  (or (functionp value)
      (and (listp value) (object-code value))))

#|
Práce se sloty. K přístupu používají object-plist a set-object-plist, takže
nejsou závislé na reprezentaci objektu.
|#

;; Zjištění hodnoty slotu field. Pokud není slot nalezen v objektu obj, pokračuje
;; rekurzivně v hledání v předcích. Pokud není slot nalezen nikde, vyvolá chybu.
;; Už není třeba vracet dvě hodnoty, protože metoda zná objekt, ve kterém je
;; uložena (slot owner)
(defun field-value (obj field)
  ;; field-not-found může být libovolný objekt, o kterém si jsme jisti,
  ;; že je jedinečný (nemůže být prvkem slotu)
  (let* ((field-not-found (gensym "FIELD-NOT-FOUND"))
         (result (getf (object-plist obj) field field-not-found)))
    (if (eql result field-not-found)
        (let ((super-object (field-value obj 'super)))
          (if (eql *nihil* super-object)
              (error "Field ~s not found." field)
            (field-value super-object field)))
      result)))

;; Nastavování hodnoty slotu. Nastavuje se přímo v objektu obj, takže se předkův 
;; slot přepíše. Neexistuje-li, slot se vytvoří.
;; Je-li value standardní metoda a objekt je datový,
;; nastaví metodě slot owner.
(defun set-field-value (obj field value)
  (let ((plist (object-plist obj)))
    (setf (getf plist field) value)
    (set-object-plist obj plist))
  (when (and (methodp value) (listp value) (not (methodp obj)))
    (set-field-value value 'owner obj))
  obj)

;; Zjištění názvu slotu (tj. symbolu) na základě řetězce
;; nebo symbolu.
;; Lispová funkce intern vyrábí symbol z jeho textového názvu
(defun field-name (field-name-str)
  (intern (format nil "~a" field-name-str)))

(defun setter-name (field-name-str)
  (intern (format nil "SET-~a" field-name-str)))

#|
(field-name "FIELD")
(field-name :field)
(setter-name "FIELD")
(setter-name 'field)
|#

;; Vytvoří metodu (primitivum) pro nastavení slotu jménem field-name-str (řetězec)
;; Je to metoda s argumenty self (příjemce) a arg1, což je nastavovaná hodnota
(defun setter-method (field-name-str)
  (lambda (self arg1 &key)
    (set-field-value self (field-name field-name-str) arg1)))

;; Přidání setter-slotu pro slot daného názvu
(defun add-setter-field (obj field-name-str)
  (set-field-value obj
                   (setter-name field-name-str)
                   (setter-method field-name-str)))


;; Funkce add-field a remove-field jsou současně primitiva

;; Přidání slotu do objektu s hodnotou. Pokud není hodnotou metoda,
;; přidá i setter. 
(defun add-field (obj field-name-str &key (value *nihil*))
  (set-field-value obj (field-name field-name-str) value)
  (unless (methodp value)
    (add-setter-field obj field-name-str))
  obj)

;; odstranění slotu z objektu
(defun remove-field (obj field-name-str &key)
  (let ((plist (object-plist obj)))
    (remf plist (field-name field-name-str))
    (remf plist (setter-name field-name-str))
    (set-object-plist obj plist)
    obj))

#|

Základní objekty

|#

;; Objekt object
(defvar *object*)
(setf *object* (list 'object nil))

(add-field *object* "ADD" :value #'add-field)
(add-field *object* "REMOVE" :value #'remove-field)

;; Vytvoření objektu:
(defun make-object ()
  (list 'object nil 'super *object*))

(defun clone-object (object)
  (let ((result (make-object)))
    ;; Důležité pořadí! Aby, pokud jde o metodu, add-field
    ;; nenastavovalo owner
    (set-object-code result (object-code object))
    (add-field result "SUPER" :value object)
    result))

(setf *nihil* (make-object))

(add-field *object* "SUPER" :value *nihil*)

(defvar *lobby*)
(setf *lobby* (make-object))

(add-field *lobby* "LOBBY" :value *lobby*)
(add-field *lobby* "OBJECT" :value *object*)
(add-field *lobby* "NIHIL" :value *nihil*)

(add-field *lobby* "OWNER" :value *nihil*)
(add-field *lobby* "SELF" :value *nihil*)


#|

Interpret

|#

;; Zavolání metody s danými argumenty
(defun call-meth (method self arg1 &rest args)
  (if (functionp method)
      (apply method self arg1 args) ;primitivum
    (apply 'call-standard-method method self arg1 args)))

;; pomocná funkce, vrací každý druhý prvek seznamu počínaje prvním
(defun every-other (list)
  (when list
    (cons (car list) (every-other (cddr list)))))

#|
(every-other '(1 2 3 4 5 6 7 8 9))
(every-other '(1 2 3 4 5 6 7 8 9 10))
|#

;; Vrátí název slotu metody pro první argument. Slot se pozná tak,
;; že jeho název začíná na "ARG1". Pokud takový slot nenajde, vrátí symbol arg1. 
(defun arg1-field (method)
  (let ((prop (find-if (lambda (prop)
                         (eql (search "ARG1" (symbol-name prop)) 0))
                       (every-other (object-plist method)))))
    (if prop prop 'ARG1)))

#|
(arg1-field '(object nil arg1 1 arg2 2 arg3 3)) 
(arg1-field '(object nil arg2 2 arg3 3))
(arg1-field '(object nil arg2 2 arg3 3 arg1-test 4))
|#
  
(defun call-standard-method (method self arg1 &rest args)
  (let ((clone (clone-object method))) ;naklonujeme metodu
    ;; jde-li o metodu v datovém objektu, nastavíme self.
    ;; pozor, i taková metoda může být zavolána následkem
    ;; poslání zprávy metodě: sama je umístěna v lobby (takže
    ;; v datovém objektu), ale byla zavolána následkem
    ;; poslání zprávy metodě, která je potomkem lobby.
    ;; proto také testujeme, není-li self metoda
    (unless (or (eql (field-value clone 'owner) *nihil*)
                (methodp self))
      (set-field-value clone 'self self))
    (when arg1                                  ;volána s prvním argumentem
      ;; Tady je vylepšení. Původní verze:
      ;; (set-field-value clone 'arg1 arg1)
      ;; Nová verze:
      (set-field-value clone (arg1-field method) arg1))
    (loop for names-and-args on args by 'cddr   ;nastavení slotů pro další argumenty
          while names-and-args
          do (set-field-value clone 
                              (field-name (first names-and-args))
                              (second names-and-args)))
    (evaluate (object-code clone) clone)))      ;a to podstatné: vyhodnocení kódu metody
                                                ;v připravené metodě

;; Posílání zpráv. 
;; (vysvětlení klíčových slov &optional, &rest, &key je v textu
(defun send (receiver message
                      &optional arg1 
                      &rest args 
                      &key (self receiver) &allow-other-keys)
  (let ((value (field-value receiver message)))
    (if (methodp value)
        (apply 'call-meth value self arg1 args)
      value)))

(defun evaluate-send-code (code object)
  ;; code je tvaru (send obj message arg1 :name1 val1 :name2 val2 ...)
  ;; hodnoty obj, arg1, val1, val2 ... vyhodnotíme a pak zavoláme send
  ;; využijeme toho, že symboly :xxx jsou keywords
  ;; Speciální případ: když obj je (send) - neboli [] před přečtením,
  ;; nahrazujeme parametrem object
  (let ((obj (second code))
        (message (third code))
        (args-and-names (cdddr code)))
    (apply 'send (if (equal obj '(send))
                     object
                   (evaluate obj object))
                 message
                 (mapcar (lambda (elem)
                           (if (keywordp elem)
                               elem
                             (evaluate elem object)))
                         args-and-names))))

(defun evaluate-code-list (code object)
  (let ((last *nihil*))
    ;; code je (code [ ... ] [ ... ] ...)
    (dolist (c (rest code))
      (setf last (evaluate c object)))
    last))

(defun make-inline-object (spec object)
  (let ((result (make-object))
        (slots (second spec))
        (code (third spec)))
    (dolist (slot slots)
      (add-field result slot :value *nihil*))
    (set-object-code result code)
    (set-field-value result 'super object)
    result))

(defun code-type (code)
  (cond ((symbolp code)                :message)         ;zpráva
        ((not (listp code))            :literal)         ;číslo, řetězec, ...
        ((eql (first code) 'send)      :send)            ;[ ... ]
        ((eql (first code) 'inline)    :inline)          ;{ ... }
        ((eql (first code) 'lambda)    :primitive)       ;(lambda (...) ...)
        ((eql (first code) 'function)  :primitive)       ;(function f) neboli #'f 
        ((eql (first code) 'code)      :code)            ;kód stand. metody
        (t (error "Unknown code type: ~s." code))))

(defun evaluate (code &optional (object *lobby*))
  (ecase (code-type code)
    (:message (send object code))
    (:literal code)
    (:send (evaluate-send-code code object))
    (:inline (make-inline-object code object))
    (:primitive (compile nil code))
    (:code (evaluate-code-list code object))))


#|
Tady končí základní definice systému.
|#


#|

Syntax pro posílání zpráv

|#

;; Výrazy na horní úrovni se načtou takto: (evaluate načtený-výraz)
;; Vnořené výrazy už jenom jako: načtený-výraz
;; Zařídí to tato dynamická proměnná:
(defvar *top-level-code-p*)
(setf *top-level-code-p* t)

;; Modifikace syntaxe Lispu, aby rozuměl hranatým závorkám.
;; výraz [obj message x y z ...] se přečte jako (send obj message x y z ...),
;; kde vnitřní podvýrazy se rekurzivně opět přečtou readerem
;; Je ale třeba vyhodnocovat v Listeneru, F8 apod. na tyto výrazy nefunguje.
(defun left-brack-reader (stream char)
  (declare (ignore char))
  (let ((result (cons 'send 
                      (let ((*top-level-code-p* nil))
                        (read-delimited-list #\] stream t)))))
    (if *top-level-code-p*
        (list 'evaluate (list 'quote result))
      result)))

(set-macro-character #\[ 'left-brack-reader)

(defun right-paren-reader (stream char)
  (declare (ignore stream))
  (error "Non-balanced ~s encountered." char))

(set-macro-character #\] 'right-paren-reader)

;; Složené závorky 
;; načtou se jako inline objekt:
;; {(a b c) [ .. ] [ .. ]} -> (inline (a b c) (code-list [ .. ] [ .. ]))
(defun left-brace-reader (stream char)
  (declare (ignore char))
  (let ((list (let ((*top-level-code-p* nil))
                (read-delimited-list #\} stream t)))
        result)
    (setf result
          (list 'inline 
                (first list)                          ;seznam slotů
                (when (rest list)
                  (cons 'code (rest list)))))         ;kód
    (if *top-level-code-p*
        (list 'evaluate (list 'quote result))
      result)))

(set-macro-character #\{ 'left-brace-reader)

(set-macro-character #\} 'right-paren-reader)

#|
;; Testy čtení (vyhodnocovat v Listeneru)
'[a b]
'[[a b] c {() d [e {(f) g h}]}]
|#


;; Hack, aby editor rozuměl hranatým a složeným závorkám
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\[ #\{) 2)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\] #\}) 3)

#|

Externí objekty: čísla a řetězce

|#

;; Čísla

(add-field *lobby* "NUMBER" :value (make-object))

(defvar *number*)
(setf *number* (field-value *lobby* 'number))

(defvar *number-plists*)
(setf *number-plists* nil)

(defmethod object-plist ((obj number))
  (let ((plist (getf *number-plists* obj)))
    (unless plist (setf plist (list 'super *number*)))
    plist))

(defmethod set-object-plist ((obj number) value)
  (setf (getf *number-plists* obj) value))

;; řetězce (nelze jim nastavovat plisty, jen načíst super)

(defvar *string*)
(setf *string* (make-object))

(add-field *lobby* "STRING" :value *string*)
(add-field *string* "+" :value (lambda (self arg1 &key)
                                 (format nil "~a~a" self arg1)))

(defmethod object-plist ((obj string))
  (list 'super *string*))


