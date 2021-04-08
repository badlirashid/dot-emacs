;;; init.el --- Badli Emacs init configuration -*- lexical-binding: t -*-

;; Copyright (C) 2021 Badli Rashid

;; Author  :    Badli Rashid <badli.rashid@yahoo.com>
;; Created :    2021-MAC-03
;; URL     :    https://github.com/badlirashid/Stuffs
;; Version :    0.1.9

;; This file is NOT part of GNU Emacs.

;;; Commentary:

;; Badli boring Emacs init.el configuration file.

;;; Licenses:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

;;;; Theme
(load-theme 'wombat)

(setq gc-cons-threshold (* 32 1024  1024))
(setq gc-cons-percentage 0.3)

(setq default-frame-alist '((width . 82) (height . 45)))

;;;; Display
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))
(if (fboundp 'tooltip-mode) (tooltip-mode -1))
(if (fboundp 'column-number-mode) (column-number-mode 1))
(if (fboundp 'line-number-mode) (line-number-mode 1))

;;;; Encoding Systems
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;;; User Details
(setq user-full-name "Badli Rashid")
(setq user-mail-address "badli.rashid@yahoo.com")

;;;; Setup defaults
(setq inhibit-startup-message t)
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message nil)
(setq use-dialog-box nil)
(setq tramp-mode nil)
(setq fill-column 80)
(setq tab-width 2)
(setq indent-tabs-mode nil)
(setq vc-follow-symlinks t)
(setq select-enable-clipboard t)

;;; icon/frame title format
(setq icon-title-format (setq frame-title-format "[ %f ]"))

;;;;; Backup Options
(setq make-backup-files nil)
(setq version-control nil)

(require 'cl-lib)
(let ((default-directory "~/.emacs.d/lisp"))
  (setq load-path
	(append
	 (cl-remove-if-not
	  #'file-directory-p
	  (directory-files (expand-file-name default-directory) t "^[^\\.]"))
	  load-path)))

;;;; Requires
(require 'package)
(require 'dash)
(require 'company)
(require 'pos-tip)
(require 'company-quickhelp)
(require 'flyspell)
(require 'diminish)
(require 'rainbow-delimiters)
(require 'org)
(require 'org-habit)
(require 'yaml-mode)
(require 'inf-ruby)
(require 'flymake)

(package-initialize)

;;;; Begins
(fset 'yes-or-no-p 'y-or-n-p)

;;;; Colors or Colours ?
(setenv "LANG" "en_GB.UTF8")
(setq ispell-program-name "aspell")
(setq ispell-extra-args '("-l en_GB -a"))
(setq ispell-dictionary "en_GB")

;;;; IDO
(ido-mode)
(setq ido-everywhere 1)
(setq ido-enable-flex-matching 1)

(defun turn-code-feature-on ()
  "Turn on code features."
  (display-line-numbers-mode 1)
  (electric-pair-local-mode 1)
  (rainbow-delimiters-mode 1)
  (setq show-paren-delay 0)
  (show-paren-mode 1))

(defun turn-code-completion-on ()
  "Enable code completion feature."
  (setq company-minimum-prefix-length 1)
  (company-mode 1)
  (setq company-quickhelp-delay 1)
  (add-hook 'company-mode-hook #'company-quickhelp-mode))

(defun turn-code-syntax-check-on ()
  "Code checking."
  (setq ruby-flymake-use-rubocop-if-available t)
  (setq python-flymake-command '("flake8" "-"))
  (flymake-mode 1))

(defun text-spell-check-on ()
  "Check spelling on text."
  (flyspell-mode))

(defun prog-spell-check-on ()
  "Check spelling on prog mode."
  (flyspell-prog-mode))

(defun compare-two-files (switch)
  "https://www.emacswiki.org/emacs/EdiffMode"
  (let
      ((file1 (pop command-line-args-left))
       (file2 (pop command-line-args-left)))
    (setq ediff-split-window-function 'split-window-horizontally)
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("-diff" . compare-two-files))

(defun three-way-comparison (switch)
  "A three way comparison"
  (let
      ((file1 (pop command-line-args-left))
       (file2 (pop command-line-args-left)
	(file3 (pop command-line-args-left)))))
       (setq ediff-split-window-function 'split-window-horizontally)
    (ediff3 file1 file2 file3))

(add-to-list 'command-switch-alist '("-diff" . compare-two-files))
(add-to-list 'command-switch-alist '("-diff3" . three-way-comparison))

;;;; Add our hooks
(add-hook 'prog-mode-hook #'turn-code-feature-on)
(add-hook 'prog-mode-hook #'turn-code-completion-on)
(add-hook 'prog-mode-hook #'turn-code-syntax-check-on)

(add-hook 'prog-mode-hook #'prog-spell-check-on)
(add-hook 'text-mode-hook #'text-spell-check-on)
(add-hook 'org-mode-hook #'text-spell-check-on)

;;;; Inf-Ruby
(autoload 'inf-ruby "inf-ruby" "Run Inf-Ruby process" t)
(add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)

(eval-after-load 'inf-ruby
  '(define-key inf-ruby-minor-mode-map
     (kbd "C-c C-s") 'inf-ruby-console-auto))

;;;; YAML
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;;;; ORG
(setq org-agenda-files '("/tmp/test.org"))
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-iswitchb)

;;;; Diminish
(diminish 'eldoc-mode)
(diminish 'company-mode " C")

;;;; KEYS
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "<f7>") 'flycheck-list-errors)
(global-set-key (kbd "<f8>") 'goto-line)
(global-set-key (kbd "<f9>") #'tool-bar-mode)

(provide 'init)
;;; init.el ends here
