use sqldb;

-- 앞에서 했던 sqldb에 usertbl을 drop하고 아무 제약 조건을 주지 않고 새로 생성해보자.
-- 하지만, 분명 외래키 제약 조건 때문에 drop이 안될 것이다.
-- 하여, buytbl을 먼저 제거하고 usertbl을 제거해야한다.

drop table if exists buytbl;
create table buytbl (
 num int auto_increment primary key,
 userid char(8),
 prodname char(6),
 groupname char(4),
 price int,
 amount smallint
 );
 
-- 외래키 제약 조건이 없으니 당연히 drop이 잘 될 것이다. 그리고 새로 만든 테이블에는 어떠한 제약 조건도 주지 않았다.
drop table if exists usertbl;
create table usertbl(
 userid char(8),
 name varchar(10),
 birthyear int,
 addr char(2),
 mobile1 char(3),
 mobile2 char(8),
 height smallint,
 mdate date,
 nation varchar(10) not null default 'KOREA' -- default 제약 조건 추가
 );
 
-- 데이터 삽입을 해보자.
-- 그런데 잘못 삽입했다. 김범수는 생년월일을 몰라서 null로 추가했고, 김경호는 오타로 1871로 입력을 해버렸다.
-- 일단 삽입해보자. 잘 입력이 될 것이다. 왜? 제약 조건이 없으니까
insert into usertbl values('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8', 'USA');
insert into usertbl values('KBS', '김범수', 1967, '경남', '011', '2222222', 173, '2012-4-4', default);
insert into usertbl values('KKH', '김경호', 1871, default, '019', '3333333', 177, '2007-7-7', default);
insert into usertbl values('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');

-- alter table 을 이용한 default제약조건 추가 
alter table usertbl
	alter column addr set default '서울';

desc usertbl;
select * from usertbl;


-- buytbl 데이터 삽입
insert into buytbl values(null, 'KBS', '운동화', null, 30, 2);
insert into buytbl values(null, 'KBS', '운동화', '전자', 1000, 1);
insert into buytbl values(null, 'JYP', '모니터', '전자', 200, 1);
insert into buytbl values(null, 'BBK', '모니터', '전자', 200, 5);

-- 현재 usertbl에는 아무런 제약 조건이 없다. 하여 alter table쿼리로
-- 기본키로 추가해보자. 그렇다고 not null은 추가할 필요가없다.
-- PK를 추가하면 자동 not null이 따라 붙는다.
alter table usertbl
	add constraint PK_usertbl_userid
	primary key (userid);

-- 확인해보자.
desc usertbl;

-- 이번에는 buytbl에 외래키 제약 조건을 추가해보자. 그리고 실행을 하면 에러가 난다. 왜일까?
-- 현재 외래키를 설정하려고 보니 데이터값에 usertbl에 'BBK'란 userid가 없어서 에러를 나게 하는 것이다.
-- 그래서 BBK를 지우고 다시 한 번 하면 잘 설정이 될 것이다.

delete from buytbl
where userid = 'BBK';

alter table buytbl
add constraint FK_usertbl_buytbl
foreign key(userid) references usertbl(userid);

-- 그런데 먼저 buytbl에 외래키 설정을 해놓고도 아래와 같이 데이터를 삽입하고 싶다면
-- foreign key 기능을 iff 시키는 방법이 있다.
-- off를 시키지 않으면 usertbl에 userid가 없는 것들은 데이터가 삽입이 안된다.
-- 하여 아래와 같은 방법으로 삽입을 한다.
-- 하지만, 아래와 같은 방법은 절대 권장하지 않는다.
-- 먼저 회원을 가입시켜야 그 회원이 물건을 사게 만들어야지 아무나 물건을 사면 이상하다. 절차가 맞지 않는 것이다.
-- 하여, usertbl에 먼저 회원 정보를 입력한 후  buytbl에 데이터를 넣는 것이 당연한 절차이다.

set foreign_key_checks = 0; -- 외래키 체크 기능 off
insert into buytbl values(null, 'BBK', '모니터', '전자', 200, 5);
insert into buytbl values(null, 'KBS', '청바지', '의류', 50, 3);
insert into buytbl values(null, 'BBK', '메모리', '전자', 80, 10);
insert into buytbl values(null, 'SSK', '책', '서적', 15, 5);
insert into buytbl values(null, 'EJW', '책', '서적', 15, 2);
insert into buytbl values(null, 'EJW', '청바지', '의류', 50, 1);
insert into buytbl values(null, 'BBK', '운동화', null, 30, 2);
insert into buytbl values(null, 'EJW', '책', '서적', 15, 1);
insert into buytbl values(null, 'BBK', '운동화', null, 30, 2);
set foreign_key_checks = 1; -- 외래키 체크 기능 on, 이후 데이터 삽입시에 외래키 체크한다.

-- 다시 usertbl에 남은 데이터를 삽입한다.
insert into usertbl values('SSK', '성시경', 1979, '서울', null, null, 186, '2013-12-12');
insert into usertbl values('LJB', '임재범', 1963, '서울', '016', '6666666', 186, '2009-9-9');
insert into usertbl values('YJS', '윤종신', 1969, '경남', null, null, 186, '2005-5-5');
insert into usertbl values('EJW', '은지원', 1972, '경북', '011', '8888888', 186, '2014-3-3');
insert into usertbl values('JKW', '조관우', 1965, '경기', '018', '9999999', 186, '2010-10-10');
insert into usertbl values('BBK', '바비킴', 1973, '서울', '010', '0000000', 186, '2013-5-5');

