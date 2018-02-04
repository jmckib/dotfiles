(add-to-list 'load-path "~/lib/emacs/")
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
      '(("django"    . "\\.html?\\'"))
)
(setq web-mode-markup-indent-offset 2)

;; (require 'coffee-mode)
(add-hook 'after-save-hook
          (lambda () (when (eq major-mode 'coffee-mode) (coffee-compile-file))))

;; rjsx-mode for es6 and jsx
(add-to-list 'auto-mode-alist '(".*\\.js\\'" . rjsx-mode))
(add-hook 'rjsx-mode-hook (lambda () (setq js2-basic-offset 2)))

;; 2-space indent for javascript
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)

; make sure INFOPATH env variable is used for info directory
(setq Info-directory-list nil)
(setq-default tab-width 4)
(setq-default fill-column 79)

(ignore-errors
(require 'server)
;; IMPORTANT: on OS X, the value of server-socket-dir confuses emacs,
;; because in some contexts it's
;; "/private/var/folders/Cd/CdNIYL8+G8qNu2I2EGxiAk+++TM/-Tmp-//emacs502"
;; while in other contexts it's
;; "/var/folders/Cd/CdNIYL8+G8qNu2I2EGxiAk+++TM/-Tmp-//emacs502"
;; To get around this, set TMP to $HOME/tmp in your .bash_profile
(if (not (server-running-p))
    (progn
     (server-force-delete)
     (server-start)
     )
    )
)

;; For some reason socket files don't get deleted properly without this, so
;; we need this for server-start to work.
(setq delete-by-moving-to-trash nil)

;; Keep track of recently opened files
(require 'recentf)
(recentf-mode 1)

;; Get rid of annoying buffer stil has clients messages
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

(global-set-key (kbd "C-c r") (lambda () (interactive) (revert-buffer nil 1)))

(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)

;;Have C-x C-m = Meta for faster typing (Yegge tip)
(global-set-key "\C-x\C-m" 'execute-extended-command)

;; C-c d to put debugging statement in code
(add-hook 'python-mode-hook
  (lambda ()
  (local-set-key (kbd "C-c d") (lambda () (interactive) (insert "import ipdb; ipdb.set_trace()")))
  )
)
(add-hook 'rjsx-mode-hook
  (lambda ()
  (local-set-key (kbd "C-c d") (lambda () (interactive) (insert "debugger;")))
  )
)
(add-hook 'coffee-mode-hook
  (lambda ()
  (local-set-key (kbd "C-c d") (lambda () (interactive) (insert "debugger;")))
  )
  )

;; leveling up to advanced keybindings
(global-set-key [(control v)] 'help-command)
(global-set-key [(control h)] 'delete-backward-char)

;; set command key to meta (doesn't work in terminal.app,
;; but does in http://emacsformacosx.com/)
(setq ns-command-modifier 'meta)

;; a better undo key
(global-set-key (kbd "C--") 'undo)

;; easier way to switch between windows
(global-set-key (kbd "M-k") 'other-window)
(global-set-key (kbd "M-j") (lambda () (interactive) (other-window -1)))

(defun comment-or-uncomment-region-or-line ()
  "Like comment-or-uncomment-region, but if there's no mark \(that means no
region\) apply comment-or-uncomment to the current line"
  (interactive)
  (if (not mark-active)
      (comment-or-uncomment-region
        (line-beginning-position) (line-end-position))
      (if (< (point) (mark))
          (comment-or-uncomment-region (point) (mark))
        (comment-or-uncomment-region (mark) (point)))))
(global-set-key (kbd "M-/") 'comment-or-uncomment-region-or-line)

;; some nice extras for editing
(global-set-key (kbd "M-/") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "M-a") 'mark-whole-buffer)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)

(when (>= emacs-major-version 24)
  (add-to-list 'custom-theme-load-path "~/lib/emacs/themes/")
  (custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(custom-safe-themes (quote ("f5e56ac232ff858afb08294fc3a519652ce8a165272e3c65165c42d6fe0262a0" default))))
  (custom-set-faces)
  (load-theme 'zenburn t)
)

(global-linum-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("f5e56ac232ff858afb08294fc3a519652ce8a165272e3c65165c42d6fe0262a0" default)))
 '(paradox-github-token t)
 '(show-trailing-whitespace t))
(setq-default column-number-mode t)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives
			   '("melpa-stable" . "https://stable.melpa.org/packages/"))
  (package-initialize)
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
