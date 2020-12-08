(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("MELPA Stable" . 10)
        ("GNU ELPA"     . 5)
        ("MELPA"        . 0)))

(load-theme 'tango-dark t)
(setq visible-bell 1)
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))

;; create a directory to hold history
(if (not (file-exists-p (expand-file-name "~/.trash.d/")))
    (make-directory (expand-file-name "~/.trash.d/" t)))

(if (not (file-exists-p (expand-file-name "~/.trash.d/emacs.history/")))
    (make-directory (expand-file-name "~/.trash.d/emacs.history/" t)))

;; Save our history there
(setq savehist-file (concat (expand-file-name "~/.trash.d/emacs.history/") "emacs." (getenv "USER")))
(savehist-mode 1)

;; Disable backups
(setq backup-inhibited t)
(setq make-backup-files nil)

;; Disable auto-save
(setq auto-save-default nil)
(setq auto-save-interval (* 60 60 24))

;; Remove lockfiles
(setq create-lockfiles nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ibuffer-sidebar shell-pop vscode-icon exec-path-from-shell multiple-cursors yasnippet company lsp-ui lsp-mode dired-sidebar use-package go-mode))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(eval-when-compile
  (require 'use-package))

(set-face-attribute 'mode-line nil :box nil)
(set-face-attribute 'mode-line-inactive nil :box nil)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-message t)
(setq default-directory "~/")


(use-package vscode-icon
  :ensure t
  :commands (vscode-icon-for-file))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-with-current-directory))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(defun +sidebar-toggle ()
  "Toggle both `dired-sidebar' and `ibuffer-sidebar'."
  (interactive)
  (dired-sidebar-toggle-sidebar)
  (ibuffer-sidebar-toggle-sidebar))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Optional - provides fancier overlays.
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Company mode is a standard completion package that works well with lsp-mode.
(use-package company
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

;; Optional - provides snippet support.
(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Custom keybindings
(global-set-key (kbd "<C-M-return>") 'shell-pop)
