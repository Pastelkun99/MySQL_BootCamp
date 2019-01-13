drop database if exists mydb2;

create database mydb2;

use mydb2;

# 문제 168
drop table if exists emp02;
create table emp02(
					empno int primary key,
                    ename varchar(10) not null,
                    job varchar(10) not null
				);
                
# 문제 169
drop table if exists backup_emp02;
create table backup_emp02(
							empno int,
                            ename varchar(10) not null,
                            job varchar(10) not null,
                            modtype varchar(5) not null,
                            moddate datetime default now() not null,
                            moduser varchar(10) default 'root'
                            );
                            
# 문제 170
drop trigger if exists backupnew;
delimiter $$
create trigger backupnew
	after insert
    on emp02
    for each row
begin
	declare newface varchar(10);
    declare newjob varchar(10);
    set newface = new.ename;
    set newjob = new.job;
    
	insert into backup_emp02 values (new.empno, new.ename, new.job, '신규', default, default);
    set @str = concat(newface, newjob, '님이 입사하셨습니다.');
end $$ 
delimiter ;

insert into emp02 values(1, '김연아', '과장');
select @str;

select * from emp02;
select * from backup_emp02;

# 문제 171
drop trigger if exists backup_update;
delimiter $$
create trigger backup_update
	after update
    on emp02
    for each row
begin
	declare component varchar(10);
    declare newjob varchar(10);
    set component = new.ename;
    set newjob = new.job;
    
    insert into backup_emp02 values (new.empno, new.ename, new.job, '수정', default, default);
    set @str = concat(new.ename, old.job, '님이', new.job, '으로 승진하셨습니다.');
end $$
delimiter ;

update emp02 set job = '차장' where empno = 1;
select @str;

# 문제 172
drop trigger if exists backup_delete;
delimiter $$
create trigger backup_delete
	after delete
    on emp02
    for each row
begin
	declare byepeople varchar(10);
    declare byejob varchar(10);
    set byepeople = old.ename;
    set byejob = old.job;
    
    insert into backup_emp02 values (old.empno, old.ename, old.job, '삭제', default, default);
    set @str = concat(old.ename, old.job, '님이 퇴사하셨습니다.');
end $$
delimiter ;

delete from emp02 where empno = 1;
select * from emp02;
select * from backup_emp02;
select @str;

# 문제 173
drop table if exists producttbl;
create table producttbl (
							prodcode varchar(10) primary key,
                            prodname varchar(10) not null,
                            maker varchar(10) not null,
                            price int not null,
                            stock int default 0
						);

# 문제 174
drop table if exists ordertbl;
create table ordertbl (
						orderno int auto_increment primary key,
                        userid varchar(10) not null,
                        prodname varchar(10),
                        order_count int not null
					);


# 문제 175
drop table if exists warehousingtbl;
create table warehousingtbl (
								num int auto_increment primary key,
                                warecode varchar(10) not null,
                                prodname varchar(10) not null,
                                waredate datetime default now(),
                                warecount int not null,
                                wareprice int
							);

# 문제 176
drop table if exists shipmenttbl;
create table shipmenttbl (
							num int auto_increment primary key,
                            warecode varchar(10) not null,
                            shipdate datetime default now(),
                            shipcount int not null,
                            shipprice int not null
						);

# 문제 177
insert into producttbl values ('A00001', '세탁기', 'LG', 500, default),
							  ('A00002', '컴퓨터', 'LG', 700, default),
                              ('A00003', '에어콘', 'LG', 1200, default),
                              ('A00004', '냉장고', 'LG', 1250, default);

select * from producttbl;


# 문제 178
drop trigger if exists stocktrg;
delimiter $$
create trigger stocktrg
	after insert
    on warehousingtbl
    for each row
begin
	update producttbl set stock = new.warecount where prodname = new.prodname;
end $$
delimiter ;

insert into warehousingtbl (num, warecode, prodname, warecount, wareprice) values
					   (null, 'A00001', '세탁기', 100, 320),
                       (null, 'A00002', '컴퓨터', 50, 500),
                       (null, 'A00003', '에어콘', 70, 950),
                       (null, 'A00004', '냉장고', 80, 1000);

select * from warehousingtbl;
select * from producttbl;

# 문제 179
drop trigger if exists stockupdate;
delimiter $$
create trigger stockupdate
	after insert
    on ordertbl
    for each row
begin
	update producttbl set stock = stock - new.order_count where prodname = new.prodname;
end $$
delimiter ;

drop trigger if exists ordershiptrg;
delimiter $$
create trigger ordershiptrg
	after update
    on producttbl
    for each row
begin
	insert into shipmenttbl values (null, new.prodname, default, (old.stock - new.stock), new.price);
end $$
delimiter ;

insert into ordertbl values (null, '김기수', '세탁기', 20);

select * from ordertbl;
select * from producttbl;
select * from shipmenttbl;

# 문제 180
drop trigger if exists ordercanceltrg;
delimiter $$
create trigger ordercanceltrg
	after delete
    on ordertbl
    for each row
begin
	update producttbl set stock = stock + old.order_count where prodname = old.prodname;
    delete from shipmenttbl where warecode = old.prodname;
end $$
delimiter ;

delete from ordertbl where orderno = 1;

select * from ordertbl;
select * from producttbl;
select * from shipmenttbl;

	