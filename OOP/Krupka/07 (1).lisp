;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k učebnímu textu M. Krupka: Objektové programování
;;;;
;;;; Kapitola 7, knihovna OMG, verze 1.0
;;;;

#| 
Před načtením souboru načtěte knihovnu micro-graphics
Pokud při načítání (kompilaci) dojde k chybě 
"Reader cannot find package MG",
znamená to, že knihovna micro-graphics není načtená.
|#

#|

DOKUMENTACE
-----------

TŘÍDA OMG-OBJECT
----------------

Jejími potomky jsou všechny třídy naší grafické knihovny. Není určena k
vytváření přímých instancí. Implementuje vlastnické vztahy mezi objekty:
delegáta, systém událostí, hlášení změn a základní události (ev-changing, 
ev-change, ev-mouse-down). Teorie kolem vlastnických vztahů je popsána 
v textu.

V rámci systému hlášení změn rozumí zprávám send-with-change, changing a 
change. Součástí systému hlášení změn jsou události ev-changing a ev-change.


NOVÉ VLASTNOSTI

delegate    Obsahuje delegáta (neboli vlastníka) objektu. Povoleno nastavovat
            pouze vlastníkem (obvykle v momentě, kdy se objekt stává jeho
            součástí).


NOVÉ ZPRÁVY

send-event object event &rest event-args

Zprávu posílá objekt object sám sobě, když chce odeslat událost event s
argumenty event-args. Ve třídě omg-object dělá metoda následující:
- zkontroluje, že objekt má delegáta (vlastnost delegate)
- zkontroluje, že delegát implementuje metodu pro událost event
- událost odešle (případně pod přeloženým jménem)
- jako výsledek vrátí object nebo hodnotu vrácenou událostí.

change object message changed-obj msg-args

Zprávu posílá objekt sám sobě poté, co u něj došlo ke změně, kterou je třeba
oznámit delegátovi (událostí ev-change). Ve třídě omg-object metoda testuje,
není-li (vnitrním počítadlem) u objektu potlačeno posílání událostí ev-change
a ev-changing. Pokud není, pošle (pomocí zprávy send-event) událost ev-change.
Parametry:
- message      jméno zprávy, která změnu vyvolala
- changed-obj  objekt, u nějž došlo ke změně (může se lišit od objektu object)
- msg-args     argumenty zprávy
Hodnoty těchto parametrů se stanou argumenty události ev.change.

changing object message changed-obj msg-args

Zprávu posílá objekt sám sobě předtím, než u něj dojde ke změně, kterou je 
třeba oznámit delegátovi (událostí ev-changing). Ve třídě omg-object metoda 
testuje, není-li (vnitrním počítadlem) u objektu potlačeno posílání událostí 
ev-change a ev-changing. Pokud není, pošle (pomocí zprávy send-event) událost
ev-changing.
Parametry:
- message      jméno zprávy, která změnu vyvolala
- changed-obj  objekt, u nějž dojde ke změně (může se lišit od objektu object)
- msg-args     argumenty zprávy
Hodnoty těchto parametrů se stanou argumenty události ev.change.

send-with-change object msg reported-msg msg-args

Zařídí poslání zprávy jménem msg objektu object s argumenty msg-args. Předtím
pomocí zprávy changing zařídí odeslání události ev-changing a potom pomocí
zprávy change poslání události ev-change. Jako zprávu, která vyvolá (vyvolala)
změnu použije zprávu reported-msg. Tedy, parametrem message události ev-change
a ev-changing bude parametr reported-msg. Parametrem changed-obj bude objekt
object a parametrem msg-args bude hodnota msg-args.
- Pokud ovšem událost ev-changing vrátí nil, znamená to, že delegát objektu
  si nepřeje, aby se změna provedla. Proto se zprávy msg a change nepošlou.
- Zpráva msg se posílá s inkrementovaným vnitřním počítadlem, což zabrání
  generování dalších podřízených událostí o změně. 


NOVÉ PŘIJÍMANÉ UDÁLOSTI

ev-change   receiver sender message changed-obj args
ev-changing receiver sender message changed-obj args

Implementovány ve třídě omg-object, aby jim každý objekt rozuměl. V této třídě
pouze přeposílají událost delegátovi pomocí zprávy change (resp. changing).

ev-mouse-down receiver sender clicked-obj button position

Přeposílá událost delegátovi.


NOVÉ ZASÍLANÉ UDÁLOSTI

ev-change   receiver sender message changing-obj args 
ev-changing receiver sender message changing-obj args

