DROP TABLE IF EXISTS keyword;
DROP TABLE IF EXISTS submits;
DROP TABLE IF EXISTS publishes;
DROP TABLE IF EXISTS article;
DROP TABLE IF EXISTS brochure;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS phone_numbers;
DROP TABLE IF EXISTS administrative;
DROP TABLE IF EXISTS journalist;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS worker;
DROP TABLE IF EXISTS newspaper;
DROP TABLE IF EXISTS publisher;

CREATE TABLE IF NOT EXISTS publisher(
pub_first_name VARCHAR(50) NOT NULL,
pub_last_name VARCHAR(20) NOT NULL,
email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
PRIMARY KEY (email)
);

                             
CREATE TABLE IF NOT EXISTS newspaper(
paper_name VARCHAR(20) NOT NULL,
publish_freq VARCHAR(10) DEFAULT 'unknown' NOT NULL,
pub_email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
PRIMARY KEY (paper_name),
CONSTRAINT OWNERSHIP
FOREIGN KEY (pub_email) REFERENCES publisher(email)
ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE IF NOT EXISTS worker(
wor_id INT(5) AUTO_INCREMENT,
hire_date DATE NOT NULL,
wor_first_name VARCHAR(20) NOT NULL,
wor_last_name VARCHAR(20) NOT NULL,
wor_email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
wor_salary FLOAT(8,2) DEFAULT 800.00 ,
PRIMARY KEY (wor_email),
UNIQUE  (wor_id)
);



CREATE TABLE IF NOT EXISTS works(
p_name VARCHAR(20) NOT NULL,
w_email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
PRIMARY KEY (p_name,w_email),
CONSTRAINT WORKS_WHERE
FOREIGN KEY (p_name) REFERENCES newspaper(paper_name)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT WORKS_WHO
FOREIGN KEY (w_email) REFERENCES worker(wor_email)
ON DELETE CASCADE ON UPDATE CASCADE
);
                         

CREATE TABLE IF NOT EXISTS journalist(
brief_resume TEXT NOT NULL,
work_exp TEXT ,
is_chief_editor TINYINT(1) NOT NULL,
j_email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
PRIMARY KEY (j_email),
CONSTRAINT ID_j
FOREIGN KEY (j_email) references worker(wor_email)
ON DELETE CASCADE ON UPDATE CASCADE
);


create table if not exists administrative(
duties varchar(10) default 'unknown' not null,
street_name varchar(20) default 'unknown' not null,
street_number varchar(5) not null,
city_name varchar(20) default 'unknown' not null,
admin_email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
primary key (admin_email),
constraint ID_admin
foreign key (admin_email) references worker(wor_email)
ON DELETE CASCADE ON UPDATE CASCADE
);


                                  
create table if not exists phone_numbers(
a_email VARCHAR(30) DEFAULT 'unknown' NOT NULL,
ph_number INT NOT NULL,
primary key (a_email,ph_number),
constraint ID_a
foreign key (a_email) references administrative(admin_email)
on delete cascade on update cascade
);


create table if not exists category(
cat_id INT(10) not null auto_increment,
cat_name varchar(20) default 'unknown' not null,
cat_description text not null,
parent_id int(10),
primary key (cat_id),
constraint recursive_rel
foreign key (parent_id) references category(cat_id)
on delete cascade on update cascade
);


																


create table if not exists brochure(
br_id int(5) not null,
date_of_release date not null,
number_of_pages int(5) not null,
newspaper_name VARCHAR(20) NOT NULL,
primary key (br_id,newspaper_name),
constraint br_1
foreign key (newspaper_name) references newspaper(paper_name)
on delete cascade on update cascade
);



create table if not exists article(
which_newspaper varchar(30) not null,
path_dir varchar(100) DEFAULT 'unknown' not null,
title varchar(30) default 'unknown' not null,
summary varchar(100)  NOT NULL,
supervised_from varchar(30) DEFAULT 'unknown' NOT NULL,
belongs_in_cat_id INT(10) not null,
publish_id int(5) not null,
number_of_pages int(2) not null,
good_to_go TINYINT(1)  default 0 NOT NULL, /* Egkrish/Aporripsh */
changes text,
resubmit TINYINT(1) default 1 not null,
approve_date date,
primary key (path_dir),
constraint supervisor_1
foreign key (supervised_from) references journalist(j_email)
on delete cascade on update cascade,
constraint article_category_2
foreign key (belongs_in_cat_id) references category(cat_id)
on delete cascade on update cascade,
constraint br_con
foreign key (publish_id) references brochure(br_id)
on delete cascade on update cascade,
constraint news_paper_1
foreign key (which_newspaper) references newspaper(paper_name)
on delete cascade on update cascade
);

create table if not exists publishes(
chief_editor_email varchar(30) default 'unknown' not null,
article_path varchar(100) DEFAULT 'unknown' not null,
brochure_id int(5) not null,
newspap_name VARCHAR(20) NOT NULL,
starting_page int(2) ,
primary key(chief_editor_email,article_path,brochure_id,newspap_name),
constraint chief
foreign key (chief_editor_email) references journalist(j_email)
on delete cascade on update cascade,
constraint articl
foreign key (article_path) references article(path_dir)
on delete cascade on update cascade,
constraint broch
foreign key (brochure_id) references brochure(br_id)
on delete cascade on update cascade,
constraint news_pap1
foreign key (newspap_name) references newspaper(paper_name)
on delete cascade on update cascade
);




create table if not exists submits(
author varchar(30) DEFAULT 'unknown' NOT NULL,
submission_date date not null,
article_path varchar(100) DEFAULT 'unknown' not null,
primary key(author,article_path),
constraint who
foreign key (author) references journalist(j_email)
on delete cascade on update cascade,
constraint which_one
foreign key (article_path) references article(path_dir)
on delete cascade on update cascade
);


create table if not exists keyword(
key_word varchar(20) not null,
art_path varchar(100) DEFAULT 'unknown' not null,
primary key (key_word,art_path),
constraint key_con
foreign key (art_path) references article(path_dir)
on delete cascade on update cascade
);




insert into publisher values ('Nikos','Papadopoulos','nikpap@gmail.com'),

		             ('Mat','Brown','matbrown@gmail.com');

insert into newspaper values ('Wall St News','weekly','nikpap@gmail.com'),
							 
			     ('New York Times','monthly','matbrown@gmail.com');




insert into worker values (null,'2002-05-23','George','Wilson','gwilson@gmail.com',1000.00),

			(null,'2010-08-05','Paul','Robinson','paulrob1@gmail.com',1100.00 ),
 
                         (null,'2005-09-21','Rose','Martin','rosemartin@gmail.com',1200.00 ),
			(null,'2015-02-24','Josh','Howard','joshhoward@gmail.com',800.00 ),

			(null,'2019-01-24','Emily','Jones','emilyjones@gmail.com',1200.00 );




insert into works values ('Wall St News','gwilson@gmail.com'),

			 ('New York Times','paulrob1@gmail.com'),
             ('Wall St News','rosemartin@gmail.com'),
             ('New York Times','joshhoward@gmail.com'),
			 ('New York Times','emilyjones@gmail.com');



insert into journalist values ('/information about journalist/',NULL,1,'gwilson@gmail.com'),
	
				('/INFORMATION ABOUT JOURNALIST/','Worked at 2 other newspapers',1,'paulrob1@gmail.com'),
                ('/information about journalist/','Worked as an editor in a sports magazine',0,'joshhoward@gmail.com');





insert into administrative values ('Secretary','Oak St','11A','New York','rosemartin@gmail.com'),

				 ('Logistics','Maple St','114','New York','emilyjones@gmail.com');





insert into phone_numbers values ('rosemartin@gmail.com',2025550157),
	
				 ('emilyjones@gmail.com',2025550114);



	

insert into category (cat_name,cat_description) values ('Politics','Information about the current political state'),

							('Economics','Information for economy'),
							('Sports','Sports results,upcoming matches etc');

insert into category (cat_name,cat_description,parent_id) values ('Domestic Policy','Information about the issues of the country',1),
								 ('Foreign Policy','Information about relations with other countries',1);
                                 





insert into brochure values (1,'2020-05-24',30,'New York Times'),
							(2,'2020-06-24',30,'New York Times'),
							(10,'2020-06-20',15,'Wall St News'),
							(11,'2020-06-27',15,'Wall St News');




insert into article values ('New York Times','C:/Users/Articles/Submitted/Article34a.doc','Political issues in 2020','text','paulrob1@gmail.com',1,1,5,default,NULL,default,'2020-05-29'),
						('New York Times','C:/Users/Articles/Submitted/Article36a.doc','UCL favourites to win it all','List of teams that are likely to win the UCL','paulrob1@gmail.com',3,1,3,default,null,default,'2020-05-29'),
                        ('New York Times','C:/Users/Articles/Submitted/Article42.doc',default,'Summary of article','joshhoward@gmail.com',1,1,10,default,null,default,null),
						('Wall St News','D:/Users/Articles/Submitted/Article40.doc','Economic Crisis','Decline in economy','gwilson@gmail.com',2,10,5,default,null,default,'2020-05-10');


insert into publishes values ('paulrob1@gmail.com','C:/Users/Articles/Submitted/Article34a.doc',1,'New York Times',1),
							  ('paulrob1@gmail.com','C:/Users/Articles/Submitted/Article36a.doc',1,'New York Times',6),
                          ('gwilson@gmail.com','D:/Users/Articles/Submitted/Article40.doc',10,'Wall St News',1);
                             
insert into submits values ('paulrob1@gmail.com','2020-05-02','C:/Users/Articles/Submitted/Article34a.doc');
insert into submits values	 ('joshhoward@gmail.com','2020-05-02','C:/Users/Articles/Submitted/Article36a.doc');
 insert into submits values  ('gwilson@gmail.com','2020-05-03','D:/Users/Articles/Submitted/Article40.doc');


insert into keyword values ('DECLINE','C:/Users/Articles/Submitted/Article34a.doc'),

			   ('BAD ECONOMY','D:/Users/Articles/Submitted/Article40.doc'),	
			   ('TEAM','C:/Users/Articles/Submitted/Article36a.doc');


