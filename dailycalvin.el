(defun kill-if-buffer-exists (bufname)
  (when (get-buffer bufname)
    (message "Killing buffer %s" bufname)
    (kill-buffer bufname)))

(defun get-calvin ()
  "Fetch the most recent Calvin image and show it in the buffer."
  (interactive)
  (save-excursion
    (let ((cmd "/usr/local/bin/wget -q -P /tmp/calvin http://calvinhobbesdaily.tumblr.com/rss > /dev/null 2>&1"))
      (shell-command  "rm -rf /tmp/calvin")
      (kill-if-buffer-exists "rss")
      (kill-if-buffer-exists "*calvin*")
      (shell-command cmd)
      (find-file "/tmp/calvin/rss")
      (goto-char (point-min))
      (when (search-forward-regexp "img src=\\\"\\\(.+?\\\)\\\"" (point-max) t 1)
	(message "%s" (match-string 1))
	(shell-command (format "/usr/local/bin/wget -q -P /tmp/calvin %s > /dev/null 2>&1" (match-string 1)))
	(switch-to-buffer (get-buffer-create "*calvin*"))
	(setq cmdStr (concat "/usr/local/bin/convert -scale 200% -quality 85% " (car (directory-files "/tmp/calvin" t "gif")) " " (file-name-sans-extension(car (directory-files "/tmp/calvin" t "gif"))) "-c.gif"))
         (shell-command cmdStr)
       	(insert-image (create-image (car (directory-files "/tmp/calvin" t "gif"))))
	(kill-if-buffer-exists "rss")
	(kill-if-buffer-exists "*Shell Command Output*")))))

  