Tyto události posílá objekt delegátovi, když u něj dochází ke změně. Událost
ev-changing bezprostředně před změnou, ev-change bezprostředně po (viz zprávu
send-with-change). Kromě standardních parametrů receiver a sender
(společných všem událostem), jsou dalšími parametry:
- message: zpráva, v důsledku jejíhož přijetí ke změně dochází
- changing-obj: příjemce této zprávy, tj, objekt, u nějž dochází ke změně
- args: argumenty, se kterými byla zpráva odeslána (bez příjemce)
Vyhodnocením seznamu (message changing-obj . args) by se zopakovalo poslání
zprávy.

ev-mouse-down receiver sender clicked-obj button position

Poslána, pokud objekt zjistí, že na něj nebo na podřízený objekt uživatel 
klikl. Parametr clicked-obj je objekt, na který se kliklo původně (může to 
být podobjekt odesílajícího objektu; pak se hodnoty sender a clicked-obj 
liší). button je :left, :center, nebo :right. position je bod (instance třídy
point), na který se kliklo.



TŘÍDA SHAPE (OMG-OBJECT)
------------------------

Potomky třídy shape jsou všechny třídy grafických objektů. Sama není určena k
vytváření přímých instancí.


NOVÉ VLASTNOSTI

window    Okno, ve kterém je objekt umístěn, nebo nil. Typicky ho instance 
          používají při kreslení. Nastavovat ho smí pouze nadřízené objekty
shape-mg-window 
          mg-window okna window.
color, thickness, filledp     
          Grafické parametry. Metody nastavující tyto hodnoty zajišťují
          signalizaci změn událostmi ev-changing a ev-change a zasílají
          objektu pomocnou zprávu do-set-color (-thickness, -filledp).
          Dělají to při inkrementovaném vnitřním počítadle, takže v rámci
          obsluhy těchto pomocných zpráv objekt další události o změnách
          neposílá. Metody set-color, set-thickness, set-filledp nejsou určeny
          k přepisování. Přepisujte metody do-set-color atd.
solidp    Zda objekt přijímá zprávu mouse-down. Ve třídě shape je vždy t.
solid-shapes
          Seznam podobjektů (včetně objektu samého) s nastavenou vlastností
          solidp. Je-li solidp Pravda už u tohoto objektu, je to jednoprvkový
          seznam s objektem samotným. Jinak je to hodnota vlastnosti
          solid-subshapes.
solid-subshapes
          Seznam podobjektů (mimo objektu samého) s nastavenou vlastností
          solidp. Zjišťuje se jen u objektů, které mají vlastnost solidp nil.
          Pokud má objekt vlastnost solidp nastavenu na Pravda, musí mít 
          implementovánu metodu solid-subshapes. Ve třídě shape vede k chybě.

NOVÉ ZPRÁVY

do-set-color object value
do-set-thickness object value
do-set-filledp object value

Nastavují hodnoty příslušných vlastností. Jsou volány z metod set-color,
set-thickness, set-filledp třídy shape. Tyto metody mohou potomci přepsat a
modifikovat tak jejich chování. Nejsou určeny k volání. 

move object dx dy
rotate object angle center
scale object coeff center

Realizují geometrické transformace objektu object. Ve třídě shape zařídí
signalizaci změn a zasílají příslušné do-zprávy. Během jejich vykonávání je
signalizace změn potlačena vnitřním počítadlem.

do-move object dx dy
do-rotate object angle center
do-scale object coeff center

Potomci třídy shape přepisují tyto metody a implementují v nich příslušné
geometrické transformace. Tyto zprávy nejsou určeny k přímému volání; jsou
volány z metod move, rotate, scale třídy shape, které vytváří správné 
prostředí pro hlášení změn. ve třídě shape metody nedělají nic.

draw shape

Vykreslí shape do jejího okna. Typicky voláno nadřízeným objektem. Ve třídě 
shape zasílá zprávy set-mg-params a do-draw.

set-mg-params shape

Nastaví kreslicí parametry okna knihovny micro-graphics, ve kterém je objekt 
umístěn, tak, aby mohl být později vykreslen. Ve třídě shape nastavuje 
parametry :foreground, :filledp, :thickness podle hodnot vlastností color,
filledp a thickness (pořadě). Zasílá se z metody draw třídy shape. Není nutné
volat jindy. Potomci mohou přepsat.

do-draw shape

Vykreslí objekt shape do jeho okna. Může počítat s tím, že grafické parametry
okna knihovny micro-graphics jsou už nastaveny (metodou set-mg-params).
Zasílá se z metody draw třídy shape. Není nutné volat jindy. Potomci mohou 
přepsat. Ve třídě shape nedělá nic.

