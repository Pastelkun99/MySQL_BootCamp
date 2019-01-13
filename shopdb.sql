#shopdb라는 데이터 베이스를 만드는 것
create database shopdb;
#use 명령어는 ~을 사용하겠다
#여기에서는 shopdb사용하겠다는 뜻임.
use shopdb;

#membertbl을 생성하는 sql문
create table membertbl(
	memberID char(8) not null,
    memberName char(5) not null,
    memberAddress char(20),
    primary key(memberID)
);

insert into membertbl values('Dang', '당탕이', '경기도 부천시 중동');
insert into membertbl values('Jee', '지운이', '서울 은평구 중산동');
insert into membertbl values('Han', '한주연', '인천 남구 주안동');
insert into membertbl values('Sang', '상길이', '경기도 성남시 분당구');
insert into membertbl values('shin', '신동욱', '');

select *
	from membertbl;
    
create table producttbl(
	productName char(4) not null,
    cost int not null,
    makeDate date,
    company char(5) not null,
    amount int not null,
    primary key(productName)
);

insert into producttbl values('컴퓨터', 10, '2013-1-1', '삼성', 17);
insert into producttbl values('세탁기', 20, '2014-9-1', 'LG', 3);
insert into producttbl values('냉장고', 5, '2015-2-1', '대우', 22);


select *
from producttbl


#membertbl에 있는 데이터 중에 membername이 지운이 인것만 가져와라
select *
from membertbl
where memberName = '지운이';

#producttbl에 있는 데이터를 가져와라.
select *
from producttbl;

create table `my testTBL`(id INT); # 백팁을 통한 DB이름 칸 띄우기alter

drop table `my testTBL`; #drop을 통한 테이블 제거
