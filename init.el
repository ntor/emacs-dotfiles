;; Simple Emacs Config


;; Basic Visual Properties
(load-theme 'modus-operandi)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)
(set-face-attribute 'fringe nil :background nil)
(set-frame-parameter nil 'height 52)
(set-frame-parameter nil 'width 103)
(set-frame-position (selected-frame) 0 0)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(setq ring-bell-function 'ignore)

;; --------------------
;; INITIALISATION (package.el/use-package)
;; --------------------
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; --------------------
;; GENERAL
;; --------------------
(use-package emacs
  :hook
  ((after-init . recentf-mode))
  :config
  (electric-pair-mode)
  
  :bind (
	 ("s-x" . execute-extended-command)
	 ("M-o" . other-window)
	 ("s-<down>" . shrink-window)
	 ("s-<up>" . enlarge-window)
	 ("C-c k" . kill-buffer-and-window)
	 ("C-x k" . kill-this-buffer)
         ("C-c f r" . recentf)
         ("s-i" . up-list)
         ("M-[" . (lambda () (interactive) (scroll-down-line 3)))
         ("M-]" . (lambda () (interactive) (scroll-up-line 3)))
	 ([swipe-left] . nil)
	 ([swipe-right] . nil)
	 ([magnify-up] . nil)
	 ([magnify-down] . nil)
	 ([pinch] . nil)
	 )
    )

;; (setq auto-window-vscroll nil)
;; (customize-set-variable 'fast-but-imprecise-scrolling t)
;; (customize-set-variable 'scroll-conservatively 101)
;; (customize-set-variable 'scroll-margin 0)
;; (customize-set-variable 'scroll-preserve-screen-position t)

(global-set-key (kbd "s-W") 'delete-frame) ; ⌘-W = Close window
(global-set-key (kbd "s-}") 'tab-bar-switch-to-next-tab) ; ⌘-} = Next tab
(global-set-key (kbd "s-{") 'tab-bar-switch-to-prev-tab) ; ⌘-{ = Previous tab
(global-set-key (kbd "s-t") 'tab-bar-new-tab) ;⌘-t = New tab
(global-set-key (kbd "s-w") 'tab-bar-close-tab) ; ⌘-w = Close tab


;; ------------------------
;; PACKAGE CONFIGURATION
;; ------------------------
(use-package corfu
  :bind
  ("C-<tab>" . completion-at-point)
  :config
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete)
  :init
  (global-corfu-mode)
  )

(use-package visual-fill-column
  )

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

(use-package consult
  :bind (
         ("C-x b" . consult-buffer)))

(use-package eglot)

(use-package tex
  :ensure auctex

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
  (setq TeX-source-correlate-start-server nil)
  (setq TeX-save-query nil)
  (setq TeX-electric-sub-and-superscript t)
  (setq LaTeX-electric-left-right-brace t)
  (setq TeX-electric-math (cons "$" "$"))
  (setq TeX-parse-self t)
  (setq reftex-plug-into-AUCTeX t)
  (setq TeX-newline-function 'reindent-then-newline-and-indent)
  (setq (TeX-view-program-selection
         '((output-dvi "open")
           (output-pdf "Skim")
           (output-html "open"))))
  (setq TeX-view-program-list
        '(("Skim"
           "/Applications/Skim.app/Contents/SharedSupport/displayline -g %n %o %b")))
  (setq reftex-default-bibliography
        "~/Documents/library/references/references.bib"
        font-latex-fontify-script nil
        font-latex-fontify-sectioning 1.0)
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

(use-package avy
  :bind (
	 ("s-;" . avy-goto-char-timer)
	 ("s-l" . avy-goto-line)
	 ("C-;" . avy-goto-char-timer))
  )

(use-package deft
  :bind
  (("C-c n d" . deft))
  :config
  (setq deft-directory "~/org/notes/")
  )

(use-package highlight-indent-guides
  :hook
  (python-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character)
  )


(use-package treemacs
  :bind
  (("C-c t" . treemacs))
  :config
  (setq treemcs-indentation 1)
  (setq treemacs-width 25) ; Adjust the width of Treemacs window
  (setq treemacs-show-hidden-files nil) ; Hide hidden files in Treemacs

  ;; (add-hook 'treemacs-mode-hook
  ;;           (lambda ()
  ;;             (text-scale-set -1))) ; Adjust the font size as desired

  (setq treemacs-no-load-time-warnings t)
  (setq treemacs-no-png-images t)
  )


(use-package expand-region
  :bind
  (("C-s-SPC" . er/expand-region)
   ("C-=" . er/expand-region)))

(use-package nerd-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package magit)


(use-package org
  :bind
  (:map org-mode-map
	("$" . pw/insert-math-parentheses))  
  :config
  (setq org-startup-indented t
        org-startup-folded t
        org-hide-leading-stars nil
        org-hide-emphasis-markers t
        org-highlight-latex-and-related '(latex)
        org-latex-create-formula-image-program 'dvisvgm
        )
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

(defun pw/notebook-full-size ()
  (interactive)
  (set-frame-parameter nil 'height 53)
  (set-frame-parameter nil 'width 203))

(defun pw/notebook-slim-size ()
  (interactive)
  (set-frame-parameter nil 'height 53)
  (set-frame-parameter nil 'width 103))

(defun pw/desktop-slim-size ()
  (interactive)
  (set-frame-parameter nil 'height 64)
  (set-frame-parameter nil 'width 140))

(defun pw/desktop-full-size ()
  (interactive)
  (set-frame-parameter nil 'height 64)
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



;; General sane defaults

;;; Code:

;; Revert Dired and other buffers
(customize-set-variable 'global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Typed text replaces the selection if the selection is active,
;; pressing delete or backspace deletes the selection.
;;(delete-selection-mode)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Use y/n instead of yes/no
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))


;; Do not save duplicates in kill-ring
(customize-set-variable 'kill-do-not-save-duplicates t)

;; Make shebang (#!) file executable when saved
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)


;; Make scrolling less stuttered
(setq auto-window-vscroll nil)
(customize-set-variable 'fast-but-imprecise-scrolling t)
(customize-set-variable 'scroll-conservatively 101)
(customize-set-variable 'scroll-margin 0)
(customize-set-variable 'scroll-preserve-screen-position t)

;; Better support for files with long lines
;; (setq-default bidi-paragraph-direction 'left-to-right)
;; (setq-default bidi-inhibit-bpa t)
;; (global-so-long-mode 1)




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
   '(auctex-latexmk consult adaptive-wrap visual-fill-column visual-fill-column-mode marginalia orderless magit nerd-icon expand-region iy-go-to-char treemacs highlight-indent-guides deft iv-go-to-char avy eglot vertico corfu use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
