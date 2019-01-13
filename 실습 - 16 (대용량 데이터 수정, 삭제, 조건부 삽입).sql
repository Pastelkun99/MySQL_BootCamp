-- 대용량 데이터를 쉽게 가져오는 방법이 있다.
-- 아래와 같이 일단 테이블을 만들자.

select *
from employees.employees;

desc employees.employees;

use sqldb;

-- 아래와 같이 testtbl4 테이블을 만들었다.
drop table if exists testtbl4;

create table testtbl4 (
id int,
fname varchar(14),
lname varchar(16)
);

-- 아래 쿼리는 대용량 데이터를 바로 삽입하는 것이다. 약 30만건
insert into testtbl4
select emp_no, first_name, last_name
from employees.employees;

-- 물론 전에 잠깐 배웠지만, 아래와 같은 방법도 있다. 테이블을 만들면서
-- 바로 select문을 이용하는 것이다.
create table testtbl5 (select emp_no, first_name, last_name
						from employees.employees);
                        
-- 각각 조회를 해보면 employees.employees 테이블의 3개 필드가 삽입되어 있는
-- 것을 확인할 수 있다.

select *
from testtbl4;

select *
from testtbl5;

-- 이제는 update(수정)문에 대해서 알아본다.
-- update... set... where... 형태로 쓴다. 앞에서 배운적 있음.
-- 만약 where(조건)절이 없다면, 모든 데이터를 수정해버린다. 현업에서도 이런 실수가 잦다.
-- 주의하도록 하자.
select *
from testtbl4
where fname = 'Kyoichi';

-- testtbl4에 있는 데이터 중 Kyoichi인 것만 lname이 '없음'으로 수정하라는 쿼리문이다.
update testtbl4
set lname = '없음'
where fname = 'Kyoichi';

-- 하지만, 간혹가다가 전체를 대상으로 update를 치는 경우가 있다.
-- 제품 단가가 올랐다던지, 아니면 월급이 5%씩 인상되었다던지 등등... 이런 경우는
-- where 절을 써주지 않아도 되는 것이다.
-- 아래는 단가를 일괄적으로 1.5배 올리는 쿼리문이다.
-- 먼저 조회해본 후, update 를 치도록 하자.
select *
from buytbl;

update buytbl
set price = price * 1.5;

-- delete문에서도 역시 where 가 없으면 모든 데이터를 날리는 것이다.
-- 하여 where 절이 반드시 들어가는 것이 좋다.
use sqldb;
delete from testtbl4
where fname = 'Aamer';

-- 확인해보면 Aamer는 없다.
select *
from testtbl4
where fname = 'Aamer';

use sqldb;
-- 아래와 같이 3개의 테이블을 각각 대용량 테이블을 만들었다.
create table bigtbl1 (select *
						from employees.employees);

create table bigtbl2 ( select *
						from employees.employees);

create table bigtbl3 ( select *
						from employees.employees);
						
-- 아래와 같이 데이터를 지우는데에는 3가지 방법이 있다.
-- 각각의 속도차이를 한번 보도록 하자.
-- 확인을 해보면 속도차이가 delete(DML) 구문이 확실히 늦은 것을 알수가 있다.
-- 하여, 테이블과 함꼐 데이터까지 다 날리고 싶다면 drop을 권장하고,
-- 테이블의 구조는 남아있게 할려면 truncate(DDL)을 권장한다.
-- 하지만 현업에서는 drop을 웬만하면 안쓴다.

drop table bigtbl1;

delete from bigtbl2;

truncate table bigtbl3;

-- drop 한 bigtbl1은 테이블까지 제거가 된 것을 확인할 수 있다.
select * from bigtbl1;

select * from bigtbl2;

select * from bigtbl3;

-- 아래와 같이 membertbl1을 usertbl에 있는 userid, name, addr필드를 3건만으로 만들었다.

drop table if exists membertbl;

create table membertbl(
select userid, name, addr
from usertbl
limit 3
);

select *
from membertbl;

-- 하지만, 테이블을 위와 같이 만들면, 제약조건은 따로 복사가 안된다고 앞에서 강의한 적이 있다.
-- 하여, 아래와 같이 직접 제약조건을 설정해준다. 지금은 잘 몰라도 된다. 일단 보자.
desc membertbl;

-- pk를 userid로 설정해주는 쿼리문이다.
alter table membertbl
add constraint pk_membertbl primary key(userid);

desc membertbl;

-- 데이터를 삽입하기 위해서 아래와 같이, insert구문을 사용했다.
-- 근데 삽입이 되질 않는다. 왜 일까?
-- pk는 오로지 1개로써 unique한 값만 지닌다고 했다.
-- 그래서 삽입이 되지 않는다. BBK때문에 말이다.
-- 근데, BBK를 제외한 나머지 두 줄은 삽입되게 하고 싶다.
-- 그떄 insert ignore into문을 사용하면 나머지 2줄은 들어가게 된다.
insert into membertbl values ('BBK', '비비코', '미국');
insert into membertbl values ('SKJ', '신미나', '서울');
insert into membertbl values ('CHUNLI', '춘리', '상해');

insert ignore into membertbl values ('BBK', '비비코', '미국');
insert ignore into membertbl values ('SKJ', '신미나', '서울');
insert ignore into membertbl values ('CHUNLI', '춘리', '상해');

select *
from membertbl;

-- 하지만, duplicate key update문을 사용하면 pk의 내용을 덮어쓰게 된다.
-- 물론 현업에서는 잘 사용하지는 않는다.
-- 다만 책에 내용이 있고 OCP자격증 시험에도 나오니 한번 알아보는 것이다.
-- 쿼리는 아래와 같다.

insert into membertbl values ('BBK', '빠삐코', '일본')
	on duplicate key update name='비비코', addr='미국';
    
-- DJM은 원래 없던 데이터이기 때문에 그냥 duplicate key update문이 실행되지는 않는다.
insert into membertbl values ('DJM', '동주민', '일본')
	on duplicate key update name= '동주민', addr='일본';
    
insert ignore into membertbl values ('SKJ', '신미나', '서울');
insert ignore into membertbl values ('CHUNLI', '춘리', '상해');

