(defun count-spaces (&optional move-bolp)
  "Count whitespaces between the point and first non-whitespace
character.

If MOVE-BOLP is non-nil, move point to beginning of line before
counting spaces.
"
  (let ((count 0)
        (mark-bolp))
    (save-excursion
      (and move-bolp (beginning-of-line))
      (setq mark-bolp (point))
      (skip-chars-forward " \t")
      (or (eolp) (setq count (- (point) mark-bolp))))
    count))

(defun indent-non-rigidly (beg end &optional new-width)
  "Increase or decrease indentation width relative to the current
indentation levels in the region. Tabs inside the region are
converted into spaces.

NEW-WIDTH specifies the amount of spaces for a single indentation
level. If unspecified, it will be set to the current width + 1.
"
  (interactive "r\nP")
  (if (use-region-p)
      (let ((preindent 0)
            (curr-width 0)
            (level 0))
        (save-excursion
          (untabify beg end)
          (setq beg (region-beginning)
                end (region-end))
          (goto-char beg)
          (setq preindent (count-spaces t))
          (while (and (= 0 curr-width) (< (point) end))
            (forward-line)
            (forward-char preindent)
            (setq curr-width (count-spaces)))
          (or new-width (setq new-width (+ 1 curr-width)))
          (goto-char beg)
          (dotimes (ctr (count-lines beg end))
            (forward-line)
            (forward-char preindent)
            (setq level (/ (count-spaces) curr-width))
            (delete-char (* level curr-width))
            (insert-char ?\ (* level new-width))
            (move-end-of-line nil))))
    (message "Please mark an active region.")))