contains-point-p shape point

Vrací logickou hodnotu "shape obsahuje point". Ve třídě shape vrací nil.

mouse-down object button position

Objekt obdrží tuto zprávu od okna poté, co do něj uživatel klikl myší. 
button je :left, :center, nebo :right, position bod. Lze se
spolehnout, že bod position je opravdu uvnitř objektu. Zprávu dostávají
pouze objekty s nastavenou vlastností solidp. Metoda třídy
shape posílá událost ev-mouse-down s argumentem clicked-obj rovným 
object.


TŘÍDA POINT (SHAPE)
-------------------

Geometrický bod s kartézskými a polárními souřadnicemi. Kreslí se jako
vyplněné kolečko.


NOVÉ VLASTNOSTI

x, y, r, phi  Souřadnice. Nastavení vyvolá hlášení o změně.

NOVÉ ZPRÁVY

set-r-phi point r phi

Souběžné nastavení obou polárních souřadnic. Vyvolává hlášení o změně.

PŘEPSANÉ METODY

do-move point dx dy
do-rotate point angle center
do-scale point coeff center

Implementují geometrické transformace bodu.

set-mg-params point

Modifikuje zděděnou metodu tak, že nastavuje :filledp na T.

do-draw point

Vykreslí bod jako vyplněné kolečko o poloměru rovném nastavené thickness.

contains-point-p point point2

Vrací true právě když je vzdálenost bodů <= (thickness point).


TŘÍDA CIRCLE (SHAPE)
--------------------

Kolečka se středem (instance třídy point) a poloměrem. Středu lze nastavovat
souřadnice a aplikovat na něj transformace.

NOVÉ VLASTNOSTI

center   Střed. Instance třídy point. Jen ke čtení.
radius   Poloměr.


PŘEPSANÉ METODY

do-move circle dx dy
do-rotate circle angle center
do-scale circle coeff center

Implementují geometrické transformace kruhu.

contains-point-p circle point

Je-li (filledp circle) true, vrací true právě když je vzdálenost bodu point
od středu <= (radius circle). Je-li (filledp circle) false, vrací true právě 
když point leží na kružnici s poloměrem (radius circle) a středem (center 
circle) o tloušťce (thickness circle).


TŘÍDA COMPOUND-SHAPE (SHAPE)
----------------------------

Předek tříd grafických objektů, složených z jiných grafických objektů.

NOVÉ VLASTNOSTI

items   Seznam podobjektů. Při nastavování otestuje validitu nastavovaných
        podobjektů (zprávou check-items), připraví hlášení změny před a po 
        nastavení a pošle zprávu do-set-items s inkrementovaným počítadlem
        pro změny. Při čtení vrací kopii seznamu.


NOVÉ ZPRÁVY

check-item shape item

Otestuje, zda objekt item může být podobjektem složeného objektu shape. Pokud
ne, vyvolá chybu. Ve třídě compound-shape vyvolává chybu pořád (abstraktní
metoda), potomci metodu musí přepsat.

check-items shape items

Otestuje, zda seznam items může být seznamem podobjektů objektu shape. Pokud
ne, vyvolá chybu. Ve třídě compound-shape posílá zprávu check-item pro každý
prvek seznamu items.

do-set-items shape value

Nastaví kopii seznamu value jako vlastnost items složeného objektu shape.
Seznam už je prověřený zprávou check-items. Není určeno k volání. Je voláno z
metody set-items třídy compound-shape po nastavení prostředí pro hlášení změn.
Ve třídě compound shape kromě vlastního nastavení vlastnosti items nastavuje
všem objektům v seznamu vlastnosti window a delegate.

send-to-items shape message &rest arguments

Lze použít, pokud chceme všem podobjektům složeného objektu shape poslat
tutéž zprávu se stejnými argumenty.


PŘEPSANÉ METODY

do-move shape dx dy
do-rotate shape angle center
do-scale shape coeff center

Pomocí zprávy send-to-items přepošle zprávu move (nebo rotate, nebo scale) 
všem podobjektům.


TŘÍDA PICTURE (COMPOUND-SHAPE)
------------------------------

Složený grafický objekt, který se vykresluje tak, že postupně vykreslí všechny
podobjekty.


PŘEPSANÉ VLASTNOSTI

window   Při nastavování automaticky nastaví totéž okno i všem podobjektům


PŘEPSANÉ METODY

check-item picture item

Vyvolá chybu, pokud item není typu shape.

