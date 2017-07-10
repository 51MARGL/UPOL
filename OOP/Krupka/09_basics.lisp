;; -*- mode: lisp; encoding: utf-8; -*-
;;;END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 09_basics.lisp - základní definice v prototypovém jazyce
;;;;

;; (Vše dávat postupně do Listeneru)
;; Slot name:

[object add "NAME" :value "OBJECT"]
[nihil set-name "NIHIL"]
[lobby set-name "LOBBY"]

#|
[object name]
[nihil name]
[[nihil super] name]
[lobby name]
|#

#|
;; Test vytváření inline objektů
{(a b c) [a b]}
|#

;; Klonování
[object add "CLONE" :value {() [{} set-super self]}]

#|
[object clone]
[[[object clone] super] name]
[[[object clone] set-name "OBJECT-1"] name]
[object name]
|#

;; Logika
[lobby add "TRUE" :value [object clone]]
[true set-name "TRUE"]
[true add "IF-TRUE" :value {(arg1 else) arg1}]
[lobby add "FALSE" :value [object clone]]
[false set-name "FALSE"]
[false add "IF-TRUE" :value {(arg1 else) else}]

[true add "AND" :value {(arg1) arg1}]
[false add "AND" :value false]

#|
[[lobby true] name]
[true name]
[false name]

[true if-true 1 :else 0]
[false if-true 1 :else 0]

[[true and true] name]
[[true and false] name]
[[false and true] name]
[[false and false] name]
|#

;; Primitivum na tisk

[object add "PRINT" :value (lambda (self arg1 &key)
                             (declare (ignore arg1))
                             (print self))]

#|
["Hello World" print]
[true if-true {() [1 print] 10} :else 0]
|#

;; return-first - vyhodnotí dva výrazy, vrátí výsledek prvního
[lobby add "RETURN-FIRST"
       :value {(self arg1 arg2 var) [[] set-var arg1]
                                    arg2
                                    var}]
#|
[lobby return-first {() ["FIRST" print]} :arg2 {() ["SECOND" print]}]
|#

;; is

[object add "IS" 
        :value {(self arg1) [object add "IS-MARK" :value false]
                            [arg1 add "IS-MARK" :value true]
                            [[] return-first [self is-mark]
                                             :arg2 {() [arg1 remove "IS-MARK"]
                                                       [object remove "IS-MARK"]}]}]
#|
[[lobby is object] name]
[[object is object] name]
[[object is lobby] name]
[[[lobby clone] is lobby] name]
[[[lobby clone] is [lobby clone]] name]
[[true is lobby] name]
|#

;; equals

[object add "EQUALS" 
            :value {(arg1) [[arg1 is self] and [self is arg1]]}]

#|
[[object equals object] name]
[[nihil equals nihil] name]
[[nihil equals object] name]
|#


;; Čísla jako externí objekty

[number set-name "NUMBER"]

#|
[[0 super] name]
[[0 is number] name]
[[0 is 0] name]
[[number is 0] name]
[[10 equals 10] name]

*number-plists*
|#

[number add "+" :value (lambda (self arg1 &key)
                         (+ self arg1))]
[number add "-" :value (lambda (self arg1 &key)
                         (- self arg1))]
[number add "*" :value (lambda (self arg1 &key)
                         (* self arg1))]
[number add "/" :value (lambda (self arg1 &key)
                         (/ self arg1))]

#|
[1 + 1]
|#

[number add "!" :value {(self) [self * [[self - 1] !]]}]
[0 add "!" :value 1]

#|
[0 !]
[2 !]
[3 !]
[10 !]
|#

#|

;; Řetězce

["Hello " + "World"]

|#

#|
;; Test volání zděděné metody

[lobby add "TEST" :value [object clone]]
[test set-name "TEST"]
[test add "TEST-MSG" :value {() "Hello"}]
[test test-msg]
 

[lobby add "TEST" :value [object clone]]
[test set-name "TEST"]
[test add "TEST-METHOD" :value {() [owner name]}]
[test test-method]

[lobby add "OBJ1" :value [object clone]]
;; všimněte si přepsání hodnoty metodou (lze i naopak):
[obj1 set-name {() [[[owner super] name nihil :self self] + [self postfix]]}]
[obj1 add "POSTFIX" :value "-1"]

[obj1 name]
[lobby add "OBJ2" :value [obj1 clone]]
[obj2 name] 

;; tady se využije vnucený self
[obj2 set-postfix "-2"]
[obj2 name]

|#

;; esoterická čísla
;; jsou to čísla vytvořená čistě prostředky jazyka

[lobby add "ZERO" :value [object clone]]
[zero add "NEXT-NUMBER" :value nihil]
[zero set-name 0]

;; succ vrací následníka čísla. next-number je pomocný slot, který
;; následníka obsahuje, pokud už byl vytvořen 
[zero add "SUCC" :value {() [[[self next-number] is nihil] 
                             if-true {() [self set-next-number [self clone]]
                                         [[self next-number] set-next-number nihil]
                                         [[self next-number] set-name [[self name] + 1]]}
                             :else {}]
                            [self next-number]}]

[lobby add "ONE" :value [zero succ]]

#|
[one name]
[[one super] name]
[[[[[one succ] succ] succ] succ] name]
[[[[[[[[one succ] succ] succ] succ] super] super] super] name]
|#

;; převod externích čísel na esoterická (převod zpět už máme pomocí name):

[0 add "ESOTERIC" :value zero]
[number add "ESOTERIC" :value {() [[[self - 1] esoteric] succ]}]

#|

[[0 esoteric] name]
[[[1 esoteric] equals one] name]
[[3 esoteric] name]

|#

;; Sčítání s esoterických čísel:

[zero add "+" :value {(arg1) arg1}]
[one add "+" :value {(arg1) [[self super] + [arg1 succ]]}]

#|
[[[2 esoteric] + [3 esoteric]] name]
|#