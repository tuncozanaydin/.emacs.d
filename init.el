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

;; On a fresh machine the archive contents aren't downloaded yet, which makes
;; use-package-always-ensure fail on the first install. Fetch them once.
(unless package-archive-contents
  (package-refresh-contents))

;; use-package ships with Emacs 29+, so no bootstrap is needed.
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; Define paths
(defvar toa/emacs-dir (expand-file-name "~/.emacs.d/"))
(defvar toa/config-org (expand-file-name "config.org" toa/emacs-dir))
(defvar toa/config-el  (expand-file-name "config.el" toa/emacs-dir))

;; Load config from the tangled elisp; fall back to tangling the org source.
(if (file-exists-p toa/config-el)
    (load toa/config-el)
  (require 'org)
  (org-babel-load-file toa/config-org))

;; Restore GC percentage after startup; gcmh (loaded in config.el) takes over
;; management of gc-cons-threshold from here on.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-percentage 0.1)))

;; Keep Custom's machine-written settings out of this file.
(setq custom-file (expand-file-name "custom.el" toa/emacs-dir))
(when (file-exists-p custom-file)
  (load custom-file))
