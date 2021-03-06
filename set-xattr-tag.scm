#!/usr/bin/guile-2.0 -s
!#
; coding: utf-8

;;;; set-xattr-tag.scm ---  write (delete old xattr) to file
;;;; (and duplicate xattr in file file.ext.txt (for file.ext))



;;; Copyright (C) 2012 Roman V. Prikhodchenko



;;; Author: Roman V. Prikhodchenko <chujoii@gmail.com>



;;;    This file is part of xattr-tag.
;;;
;;;    xattr-tag is free software: you can redistribute it and/or modify
;;;    it under the terms of the GNU General Public License as published by
;;;    the Free Software Foundation, either version 3 of the License, or
;;;    (at your option) any later version.
;;;
;;;    xattr-tag is distributed in the hope that it will be useful,
;;;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;    GNU General Public License for more details.
;;;
;;;    You should have received a copy of the GNU General Public License
;;;    along with xattr-tag.  If not, see <http://www.gnu.org/licenses/>.



;;; Keywords: set xattr tag search



;;; Usage:

;; set-xattr-tag.scm        path/to/test.txt     tag1 tag2 tag3



;;; History:

;; Version 0.1 was created at 2012.february.03



;;; Code:



(load "lib-xattr-tag.scm")



;; bug in ?all? version GNU Guile before 2.0.4 with function "command-line"
;; http://lists.gnu.org/archive/html/guile-user/2011-11/msg00015.html


(let ((filename (cadr (command-line)))
      (tag-list (cddr (command-line))))

  
  (display "filename=")(display filename)(newline)
  (display "tag-list=")(display tag-list)(newline)

  (set-xattr-tag filename "user.metatag" tag-list)

  (set-xattr-tag filename "user.checksum.md5"
		 (list (get-md5 filename)))

  (set-xattr-tag filename "user.checksum.sha1"
		 (list (get-sha1 filename)))

  (set-xattr-tag filename "user.checksum.sha256"
		 (list (get-sha256 filename)))
  
  (set-info-tag filename (string-append filename *xattr-file-extension*))
 
  ;; automatic update tag-list and zsh-completion
  (append-to-index-and-save tag-list))
