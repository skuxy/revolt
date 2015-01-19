#!/usr/bin/newlisp

;	Part of MCMS project
;	- file: article.lsp
;	- author: vjekoart@gmail.com
;
;	Functions for manipulating articles.
;	Main functionalities:
;		1. Add new article 	(create)
;		2. Edit article 	(update)
;		3. Remove article 	(remove)
;		4. Show article 	(show)
;		5. Show article excerpt
;		6. Show all articles (show-all)
;		7. Toggle 'Featured' (featured)

(load "category.lsp")

(context 'article)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Local auxiliary functions
;

; Returns new article ID
(define (get-id)
	(inc (first (flat (auxiliary:get-max-value "post_id" "POSTS")))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;	Main functions
;

; Add new article to database
(define (create title category-id featured content)
	(unless (category:check-parent (int category-id))
		((println "ERROR: Wrong category ID.") (exit)))
	(if (= featured "y")
		(set 'featured 1)
		(set 'featured 0))
	
	(set 'id (get-id))
	(set 'slug (auxiliary:get-unique-slug title "POSTS"))
	(set 'article-date (auxiliary:get-time))
	(set 'viewcount 0)
	(set 'post-def
		(format "'%d','%s','%s','%s','%d','%d','%d','%s'"
			id title slug article-date (int category-id) featured viewcount content))

	(auxiliary:insert-table-value "POSTS" post-def))

; Update article information
; only name and content can be updated (slug will be modified automatically)
(define (update id new-name new-content)
	(when new-name
		(set 'new-slug (auxiliary:get-unique-slug new-name "POSTS"))
		(set 'new-values (string "post_title='" new-name "'," "post_slug='" new-slug "'"))
		(auxiliary:update-row "POSTS" new-values "post_id" id))
	(when new-content
		(set 'new-content (string "post_content='" new-content "'"))
		(auxiliary:update-row "POSTS" new-content "post_id" id)))

; Remove article by ID
(define (remove id)
	(if (number? (int id))
		(auxiliary:delete-row "POSTS" "post_id" id)))

; Show article information based on key and value
; key can be: id, name or slug
(define (show key value)
	(set 'key (lower-case key))
	(when (or (= key "id") (= key "name") (= key "slug"))
		(if (= key "id") 	(set 'key "post_id")
			(= key "name") 	(set 'key "post_name")
			(= key "slug") 	(set 'key "post_slug"))
		(println (auxiliary:get-row "POSTS" key value))))

; Show all categories
(define (show-all)
	(println (auxiliary:get-table "POSTS")))

; Toggle 'Featured' option for article
(define (featured id)
	(when (number? (int id))
		(set 'old-value (auxiliary:get-column-value "post_featured" "POSTS" "post_id" id))
		(if (= (first (flat old-value)) 1) (set 'new-value 0) (set 'new-value 1))
		(auxiliary:update-row "POSTS" (string "post_featured=" new-value) "post_id" id)
	)
)


; eof ;