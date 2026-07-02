;; -*- lexical-binding: t; -*-

;; Temporarily increase GC threshold for faster startup
(setq gc-cons-threshold (* 100 1024 1024)) ;; 100MB
(setq gc-cons-percentage 0.6)

(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Initialize package system
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; Define paths
(defvar toa/emacs-dir (expand-file-name "~/.emacs.d/"))
(defvar toa/config-org (expand-file-name "config.org" toa/emacs-dir))
(defvar toa/config-el  (expand-file-name "config.el" toa/emacs-dir))

;; Ensure org is loaded for babel functions
(require 'org)

;; Load config from org file
(if (file-exists-p toa/config-el)
    (load toa/config-el)
  (org-babel-load-file toa/config-org))

;; Restore normal GC thresholds after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 10 1024 1024)) ;; 10MB
            (setq gc-cons-percentage 0.1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-builtin-face ((t (:family "MonoLisa toa" :slant italic))))
 '(font-lock-comment-face ((t (:family "MonoLisa toa script" :slant normal))))
 '(font-lock-doc-face ((t (:family "MonoLisa toa script" :slant normal))))
 '(font-lock-keyword-face ((t (:family "MonoLisa toa" :slant italic :weight bold))))
 '(font-lock-type-face ((t (:family "MonoLisa toa" :slant italic)))))
