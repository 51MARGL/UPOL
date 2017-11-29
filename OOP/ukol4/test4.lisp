;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ULOHA 9.1  
;;; 

[true add "OR" :value true]
[false add "OR" :value {(arg1) arg1}]

#|
[[true or true] name]
[[true or false] name]
[[false or true] name]
[[false or false] name]
|#

[true add "NOT" :value false]
[false add "NOT" :value true]

#|
[[true not] name]
[[false not] name]
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ULOHA 9.2  
;;; 

[object add "IS-NIHIL" :value false]
[nihil set-is-nihil true]

#|
[[nihil is-nihil] name]
[[lobby is-nihil] name]
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ULOHA 9.3  
;;; 

[lobby add "PAIR" :value [object clone]]
[pair set-name "PAIR"]
[pair add "CAR"]
[pair add "CDR"]
[pair add "CONS" :value {(arg1 arg2) [self set-car arg1] [self set-cdr arg2]}]

[lobby add "EMPTY-LIST" :value [pair clone]]
[empty-list set-name "EMPTY-LIST"]
[empty-list set-car nihil]
[empty-list set-cdr nihil]

[lobby add "LIST" :value [pair clone]]
[list set-name "LIST"]

#|
[pair cons 1 :arg2 [[pair clone] cons 3 :arg2 4]]
[[pair cdr] car] ;3
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[list car]  ;1
[[list cdr] car] ;2
[[[list cdr] cdr] car] ;3
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ULOHA 9.4  
;;; 

[empty-list add "LENGTH" :value zero]

[list add "LENGTH" :value {() [[[self cdr] is empty-list]
                               if-true {() [1 esoteric]}
                               :else {() [[1 esoteric] + [[self cdr] length]]}]}]

#|
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[[list length] name] ;3
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ULOHA 9.5  
;;; 

[list add "APPEND" :value {(arg1) [[[self cdr] is empty-list]
                                   if-true {() [self set-cdr arg1]}
                               :else {() [[self cdr] append arg1]}]}]

#|
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[list append [[list clone] cons 4 :arg2 empty-list]]
[[[[list cdr] cdr] cdr] car] ;4
[[list length] name] ;4
|#

[list add "FIND" :value {(arg1) [[[self car] is arg1]
                                 if-true {() [self car]}
                                 :else {()  [[[self cdr] is empty-list]
                                             if-true {() nihil}
                                             :else {() [[self cdr] find arg1]}]}]}]

#|
[list cons [1 esoteric] :arg2 [[list clone] cons [2 esoteric] :arg2 [[list clone] cons [3 esoteric] :arg2 empty-list]]]
[[list find [1 esoteric]] name] ;1
[[list find [10 esoteric]] name] ;NIHIL
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; ULOHA 9.8  
;;; 

[zero add "*" :value {(arg1) self}]
[one add "*" :value {(arg1) arg1}]
[[one succ] add "*" :value {(arg1) [self + [[arg1 super] * self]]}]

#|
[[[0 esoteric] * [4 esoteric]] name]
[[[2 esoteric] * [1 esoteric]] name]
[[[2 esoteric] * [5 esoteric]] name]
|#



[zero add "-" :value {(arg1) [[[arg1 name] is 0]
                              if-true {() self}
                              :else {}]}]


[one add "-" :value {(arg1) [[arg1 is self]
                             if-true {() zero}
                             :else {() [[[arg1 name] is 0]
                                        if-true {() self}
                                        :else {}]}]}]

[[one succ] add "-" :value {(arg1) [[arg1 is self]
                                    if-true {() zero}
                                    :else {() [[[arg1 name] is 0]
                                        if-true {() self}
                                        :else {() [[self super] - [arg1 super]]}]}]}]

#|
[[[9 esoteric] - [4 esoteric]] name]
[[[2 esoteric] - [1 esoteric]] name]
[[[2 esoteric] - [2 esoteric]] name]
[[[2 esoteric] - [5 esoteric]] name] ;!!chyba zaporna cisla nejsou definovane!!
|#

[zero add "^" :value {(arg1) self}]
[one add "^" :value {(arg1) [[[arg1 name] is 0]
                              if-true {() one}
                               :else {() [self * [self ^ [arg1 super]]]}]}]

#|
[[[0 esoteric] ^ [4 esoteric]] name]
[[[2 esoteric] ^ [1 esoteric]] name]
[[[4 esoteric] ^ [5 esoteric]] name]
[[[4 esoteric] ^ [0 esoteric]] name]
|#



[zero add "!" :value [1 esoteric]]
[one add "!" :value {(self) [self * [[self super] !]]}]


#|
[[[0 esoteric] !] name]
[[[2 esoteric] !] name]
[[[4 esoteric] !] name]
|#