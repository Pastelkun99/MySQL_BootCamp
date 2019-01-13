-- 먼저 sqldb를 다시 초기화하자.
use sqldb;

-- 아래는 view를 만드는 쿼리이다. 설명하자면 v_userbuytbl를 만드는데
-- select 문의 내용을 view로 만들겠다는 것이다.
-- 매번 저렇게 조회를 하게 되면 계속 쿼리를 길게 쳐야 할 것이다.
-- 한번 만들고 view를 활용하면 된다.

create view v_userbuytbl
as
	select U.userid as 'USER ID', U.name as 'USER NAME', B.prodname as 'PRODNAME',
			U.addr as '주소', concat(U.mobile1, U.mobile2) as 'MOBILE PHONE'
	from usertbl U
    inner join buytbl B
    on U.userid = B.userid;
    
-- view를 조회했는데 마치 테이블을 조회하는 것처럼 느껴진다.
select *
from v_userbuytbl;

-- 필드별로 조회하고 시으면 알리아스 준걸로 필드명을 주고 반드시 백틱을 사용하여 감싸야 한다.
select `USER ID`, `USER NAME`
from v_userbuytbl;

-- 아래는 view를 수정하는 것이다.
alter view v_userbuytbl
as
	select U.userid as '사용자 아이디', U.name as '이름', B.prodname as '제품 이름',
			U.addr as '주소', concat(U.mobile1, U.mobile2) as '전화번호'
	from usertbl U
    inner join buytbl B
		on U.userid = B.userid;
        
select *
from v_userbuytbl;

select `이름`, `전화번호`
from v_userbuytbl;

-- 삭제할때 역시 drop을 사용
drop view v_userbuytbl;

-- 또다른 view를 만들어보자
-- 근데 or replace가 왔다. 이것은 v_usertbl가 있다면, 아래 것으로 view를 덮어쓰라는 것이다.
-- 만약 없다면 만든다.
create or replace view v_usertbl
as 
	select userid, name, addr
    from usertbl;
    
-- 뷰의 구조를 보면 꼭 테이블과 유사하게 되어있다. 하지만 제약조건들은 보이지 않는다는것을 기억하자.
desc v_usertbl;

-- 뷰를 통해서 수정을 하지 수정이 된다. 그리고 실제 테이블을 확인해봐도 변경이 되었다.
update v_usertbl
set addr = '부산'
where userid = 'EJW';

select *
from usertbl;

desc usertbl;

-- 하지만 아래 삽입은 되지 않는다.
-- 왜일까? 이유는 usertbl에는 birthyear필드가 not null이기 때문이다.
-- 따라서 삽입이 되지 않는다.
-- 아래 데이터를 꼭 삽입하고 싶다면, view에 birthyear를 추가하던가,
-- birthyear를 default값을 주던가, 아니면 null로 설정을 바꿔야 할 것이다.
insert into v_usertbl(userid, name, addr) values ('KBM', '김병만', '충북');

-- 하여 아래와 같이 view를 수정했다.
create or replace view v_usertbl
as
	select userid, name, addr, birthyear
    from usertbl;

-- 그리고 필드를 추가해서 삽입을 하니 잘 되는 것을 알 수 있다.
insert into v_usertbl(userid, name, addr, birthyear) values ('KBM', '김병만', '충북', '19750807');

select *
from usertbl;

-- 집계 함수와 group by 와 order by를 이용하는 view도 사용해보자.
create or replace view v_sum
as
	select userid as 'USER ID', sum(price*amount) as '합계'
    from buytbl
    group by userid
    order by sum(price*amount) desc;
    
-- select문의 결과대로 잘 나오는 것을 알 수 있다.
-- 그리고 집계함수가 들어가 view는 데이터를 변경할 수 없음을 명심하자.
select *
from v_sum;

update v_sum
set `합계` = 2000
where userid = 'BBK';

-- 이것을 직접 눈으로 확인해보자.
-- information_schema는 시스템 데이터베이스이다.
-- 확인해보면 is_updateable을 보면 no로 되어있다.
-- 하여 이 v_sum은 view로는 수정, 삭제, 삽입이 불가능하다.
-- 즉 다시말해 집계함수를 사용한 view는 절대 수정이나 삭제가 되지 않는다.
-- 아울러, union all, join, distinct, group by도 안된다.
select *
from information_schema.views
where table_schema = 'sqldb'
and table_name = 'v_sum';

-- 키가 177 이상인 사람을 조회하는 view 생성함.
create or replace view v_height177
as
	select *
    from usertbl
    where height >= 177;
    
select *
from v_height177;

-- 실행은 되지만 키가 177 이상인 사람은 view에 없다.
delete from v_height177
where height < 177;

-- 자 입력을 해보면 입력은 된다. 하지만 조회를 하면 나오지 않는다. 왜? view에서 키가 177 이상인 사람만 조회하기때문이다.
insert into v_height177 values('SEH', '신은혁', 2008, '구미', null, null, 140, '2010-5-5');

select *
from v_height177;

-- 근데 혼란이 온다. 177이상인 데이터만 입력을 받기 위해서 with check option 구문을 사용하면 된다.
alter view v_height177
as
	select *
    from usertbl
    where height >= 177
    with check option; -- 177 이상인지 체크함.
    
-- 다시한번 삽입해보자. 에러가 난다. 왜? with check option 구문떄문에 177 이하는 삽입이 되지 않는 것이다.
insert into v_height177 values('KKK', '김기군', 2008, '구미', null, null, 140, '2010-5-5');

-- 복합 view도 아래와 같이 만들 수 있다.
create or replace view v_userbuytbl
as
	select U.userid as 'USER ID', U.name as 'USER NAME', B.prodname as 'PROD NAME',
    U.addr as '주소', concat(U.mobile1, U.mobile2) as 'MOBILE PHONE'
    from usertbl U
    inner join buytbl B
    on U.userid = B.userid;
    
-- 조인 뷰에 데이터 삽입은 안된다.
insert into v_userbuytbl values('PKL', '박경리', '작가', '경기', '00000000', '2010-5-5');

-- 테이블을 제거했다. 그럼 뷰는 어떻게 될까?
drop table buytbl, usertbl;

-- 진짜 테이블이 없는데 어찌 뷰가 실행되겠는가? 참조할 테이블이 사라졌는데...
select *
from v_userbuytbl;

-- 이때는 뷰가 참조하고 있는 테이블을 확인해보면 된다.
check table v_userbuytbl;
