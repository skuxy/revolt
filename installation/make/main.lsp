#!/usr/bin/newlisp

(load "functions.lsp")


(println "##############################")
(println "\n    MCMS - create database")
(println "------------------------------")

(set 'cms-data '())


(print "\nEnter username: ")
(push (read-line) cms-data -1) ; username:1


(do-until (= password password-repeat)
	(print "\nEnter password: ")
	(set 'password (read-line))
	(print "Repeat password: ")
	(set 'password-repeat (read-line)))
(push password cms-data -1) ; password:1


(print "\nEnter secret question: ")
(push (read-line) cms-data -1) ; secret question:2
(do-until (= secret secret-repeat)
	(print "\nEnter secret answer: ")
	(set 'secret (read-line))
	(print "Repeat secret answer: ")
	(set 'secret-repeat (read-line)))
(push secret cms-data -1) ; secret answer:3


(print "\nEnter admin name: ")
(push (read-line) cms-data -1) ; admin name:4
(print "Enter admin e-mail: ")
(push (read-line) cms-data -1) ; admin email:5


(print "\nDate & time of installation: ")
(push (date (date-value) 0 "%H:%M:%S-%d.%m.%Y") cms-data -1) ; date:6
(println (nth -1 cms-data))
(print "Enter timezone (e.g. UTF-8): ")
(push (read-line) cms-data -1) ; timezone:7


(println "\nSHEIT YOU BANGED:\n" cms-data)


(print "\nCreate database? [Y/n]: ")
(set 'confirm (read-line))
(if (or (= confirm "y") (= confirm "Y"))
	(create-database cms-data (nth 2 (main-args)))
	(println "\nk thx bye"))

(exit)