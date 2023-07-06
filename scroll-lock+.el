;;; scroll-lock+.el --- Configurable scroll lock scrolling  -*- lexical-binding:t -*-

;; Copyright (C) 2023  Eliza Velasquez

;; Author: Eliza Velasquez
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.3"))
;; Created: 2023-06-15
;; Keywords: convenience
;; URL: https://github.com/elizagamedev/scroll-lock-plus.el

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use,
;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following
;; conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.

;;; Commentary:

;; When `scroll-lock+-mode' is enabled, certain commands that normally simply
;; move the point vertically across lines will also scroll the window by the
;; same number of lines, similar to `scroll-lock-mode'.  In other words, the
;; vertical position of the point relative to the window will remain fixed while
;; navigating up and down through a buffer.
;;
;; The key difference between `scroll-lock+-mode' and `scroll-lock-mode' is that
;; the commands that trigger this behavior in `scroll-lock+-mode' are
;; configurable via the `scroll-lock+-commands' option instead of being a
;; rigidly defined subset of navigation commands.

;;; Code:

(defvar-local scroll-lock+--preserve-screen-pos-save scroll-preserve-screen-position)
(defvar-local scroll-lock+--old-posn-actual-row nil)

(defgroup scroll-lock+ nil
  "Enhanced buffer-local minor mode for pager-like scrolling."
  :group 'editing)

(defcustom scroll-lock+-commands
  '(next-line
    previous-line
    forward-paragraph
    backward-paragraph)
  "Commands which scroll the window alongside the point."
  :group 'scroll-lock+
  :type '(list function))

;;;###autoload
(define-minor-mode scroll-lock+-mode
  "Enhanced buffer-local minor mode for pager-like scrolling.

When `scroll-lock+-mode' is enabled, certain commands that
normally simply move the point vertically across lines will also
scroll the window by the same number of lines, similar to
`scroll-lock-mode'.  In other words, the vertical position of the
point relative to the window will remain fixed while navigating
up and down through a buffer.

The commands which trigger this behavior can be configured via
`scroll-lock+-commands'."
  :lighter " ScrLck+"
  (if scroll-lock+-mode
      (progn
        (when (bound-and-true-p scroll-lock-mode)
          (scroll-lock-mode -1))
	(setq scroll-lock+--preserve-screen-pos-save
              scroll-preserve-screen-position)
        (setq-local scroll-preserve-screen-position t)
        (add-hook 'pre-command-hook #'scroll-lock+--pre-command-hook nil t)
        (add-hook 'post-command-hook #'scroll-lock+--post-command-hook nil t))
    (setq scroll-preserve-screen-position scroll-lock+--preserve-screen-pos-save)
    (remove-hook 'pre-command-hook #'scroll-lock+--pre-command-hook t)
    (remove-hook 'post-command-hook #'scroll-lock+--post-command-hook t)))

(defun scroll-lock+--pre-command-hook ()
  "Preserve relative scroll position."
  (when (memq this-command scroll-lock+-commands)
    (setq scroll-lock+--old-posn-actual-row
          (cdr (posn-actual-col-row (posn-at-point))))))

(defun scroll-lock+--post-command-hook ()
  "Restore relative scroll position."
  (when scroll-lock+--old-posn-actual-row
    (unwind-protect
        (recenter scroll-lock+--old-posn-actual-row)
      (setq scroll-lock+--old-posn-actual-row nil))))

(provide 'scroll-lock+)

;;; scroll-lock+.el ends here
