create database todolist;

create table userinfo(
	id varchar(16) not null,
    pw varchar(16) not null,
    phonenumber1 int,
    phonenumber2 int,
    phonenumber3 int
    );

drop table userinfo;
select * from userinfo;