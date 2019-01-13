-- 서브쿼리는 쿼리문 안에 또 쿼리가 있는 것을 의미한다.

-- 아래는 키가 177 초과되는 데이터를 출력한다.
-- 김경호의 키가 177임을 알고 있을때 할 수 있는 쿼리문이다.
-- 그러나 몰랐을때는 어떻게 해야할까?
-- 이때 서브쿼리를 적절히 이용하면 된다.
select name, height
from usertbl
where height > 177;
-- 아래는 서브쿼리를 작성해서 위와 같이 동일한 결과를 출력한 것이다.
-- 실행 순서는 먼저 서브쿼리가 실행되고 결과값이 나온 것을 가지고 상위쿼리를 진행한다.
-- 서브쿼리의 값은 177인걸 알 수 있다.
select name, height
from usertbl
where height > (select height from usertbl where name = '김경호');


-- 아래 쿼리문을 실행해보면 에러가 발생한다. 이유가 뭘까?
-- 반드시 비교대상이 숫자 1개의 값이 나와야 하는데 서브쿼리를 따로 실행해보면 2개가 나온다.
-- 그럼 비교가 될 수가 없다. 문법에 맞지 않는 것이다.
select name, height
from usertbl
where height > (select height from usertbl where addr = '경남');
-- 하여 위의 코드를 실행하고자 한다면 아래와 같이 쿼리를 작성한다.
-- any 키워드를 사용하여 실행을 해보면 된다.
-- 서브쿼리의 값은 173, 170이었다. 서브쿼리 앞의 any의 의미는 or과 비슷한 개념이라고 생각하자. 170이거나 173이다.
-- 즉 다시말해, 170 이상인 데이터를 다 출력하겠다는 의미가 되는 것이다.
-- 기억할 것은 서브쿼리가 반환하는 값은 키라는 것이다.
select name, height, addr
from usertbl
where height > any (select height from usertbl where addr = '경남');


-- any와 동일한 기능을 하는 키워드중 하나가 some이다. any나 some이나 똑같은 것이다.
select name, height, addr
from usertbl
where height > some (select height from usertbl where addr = '경남');


-- all은 서브쿼리의 결과값 둘다 만족하는 데이터만 출력한다.
-- 즉, 다시말해 170, 173다 만족하는 값은 173인 것이다.
select name, height, addr
from usertbl
where height > all (select height from usertbl where addr = '경남');


-- 부등호를 바꾸면 170, 173과 똑같은 결과값만 리턴하게 되어있다.
select name, height, addr
from usertbl
where height = any (select height from usertbl where addr = '경남');


-- 또한 위와 똑같은 결과를 얻고자 한다면, 앞에서 배운 in을 사용하면 쉽게 해결된다.
select name, height, addr
from usertbl
where height in (select height from usertbl where addr = '경남');

-- 다음은 정렬과 관계된 내용이다.
-- 기본적으로 order by를 쓰게되면 주어진 필드에 의해 오름차순(asc)으로 정렬이 된다.
select *
from usertbl
order by mdate;

-- 반대로 내림차순 하고 싶으면 desc를 붙여주면 된다.
select *
from usertbl
order by mdate desc;


-- 아래 쿼리는 키에 의해 오름차순 정렬이다. 하지만, 키가 같은 사람이 이승기와 임재범이 있다.
-- 이때는 이름별로 정렬을 하고 싶을 것이다.
select *
from usertbl
order by height;

-- 아래 쿼리가 바로 키가 먼저 내림차순이 되고 그리고 오름차순으로 정렬한 것이다.
-- 이렇게 컬럼별로 정렬을 원하는 대로 하면 도니다.
select *
from usertbl
order by height desc, name asc;


-- 회원 테이블에서 회원들의 사는 지역을 어딘지 알고싶다.
-- 하지만 아래와 같이 쿼리를 하게되면 중복된 데이터가 나온다.
-- 그냥 사는 지역만 보고자 한다면 중복을 제거하고 봐야 편할 것이다.
select addr
from usertbl;

-- 이때 쓰는 것이 바로 distinct키워드이다. 현업에서 정말 자주쓰는 키워드이다.
select distinct addr
from usertbl;

-- 이제 데이터갯수를 제한을 두는 limit키워드에 대해서 알아보자.
-- 만약 회사에서 근속년수가 가장 오래된 사람 5명에 대해 상장을 주고 싶다.
-- 그럼 다 조회를 해야하는가? 아래 쿼리를 보자.
-- limit를 쓰지 않는다면 데이터를 30만건을 긁어서 가져와서 쿼리를 치니 굉장히 비효율적일 것이다.
-- 하여 limit키워드를 적절히 이용하면 좋을 것이다.

use employees;

select emp_no, hire_date, first_name, last_name
from employees
order by hire_date
limit 5;
-- limit 100, 5; -- 좌측처럼 100번부터 5건 같은식으로 조건도 줄 수 있다.

-- 테이블 복사하는 방법
-- 설명을 하자면, buytbl의 모든 데이터를 조회해서 그 데이터를 가지고 buytbl2를 만들어라는 내용인 것이다.
use sqldb;
drop table if exists buytbl2;
create table buytbl2 (select * from buytbl);

select *
from buytbl2;

-- 하지만, 테이블을 복사를 하게 되더라도 제약조건은 복사가 안된다.(PK,FK) 그것만 기억하도록 하자.
desc buytbl2;
desc buytbl;