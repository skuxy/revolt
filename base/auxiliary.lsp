#!/usr/bin/newlisp

(load "init.lsp")

(context 'auxiliary)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	FUNKCIJE ZA RAD SA BAZOM
;

(define (open-database db-name)
	(if (sql3:open db-name)
		(println "\tDatabase " db-name " opened.")
		((println "\tERROR: " (sql3:error)) (exit))))

(define (close-database)
	(if (sql3:close)
		(println "\tDatabase closed.")
		((println "\tERROR: " (sql3:error)) (exit))))

; Process SQL query
(define (sql-query sql-text)
	(set 'query-results (sql3:sql sql-text)))


;;	READ FROM DATABASE

; Return max value in column 'what' from table 'where'
(define (get-max-value what where)
	(set 'sql-text (string "SELECT MAX(" what ") FROM " where ";"))
	(set 'value (sql-query sql-text)))

; Return row from table where column 'column' is equal to value
(define (get-row table column value)
	(set 'sql-text (string "SELECT * FROM " table " WHERE " column " IS '" value "';"))
	(set 'value (sql-query sql-text)))

; Return whole table
(define (get-table table-name)
	(set 'sql-text (string "SELECT * FROM " table-name ";"))
	(set 'value (sql-query sql-text)))

; Get column value of 'column-name' from 'table' where column 'key' is equal to 'value'
(define (get-column-value column-name table key value)
	(set 'sql-text (string "SELECT " column-name " FROM " table " WHERE " key " IS '" value "';"))
	(set 'value (sql-query sql-text)))

; Return value of column from table where column is equal to value
(define (check-column-value column table value)
	(set 'sql-text (string "SELECT " column " FROM " table " WHERE " column " IS '" value "';"))
	(set 'value (sql-query sql-text)))


;;	WRITE TO DATABASE

; Insert new row in table with values
(define (insert-table-value table-name table-values)
	(set 'sql-text (string "INSERT INTO " table-name " VALUES (" table-values ");"))
	(sql-query sql-text))

; Update row which has key with value key-value
(define (update-row table-name new-values key key-value)
	(set 'sql-text (string "UPDATE " table-name " SET " new-values " WHERE " key "='" key-value "';"))
	(sql-query sql-text))

; Delete row which has key with value key-value
(define (delete-row table-name key key-value)
	(set 'sql-text (string "DELETE FROM " table-name " WHERE " key "='" key-value "';"))
	(sql-query sql-text))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	POMOCNE FUNKCIJE
;

; Convert string to slug from non-slug format
(define (get-slug non-slug)
	(set 'slug (replace {_} (replace {\W+} non-slug {-} 1) {-} 1))
	(while (starts-with slug "-" 1)
		(set 'slug (slice slug 1 (utf8len slug))))
	(while (ends-with slug "-" 1)
		(set 'slug (slice slug 0 (- (utf8len slug) 1))))
	(lower-case slug))

; Create uniqe slug for selected table
(define (get-unique-slug name table)
	(if (= table "CATEGORIES") 	(set 'column "cat_slug")
		(= table "POSTS") 		(set 'column "post_slug")
		(= table "TAGS") 		(set 'column "tag_slug")
		(= table "REPOSITORY") 	(set 'column "repo_slug"))
	(set 'non-unique (get-slug name))
	(when (check-column-value column table non-unique)
		(set 'non-unique (append non-unique "-1"))
		(set 'suffix 2)
		(while (check-column-value column table non-unique)
			(setf (non-unique -1) (string suffix))
			(inc suffix)))	
	(set 'unique-slug non-unique))

; Return current server time in correct format
(define (get-time)
	(date (date-value) 0 "%H:%M:%S-%d.%m.%Y"))



; eof ;