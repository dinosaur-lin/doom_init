;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(after! org-tree-slide
  (setq org-tree-slide-skip-outline-level 0))
(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                         :time-grid t
                                         :scheduled today)
                                  (:name "Due today"
                                         :deadline today)
                                  (:name "Important"
                                         :priority "A")
                                  (:name "Overdue"
                                         :deadline past)
                                  (:name "Due soon"
                                         :deadline future)))
  :config
  (org-super-agenda-mode))

(setq tramp-verbose 10)
(setq tramp-histfile-override ".tramp_history")

(require 'subr-x)

(defun my-config-remote-hosts ()
  (let ((remote-hosts (make-hash-table :test 'equal)))
        (puthash "NY-UAT1" "195.167.253.12" remote-hosts)
        (puthash "NY-UAT2" "195.167.253.13" remote-hosts)
        remote-hosts))

(defun my-remote-tramp-connection (first-hop second-hop)
  (format "/ssh:ylin@%s|ssh:ylin_sct@%s:~" first-hop second-hop))

(defun my-remote-host (host-name remote-host-name-ip-hash)
  (let ((ip (gethash host-name remote-host-name-ip-hash)))
    (if ip ip host-name)))

(defun my-remote-shell (host-name)
  "Running remote shell"
  (interactive
   (list (ido-completing-read "Host name: " (hash-table-keys (my-config-remote-hosts)))))
  (let* ((hosts (my-config-remote-hosts))
        (host (my-remote-host host-name hosts))
        (jump-url (my-remote-tramp-connection "172.22.140.173" host)))
  (find-file jump-url)))
