
/*
	통상 sql은 아래와 같은 분류로 나뉜다.
    1. DML(Data Manipulation Language) : 데이터 조작어 ex) select, insert, delete, update
		DML은 얼마든지 취소가 가능하다. rollback이란 키워드로 말이다.
	2. DDL(Data Definition Language) : 데이터 정의 언어 ex) create, drop, alter, truncate
		취소 불가. 실행하면 바로 적용됨
	3. DCL(Data Control Language) 데이터 제어 언어 ex) grant, revoke, deny
		사용자에게 어떤 권한을 부여하거나 빼앗을 때 주로 사용하는 구문
*/

-- 새로운 테이블인 testtbl을 만들고 안에 데이터를 insert into를 통해서 삽입하였다.
use sqldb;
drop table if exists testtbl1;
create table testtbl1 (
id int,
username char(3),
 age int
 );
insert into testtbl1 values(1, '홍길동', 25);

select *
from testtbl1;

-- 만약 insert할때 사용자가 원하는 필드만 넣고 싶을때는 테이블명 (컬럼명, 컬럼명...)
-- 형태로 지정해준다.
-- 넣어주지 않은 필드는 당연히 null이 된다.
insert into testtbl1(id, username) values (2, '김연아');

-- 필드를 사용자 맘대로 설정해서 넣어줄수도 있다.
insert into testtbl1(username, age, id) values ('초아', 29, 3);

use sqldb;
-- testtbl2 테이블을 만드는데, 앞서 잠깐 살펴보았지만 auto_increment 키워드를 사용하면,
-- id값이 int 형태로 자동 증가한다. 하여, insert시 그 필드는 null을 넣어줘도 무방하다.
drop table if exists testtbl2;
create table testtbl2(
		id int auto_increment primary key,
        username char(3),
        age int
);
select *
from testtbl2;

insert into testtbl2 values(null, '지민', 33);
insert into testtbl2 values(null, '강민', 22);
insert into testtbl2 values(null, '은수', 11);

-- 만약 직접 넣어주게되면 auto_increment는 적용되지 아니한다.
insert into testtbl2 values(9, '연수', 123);

delete from testtbl2
where id = 9;

select *
from testtbl2;
-- auto_increment한 필드가 마지막으로 삽입된 것을 조회할때는 last_insert_id()함수를 이용하면 편리.
select last_insert_id();

-- 만약 건너뛰어서 100번부터 증가시키면서 넣고 싶을때는 아래와 같이 테이블을 수정하면 된다.
-- 테이블을 수정하고자 할때는 alter키워드를 사용한다.
alter table testtbl2 auto_increment = 100;

insert into testtbl2 values (null, '연수', 23);

select *
from testtbl2;

use sqldb;
-- testtbl3 테이블을 만들었다.
create table testtbl3 (
	id int auto_increment primary key,
    username char(3),
    age int
);

-- 다시 testtbl3의 자동증가를 1000부터 시작하게끔 testtbl3테이블의
-- auto_increment를 1000으로 수정했다.
alter table testtbl3 auto_increment = 1000;

-- 아래 부분은 좀 생소하지만, 알아둘 필요가 있는 서버변수이다.
-- set키워드 다음 @@ 붙으면 서버변수라고 생각해라.
-- 이건 자동증가를 3씩 하게끔 설정하는 것이다.
set @@auto_increment_increment = 3;

delete from testtbl3;

-- testtbl3에 데이터를 3개 삽입해본다.
insert into testtbl3 values (null, '나연', 33);
insert into testtbl3 values (null, '동수', 22);
insert into testtbl3 values (null, '은혁', 11);

-- 조회를 해보면 id가 3씩 증가되는 것을 볼수가 있다.
select *
from testtbl3;