do-draw picture

Pošle zprávu draw všem podobjektům (v opačném pořadí, aby se vykreslily zezadu
dopředu)

contains-point-p picture point

Prochází podobjekty a přeposílá jim zprávu contains-point-p. Pokud pro některý
podobjekt je výsledek true, vrátí true. Jinak false.


TŘÍDA POLYGON (COMPOUND-SHAPE)
------------------------------

Grafický objekt složený z bodů. Vykresluje se jako polygon. Proti 
compound-shape má novou vlastnost: closedp.

NOVÉ VLASTNOSTI

closedp  Při filledp nastaveném na false určuje, zda do polygonu patří i
         úsečka spojující první a poslední bod. Při nastavování nachystá
         prostředí hlášení změn a vlastní nastavení provede zasláním zprávy
         do-set-closedp.


NOVÉ ZPRÁVY

do-set-closedp polygon value

Vlastní nastavení vlastnosti closedp. Voláno z metody set-closedp třídy
polygon, která připravuje prostředí pro hlášení změn. Nevolat přímo, pouze
přepisovat.

PŘEPSANÉ METODY

check-item polygon item

Vyvolá chybu, pokud item není bod.

set-mg-params polygon

Volá zděděnou metodu a pak nastavuje kreslicí parametr closedp.

do-draw polygon

Vykreslí polygon zavoláním mg:draw-polygon.

contains-point-p polygon point

Vrací, zda polygon obsahuje bod point. Bere v úvahu vlastnosti closedp,
filledp, thickness.


TŘÍDA WINDOW (MG-OBJECT)
------------------------

Instance reprezentují okna knihovny micro-graphics. Okno se otevře automaticky
při vytváření nové instance. Oknu lze nastavit barvu pozadí a vykreslovaný
grafický objekt.


NOVÉ VLASTNOSTI

shape      Grafický objekt vykreslovaný do okna. Při nastavení se nachystá
           prostředí na hlášení změn a pak se zavolá do-set-shape. Potom
           se okno označí k překreslení zprávou invalidate.
background Barva pozadí okna. Při nastavení se nachystá prostředí na hlášení
           změn a pak se zavolá do-set-background. Potom se okno označí k 
           překreslení zprávou invalidate.
mg-window  Odkaz na okno knihovny micro-graphics. Jen ke čtení.


NOVÉ ZPRÁVY

do-set-shape window shape

Vlastní nastavení vlastnosti shape. Po nastavení vlastnosti se objektu shape
nastaví vlastnost window a delegate na window a událost ev-change.

do-set-background window color

Vlastní nastavení vlastnosti background.

invalidate window

Posílá se oknu, pokud je třeba ho překreslit. Označí okno k překreslení a 
někdy později okno dostane zprávu redraw.

change window message changed-obj args

Zavolá zděděnou metodu a pak invalidate.

redraw window

Vymaže okno barvou pozadí (vlastnost background) a pak vykreslí do okna objekt
uložený ve vlastnosti shape tím, že mu pošle zprávu draw. Nevolat přímo, 
používat zprávu invalidate.

install-callbacks window

Posílá se oknu jako součást inicializace. Slouží k instalaci zpětných
volání knihovny micro-graphics. Ve třídě window instaluje zpětná volání
:display a :mouse-down pomocí zpráv install-display-callback a
install-mouse-down-callback.

install-display-callback window
install-mouse-down-callback window

Nainstalují příslušná zpětná volání.

window-mouse-down window button position

Tuto zprávu okno dostane, pokud do něj uživatel klikne myší. Parametr
button je :left, :center, nebo :right, position je bod, určující pozici myši
při kliknutí. Metoda ve třídě window zjistí, zda se kliklo dovnitř grafického
objektu v okně, který má nastavenu vlastnost solidp na Pravda. Pokud ano, 
pošle si zprávu mouse-down-inside-shape, jinak si pošle zprávu
mouse-down-no-shape. Není určeno k přímému volání.


PŘIJÍMANÉ UDÁLOSTI

ev-change

Ve třídě window pošle oknu zprávu invalidate, aby se vyvolalo jeho
překreslení. Volá zděděnou metodu.
|#

;;;
;;; Třída omg-object
;;;

(defclass omg-object () 
  ((delegate :initform nil)
   (change-level :initform 0)))