-- 자 아래 제약 조건 추가는 check 제약 조건이다. 즉, 1900 이후 값을 입력받으란 것이다.
-- 원래 오라클이나 mssql에는 check 제약 조건이 있다. 하지만 mysql에는 이런 기능이 없다.
-- 하지만 이런 check기능은 trigger로써 해결할 수 있으니 별 문제가 없다.
-- 그냥 알아두기만 하자.
alter table usertbl
add constraint CK_birthyear
check (birthyear >= 1900 and bitrhyear <= year(curdate()));

desc usertbl;
-- 분명 위에서 check 제약 조건을 주었음에도 불구하고 아래 데이터가 추가가 됨을 알 수가 있다.
insert into usertbl values('SEN', '신은혁', 1888, '전남', '019', '3333333', 177, '2007-7-7');
delete from usertbl where userid = 'SEN';

select *
from usertbl;

-- 아래 쿼리는 아시다시피 BBK를 VVK로 수정하라는 쿼리문이다.
-- 실행해보면 에러가 난다. 왜? 외래키 제약 조건이 걸려있는 것이다.
update usertbl
set userid = 'VVK'
where userid = 'BBK';

-- 하지만 억지로 바꾸고 싶다면 위에서 배운 외래키 체크를 해제하고 하면 된다.
set foreign_key_checks = 0;
update usertbl
set userid = 'VVK'
where userid = 'BBK';
set foreign_key_checks = 1;

-- 확인해보면 바뀌어 있는 것을 확인할 수 있다.
select * from usertbl;

select * from buytbl;

delete from buytbl;

-- 두 테이블을 조인하여 아래와 같이 결과를 도출하였다.
-- 근데 분명히 buytbl은 데이터가 12건이 있었음에도 불구하고, 8건이 조회가 되었다.
-- 왜? BBK가 VVK로 변경이 되었으니 당연히 결과값이 안나올 것이다.
select count(*)
from buytbl;

select U.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from usertbl U
inner join buytbl B
on U.userid = B.userid;

-- 그래서 buytbl을 outerjoin을 통해서 한번 확인해보자.
-- 확인해보지 역시 BBK가 나오긴 하지만 구매부분은 다 null이 되어 있을 것이다.
-- 왜? 위에서 BBK를 VVK로 바꾸었으니까 참조가 되지 않는 것이다.
select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from buytbl B
left outer join usertbl U
on U.userid = B.userid;

-- 자 그럼 다시 원상복구 시켜보자.
set foreign_key_checks = 0;
update usertbl
set userid = 'BBK'
where userid = 'VVK';
set foreign_key_checks = 1;

-- 이제 데이터가 제대로 나온다.
select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from buytbl B
left outer join usertbl U
on U.userid = B.userid;

-- 근데 계속 BBK를 VVK로 바꿔달라고 하면 외래키를 추가할 때 on update cascade구문을 사용하면
-- buytbl에 있는 BBK가 VVK로 자동으로 바뀐다.

-- 먼저 buytbl에 설정되어 있는 외래키를 제거하고 다시 추가하자.
alter table buytbl
drop foreign key fk_usertbl_buytbl;

alter table buytbl
	add constraint fk_usertbl_buytbl
    foreign key(userid) references usertbl(userid)
    -- 이 구문이 들어감으로써 usertbl의 PK가 변경되면 따라서 buytbl의 FK인 userid도 따라 바뀐다.
    on update cascade;

-- 그래서 바꿔봤다. 잘 바뀐다. 왜? on update cascade때문에
update usertbl
set userid = 'VVK'
where userid = 'BBK';

-- 확인해보면 잘 바뀌어 있는 것을 볼 수가 있다.
-- 하지만, 현업에서는 PK를 바꾸는건 권장사항이 아니다.
-- 이 예제에서도 개명을 했다면 모르겠지만 말이다.

select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from buytbl B
left outer join usertbl U
on U.userid = B.userid;

-- 또, VVK가 탈퇴를 하려고 할 때에도 외래키 제약 조건에 의해 삭제가 안된다.
-- 삭제가 되어버리면 buytbl에 있는 데이터가 붕 떠버리는 경우가 되어버려서 그런다.
-- 그래서 이 때는 on delete cascade제약 조건을 추가해주면 자동으로 따라서 VVK의 buytbl에 있는
-- 데이터도 따라서 삭제가 되는 것이다.

delete from usertbl
where userid = 'VVK';

-- 먼저 buytbl에 설정되어 있는 외래키를 제거하고 다시 추가하자.
alter table buytbl
drop foreign key fk_usertbl_buytbl;

alter table buytbl
	add constraint fk_usertbl_buytbl
    foreign key(userid) references usertbl(userid)
    on update cascade	-- 수정시 따라서 수정
    on delete cascade;	-- 삭제시 따라서 삭제

delete from usertbl
where userid = 'VVK';

-- 확인해보면 VVK건도 다 삭제되었다.
select *
from buytbl;

-- 분명 위에서 birthyear필드에는 check제약조건이 있음에도 불구하고
-- 삭제가 된다. 위에서 말했듯이 mysql에서는 check제약 조건은 제대로 기능을 하지 않는다.
-- 하여 삭제가 되는 것이다.
alter table usertbl
drop column birthyear;

alter table usertbl
add column birthyear int first;

select *
from usertbl;