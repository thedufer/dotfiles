
(load "/j/office/app/emacs/prod/jane-elisp/elisp/jane/jane-defaults")
(setq evil-want-C-u-scroll t)
(Jane.evil)
(Jane.shell-file)
(define-key evil-normal-state-map (kbd "C-f") #'universal-argument)
(set-display-table-slot standard-display-table 'wrap ?\x260)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((eval shell-file-mode t) (emacs-lisp-docstring-fill-column . 80) (whitespace-line-column . 80)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :height 120 :font "DejaVu LGC Sans Mono" :family "DejaVu LGC Sans Mono"))))
 '(caml-types-expr-face ((t (:background "forest green"))) t)
 '(flyspell-duplicate ((t (:underline t))))
 '(flyspell-incorrect ((t (:underline t))))
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "green3"))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face :foreground "pale goldenrod"))))
 '(font-lock-function-name-face ((((class color) (background dark)) (:foreground "LightSkyBlue" :weight semi-bold))))
 '(help-argument-name ((t (:background "gray25"))))
 '(mouse ((t (:background "purple"))))
 '(tuareg-font-lock-governing-face ((t (:inherit font-lock-keyword-face :foreground "orange" :weight bold))))
 '(tuareg-font-lock-operator-face ((t (:inherit font-lock-keyword-face :foreground "lightblue"))))
 '(whitespace-trailing ((t (:background "pink" :weight bold)))))
