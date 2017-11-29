(defvar *game* '(0 ("Welcome, choose options(type (choose x))"
                   "1 - Start. 2 - Exit." 2 (1 0) (15 0))
                  1 ("You need to start your engine:"
                     "1 - Turn the key. 2 - Use kickstarter." 2 (2 0) (3 2) )
                  2 ("Nice! You didn't brake the key. Seems like you are low on fuel" 
                     "1 - Drive to the highway. 2 - Drive to the gus station. 3 - Stay home." 3 (4 0) (5 0) (12 0))
                  3 ("So...You broke your leg. -2 Lifes." 
                     "1 - Try to drive to hospital on your own. 2 - Call an ambulance." 2 (6 all) (7 0))
                  4 ("That wasn't best decision. You've stuck on highway one alone."
                     "1 - Try to stop someone for help. 
2 - Try to reach nearest gus station on foot. Seems like there is shortcut." 2 (8 0) (9 all))
                  5 ("Good job. Now you can drive somewhere."
                     "1 - Nearest pub and get some beer. 2 - Just get a night ride. 3 - Drive home" 3 (10 all) (11 0) (12 0))
                  6 ("Because of your leg, You have fallen down and were hitted by bus. Morgue's workers were really surprised."
                     () 0)
                  7 ("Seems like nothing serious. They've fixed it quickly, but anyway now you have gyps."
                     "1 - Stay at home. 2 - Go to pub and have some beer. 3 - Go to your girlfriend." 3 (12 0) (13 3) (14 0))
                  8 ("So You were there for about 5 hours. But one trucker finally helped you out. Seems like you are tired."
                     "1 - Drive home. 2 - Drive to your girlfriend." 2 (12 0) (14 0))
                  9 ("You've lost in woods because of that. At night your bonfire lure a bear, that slashed You into pieces."
                     () 0)
                  10 ("Beer was nice, but You've drunk pretty much. After pub You've decided to have a ride and got yourself into accident."
                      () 0)
                  11 ("Nothing special has happened. But seems like you are tired."
                      "1 - Drive home. 2 - Drive to your girlfriend." 2 (12 0) (14 0))
                  12 ("That was a crazy day, but You have survived anyway. Do You want to try another day?"
                      "1 - Yes. 2- No." 2 (1 0) (15 0))
                  13 ("In the pub You've gotten into fight. Someone kicked your ass. -3 Lifes"
                      "1 - Go home. 2 - Go to your girlfriend." 2 (12 0) (14 0))
                  14 ("You had a nice evening with her. Nice ending of the day. Do You want to try another day?"
                      "1 - Yes. 2- No." 2 (1 0) (15 0))
                  15 ("You've left the game. Goodbye" "No options.")))

(defvar *you* '(() ;Lifes
                () ;Current situation
                () ;Options
                ())) ;Nof situation

(defun get-global-lvl ()
  (cadr (member (currentpos-number) *game*)))

(defun get-global-situation (n)
  (caadr (member n *game*)))

(defun get-global-option (n)
  (cadadr (member n *game*)))

(defun get-globalnof-situation (n)
  (car (member n *game*)))

(defun get-options-amount ()
  (nth 2 (get-global-lvl)))

(defun get-lifes-penalty (chosen-option)
  (cadr (nth (+ chosen-option 2) (get-global-lvl))))

(defun get-next-situation (chosen-option)
  (car (nth (+ chosen-option 2) (get-global-lvl))))

(defun get-current-lifes ()
  (car *you*))

(defun get-current-situation ()
  (cadr *you*))

(defun get-current-option ()
  (caddr *you*))

(defun currentpos-number ()
  (cdddr *you*))

(defun set-lifes (n)
  (setf (car *you*) n))

(defun set-situation (sit)
  (setf (cadr *you*) sit))

(defun set-option (opt)
  (setf (caddr *you*) opt))

(defun set-nof-situation (n)
  (setf (cdddr *you*) n))

(defun dead ()
  (< (get-current-lifes) 1))

(defun print-lvl ()
  (print "Lifes:")
  (print (get-current-lifes))
  (print "Current situation:")
  (print (get-current-situation))
  (print "Options:")
  (print (get-current-option))
  (print "Type (choose x)")
  (values))

(defun set-newlvl (sit)
  (progn
    (set-situation (get-global-situation sit)) 
    (set-option (get-global-option sit)) 
    (set-nof-situation (get-globalnof-situation sit))))

(defun start ()
  (set-lifes 5)
  (set-newlvl 0)
  (print-lvl))

(defun game-over ()
  (print (get-current-situation))
  (print "You've lost all your lifes. You need to start again. Type (start)")
  (values))

(defun kill-lifes (lifes-penalty)
  (if (eql lifes-penalty 'all)  (set-lifes 0)
    (set-lifes (- (get-current-lifes) lifes-penalty))))
  
(defun check-results (x)
       (or (> x (get-options-amount))
           (< x 1)))

(defun results-error ()
  (print "No such options. Try again")
  (print-lvl))

(defun choice-result (chosen-option)
  (progn 
    (kill-lifes (get-lifes-penalty chosen-option))
    (get-next-situation chosen-option)))

(defun choose (x)
  (if (check-results x) (results-error)
    (progn
      (set-newlvl (choice-result x))
      (if(dead) (game-over)
        (print-lvl)))))   
          


                    
                      
          



   



                          
  
