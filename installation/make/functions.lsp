#!/usr/bin/newlisp

(load "/usr/share/newlisp/modules/sqlite3.lsp")
(load "/usr/share/newlisp/modules/crypto.lsp")

(define (salt-password raw-password salt-time)
	(set 'salt (crypto:md5 salt-time))
	(string (crypto:md5 (string raw-password salt)) ":" salt))

(define (create-table table-name table-data)
	(if (sql3:sql (string "CREATE TABLE " table-name " (" table-data ")"))
		(println "--- Table " table-name " created.")
		((println "--- ERROR: " (sql3:error)) (exit))))

(define (update-table-value table-name table-values)	
	(if (sql3:sql (string "INSERT INTO " table-name " VALUES (" table-values ");"))
		(println "--- Table " table-name " updated.")
		((println "--- ERROR: " (sql3:error)) (exit))))

(define (create-database cms-data db-name)
	(println "\nCreating database!")
	(println "--- DB name: " db-name)
	(if (sql3:open db-name)
		(println "--- Database created/opened.")
		((println "--- ERROR: " (sql3:error)) (exit)))
	(set 'general-def
		"title TEXT,
		subtitle TEXT,
		keywords TEXT,
		time_zone TEXT,
		admin_name TEXT,
		admin_email TEXT,
		repository TEXT,
		media TEXT")
	(set 'secret-def
		"admin_username	TEXT,
		admin_password TEXT,
		secret_question TEXT,
		secret_answer TEXT,
		cookie_name TEXT,
		cookie_value TEXT,
		cookie_time TEXT")
	(set 'options-def 
		"option_id INTEGER,
		option_desc TEXT,
		option_value TEXT")
	(set 'media-def
		"media_id INTEGER,
		media_name TEXT,
		media_date INTEGER,
		media_filename TEXT,
		media_desc TEXT")
	(set 'categories-def
		"cat_id INTEGER,
		cat_name TEXT,
		cat_slug TEXT,
		cat_parent INTEGER,
		cat_date INTEGER,
		cat_desc TEXT")
	(set 'posts-def
		"post_id INTEGER,
		post_title TEXT,
		post_slug TEXT,
		post_date INTEGER,
		post_cat INTEGER,
		post_featured INTEGER,
		post_viewcount INTEGER,
		post_content TEXT")
	(set 'tags-def
		"tag_id INTEGER,
		tag_name TEXT,
		tag_slug TEXT,
		tag_date INTEGER,
		tag_desc TEXT")
	(set 'repository-def
		"repo_id INTEGER,
		repo_name TEXT,
		repo_slug TEXT,
		repo_tag_id TEXT,
		repo_filename TEXT,
		repo_date INTEGER,
		repo_down INTEGER,
		repo_desc TEXT")
	(create-table "GENERAL" general-def)
	(create-table "SECRET" secret-def)
	(create-table "OPTIONS" options-def)
	(create-table "MEDIA" media-def)
	(create-table "CATEGORIES" categories-def)
	(create-table "POSTS" posts-def)
	(create-table "TAGS" tags-def)
	(create-table "REPOSITORY" repository-def)

	(println "Adding default values!")

	(set 'general-values (string
		"'Dickblog',
		'Big & long blog about flowers!',
		'dickblog|dick blog|dinamo',
		'" (last cms-data) "',
		'" (nth 4 cms-data) "',
		'" (nth 5 cms-data) "',
		'data/repository',
		'data/media'"))	
	(set 'secret-values (string 
		"'" (first cms-data) "',
		'" (salt-password (nth 1 cms-data) (nth 6 cms-data)) "',
		'" (nth 2 cms-data) "',
		'" (nth 3 cms-data) "',
		NULL,
		NULL,
		NULL"))
	(set 'options-values-1 "0100, 'Number of latest posts on frontpage.', '3'")
	(set 'options-values-2 "0101, 'Number of posts per category page.', '5'")
	(set 'options-values-3 "0102, 'Number of files per repository page.', '10'")
	(set 'categories-values (string
		"0,
		'Uncategorized',
		'uncategorized',
		0,
		'" (nth 6 cms-data) "',
		'Category for hoes without pimps!'"))	
	(set 'posts-values (string
		"0,
		'Sample post',
		'sample-post',
		'" (nth 6 cms-data) "',
		0,
		0,
		0,
		'moram smislit format posta'"))	
	(set 'tags-values (string
		"0,
		'Untagged',
		'untagged',
		'" (nth 6 cms-data) "',
		'Example of a tag for repository.'"))
	(update-table-value "GENERAL" general-values)
	(update-table-value "SECRET" secret-values)
	(update-table-value "OPTIONS" options-values-1)
	(update-table-value "OPTIONS" options-values-2)
	(update-table-value "OPTIONS" options-values-3)
	(update-table-value "CATEGORIES" categories-values)
	(update-table-value "POSTS" posts-values)
	(update-table-value "TAGS" tags-values))