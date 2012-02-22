#!/usr/bin/guile -s
!#

;;;; find-xattr-tag.scm ---  find file by xattr, and other attributes



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



;;; Keywords: find xattr tag search



;;; Usage:

;; ./find-xattr-tag.scm store/doc/ tag1 tag2 tag3
;; search in path "store/doc/" files with  "tag1 AND tag2 AND tag3"
;;
;; or you can use this command:
;;
;; find . -type f -exec getfattr -d {} \;


;;; History:

;; Version 0.1 was created at 2012.february.03



;;; Code:



; coding: utf-8
(setlocale LC_ALL "en_US.UTF-8")

(define nil '())

(load "../battery-scheme/system-cmd.scm")
(load "../battery-scheme/string.scm")
(load "../battery-scheme/print-list.scm")
(load "../battery-scheme/recursive-file-list.scm")
(load "lib-xattr-tag.scm")





;;(define (member-tf x lst)
;;  (if (member x lst) #t #f))

(define (count-include x lst)
  (define (counter-true list-tf)
    (if (eq? nil list-tf)
	0
	(+ (if (car list-tf) 1 0) (counter-true (cdr list-tf)))))
  (counter-true (map (lambda (i) (string-contains-ci i x)) lst)))


(define (include-list list-1 list-2)
  ;; list-1 included in list-2
  ;; fixme name "include-list"
  ;; fixme if initial list-1 === nil   => #t
  (if (equal? list-1 nil)
      0
      (+ (count-include (car list-1) list-2) (include-list (cdr list-1) list-2))))
;;    (and (member-tf (car list-1) list-2) (include-list (cdr list-1) list-2))))



(use-modules (ice-9 regex))
(define (get-path-file-name-tag filename)
  ;; strange but this construction not work? fixme
  ;;(map match:substring (list-matches (string-join (list "[^" (char-set->string (char-set-union char-set:punctuation char-set:whitespace)) "]")) "abc 42 def --_- -78"))
  (map match:substring (list-matches "[^- _/.]+" filename)))






(define (calc-rating filename tags)
  (include-list tags 
		(append (get-path-file-name-tag filename) (get-xattr-tag filename "user.metatag"))))




;;(define (procf filename statinfo flag)
;;  (if (and (equal? 'regular flag)
;;	   (include-list  list-2) )
;;	 (display filename)))
;;  #t) ;; fixme






(define (find-tag startpath tag-list)
  (map (lambda (filepath) (list filepath (calc-rating filepath tag-list))) (list-all-files startpath)))



;(display (list-all-files "/home/chujoii/project/xattr-tag/q"))

(let ((filename (cadr (command-line)))
      (filetags (cddr (command-line))))

  (print-list-without-bracket (sort
			       (find-tag filename filetags)
			       (lambda (x y) (< (cadr x) (cadr y))))))


;(let ((filename "/home/chujoii/project/xattr-tag/q")
;      (filetags (list "Предложение")))
;
;  (print-list-without-bracket (sort
;			       (find-tag filename filetags)
;			       (lambda (x y) (< (cadr x) (cadr y))))))




