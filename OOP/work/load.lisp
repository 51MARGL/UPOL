;; -*- mode: lisp; encoding: utf-8; -*-

#|

Soubor 10_load.lisp

Načtení tohoto souboru vede ke zkompilování a načtení knihovny micro-graphics,
souboru 10.lisp a dalších souborů ke kapitole 10: 10_bounds.lisp, 
10_text-shape.lisp, 10_button.lisp.

Adresář knihovny micro-graphics a všechny uvedené soubory musí být ve stejném
adresáři jako tento soubor.

|#

(in-package "CL-USER")

(defsystem oop-10 ()
  :members ("micro-graphics/load" 
            "10" "10_bounds" "10_text-shape" "10_button")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(compile-system 'oop-10 :load t)