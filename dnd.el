(defvar dnd-agent-name "KBFS-Agent1")

(global-set-key "\C-c\C-k\C-vDD" 'dnd-quick-start)

(global-set-key "\C-cdde" 'dnd-edit-dnd-file)
(global-set-key "\C-cddgl" 'dnd-action-get-line)
(global-set-key "\C-cddws" 'dnd-set-windows)
(global-set-key "\C-cdds" 'dnd-quick-start)
(global-set-key "\C-cddr" 'dnd-restart)
(global-set-key "\C-cddk" 'dnd-kill)
(global-set-key "\C-cddc" 'dnd-clear-context)
(global-set-key "\C-cddm" 'dnd-reload-all-modified-source-files)

(global-set-key "\C-cddop" 'dnd-open-source-file)
(global-set-key "\C-cddoP" 'dnd-open-source-file-reload)

(defvar dnd-default-context "Org::FRDCSA::DnD")
(defvar dnd-source-files nil)

(defun dnd-issue-command (query)
 ""
 (interactive)
 (uea-query-agent-raw nil dnd-agent-name
  (freekbs2-util-data-dumper
   (list
    (cons "_DoNotLog" 1)
    (cons "Eval" query)))))

(defun dnd-action-get-line ()
 ""
 (interactive)
 (see (dnd-issue-command
  (list "_prolog_list"
   (list "_prolog_list" 'var-Result)
   (list "emacsCommand"
    (list "_prolog_list" "kmax-get-line")
    'var-Result)))))

(defun dnd-quick-start ()
 ""
 (interactive)
 
 (dnd)
 (dnd-fix-windows)
 (dnd-select-windows))

(defun dnd (&optional load-command)
 ""
 (interactive)
 (if (dnd-running-p)
  (error "ERROR: DnD Already running.")
  (progn
   (run-in-shell "cd /var/lib/myfrdcsa/codebases/minor/dnd/scripts" "*DnD*")
   (sit-for 3.0)
   (ushell)
   (sit-for 1.0)
   (pop-to-buffer "*DnD*")
   (insert (or load-command "./dnd-start -u"))
   (comint-send-input)
   (sit-for 3.0)
   (run-in-shell "cd /var/lib/myfrdcsa/codebases/minor/dnd/scripts && ./dnd-start-repl" "*DnD-REPL*" nil 'formalog-repl-mode)
   (setq formalog-agent dnd-agent-name)
   (sit-for 1.0))))

(defun dnd-set-windows ()
 ""
 (interactive)
 (dnd-fix-windows)
 (dnd-select-windows))

(defun dnd-fix-windows ()
 ""
 (interactive)
 (delete-other-windows)
 (split-window-vertically)
 (split-window-horizontally)
 (other-window 2)
 (split-window-horizontally)
 (other-window -2))

(defun dnd-select-windows ()
 ""
 (interactive)
 (switch-to-buffer "*DnD*")
 (other-window 1)
 (switch-to-buffer "*ushell*")
 (other-window 1)
 (switch-to-buffer "*DnD-REPL*")
 (other-window 1)
 (ffap "/var/lib/myfrdcsa/codebases/minor/dnd/dnd.pl"))

(defun dnd-restart ()
 ""
 (interactive)
 (if (yes-or-no-p "Restart DnD? ")
  (progn
   (dnd-kill)
   (dnd-quick-start))))

(defun dnd-kill ()
 ""
 (interactive)
 (flp-kill-processes)
 (shell-command "killall -9 \"dnd-start\"")
 (shell-command "killall -9 \"dnd-start-repl\"")
 (shell-command "killall-grep DnD-Agent1")
 (kmax-kill-buffer-no-ask (get-buffer "*DnD*"))
 (kmax-kill-buffer-no-ask (get-buffer "*DnD-REPL*"))
 ;; (kmax-kill-buffer-no-ask (get-buffer "*ushell*"))
 (dnd-running-p))

(defun dnd-running-p ()
 (interactive)
 (setq dnd-running-tmp t)
 (let* ((matches nil)
	(processes (split-string (shell-command-to-string "ps auxwww") "\n"))
	(failed nil))
  (mapcar 
   (lambda (process)
    (if (not (kmax-util-non-empty-list-p (kmax-grep-v-list-regexp (kmax-grep-list-regexp processes process) "grep")))
     (progn
      (see process 0.0)
      (setq dnd-running-tmp nil)
      (push process failed))))
   dnd-process-patterns)
  (setq dnd-running dnd-running-tmp)
  (if (kmax-util-non-empty-list-p failed)
   (see failed 0.1))
  dnd-running))

(defun dnd-clear-context (&optional context-arg)
 (interactive)
 (let* ((context (or context-arg dnd-default-context)))
  (if (yes-or-no-p (concat "Clear Context <" context ">?: "))
   (freekbs2-clear-context context))))

(defvar dnd-process-patterns
 (list
  "dnd-start"
  "dnd-start-repl"
  "/var/lib/myfrdcsa/codebases/internal/unilang/unilang-client"
  "/var/lib/myfrdcsa/codebases/internal/freekbs2/kbs2-server"
  "/var/lib/myfrdcsa/codebases/internal/freekbs2/data/theorem-provers/vampire/Vampire1/Bin/server.pl"
  ))

(defun dnd-eval-function-and-map-to-integer (expression)
 ""
 (interactive)
 (dnd-serpro-map-object-to-integer
  (funcall (car expression) (cdr expression))))

(defun dnd-serpro-map-object-to-integer (object)
 ""
 (interactive)
 (see object)
 (see (formalog-query (list 'var-integer) (list "prolog2TermAlgebra" object 'var-integer) nil "DnD-Agent1")))

(defun dnd-serpro-map-integer-to-object (integer)
 ""
 (interactive)
 (see integer)
 (see (formalog-query (list 'var-integer) (list "termAlgebra2prolog" object 'var-integer) nil "DnD-Agent1")))

(defun dnd-edit-dnd-file ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/dnd/dnd.el"))

(defun dnd-reload-all-modified-source-files ()
 ""
 (interactive)
 (kmax-move-buffer-to-end-of-buffer (get-buffer "*DnD*"))
 (formalog-query
  nil
  (list "make")
  nil "DnD-Agent1"))

;; emacsCommand(['kmax-get-line'],Result). 
;; (see (freekbs2-importexport-convert (list (list 'var-Result) (list "emacsCommand" (list "kmax-get-line") 'var-Result)) "Interlingua" "Perl String"))

;; "Eval" => {
;;           "_prolog_list" => {
;;                             "_prolog_list" => [
;;                                               \*{'::?Result'}
;;                                             ],
;;                             "emacsCommand" => [
;;                                               [
;;                                                 "_prolog_list",
;;                                                 "kmax-get-line"
;;                                               ],
;;                                               \*{'::?Result'}
;;                                             ]
;;                           }
;;         },

;; "Eval" => [
;;           [
;;             "_prolog_list",
;;             [
;;               "_prolog_list",
;;               \*{'::?Result'}
;;             ],
;;             [
;;               "emacsCommand",
;;               [
;;                 "_prolog_list",
;; 	        "kmax-get-line",
;;               ],
;;               \*{'::?Result'}
;;             ]
;;           ]
;;         ],


;; <message>
;;   <id>1</id>
;;   <sender>DnD-Agent1</sender>
;;   <receiver>Emacs-Client</receiver>
;;   <date>Sat Apr  1 10:16:28 CDT 2017</date>
;;   <contents>eval (run-in-shell \"ls\")</contents>
;;   <data>$VAR1 = {
;;           '_DoNotLog' => 1,
;;           '_TransactionSequence' => 0,
;;           '_TransactionID' => '0.667300679865178'
;;         };
;;   </data>
;; </message>

;; (see (eval (read "(run-in-shell \"ls\")")))
;; (see (cons "Result" nil ))

;; (see (freekbs2-util-data-dumper
;;      (list
;;       (cons "_DoNotLog" 1)
;;       (cons "Result" nil)
;;       )
;;       ))

;; ;; (see '(("_DoNotLog" . 1) ("Result")))
;; ;; (see '(("Result"))

;; (freekbs2-util-convert-from-emacs-to-perl-data-structures '(("_DoNotLog" . 1) ("Result")))
;; (mapcar 'freekbs2-util-convert-from-emacs-to-perl-data-structures '(("_DoNotLog" . 1) ("Result")))

;; (mapcar 'freekbs2-util-convert-from-emacs-to-perl-data-structures '(("_DoNotLog" . 1) ("Result")))

;; (see '(("_DoNotLog" . 1) ("Result")))
;; (see '(("Result")))
;; (see '(("_DoNotLog" . 1)))

;; (join ", " (mapcar 'freekbs2-util-convert-from-emacs-to-perl-data-structures '("Result")))


;; (dnd-eval-function-and-map-to-integer (list 'buffer-name))




;;;;;;;;;;;;;;;; FIX Academician to use DnD
;; see /var/lib/myfrdcsa/codebases/minor/academician/academician-dnd.el

;; (dnd-retrieve-file-id "/var/lib/myfrdcsa/codebases/internal/digilib/data-git/game/16/c/Knowledge Representation and Reasoning.pdf")

(defun dnd-retrieve-file-id (file)
 (let* ((chased-original-file (kmax-chase file))
	(results
	 (formalog-query
	  (list 'var-FileIDs)
	  (list "retrieveFileIDs" chased-original-file 'var-FileIDs)
	  nil "DnD-Agent1")))
  (see (car (cdadar results)))))

;; (defun academician-get-title-of-publication (&optional overwrite)
;;  ""
;;  (interactive "P")
;;  (let* ((current-cache-dir (doc-view--current-cache-dir))
;; 	(current-document-hash (gethash current-cache-dir academician-parscit-hash))
;; 	(title0 (gethash current-cache-dir academician-title-override-hash)))
;;   (if (non-nil title0)
;;    title0
;;    (progn
;;     (academician-process-with-parscit overwrite)
;;     (let* ((title1
;; 	    (progn
;; 	     ;; (see current-document-hash)
;; 	     (cdr (assoc "content" 
;; 		   (cdr (assoc "title" 
;; 			 (cdr (assoc "variant" 
;; 			       (cdr (assoc "ParsHed" 
;; 				     (cdr (assoc "algorithm" current-document-hash))))))))))))
;; 	   (title2
;; 	    (cdr (assoc "content" 
;; 		  (cdr (assoc "title" 
;; 			(cdr (assoc "variant" 
;; 			      (cdr (assoc "SectLabel" 
;; 				    (cdr (assoc "algorithm" current-document-hash)))))))))))
;; 	   (title 
;; 	    (chomp (or title1 title2))))
;;      (if (not (equal title "nil"))
;;       title
;;       (academician-override-title)))))))

;; (defun academician-process-with-parscit (&optional overwrite)
;;  "Take the document in the current buffer, process the text of it
;;  and return the citations, allowing the user to add the citations
;;  to the list of papers to at-least-skim"
;;  (interactive "P")
;;  (if (derived-mode-p 'doc-view-mode)
;;   (if doc-view--current-converter-processes
;;    (message "Academician: DocView: please wait till conversion finished.")
;;    (let ((academician-current-buffer (current-buffer)))
;;     (academician-doc-view-open-text-without-switch-to-buffer)
;;     (while (not academician-converted-to-text)
;;      (sit-for 0.1))
;;     (let* ((filename (buffer-file-name))
;; 	   (current-cache-dir (doc-view--current-cache-dir))
;; 	   (txt (expand-file-name "doc.txt" current-cache-dir)))
;;      (if (equal "fail" (gethash current-cache-dir academician-parscit-hash "fail"))
;;       (progn
;;        ;; check to see if there is a cached version of the parscit data
;;        (if (file-readable-p txt)
;; 	(let* ((command
;; 		(concat 
;; 		 "/var/lib/myfrdcsa/codebases/minor/academician/scripts/process-parscit-results.pl -f "
;; 		 (shell-quote-argument filename)
;; 		 (if overwrite " -o " "")
;; 		 " -t "
;; 		 (shell-quote-argument txt)
;; 		 " | grep -vE \"^(File is |Processing with ParsCit: )\""
;; 		 ))
;; 	       (debug-1 (if academician-debug (see (list "command: " command))))
;; 	       (result (progn
;; 			(message (concat "Processing with ParsCit: " txt " ..."))
;; 			(shell-command-to-string command)
;; 			)))
;; 	 (if academician-debug (see (list "result: " result)))
;; 	 (ignore-errors
;; 	  (puthash current-cache-dir (eval (read result)) academician-parscit-hash))
;; 	 )
;; 	(message (concat "File not readable: " txt)))
;;        ;; (freekbs2-assert-formula (list "has-title") academician-default-context)
;;        )))))))


;; (global-set-key "\C-cdd" )

;; (defun dnd-roll ()
;;  ""
;;  (interactive)
;;  )


(add-to-list 'load-path "/var/lib/myfrdcsa/codebases/minor/dnd/frdcsa/emacs")
(require 'dnd-rolls)



(defun dnd-open-source-file-reload ()
 (interactive)
 (setq dnd-source-files nil)
 (dnd-open-source-file)
 (dnd-get-actual-source-files))

(defun dnd-open-source-file ()
 (interactive)
 (dnd-load-source-files)
 (let ((file (ido-completing-read "Source File: " (dnd-get-actual-source-files))))
  (ffap file)
  (end-of-buffer)
  (dnd-complete-from-predicates-in-current-buffer)))

(defun dnd-get-actual-source-files ()
 ""
 (mapcar 'shell-quote-argument
  (kmax-grep-list dnd-source-files
   (lambda (value)
    (and (stringp value) (file-exists-p value))))))

(defun dnd-complete-from-predicates-in-current-buffer ()
 ""
 (interactive)
 (if dnd-complete-from-predicates
  (let ((predicates (dnd-util-get-approximately-all-predicates-in-current-file buffer-file-name)))
   (insert (concat (ido-completing-read "Predicate: " predicates) "()."))
   (backward-char 2))))

(defun dnd-load-source-files ()
 ""
 (if (not (non-nil dnd-source-files))
  (progn
   (setq dnd-source-files
    (cdr
     (nth 1
      (nth 0
       (formalog-query (list 'var-X) (list "listFiles" 'var-X) nil "DnD-Agent1")))))
   (setq dnd-source-files-chase-alist (kmax-file-list-chase-alist dnd-source-files)))))

(defun dnd-get-stats ()
 ""
 (interactive)
 (-flatten (mapcar #'last (formalog-query (list 'var-X) (list "getTypeValue" "aindilis" "stats" 'var-X) nil "DnD-Agent1"))))

(defun dnd-get-skills ()
 ""
 (interactive)
 (-flatten (mapcar #'last (formalog-query (list 'var-X) (list "getTypeValue" "aindilis" "skills" 'var-X) nil "DnD-Agent1"))))

(defun dnd-make-saving-throw ()
 ""
 (interactive)
 (see (car (last (first (formalog-query (list 'var-X) (list "make" "aindilis" (list "savingThrow" (completing-read "Stat: " (dnd-get-stats)) 'var-X)) nil "DnD-Agent1"))))))

(defun dnd-make-check ()
 ""
 (interactive)
 (see (car (last (first (formalog-query (list 'var-X) (list "make" "aindilis" (list "check" (completing-read "Skill: " (dnd-get-skills)) 'var-X)) nil "DnD-Agent1"))))))

