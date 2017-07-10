(defvar window)
(setf window [object clone])
[window set-name "WINDOW"]
[window add-field 'background :value :white]
[window add-field 'mg-window :value nihil]
[window add-field 'display :value (lambda (self arg1 &key)
                                    [self set-mg-window (mg:display-window)])]
[[window clone] display]

(setf lobby [object clone])
[lobby set-name "LOBBY"]
[lobby add "TRUE" :value {()}]