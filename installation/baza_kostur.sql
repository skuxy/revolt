-- 1 ROW TABLES --
CREATE TABLE GENERAL (
	title 			TEXT,
	subtitle		TEXT,
	keywords		TEXT,
	time_zone		TEXT,		-- format: UTC
	admin_name 		TEXT,
	admin_email		TEXT,
	repository		TEXT,
	media 			TEXT
);

CREATE TABLE SECRET (
	admin_username	TEXT,
	admin_password	TEXT,
	secret_question	TEXT,
	secret_answer	TEXT,
	cookie_name		TEXT,
	cookie_value	TEXT,
	cookie_time		TEXT
);
-- END OF 1 ROW TABLES --

CREATE TABLE OPTIONS (
	option_id		INTEGER,
	option_desc		TEXT,
	option_value	TEXT
);

CREATE TABLE MEDIA (
	media_id		INTEGER,	-- [1,+]
	media_name 		TEXT,
	media_date		TEXT,
	media_filename	TEXT,
	media_desc		TEXT
);

CREATE TABLE CATEGORIES (
	cat_id			INTEGER,	-- cat_id = 0; default uncategorized
	cat_name		TEXT,
	cat_slug		TEXT,
	cat_parent		INTEGER,	-- svaka kategorija moze imati samo jednog roditelja
	cat_date		TEXT,
	cat_desc		TEXT
);

CREATE TABLE POSTS (
	post_id			INTEGER,	-- post_id != 0
	post_title		TEXT,
	post_slug		TEXT,
	post_date		TEXT,
	post_cat		INTEGER,	-- cat_id (ako post_cat ima roditelja onda je i to kategorija posta)
	post_featured	INTEGER,	-- boolean
	post_viewcount	INTEGER,	-- unsigned
	post_content	TEXT
);

CREATE TABLE TAGS (
	tag_id 			INTEGER,	-- tag_id = 0; default uncategorized
	tag_name		TEXT,
	tag_slug		TEXT,
	tag_date		TEXT,
	tag_desc		TEXT
);

CREATE TABLE REPOSITORY (
	repo_id			INTEGER,
	repo_name 		TEXT,
	repo_slug		TEXT,
	repo_tag_id		TEXT,
	repo_filename 	TEXT,
	repo_date		TEXT,
	repo_down		INTEGER,
	repo_desc		TEXT
);