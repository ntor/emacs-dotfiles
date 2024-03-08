;; Simple Emacs Config

(load-theme 'modus-vivendi)
(set-face-attribute 'fringe nil :background nil)
;; (add-hook 'modus-themes-after-load-theme-hook
;;           (lambda () (set-face-attribute 'fringe nil :background nil)))

(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)
(set-frame-parameter nil 'height 52)
(set-frame-parameter nil 'width 103)
(set-frame-position (selected-frame) 0 0)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(setq ring-bell-function 'ignore)

;; Window Setup
;; ------------

(defun pw/notebook-full-size ()
  (interactive)
  ;; (set-frame-parameter nil 'height 53)
  (toggle-frame-maximized)
  (set-frame-parameter nil 'width 203))

(defun pw/notebook-slim-size ()
  (interactive)
  ;; (set-frame-parameter nil 'height 53)
  (toggle-frame-maximized)
  (set-frame-parameter nil 'width 103))

(defun pw/desktop-slim-size ()
  (interactive)
  (toggle-frame-maximized)
  (set-frame-parameter nil 'width 140))

(defun pw/desktop-full-size ()
  (interactive)
  (toggle-frame-maximized)
  (set-frame-parameter nil 'width 271))

(defun pw/move-frame-top-left ()
  (interactive)
  (set-frame-position (selected-frame) 0 0))

(defun pw/insert-math-parentheses () (interactive)
       (insert "\\(  \\)")
       (backward-char 3))

(add-hook 'window-setup-hook
          'pw/notebook-slim-size 'append)
(add-hook 'window-setup-hook
          'pw/move-frame-top-left 'append)


(defun backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir "~/.emacs.d/emacs-backup/")
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setq make-backup-file-name-function 'backup-file-name)



;; --------------------
;; INITIALISATION (package.el/use-package)
;; --------------------
;; (require 'package)

;; (setq package-archives '(("melpa" . "https://melpa.org/packages/")
;;                          ("org" . "https://orgmode.org/elpa/")
;;                          ("elpa" . "https://elpa.gnu.org/packages/")))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; (package-initialize)
;; (unless package-archive-contents
;;   (package-refresh-contents))
;; Initialize use-package on non-Linux platforms
;; (unless (package-installed-p 'use-package)
;;   (package-install 'use-package))
;; (require 'use-package)

(setq use-package-always-ensure t)

;; --------------------
;; GENERAL
;; --------------------
(use-package emacs
  :hook
  (after-init . recentf-mode)
  (prog-mode . electric-pair-mode)

  :config
  (pixel-scroll-precision-mode)
  (global-auto-revert-mode 1)
  (setq auto-revert-verbose nil)
  (setq scroll-conservatively 101)
  (setq enable-recursive-minibuffers t)
  
  ;; (setq scroll-margin 0)
  ;; (setq major-mode-remap-alist
  ;;       '((python-mode . python-ts-mode))
  ;;       )
  ;; (keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)
  
  ;; Revert Dired and other buffers
  (customize-set-variable 'global-auto-revert-non-file-buffers t)
  ;;(delete-selection-mode)

  ;; Use spaces instead of tabs
  (setq-default indent-tabs-mode nil)
  (setq sentence-end-double-space nil)

  ;; Use y/n instead of yes/no
  (if (boundp 'use-short-answers)
      (setq use-short-answers t)
    (advice-add 'yes-or-no-p :override #'y-or-n-p))

  ;; Do not save duplicates in kill-ring
  (customize-set-variable 'kill-do-not-save-duplicates t)

  ;; Make shebang (#!) file executable when saved
  (add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)
  
  :bind (
	 ("s-x" . execute-extended-command)
	 ("M-o" . other-window)
	 ("s-<down>" . shrink-window)
	 ("s-<up>" . enlarge-window)
	 ("C-c k" . kill-buffer-and-window)
	 ("C-x k" . kill-this-buffer)
         ("C-x C-b" . ibuffer)
         ("C-c f r" . recentf)
         ("C-c d" . duplicate-dwim)
         ("C-s-SPC" . mark-sexp)
         ("s-i" . up-list)
         ("M-[" . (lambda () (interactive) (scroll-down-line 3)))
         ("M-]" . (lambda () (interactive) (scroll-up-line 3)))
	 ([swipe-left] . nil)
	 ([swipe-right] . nil)
	 ([magnify-up] . nil)
	 ([magnify-down] . nil)
	 ([pinch] . nil)
         ("C-<wheel-down>" . nil)
         ("C-<wheel-up>" . nil)
	 )
  )

;; (setq auto-window-vscroll nil)
;; (customize-set-variable 'fast-but-imprecise-scrolling t)
;; (customize-set-variable 'scroll-conservatively 101)
;; (customize-set-variable 'scroll-margin 0)
;; (customize-set-variable 'scroll-preserve-screen-position t)

;; (global-set-key (kbd "s-W") 'delete-frame) ; ⌘-W = Close window
;; (global-set-key (kbd "s-}") 'tab-bar-switch-to-next-tab) ; ⌘-} = Next tab
;; (global-set-key (kbd "s-{") 'tab-bar-switch-to-prev-tab) ; ⌘-{ = Previous tab
(global-set-key (kbd "s-t") 'tab-bar-new-tab) ;⌘-t = New tab
(global-set-key (kbd "s-w") 'tab-bar-close-tab) ; ⌘-w = Close tab


;; ------------------------
;; PACKAGE CONFIGURATION
;; ------------------------
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(use-package corfu
  :bind
  ("C-<tab>" . completion-at-point)
  :config
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete)
  :init
  (global-corfu-mode)
  )

(use-package which-key
  :config
  (which-key-mode))

(use-package visual-fill-column
  )

(use-package popper
  :bind (("M-`"   . popper-toggle)
         ("C-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          "\\*eldoc .+\\*"
          "\\*eldoc\\*"
          "\\*TeX Help\\*"
          help-mode
          compilation-mode))
  (popper-mode 1)
  ;; (popper-echo-mode -1)
  )

;; (use-package solaire-mode
;;   :init
;;   (solaire-global-mode +1)
;;   )

(use-package git-gutter-fringe
  :init
  (global-git-gutter-mode))


(use-package adaptive-wrap)

(use-package savehist
  :init
  (savehist-mode))

(use-package vertico
  :config
  (setq vertico-count 8)
  :init
  (vertico-mode))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("s-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  )

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :bind (
         ("C-x b" . consult-buffer)
         ("s-m" . consult-imenu))
  )

(use-package eglot)

(use-package tex
  :ensure auctex

  :bind (:map TeX-mode-map
         ("M-=" . (lambda () (interactive) (save-buffer) (TeX-command "LaTeX" 'TeX-master-file)))
         )

  :hook
  ((LaTeX-mode . tex-pdf-mode)
   (LaTeX-mode . TeX-source-correlate-mode)
   (LaTeX-mode . visual-line-mode)
   (LaTeX-mode . visual-fill-column-mode)
   (LaTeX-mode . adaptive-wrap-prefix-mode)
   (LaTeX-mode . LaTeX-math-mode)
   (LaTeX-mode . turn-on-reftex))

  :config
  (setq TeX-source-correlate-method 'synctex)
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  (setq TeX-PDF-mode t)
  (setq TeX-save-query nil)
  (setq TeX-electric-sub-and-superscript t)
  (setq LaTeX-electric-left-right-brace t)
  (setq TeX-electric-math (cons "$" "$"))
  ;;(setq TeX-parse-self t)
  (setq reftex-plug-into-AUCTeX t)
  (setq TeX-newline-function 'reindent-then-newline-and-indent)
  (setq TeX-view-program-selection
        '((output-dvi "open")
          (output-pdf "Skim")
          (output-html "open")))
  (setq TeX-view-program-list
        '(("Skim"
           "/Applications/Skim.app/Contents/SharedSupport/displayline -g %n %o %b")))
  (setq reftex-default-bibliography
        "~/Documents/library/references/references.bib"
        font-latex-fontify-script nil
        font-latex-fontify-sectioning 1.0)
  (setq blink-matching-paren nil)
  )

(use-package auctex-latexmk
  :init
  (auctex-latexmk-setup)
  :config
  (setq auctex-latexmk-inherit-TeX-PDF-mode t)
  )


(use-package cdlatex
  :config
  (setq cdlatex-simplify-sub-super-scripts nil)
  )

(use-package citar
  :bind
  ("C-c b" . citar-open)
  ("C-c i" . citar-insert-citation)
  :custom
  (citar-bibliography '("~/Documents/library/references/references.bib"))
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :config
  (push '("pdf" . citar-file-open-external) citar-file-open-functions)
  (setq org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar)
  (setq citar-open-resources '(:files))
  )


(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))
;;(use-package pdf-tools)

(use-package avy
  :bind (
	 ("s-;" . avy-goto-char-timer)
	 ("s-l" . avy-goto-line)
	 ("C-;" . avy-goto-char-2))
  :custom
  (setq avy-indent-line-overlay nil)
  )

(use-package deft
  :bind
  (("C-c n d" . deft))
  :config
  (setq deft-directory "~/org/notes/")
  (setq deft-default-extension "org"
        ;; de-couples filename and note title:
        deft-use-filename-as-title nil
        deft-use-filter-string-for-filename t
        ;; disable auto-save
        deft-auto-save-interval -1.0
        ;; converts the filter string into a readable file-name using kebab-case:
        deft-file-naming-rules
        '((noslash . "-")
          (nospace . "-")
          (case-fn . downcase)))
  )

(use-package highlight-indent-guides
  :hook
  (python-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character)
  )

(use-package markdown-mode)

(use-package treemacs
  :bind
  (("C-c t" . treemacs)
   ("M-0" . treemacs-select-window))
  :config
  (setq treemacs-no-png-images t)
  (setq treemacs-indentation 2)
  (setq treemacs-width 30) ; Adjust the width of Treemacs window
  (setq treemacs-text-scale -1)
  (setq treemacs-show-hidden-files nil) ; Hide hidden files in Treemacs
  (setq treemacs-no-load-time-warnings t)
  (treemacs-fringe-indicator-mode 'only-when-focused)
  )


(use-package expand-region
  :bind
  (
   ("C-=" . er/expand-region)
   ;;("C-s-SPC" . er/expand-region)
   ;; ("s-," . er/mark-LaTeX-math)
   ;; ("s-." . er/mark-LaTeX-inside-environment)
   ))
  

(use-package nerd-icons)

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :config
  (setq mode-line-right-align-edge 'right-fringe)
  )

(use-package magit
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  )

;;(package-vc-install '(combobulate :url "https://github.com/mickeynp/combobulate"))
;; (use-package combobulate
;;   :preface
;;   (setq combobulate-key-prefix "C-c o")

;;   ;; :hook ((python-ts-mode . combobulate-mode)
;;   ;;        (js-ts-mode . combobulate-mode)
;;   ;;        (css-ts-mode . combobulate-mode)
;;   ;;        (yaml-ts-mode . combobulate-mode)
;;   ;;        (json-ts-mode . combobulate-mode)
;;   ;;        (typescript-ts-mode . combobulate-mode)
;;   ;;        (tsx-ts-mode . combobulate-mode))
;;   ;; ;; Amend this to the directory where you keep Combobulate's source
;;   ;; ;; code.
;;   ;; :load-path ("path-to-git-checkout-of-combobulate"))
;;   )

(use-package impatient-mode)

;; Org
;; ---

(use-package org
  :bind
  (:map org-mode-map
	("$" . pw/insert-math-parentheses))
  :hook
  (org-mode . visual-line-mode)
  :config
  (setq org-startup-indented t
        org-startup-folded t
        org-hide-leading-stars nil
        org-hide-emphasis-markers t
        org-highlight-latex-and-related '(latex)
        org-latex-create-formula-image-program 'dvisvgm
        )
  (setq calendar-week-start-day 1)
  (setq org-cite-global-bibliography '("~/Documents/library/references/references.bib"))
  ;; (plist-put org-format-latex-options :foreground 'default)
  ;;(plist-put org-format-latex-options :background "Transparent")
  ;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 0.7))
  (remove-hook 'org-cycle-hook
               #'org-optimize-window-after-visibility-change)
  (remove-hook 'org-cycle-hook
               #'org-cycle-optimize-window-after-visibility-change)
  ;;(require 'ox-ipynb)
  ;;(set-company-backend! 'org-mode nil)
  (setq org-clock-mode-line-total 'current)
  (setq org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                       (:session . "py")
                                                       (:kernel . "python3")))
  )



;; Python
;; ------

;; To conisder: py-isort, pyimport, python-pytest

(use-package eldoc
  :config
  (setq eldoc-echo-area-use-multiline-p nil))

(use-package python-mode
  :hook
  (python-base-mode . eglot-ensure)
  (python-base-mode . eldoc-mode)
  :bind
  (:map python-mode-map
        ("C-c e n" . flymake-goto-next-error)
        ("C-c e p" . flymake-goto-prev-error)
        )
  :init
  (setq python-indent-guess-indent-offset-verbose nil)

  :config
  (er/enable-mode-expansions 'python-ts-mode 'er/add-python-mode-expansions)
  )

(use-package pet
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))

(use-package jupyter
  :config
  (setq jupyter-repl-echo-eval-p t)
  )

(use-package code-cells
  :hook
  (python-mode . code-cells-mode-maybe))

(use-package python-black
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim)
  )

;; (use-package numpydoc
;;   :bind
;;   (:map python-mode-map
;;         ("C-c C-n" . numpydoc-generate)
;;         )

;;   :init
;;   (setq numpydoc-insert-examples-block nil)
;;   (setq numpydoc-template-long nil)
;;   )

;; (use-package python-pytest)
;; (use-package python-isort)

;; (use-package pyvenv
;;   :bind
;;   (:map pyvenv-mode-map
;;         ("C-c p a" . pyvenv-activate)
;;         ("C-c p d" . pyvenv-deactivate)
;;         ("C-c p w" . pyvenv-workon)
;;         )

;;   :hook
;;   (python-mode . pyvenv-mode)
;;   (python-mode . pyvenv-tracking-mode)

;;   :init
;;   (add-hook 'pyvenv-post-activate-hooks #'pyvenv-restart-python)
;;   (setq pyvenv-default-virtual-env-name "venv")
;;   )

;; (use-package anaconda-mode
;;   :hook
;;   (python-mode . anaconda-mode))

;; (use-package python-docstring
;;   :delight
;;   :hook (python-base-mode . python-docstring-mode))

;; (use-package python-insert-docstring
;;   :config
;;   (add-hook 'python-base-mode-hook
;;             (lambda ()
;;               (local-set-key
;;                (kbd "C-c I")
;;                'python-insert-docstring-with-google-style-at-point))))

;; (use-package sphinx-doc
;;   :delight
;;   :hook (python-base-mode . sphinx-doc-mode))






;; General sane defaults

;;; Code:



;; -----------------------------
;; CUSTOM
;; -----------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   '((output-dvi "open")
     (output-pdf "Skim")
     (output-html "open")))
 '(cursor-type t)
 '(deft-auto-save-interval 7.0)
 '(fill-column 100)
 '(ns-alternate-modifier 'meta)
 '(ns-command-modifier 'super)
 '(ns-right-alternate-modifier nil)
 '(ns-right-command-modifier 'meta)
 '(package-selected-packages
   '(citar-embark eldoc-mode embark git-gutter-fringe impatient-mode markdown-mode popper code-cells jupyter which-key-mode which-key python-mode pyvenv numpydoc anaconda anaconda-mode exec-path-from-shell pdf-tools auctex-latexmk consult adaptive-wrap visual-fill-column visual-fill-column-mode marginalia orderless magit nerd-icon expand-region iy-go-to-char treemacs highlight-indent-guides deft iv-go-to-char avy eglot vertico corfu use-package))
 '(package-vc-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
