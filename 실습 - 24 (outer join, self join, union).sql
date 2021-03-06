
use sqldb;
-- 이제는 outer join을 살펴보자
-- inner join은 조건에 해당하는 행만 리턴해줬다.
-- 하지만, 구매기록이 없는 고객까지 출력하고 싶다면 left outer join을 사용하면 된다.
-- 다시말해, left outer join을 기준으로 하여 왼쪽 테이블 즉 usertbl의 모든 데이터를
-- 출력하는 것이다. 이것이 바로 left out join인 것이다.

select U.userid, U.name, B.prodname, U.addr, concat(U.mobile1, U.mobile2) as '연락처'
from usertbl U
left outer join buytbl B
		   on U.userid = B.userid
           order by U.userid;
           
-- 이번에는 right outer join에 대해서 알아보면 left outer join과 자리만 바뀌는 것 밖에 없다.
-- right outer join을 기준으로 오른쪽 테이블 즉, buytbl에 있는 것들 모두 다 출력 하라는 것이다.

select *
from usertbl;

select *
from buytbl;

select U.userid, U.name, B.prodname, U.addr, concat(U.mobile1, U.mobile2) as '연락처'
from usertbl U
right outer join buytbl B
on U.userid = B.userid
order by U.userid;

-- outer join을 잘 이용하여 구매한 내역이 없는 고객리스트를 출력해보자.
select U.userid, U.name, B.prodname, U.addr, concat(U.mobile1, U.mobile2) as '연락처'
from usertbl U
left outer join buytbl B
				on U.userid = B.userid
                -- prodname이 null이란 것은 구매한 적이 없다라는 것을 의미하는 것이다.
                where B.prodname is null
                order by U.userid;
                
-- 아래 쿼리는 left outer join을 이용하여 3개의 테이블을 엮어서 학생중에 동아리에 가입하지 않은 사람을
-- 추출해주는 쿼리이다.

select S.stdname, S.addr, C.clubname, C.roomno
from stdtbl S
left outer join stdclubtbl SC
			on S.stdname = SC.stdname
left outer join clubtbl C
			on SC.clubname = C.clubname
            order by S.stdname;
            
-- 아래 쿼리는 left outer join과 right outer join을 이용하여 3개의 테이블을 엮어서
-- 학생이 한명도 가입하지 아니한 동아리를 추출하는 쿼리문이다.
-- 왜 right outer join을 사용했을까? 동아리명이 다 나와야 하니깐 그런 것이다.
select C.clubname, C.roomno, S.stdname, S.addr
from stdtbl S
left outer join stdclubtbl SC
			on S.stdname = SC.stdname
right outer join clubtbl C
			on SC.clubname = C.clubname
            order by C.clubname;
            
-- 그런데 위의 두개의 결과값을 동시에 보고싶을때는 어떻게 할까?
-- 두 쿼리의 결과값을 연결해주는 키워드가 필요하다.
-- 그게 바로 union인 것이다. 즉 합집합이란 말이다.
-- 결과는 학생중 동아리에 가입하지 않은 것과 한명도 가입하지 않은 동아리를 추출해낸다.
select S.stdname, S.addr, C.clubname, C.roomno
from stdtbl S
left outer join stdclubtbl SC
			on S.stdname = SC.stdname
left outer join Clubtbl C
			on SC.clubname = C.clubname
union
select C.clubname, C.roomno, S.stdname, S.addr
from stdtbl S 
left outer join stdclubtbl SC
			on S.stdname = SC.stdname
left outer join clubtbl C
			on SC.clubname = C.clubname;
            
-- 이제는 cross join에 대해서 알아보자.
-- CROSS JOIN의 결과 개수는 두 테이블 개수를 곱한 개수가 된다.
-- 카티션곱 (Cartesian Product) 이라고도 부른다. 통상 대용량 데이터를 생성할 때 사용한다.
select *
from buytbl
cross join usertbl;

-- employeesDB의 employee테이블과 titles테이블을 cross join을 해서 대용량 데이터를
-- 만들어보자. 확인해보면 1333억개 정도의 데이터가 만들어지는 것을 확인할 수가 있다.
use employees;
select format(count(*), 0) as '데이터 갯수'
from employees
cross join titles;

-- 아래와 같이 쿼리를 치면 아마 여러분들 컴퓨터는 뻗을 것이다.
select *
from employees
cross join titles;

-- 이제 self join을 알아보자 이 조인은 테이블 하나로 두번 이상 엮어서 걸과값을
-- 얻어오는 것이다. 책 279페이지 그림과 테이블을 보자.
-- 만약, 우대리의 상관인 이부장의 전화번호를 알고싶으면 self join을 해서 알아낼 수가 있는 것이다.

use sqldb;
-- emptbl을 생성하자.
drop table if exists emptbl;
create table emptbl( emp char(3) not null primary key,
					 manager char(3),
                     emptel varchar(8) );
                     
-- 데이터를 입력해보자.
insert into emptbl values ('나사장', null, '0000'), ('김재무', '나사장', '2222'),
						  ('김부장', '김재무', '2222-1'), ('이부장', '김재무', '2222-2'),
                          ('우대리', '이부장', '2222-2-1'), ('지사원', '이부장', '2222-2-2'),
                          ('이영업', '나사장', '1111'), ('한과장', '이영업', '1111-1'),
                          ('최정보', '나사장', '3333'), ('윤차장', '최정보', '3333-1'),
                          ('이주임', '윤차장', '3333-1-1');

select *
from emptbl;

-- 그럼 우대리의 상관인 이부장의 전화번호를 추출해내는 쿼리를 만들어보자.
-- 하나의 테이블을 찢어서 두개로 분리한다고 생각하고, 조건을 설정할떄 manager필드와
-- emp 필드가 같고, where절을 우대리로 주면 될 것이다.
-- 개념이 조금 어렵지만, 잘 생각해보고 반복하면 된다.

select A.emp as '부하직원', B.emp as '직속상관', B.emptel
from emptbl A
inner join emptbl B
		on A.manager = B.emp
        where A.emp = '우대리';
        
-- union과 union all을 살펴보자.
-- union은 두 쿼리문의 결과를 출력하는데 중복된 것을 제외를 한다.
-- 하지만, union all은 두 쿼리문의 결과를 출력하는 것은 똑같지만, 중복된 것도 다 출력된다.

select *
from stdtbl
union all
select *
from clubtbl;

-- not in과 in을 알아보자. not in은 서브쿼리나 데이터 값을 제외할때 쓰는 것이고,
-- in은 포함할 때 쓰는 것이다. 아래 쿼리를 보자.
-- 아래 쿼리는 핸드폰 번호가 없는 사람들을 제외하고 출력하는 것이다.
select name, concat(mobile1, mobile2) as '연락처'
from usertbl
where name not in ( select name from usertbl where mobile1 is null);

-- 반대로 in을 쓰게 된다면, 핸드폰 번호가 없는 사람만 출력하는 것이다.
select name, concat(mobile1, mobile2) as '연락처'
from usertbl
where name in (select name from usertbl where mobile1 is null);