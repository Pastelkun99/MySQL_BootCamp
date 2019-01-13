drop table if exists member;
create table member (
	id varchar(20) not null primary key,
    pw varchar(20) not null,
    name varchar(30) not null,
    phone varchar(30)
);

select * from member;
insert into member values('kim', '1234', '김개똥', '010');
insert into member values('shin', '1234', '신은혁', '017');
insert into member values('min', '1234', '민수아', '011');


drop table if exists new_member;
create table new_member (
	name varchar(30) not null,
    id varchar(20) not null primary key,
    pw varchar(20) not null,
    phone1 varchar(10),
    phone2 varchar(10),
    phone3 varchar(10),
    gender varchar(10)
);

drop table if exists members;
create table members (
	id varchar(20) not null primary key,
    pw varchar(20) not null,
    name varchar(30) not null,
    eMail varchar(30),
    address varchar(100),
    rDate varchar(50)
);

insert into members values('pastelkun', '1234', '구씨', 'pastelkun@naver.com', '우리집', now());

select * from new_member;
select * from members;
delete from members where id = 'ddong';

truncate members;