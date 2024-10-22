;;;;;;;;;;;;;;;;;;;;;;;;;; Configuraciones generales ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq user-full-name "Xavier Góngora"
      user-mail-address "ixbalanque@protonmail.ch")

(setq doom-font (font-spec :family "Hasklig" :size 15)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 15)
      doom-big-font (font-spec :family "Hasklig" :size 24))

(setq doom-theme 'doom-moonlight) ; fallback theme

(setq display-line-numbers-type 'true)

(setq org-directory "~/org/")

;;;;;;;;;;;;;;;;;;;;;;;;;; Personalización de interfaz ;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable bold and italics
;;(after! doom-themes
;;        (setq doom-themes-enable-bold t
;;              doom-themes-enable-italic t))

;; Customize code fonts
;; Docs:
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Faces-for-Font-Lock.html
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Face-Attributes.html
;; (custom-set-faces!
;;   '(font-lock-comment-face :slant italic :weight light)
;;   '(font-lock-keyword-face :slant oblique :weight semi-bold)
;;   '(font-lock-function-name-face :weight bold)
;;   '(font-lock-type-face :weight semi-light))

;; Default dictionary
(setq ispell-dictionary "es_MX")

;; Fullscreen on new frames
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Disable smart parenthesis
;; Ref:
;; https://discourse.doomemacs.org/t/disable-smartparens-or-parenthesis-completion/134
;; TODO: alternativamente quitar +smartparens de default en init.el
;; En la referencia se especifican formas de desactivarlo para ciertos lenguajes
;;(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; Automatic theme switch
(use-package! circadian
  :config
  (setq calendar-latitude 19.0)
  (setq calendar-longitude -99.1)
  (setq circadian-themes '((:sunrise . default)
                           (:sunset  . doom-moonlight)))
  (circadian-setup))

;; HACK: fix white cursor on emacs-daemon start
;; Fuente: https://github.com/doomemacs/doomemacs/issues/1728#issuecomment-526149671https://github.com/doomemacs/doomemacs/issues/1728#issuecomment-526149671
(add-hook! 'after-make-frame-functions
  (defun my-load-theme-fix (frame)
    (select-frame frame)
    (doom/reload-theme)))

;; Example function switch theme on fixed times
;; https://yannesposito.com/posts/0014-change-emacs-theme-automatically/index.html
;; (defun y/auto-update-theme ()
;;   "depending on time use different theme"
;;   ;; very early => gruvbox-light, solarized-light, nord-light
;;   (let* ((hour (nth 2 (decode-time (current-time))))
;;          (theme (cond ((<= 7 hour 8)   'doom-gruvbox-light)
;;                       ((= 9 hour)      'doom-solarized-light)
;;                       ((<= 10 hour 16) 'doom-nord-light)
;;                       ((<= 17 hour 18) 'doom-one-light)
;;                       ((<= 19 hour 22) 'doom-tokyo-night)
;;                       (t               'doom-laserwave))))
;;     (when (not (equal doom-theme theme))
;;       (setq doom-theme theme)
;;       (load-theme doom-theme t))
;;     ;; run that function again next hour
;;     (run-at-time (format "%02d:%02d" (+ hour 1) 0) nil 'y/auto-update-theme)))

;; (y/auto-update-theme)

;; Automated project discovery
;; https://docs.projectile.mx/projectile/usage.html#automated-project-discovery
(setq projectile-project-search-path '("~/GitRepos"))

;; For localized quotes
;; Referencia:
;; https://www.emacswiki.org/emacs/TypographicalPunctuationMarks
(use-package! typopunct
  ;; if you omit :defer, :hook, :commands, or :after, then the package is loaded
  ;; immediately. By using :hook here, the `typopunct` package won't be loaded
  ;; until markdown-mode is triggered
  :hook (markdown-mode . typopunct-mode)
  :init
  ;; code here will run immediately
  :config
  ;; code here will run after the package is loaded
  (add-to-list 'typopunct-language-alist
               `(spanish
                 ,(decode-char 'ucs #xAB)     ; opening-guillemet-q (outer)
                 ,(decode-char 'ucs #xBB)     ; closing-guillemet-q (outer)
                 ,(decode-char 'ucs #x201C)   ; opening-double-q (inner)
                 ,(decode-char 'ucs #x201D))) ; closing-double-q (inner)
  (setq-default typopunct-buffer-language 'spanish)
  (when (equal ispell-dictionary "es_MX")
    ;;(typopunct-change-language 'spanish)
    (typopunct-mode 1)))

;; (add-hook! (markdown-mode . typopunct-mode)
;;  (defun disable-typopunct-in-buffer ()
;;    "Disable typopunct when changing to a non-dictionary spanish dictionary"
;;    (when (and (not (equal ispell-local-dictionary nil)))
;;      (not (equal ispell-local-dictionary "es_MX"))
;;      (typopunct-mode 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;; Development ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Default for common-lisp is sbcl
(setq inferior-lisp-program "clisp")

;; haskell-language-server configuration
;; https://haskell-language-server.readthedocs.io/en/latest/configuration.html#language-specific-server-options
(after! lsp-haskell
  (setq lsp-haskell-formatting-provider "stylish-haskell")
  ;;   (setq lsp-haskell-plugin-ormolu-config-external t)
  ;;   (setq lsp-haskell-check-project t) ;typecheck whole project on initial load
  ;;   (setq lsp-haskell-check-parents "CheckOnSave") ;typecheck reverse dependencis of file
  )

;; Change default Tidal boot script
;; (setq tidal-boot-script-path
;;      "/home/xavigo/.emacs.d/.local/straight/repos/Tidal/BootTidal.hs")

;; Tidal keybidings
;; (map! :after tidal
;;       :map tidal-mode-map
;;       :prefix "SPC t t"
;;       "h" #'tidal-hush
;;       "e" #'tidal-eval-multiple-lines
;;       "s" #'tidal-start-haskell
;;       )

;; Supercollider
(add-to-list 'load-path "/home/xavigo/.local/share/SuperCollider/downloaded-quarks/scel/el")
(require 'sclang)


;; Remove persistent undo history
(remove-hook 'undo-fu-mode-hook #'global-undo-fu-session-mode)

;; Fish Shell
;;
;; Set a POSIX shell because Fish (and possibly other non-POSIX shells)
;; is known to inject garbage output into some of the child processes that Emacs spawns.
;; Many Emacs packages/utilities will choke on this output,
;; causing unpredictable issues.
(setq shell-file-name (executable-find "bash"))

;; Emacs' terminal emulators most be configured to use Fish.
(setq-default vterm-shell (executable-find "fish"))

(setq-default explicit-shell-file-name (executable-find "fish"))
