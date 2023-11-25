;; Functions for swapping windows

(defun swap-windows (swap-proc arg-name)
  "Swap two open windows based on given SWAP-PROC. Stores the
loaded buffers and cursor position in local variables to maintain
cursor position in buffer.

ARG-NAME specifies the argument needed to perform the swap.
"
  (if (= (length (window-list)) 2)
      (progn
	(setq curr-window-buffer (window-buffer))
	(setq curr-pos (point))
	(other-window 1)
	(setq other-window-buffer (window-buffer))
	(setq other-pos (point))
	(setq orientation (car (car (window-tree))))
	(funcall swap-proc (eval arg-name))
	(goto-char curr-pos)
	(other-window 1)
	(switch-to-buffer other-window-buffer)
	(goto-char other-pos)
	(other-window 1))))

(defun swap-window-buffers ()
  "Swap two open windows' buffer contents to simulate swapping
window positions."
  (interactive)
  (swap-windows (lambda (curr-window-buffer)
		  (switch-to-buffer curr-window-buffer))
		'curr-window-buffer))

(defun swap-window-orientation ()
  "Swap two open windows' orientation from top-and-bottom to
side-by-side and vice versa."
  (interactive)
  (swap-windows (lambda (orientation)
		  (delete-window)
		  (split-window nil nil orientation))
		'orientation))