(defmethod delegate ((obj omg-object))
  (slot-value obj 'delegate))

(defmethod set-delegate ((obj omg-object) delegate)
  (setf (slot-value obj 'delegate) delegate))

(defmethod change-level ((obj omg-object))
  (slot-value obj 'change-level))

(defmethod inc-change-level ((obj omg-object))
  (setf (slot-value obj 'change-level)
        (+ (slot-value obj 'change-level) 1))
  obj)

(defmethod dec-change-level ((obj omg-object))
  (setf (slot-value obj 'change-level)
        (- (slot-value obj 'change-level) 1))
  obj)

(defun has-method-p (object message arguments)
  (and (fboundp message)              ;je se symbolem message 
                                      ;svázána zpráva (funkce)?
       (compute-applicable-methods    ;vypočte seznam metod
        (symbol-function message)     ;pro zprávu svázanou s message
        (cons object arguments))))    ;s danými argumenty

;; posílání událostí: send-event

(defmethod send-event ((object omg-object) event 
		       &rest event-args)
  (let ((delegate (delegate object)))
    (if (and delegate 
             (has-method-p delegate event (cons object event-args)))
        (apply event delegate object event-args)
      object)))

(defmethod change ((object omg-object) message changed-obj args)
  (if (= (change-level object) 0)
      (send-event object 'ev-change message changed-obj args)
    object))

(defmethod changing ((object omg-object) message changing-obj args)
  (if (= (change-level object) 0)
      (send-event object 'ev-changing message changing-obj args)
    object))

(defmethod send-with-change ((obj omg-object) msg reported-msg args)
  (when (changing obj reported-msg obj args)
    (unwind-protect
        (progn (inc-change-level obj)
          (apply 'funcall msg obj args))
      (dec-change-level obj))
    (change obj reported-msg obj args))
  obj)

;; základní události

(defmethod ev-change ((obj omg-object) sender message changed-obj args)
  (change obj message changed-obj args))

(defmethod ev-changing ((obj omg-object) sender message changing-obj args)
  (changing obj message changing-obj args))

(defmethod ev-mouse-down ((obj omg-object) sender clicked-obj button position)
  (send-event obj 'ev-mouse-down clicked-obj button position))

;;;
;;; Třída shape
;;;

(defclass shape (omg-object)
  ((color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (window :initform nil)))

(defmethod window ((shape shape)) 
  (slot-value shape 'window))

(defmethod set-window ((shape shape) value) 
  (setf (slot-value shape 'window) value)
  shape)

(defmethod shape-mg-window ((shape shape))
  (when (window shape)
    (mg-window (window shape))))

(defmethod color ((shape shape)) 
  (slot-value shape 'color))

(defmethod do-set-color ((shape shape) value)
  (setf (slot-value shape 'color) value))

(defmethod set-color ((shape shape) value) 
  (send-with-change shape 
                    'do-set-color 'set-color 
                    `(,value)))

(defmethod thickness ((shape shape)) 
  (slot-value shape 'thickness)) 

(defmethod do-set-thickness ((shape shape) value) 
  (setf (slot-value shape 'thickness) value)) 

(defmethod set-thickness ((shape shape) value)
  (send-with-change shape 
                    'do-set-thickness 'set-thickness 
                    `(,value)))

(defmethod filledp ((shape shape))
  (slot-value shape 'filledp))

(defmethod do-set-filledp ((shape shape) value)
  (setf (slot-value shape 'filledp) value))

(defmethod set-filledp ((shape shape) value)
  (send-with-change shape 
                    'do-set-filledp 'set-filledp 
                    `(,value)))

(defmethod do-move ((shape shape) dx dy)
  shape)

(defmethod move ((shape shape) dx dy)
  (send-with-change shape 
                    'do-move 'move 
                    `(,dx ,dy)))

(defmethod do-rotate ((shape shape) angle center)
  shape)

(defmethod rotate ((shape shape) angle center)
  (send-with-change shape 
                    'do-rotate 'rotate 
                    `(,angle ,center)))

(defmethod do-scale ((shape shape) coeff center)
  shape)

(defmethod scale ((shape shape) coeff center)
  (send-with-change shape 
                    'do-scale 'scale 
                    `(,coeff ,center)))

(defmethod set-mg-params ((shape shape)) 
  (let ((mgw (shape-mg-window shape)))
    (mg:set-param mgw :foreground (color shape)) 
    (mg:set-param mgw :filledp (filledp shape))
    (mg:set-param mgw :thickness (thickness shape)))
  shape)

(defmethod do-draw ((shape shape)) 
  shape)

(defmethod draw ((shape shape))
  (set-mg-params shape)
  (do-draw shape))


;;; Práce s myší

(defmethod solidp ((shape shape))
  t)

(defmethod solid-shapes ((shape shape))
  (if (solidp shape)
      (list shape)
    (solid-subshapes shape)))

(defmethod solid-subshapes ((shape shape))
  (error "Method has to be rewritten."))


(defmethod contains-point-p ((shape shape) point)
  nil)

(defmethod mouse-down ((shape shape) button position)
  (send-event shape 'ev-mouse-down shape button position))

;;;
;;; Třída point
;;;

(defclass point (shape) 
  ((x :initform 0) 
   (y :initform 0)))

(defmethod x ((point point))
  (slot-value point 'x))

(defmethod y ((point point))
  (slot-value point 'y))

(defmethod do-set-x ((point point) value)
  (setf (slot-value point 'x) value))

(defmethod set-x ((point point) value)
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (send-with-change point 
                    'do-set-x 'set-x 
                    `(,value)))

(defmethod do-set-y ((point point) value)
  (setf (slot-value point 'y) value))

(defmethod set-y ((point point) value)
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (send-with-change point 
                    'do-set-y 'set-y 
                    `(,value)))

(defmethod r ((point point)) 
  (let ((x (slot-value point 'x)) 
        (y (slot-value point 'y))) 
    (sqrt (+ (* x x) (* y y)))))

(defmethod phi ((point point)) 
  (let ((x (slot-value point 'x)) 
        (y (slot-value point 'y))) 
    (cond ((> x 0) (atan (/ y x))) 
          ((< x 0) (+ pi (atan (/ y x)))) 
          (t (* (signum y) (/ pi 2))))))

(defmethod do-set-r-phi ((point point) r phi)
  (set-x point (* r (cos phi)))
  (set-y point (* r (sin phi))))

(defmethod set-r-phi ((point point) r phi) 
  (send-with-change point 
                    'do-set-r-phi 'set-r-phi 
                    `(,r ,phi)))

(defmethod do-set-r ((point point) value)
  (set-r-phi point value (phi point)))

(defmethod set-r ((point point) value) 
  (send-with-change point 
                    'do-set-r 'set-r 
                    `(,value)))

(defmethod do-set-phi ((point point) value)
  (set-r-phi point (r point) value))

(defmethod set-phi ((point point) value) 
  (send-with-change point 
                    'do-set-phi 'set-phi
                    `(,value)))

(defmethod set-mg-params ((pt point))
  (call-next-method)
  (mg:set-param (shape-mg-window pt) :filledp t)
  pt)

(defmethod do-draw ((pt point)) 
  (mg:draw-circle (shape-mg-window pt) 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)

(defmethod do-move ((pt point) dx dy)
  (set-x pt (+ (x pt) dx))
  (set-y pt (+ (y pt) dy))
  pt)

(defmethod do-rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-phi pt (+ (phi pt) angle))
    (move pt cx cy)
    pt))

(defmethod do-scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-r pt (* (r pt) coeff))
    (move pt cx cy)
    pt))

;; Práce s myší

;; Pomocné funkce (vzdálenost bodů)

(defun sqr (x)
  (expt x 2))

(defun point-sq-dist (pt1 pt2)
  (+ (sqr (- (x pt1) (x pt2)))
     (sqr (- (y pt1) (y pt2)))))

(defun point-dist (pt1 pt2)
  (sqrt (point-sq-dist pt1 pt2)))

(defmethod contains-point-p ((shape point) point)
  (<= (point-dist shape point) 
      (thickness shape)))

;;;
;;; Třída circle
;;;

(defclass circle (shape) 
  ((center :initform (make-instance 'point)) 
   (radius :initform 1)))

(defmethod initialize-instance ((c circle) &key)
  (call-next-method)
  (set-delegate (center c) c))

(defmethod radius ((c circle))
  (slot-value c 'radius))

(defmethod do-set-radius ((c circle) value)
  (setf (slot-value c 'radius) value))

(defmethod set-radius ((c circle) value)
  (when (< value 0)
    (error "Circle radius should be a non-negative number"))
  (send-with-change c 
                    'do-set-radius 'set-radius 
                    `(,value)))

(defmethod center ((c circle))
  (slot-value c 'center))

(defmethod do-draw ((c circle))
  (mg:draw-circle (shape-mg-window c)
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)

(defmethod do-move ((c circle) dx dy)
  (move (center c) dx dy)
  c)

(defmethod do-rotate ((c circle) angle center)
  (rotate (center c) angle center)
  c)

(defmethod do-scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (set-radius c (* (radius c) coeff))
  c)

;; Práce s myší

(defmethod contains-point-p ((circle circle) point)
  (let ((dist (point-dist (center circle) point))
        (half-thickness (/ (thickness circle) 2)))
    (if (filledp circle)
        (<= dist (radius circle))
      (<= (- (radius circle) half-thickness)
          dist
          (+ (radius circle) half-thickness)))))


;;;
;;; Třída compound-shape
;;;

(defclass compound-shape (shape)
  ((items :initform '())))

(defmethod items ((shape compound-shape)) 
  (copy-list (slot-value shape 'items)))

(defmethod send-to-items ((shape compound-shape) 
			  message
			  &rest arguments)
  (dolist (item (items shape))
    (apply message item arguments))
  shape)

(defmethod check-item ((shape compound-shape) item)
  (error "Abstract method."))

(defmethod check-items ((shape compound-shape) item-list)
  (dolist (item item-list)
    (check-item shape item))
  shape)

(defmethod do-set-items ((shape compound-shape) value)
  (setf (slot-value shape 'items) (copy-list value))
  (send-to-items shape #'set-delegate shape))

(defmethod set-items ((shape compound-shape) value)
  (check-items shape value)
  (send-with-change shape 
                    'do-set-items 'set-items 
                    `(,value)))

(defmethod do-move ((shape compound-shape) dx dy)
  (send-to-items shape #'move dx dy)
  shape)

(defmethod do-rotate ((shape compound-shape) angle center)
  (send-to-items shape #'rotate angle center)
  shape)

(defmethod do-scale ((shape compound-shape) coeff center)
  (send-to-items shape #'scale coeff center)
  shape)


;;;
;;; Třída picture
;;;

(defclass picture (compound-shape)
  ())

(defmethod check-item ((pic picture) item)
  (unless (typep item 'shape)
    (error "Invalid picture element type."))
  pic)

(defmethod do-set-items ((shape picture) value)
  (call-next-method)
  (send-to-items shape 'set-window (window shape)))

(defmethod draw ((pic picture))
  (dolist (item (reverse (items pic)))
    (draw item))
  pic)

(defmethod set-window ((shape picture) value)
  (send-to-items shape 'set-window value)
  (call-next-method))

;; Práce s myší

(defmethod solidp ((pic picture))
  nil)

(defmethod solid-subshapes ((shape picture))
  (mapcan 'solid-shapes (items shape)))

(defmethod contains-point-p ((pic picture) point)
  (find-if (lambda (item)
	     (contains-point-p item point))
	   (items pic)))


;;;
;;; Třída polygon
;;;

(defclass polygon (compound-shape)
  ((closedp :initform t)))

(defmethod check-item ((poly polygon) item)
  (unless (typep item 'point) 
    (error "Items of polygon should be points."))
  poly)

(defmethod closedp ((p polygon))
  (slot-value p 'closedp))

(defmethod do-set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value))

(defmethod set-closedp ((p polygon) value)
  (send-with-change p 
                    'do-set-closedp 'set-closedp
                    `(,value)))

(defmethod set-mg-params ((poly polygon)) 
  (call-next-method)
  (mg:set-param (shape-mg-window poly) 
                :closedp
                (closedp poly))
  poly)

(defmethod do-draw ((poly polygon)) 
  (let (coordinates)
    (dolist (point (reverse (items poly)))
      (setf coordinates (cons (y point) coordinates)
            coordinates (cons (x point) coordinates)))
    (mg:draw-polygon (shape-mg-window poly) 
                     coordinates))
  poly)

;;
;; contains-point-p pro polygon je trochu složitější
;; (není třeba rozumět detailům)
;;

(defun scalar-product (v1 v2)
  (apply '+ (mapcar '* v1 v2)))

(defun scalar-mult (k v)
  (mapcar (lambda (x) (* k x))
          v))

(defun vec-+ (v1 &rest vectors)
  (apply 'mapcar '+ v1 vectors))

(defun vec-- (v1 &rest vectors)
  (apply 'mapcar '- v1 vectors))

(defun vec-= (v1 v2)
  (every '= v1 v2))

(defun vec-sq-len (v)
  (scalar-product v v))

(defun vec-near-p (v1 v2 tolerance)
  (<= (vec-sq-len (vec-- v1 v2))
      (expt tolerance 2)))

(defun pt-in-seg-p (pt x1 x2 tolerance)
  "Zjisti, zda je bod pt na usecce [x1 x2]."
  (let* ((u (vec-- x2 x1))
         (v (vec-- x1 pt))
         (uu (scalar-product u u)))
    (if (zerop uu)
        (vec-near-p pt x1 tolerance)
      (let ((k (- (/ (scalar-product u v) uu))))
        (and (<= 0 k 1)
             (vec-near-p pt (vec-+ x1 (scalar-mult k u)) tolerance))))))

(defun point-in-segs-p (pt tolerance &optional pt1 pt2 &rest points)
  (and pt1 
       pt2
       (or (pt-in-seg-p pt pt1 pt2 tolerance)
           (apply 'point-in-segs-p pt tolerance pt2 points))))

(defun vert-between-p (pt pt1 pt2)
  (let ((pty (second pt))
        (pt1y (second pt1))
        (pt2y (second pt2)))
    (declare (number pty pt1y pt2y))
    (declare (optimize (speed 3) (safety 0)))
    (or (< pt1y pty pt2y)
        (> pt1y pty pt2y)
        ;;u mensiho z pt1y, pt2y umoznime i rovnost
        (and (/= pt1y pt2y)
             (= (min pt1y pt2y) pty)))))

(defun horiz-right-p (pt pt1 pt2)
  (destructuring-bind (ptx pty pt1x pt1y pt2x pt2y) (append pt pt1 pt2)
    (< (+ (* (- pt1x pt2x) 
             (/ (- pty pt2y)
                (- pt1y pt2y)))
          pt2x)
       ptx)))

(defun intersects-p (pt pt1 pt2)
  (and (vert-between-p pt pt1 pt2)
       (horiz-right-p pt pt1 pt2)))

(defun count-intersections (pt &optional pt1 pt2 &rest points)
  (if (and pt1 pt2)
       (+ (if (intersects-p pt pt1 pt2) 1 0)
          (apply 'count-intersections pt pt2 points))
    0))

(defun point-in-poly-p (pt ignore &rest points)
  (declare (ignore ignore))
  (oddp (apply 'count-intersections pt points)))

(defun point-x-y (point)
  (list (x point) (y point)))

(defmethod contains-point-p ((poly polygon) point)
  (let ((items (items poly)))
    (apply (if (filledp poly) 'point-in-poly-p 'point-in-segs-p) 
           (point-x-y point)
           (thickness poly)
           (mapcar 'point-x-y (if (or (closedp poly) (filledp poly))
                                  (append (last items) items)
                                items)))))


;;;
;;; Třída window
;;;

(defclass window (omg-object)
  ((mg-window :initform (mg:display-window))
   (shape :initform nil)
   (background :initform :white)))

(defmethod mg-window ((window window))
  (slot-value window 'mg-window))

(defmethod shape ((w window))
  (slot-value w 'shape))

(defmethod do-set-shape ((w window) shape)
  (when shape
    (set-window shape w)
    (set-delegate shape w))
  (setf (slot-value w 'shape) shape)
  w)

(defmethod set-shape ((w window) shape)
  (send-with-change w 
                    'do-set-shape 'set-shape 
                    `(,shape)))

(defmethod background ((w window))
  (slot-value w 'background))

(defmethod do-set-background ((w window) color)
  (setf (slot-value w 'background) color))

(defmethod set-background ((w window) color)
  (send-with-change w 
                    'do-set-background 'set-background 
                    `(,color)))

(defmethod invalidate ((w window))
  (mg:invalidate (mg-window w))
  w)

(defmethod change ((w window) message changed-obj args)
  (call-next-method)
  (invalidate w))

(defmethod redraw ((window window))
  (let ((mgw (mg-window window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window))))
  window)


;; Klikání

(defmethod find-clicked-shape ((w window) position)
  (when (shape w)
    (find-if (lambda (shape) (contains-point-p shape position))
             (solid-shapes (shape w)))))

(defmethod mouse-down-inside-shape ((w window) shape button position)
  (mouse-down shape button position)
  w)

(defmethod mouse-down-no-shape ((w window) button position)
  w)

(defmethod window-mouse-down ((w window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (mouse-down-inside-shape w shape button position)
      (mouse-down-no-shape w button position))))


;; Inicializace

(defmethod install-display-callback ((w window))
  (mg:set-callback (mg-window w)
		   :display (lambda (mgw)
                              (declare (ignore mgw))
                              (redraw w)))
  w)

(defmethod install-mouse-down-callback ((w window))
  (mg:set-callback 
   (mg-window w) 
   :mouse-down (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-mouse-down 
                  w
                  button 
                  (move (make-instance 'point) x y)))))

(defmethod install-callbacks ((w window))
  (install-display-callback w)
  (install-mouse-down-callback w)
  w)

(defmethod initialize-instance ((w window) &key)
  (call-next-method)
  (install-callbacks w)
  w)



