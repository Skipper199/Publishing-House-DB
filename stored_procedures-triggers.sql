drop procedure if exists brochure_info;
DELIMITER $

create procedure brochure_info(in inputBrochureID int, in inputNewspaper varchar(20))
begin
		 declare j int;
		 declare i int;
         declare articlePages int;
         declare brochurePages int;
         declare sumPages int;
         declare pagesLeft int;
         
         set sumPages=0;
         set i=0;
         
		 select article.title, worker.wor_first_name, worker.wor_last_name,
			    article.approve_date, publishes.starting_page, article.number_of_pages
		 
         from article 
		 inner join submits  on article.path_dir=submits.article_path
         inner join journalist  on submits.author=journalist.j_email
         inner join worker  on journalist.j_email=worker.wor_email
         inner join publishes  on article.path_dir=publishes.article_path
         inner join brochure on publishes.brochure_id=brochure.br_id
         inner join newspaper on brochure.newspaper_name=newspaper.paper_name
         
		 where inputBrochureID=brochure.br_id and inputNewspaper=newspaper.paper_name;
          
		
         select count(*)
         into j 
         from article
         where article.publish_id=inputBrochureID and inputNewspaper=article.which_newspaper;
		
         
		 select number_of_pages
         into brochurePages
         from brochure
         where inputBrochureID=brochure.br_id and inputNewspaper=brochure.newspaper_name;
			
            
         
          while i < j do
            select number_of_pages 
            into articlePages
            from article
            where  article.publish_id=inputBrochureID and inputNewspaper=article.which_newspaper
            limit i,1; 
            
            set sumPages = sumPages + articlePages;
            set i = i + 1;
		 end while;
          set pagesLeft = brochurePages - sumPages;
         if (brochurePages > sumPages) then
			SELECT "There are pages left blank in the brochure.Blank Pages=" +pagesLeft; 
		 else 
			select "There are no blank pages left";
         end if;
         
        
		
end $
delimiter ;





drop procedure if exists newSalary;

DELIMITER $

create procedure newSalary (in empName varchar(20), in empLastName varchar(20))
begin
		
        declare hireDate date;
		declare currDate date;
        declare timeDiff int;
        declare salaryIncreasePercent int default 0;
        declare salaryIncrease int default 0;
        declare salary float(8,2);
        declare newSalary float(8,2);
        
        select curdate() into currDate;
        
		select worker.hire_date,worker.wor_salary
        into hireDate,salary
        from worker
        where empName=worker.wor_first_name and empLastName=worker.wor_last_name;
        

        SELECT TIMESTAMPDIFF(month,hireDate, currDate) into timeDiff;
        
		set salaryIncreasePercent = 0.5 * timeDiff;
        
        set salaryIncrease = salary * salaryIncreasePercent / 100;
        set newSalary = salary + salaryIncrease;
        
        select salaryIncrease , newSalary; 
        
		
end$

DELIMITER ;





drop trigger if exists baseSalary;

delimiter $

create trigger baseSalary
before insert on worker
for each row
	begin
		set new.wor_salary=650.00;
	end$
    
delimiter ;






drop trigger if exists isChiefEditor;

delimiter $

create trigger isChiefEditor
after insert on submits
for each row
		begin

            declare chief tinyint(1) default 0;
            
            set chief = 0;
		
            
            select is_chief_editor
            into chief
            from journalist
            where journalist.j_email=new.author;
            
            if (chief = 1) then
				update journalist
				inner join submits on submits.author=journalist.j_email
                inner join article on article.path_dir=submits.article_path 
                set good_to_go = 1 , changes = null , resubmit = 0
               
                where journalist.j_email=new.author;
                
			end if;
        end$
        
delimiter ;








drop trigger if exists spaceForArticle;

delimiter $

create trigger spaceForArticle
before insert on publishes
for each row
begin
		declare n int default 0;
        declare i int default 0;
        declare brochurePages int default null;
        declare articlePages int default null;
        declare sumPages int default 0;
        declare pagesLeft int default null;
        declare latestArticlePages int default null;
        
        
        set i=0;
        
       select count(*)
       into n
       from article
       inner join publishes on article.path_dir=publishes.article_path
       inner join brochure on brochure.br_id=article.publish_id
	   where brochure.br_id=new.brochure_id and brochure.newspaper_name=new.newspap_name;
       
       select brochure.number_of_pages
       into brochurePages
       from brochure
       where brochure.br_id=new.brochure_id and brochure.newspaper_name=new.newspap_name;
       
       
       while i < n do
		select article.number_of_pages
        into articlePages
        from article
        inner join publishes on article.path_dir=publishes.article_path
        inner join brochure on brochure.br_id=article.publish_id
        where article.publish_id=new.brochure_id and article.which_newspaper=new.newspap_name
        limit i,1;
        
        set sumPages = sumPages + articlePages;
        set i = i + 1;
        
         end while;
         
         set pagesLeft = brochurePages - sumPages;
         
         select article.number_of_pages
         into latestArticlePages
         from article
         where article.path_dir=new.article_path;
         
         if (brochurePages is not null and pagesLeft < latestArticlePages) then
         
			SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = 'Not enough pages left in the brochure :)';
         
        
        end if;
            
        
    
end$
    
    
delimiter ;
