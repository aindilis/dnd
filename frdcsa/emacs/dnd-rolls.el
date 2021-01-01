(global-set-key "\C-cdd4" 'dnd-roll-d4)
(global-set-key "\C-cdd6" 'dnd-roll-d6)
(global-set-key "\C-cdd8" 'dnd-roll-d8)
(global-set-key "\C-cdd10" 'dnd-roll-d10)
(global-set-key "\C-cdd20" 'dnd-roll-d20)

(defun dnd-roll-d4 (&optional arg)
 (interactive "P")
 (see (dnd-roll 4 arg)))

(defun dnd-roll-d6 (&optional arg)
 (interactive "P")
 (see (dnd-roll 6 arg)))

(defun dnd-roll-d8 (&optional arg)
 (interactive "P")
 (see (dnd-roll 8 arg)))

(defun dnd-roll-d10 (&optional arg)
 (interactive "P")
 (see (dnd-roll 10 arg)))

(defun dnd-roll-d20 (&optional arg)
 (interactive "P")
 (see (dnd-roll 20 arg)))

(defun dnd-roll (n &optional arg)
 (+ (cl-random n) 1))

(defun dnd-roll-with-advantage (n)
 (max (dnd-roll n) (dnd-roll n)))

(defun dnd-roll-with-disadvantage (n)
 (min (dnd-roll n) (dnd-roll n)))

(defun dnd-roll-prolog (n)
 (string-to-int
  (substring-no-properties
   (car
    (cdr
     (car
      (formalog-query
       (list 'var-roll)
       (list "roll" (list "d" n) 'var-roll)
       nil "DnD-Agent1")))))))

(provide 'dnd-rolls)
