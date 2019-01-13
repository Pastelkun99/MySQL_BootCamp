create database posmachine;

drop table if exists usertbl;
create table usertbl ( 
						id varchar(16) not null primary key,
						password varchar(16) not null,
                        tel varchar(11) not null
					 );
                     
                     
insert into usertbl values ('구윤모', '1234', '01049157404');

select * from usertbl;
truncate usertbl;

select id, password from usertbl;

drop table if exists menutbl;
create table menutbl ( menunum int auto_increment key not null,
					   name varchar(20) not null,
                       price int not null,					   
                       size varchar(10) default 'Small',
                       shot varchar(10) default 'No',
                       count int,
                       selltime varchar(20)
                       );

truncate menutbl;
                       
insert into menutbl values (1, '아메리카노', 1800, default, default, null, now());
insert into menutbl values (2, '에스프레소', 1500, default, default, null, now());
insert into menutbl values (3, '카페라떼', 2300, default, default, null, now());
insert into menutbl values (4, '카라멜마끼아또', 2500, default, default, null, now());
insert into menutbl values (5, '카페모카', 2400, default, default, null, now());
insert into menutbl values (6, '딸기스무디', 2900, default, '선택 불가', null, now());
insert into menutbl values (7, '망고스무디', 2900, default, '선택 불가', null, now());
insert into menutbl values (8, '자바칩프라페', 3500, default, '선택 불가', null, now());
insert into menutbl values (9, '쿠키앤프라페', 3400, default, '선택 불가', null, now());
insert into menutbl values (10, '토마토주스', 2800, default, '선택 불가', null, now());
insert into menutbl values (11, '크로크마담샌드위치', 3000, '선택 불가', '선택 불가', null, now());
insert into menutbl values (12, '클래식클럽샌드위치', 3300, '선택 불가', '선택 불가', null, now());
insert into menutbl values (13, '이탈리안샌드위치', 3500, '선택 불가', '선택 불가', null, now());
insert into menutbl values (14, '아이스크림와플', 2300, '선택 불가', '선택 불가', null, now());
insert into menutbl values (15, '달콤큐브브레드', 3000, '선택 불가', '선택 불가', null, now());
                       
select * from menutbl;
select name, price from menutbl where name = '아메리카노';

truncate menutbl;

drop table if exists selltbl;
create table selltbl ( menunum int auto_increment primary key,
					   name varchar(10) not null,
					   price int not null,
                       size varchar(10) default 'small',
                       shot varchar(10) default 'no',
                       count int,
                       selltime varchar(25)
					  );
                      

select * from selltbl;
delete from selltbl where menunum = 13;

select * from selltbl where selltime like '%2018%';

truncate selltbl;

create table exporttbl (menunum int auto_increment primary key,
						name varchar(20) not null,
                        price int not null,
                        size varchar(10) default 'small',
                        shot varchar(10) default 'no',
                        count int,
                        selltime varchar(25)
                        );

select * from exporttbl;
truncate exporttbl;

drop table if exists stocktbl;
create table stocktbl (	stockindex int,
						stocktime date,
						category varchar(30) not null,
						stockwondu int not null,
                        stockmilk int not null,
                        stockchoco int not null,
                        stockwhipping int not null,
                        stocktomato int not null,
                        stockbread int not null,
                        stockwapple int not null,
                        stockcinamon int not null);


update stocktbl set stockindex = 3 where stockindex = 5;

truncate stocktbl;

insert into stocktbl values(1, curdate(), '출고', 3, 3, 3, 3, 3, 3, 3, 3);
insert into stocktbl values(2, curdate(), '입고', 5, 10, 3, 45, 31, 22, 77, 48);
insert into stocktbl values(3, curdate(), '분실', 4, 7, 5, 1, 7, 4, 4, 6);
insert into stocktbl values(4, curdate(), '저장', 7, 8, 9, 78, 7, 8, 9, 6);
insert into stocktbl values(5, curdate(), '모름', 1, 2, 3, 4, 5, 6, 7, 8);
insert into stocktbl values(6, curdate(), '출고', 3, 3, 3, 3, 3, 3, 3, 3);
insert into stocktbl values(7, curdate(), '입고', 5, 10, 3, 45, 31, 22, 77, 48);
insert into stocktbl values(8, curdate(), '분실', 4, 7, 5, 1, 7, 4, 4, 6);
insert into stocktbl values(9, curdate(), '저장', 7, 8, 9, 78, 7, 8, 9, 6);
insert into stocktbl values(10, curdate(), '모름', 1, 2, 3, 4, 5, 6, 7, 8);
insert into stocktbl values(11, curdate(), '출고', 3, 3, 3, 3, 3, 3, 3, 3);
insert into stocktbl values(12, curdate(), '입고', 5, 10, 3, 45, 31, 22, 77, 48);
insert into stocktbl values(13, curdate(), '분실', 4, 7, 5, 1, 7, 4, 4, 6);
insert into stocktbl values(14, curdate(), '저장', 7, 8, 9, 78, 7, 8, 9, 6);
insert into stocktbl values(15, curdate(), '모름', 1, 2, 3, 4, 5, 6, 7, 8);
insert into stocktbl values(16, curdate(), '출고', 3, 3, 3, 3, 3, 3, 3, 3);
insert into stocktbl values(17, curdate(), '입고', 5, 10, 3, 45, 31, 22, 77, 48);
insert into stocktbl values(18, curdate(), '분실', 4, 7, 5, 1, 7, 4, 4, 6);
insert into stocktbl values(19, curdate(), '저장', 7, 8, 9, 78, 7, 8, 9, 6);
insert into stocktbl values(20, curdate(), '모름', 1, 2, 3, 4, 5, 6, 7, 8);
						
select * from stocktbl;			

show variables like 'secure_file_priv';

 select * from posmachine.selltbl
 into outfile 'C:\\temp\\selltablelist.csv' character set euckr
 fields terminated by ',' optionally enclosed by '"'
 escaped by '\\'
 lines terminated by '\n';
