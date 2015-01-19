-- DEFAULT VALUES --
-- <%NAME%> treba zamijenit sa vrijednoscu dobivenom pri instalaciji!

INSERT INTO GENERAL VALUES (
	'Dickblog',
	'Big & long blog about flowers!',
	'dickblog|dick blog|dinamo',
	'<%TIMEZONE%>',
	'<%ADMINAME%>',
	'<%ADMINEMAIL%>',
	'data/repository', 	-- kreira se tokom instalacije
	'data/media'		-- kreira se tokom instalacije
);

INSERT INTO SECRET VALUES (
	'<%USERNAME%>',
	'<%SALTEDPASSWORD%>',
	'<%SECRETQUESTION%>',
	'<%SECRETANSWER%>',
	NULL,
	NULL,
	NULL
);

-- Can't modify this --
INSERT INTO OPTIONS VALUES (0100, 'Number of latest posts on frontpage.', '3');
INSERT INTO OPTIONS VALUES (0101, 'Number of posts per category page.', '5');
INSERT INTO OPTIONS VALUES (0102, 'Number of files per repository page.', '10');

INSERT INTO CATEGORIES VALUES (
	0,
	'Uncategorized',
	'uncategorized',
	0,
	<%DATEOFINSTALLATION%>,
	'Category for hoes without pimps!'
);

INSERT INTO POSTS VALUES (
	0,
	'Sample post',
	'sample-post',
	<%DATEOFINSTALLATION%>,
	0,
	0,
	0,
	'moram smislit format posta'
);

INSERT INTO TAGS VALUES (
	0,
	'Untagged',
	'untagged',
	<%DATEOFINSTALLATION%>,
	'Example of a tag for repository.'
);