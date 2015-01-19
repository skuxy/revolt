#!/usr/bin/newlisp

;	Part of MCMS project
;	- file: category.lsp
;	- author: vjekoart@gmail.com
;
;	Functions for manipulating categories.
;	Main functionalities:
;		1. Add new category (create)
;		2. Edit category 	(update)
;		3. Remove category 	(remove)
;		4. Show category information (show)
;		5. Show all categories (show-all)

(load "auxiliary.lsp")

(context 'category)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Local auxiliary functions
;

; Returns new category ID
(define (get-id)
	(inc (first (flat (auxiliary:get-max-value "cat_id" "CATEGORIES")))))

; Checks if parent ID exists as category
(define (check-parent id)
	(if (auxiliary:check-column-value "cat_id" "CATEGORIES" id) true nil))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Main functions
;

; Add new category to database
(define (create name parent description)
	(unless (check-parent (int parent))
		((println "ERROR: Wrong parent ID.") (exit)))
	
	(set 'id (get-id))
	(set 'slug (auxiliary:get-unique-slug name "CATEGORIES"))
	(set 'category-date (auxiliary:get-time))
	(set 'category-def (string
		"'" id "','" name "','" slug "','" parent "','" category-date "','" description "'"))

	(auxiliary:insert-table-value "CATEGORIES" category-def))

; Update category information
; only name and description can be updated (slug will be modified automatically)
(define (update id new-name new-description)
	(when new-name
		(set 'new-slug (auxiliary:get-unique-slug new-name "CATEGORIES"))
		(set 'new-values (string "cat_name='" new-name "'," "cat_slug='" new-slug "'"))
		(auxiliary:update-row "CATEGORIES" new-values "cat_id" id))
	(when new-description
		(set 'new-description (string "cat_desc='" new-description "'"))
		(auxiliary:update-row "CATEGORIES" new-description "cat_id" id)))

; Remove category by ID
(define (remove id)
	(if (number? (int id))
		(auxiliary:delete-row "CATEGORIES" "cat_id" id)))

; Show category information based on key and value
; key can be: id, name or slug
(define (show key value)
	(set 'key (lower-case key))
	(when (or (= key "id") (= key "name") (= key "slug"))
		(if (= key "id") 	(set 'key "cat_id")
			(= key "name") 	(set 'key "cat_name")
			(= key "slug") 	(set 'key "cat_slug"))
		(println (auxiliary:get-row "CATEGORIES" key value))))

; Show all categories
(define (show-all)
	(println (auxiliary:get-table "CATEGORIES")))


; eof ;