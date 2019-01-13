/*
기본적 쿼리문의 순서이다. 물론 해당 줄은 생략은 가능하다.
하지만 다 사용하게 된다면, 무조건 아래와 같은 순서대로 작성을 해야한다.
다시말해 외워야 한다.
	select ...
    from   ...
    where  ...
    group by ...
    having ...
    order by ...
    */
    
use sqldb;

-- 고객이 구매한 건수를 확인해보는 쿼리문이다. 하지만 중복되는게 많이 나온다.
-- 아울러 집계가 되지 않아 한눈에 보기 어렵다.
-- 하여, group by절을 이용하면 편리하다.
select userid, amount
from buytbl
order by userid;

-- 아래 쿼리문을 실행해보면 고객별로 구매한 건수가 바로 한눈에 들어온다.
-- 여기서 sum()이 나왔는데 이것은 집계함수이며, 아울러  group by를 할때 즉,
-- 그룹을 지을때 userid로 하겠다는 의미이다. 일단 집계함수류가 나오면 무조건
-- group by절이 들어가야 한다는 것을 기억하도록 하자. 현업에서 정말 이것도 많이 쓴다.
select userid, sum(amount)
from buytbl
group by userid
order by userid;

-- 보기 좋게 알리아스를 사용해서 출력해봤다.
select userid as '사용자 아이디', sum(amount) as '구매한 건수'
from buytbl
group by userid
order by userid;

-- 이제 총 구매액을 한번 집계하여 보자.
-- 총구매액은 수량 * 단가가 될 것이다.
select *
from buytbl;

-- 아래 쿼리는 고객별로 총구매액을 기준으로 하여 내림차순으로 정렬하였다.
-- 역시 한눈에 보기 좋게 들어오는 것을 알수가 있다.
select userid as '사용자 아이디', sum(price*amount) as '총 구매액'
from buytbl
group by userid
order by sum(price*amount) desc;

-- 이제는 평균을 구하는 avg()에 대해 알아보자.
-- 아래 쿼리는 모든 고객을 대상으로 하여 평균 구매갯수를 알아보는 쿼리이다.
select avg(amount)
from buytbl;

-- 아래는 사용자 별로 구매건수를 구하는 쿼리이다.
-- 역시 userid별로 그룹을 짓고 avg(amount)로 내림차순하였다.
select userid as '사용자 아이디', avg(amount) as '평균 구매갯수'
from buytbl
group by userid
order by avg(amount) desc;

-- 이제 max(최대값)과 min(최소값)에 대해 알아보자.
select name, height
from usertbl;

-- 아래 쿼리를 치게 되면 원하는 결과를 얻지 못한다. 왜일까?
-- 이렇게 쿼리를 하게되면 기준이 없기 때문에 임의대로 결과값을 출력한다.
select name, max(height), min(height)
from usertbl;

-- 하여, 아래와 같이 코드를 바꿔도 역시 원하는 값을 얻을 수 없다.
-- 이름별로 그룹을 지어버리면 전부 10이 나오게 되어있다.
select name, max(height), min(height)
from usertbl
group by name;

-- 그래서 이 때는 잠시 앞서 배운 서브쿼리를 적절히 이용하면 원하는 결과값을 도출 할 수 있다.
select name, height
from usertbl
where height = (select max(height) from usertbl)
   or height = (select min(height) from usertbl);
-- union을 사용할 수도 있음 (합집합)    
    
    
-- 이제는 건수를 집계하는 count()에 대해서 알아보자.
-- 아래 쿼리는 현재 usertbl에 있는 데이터건수를 집계해준다.
select count(*)
from usertbl;

-- 그럼 핸드폰을 가지고 있는 사람의 건수만 집계해보는 쿼리를 만들어 본다.
-- 아래 두 쿼리문은 동일한 결과를 나타낸다. 항상 말하지만, 프로그램에는 정답이 없다.
-- 결과만 도출하면 된다. 사람하다 생각하는 것이 다르다. 노하우가 쌓이면 좀 더 좋은 쿼리가 보기좋게 나온다.
select count(*) as '휴대폰이 없는 사람'
from usertbl
where mobile1 is null;

select count(mobile1) as '휴대폰이 없는 사람'
from usertbl;

use employees;
-- 단순히 건수만 확인하고자 한다면 아래와 같이 쿼리를 날리면 DB데이터를 다 긁어서 오기 때문에 상당히 부하가 걸린다.
-- 건수만 확인하고자 한다면 count(*)를 이용하자.
select * from employees;

select count(*) from employees;


use sqldb;
-- 아래 쿼리는 아까 사용했던 사용자별 총구매액을 내림차순으로 정렬한 것이다.
-- 이제는 having절을 사용하는 법을 알아보자.

select userid as '사용자 아이디', sum(price*amount) as '총구매액'
from buytbl
group by userid
order by sum(price*amount) desc;

-- 그럼 위와 같이 총구매액으로 정렬하였다. 근데 총구매액이 1000만원 이상만 보고 싶다면 어떻게 해야할까?
-- 조건이니 where 절에 주면 될 것이라 생각할 것이다. 한번 해보자.
-- 그러나 에러가 난다. 다시말해 where 절에서는 집계함수를 쓸 수가 없다는 것이다.(매우 중요)
-- 그럼 어떻게 해야하나? 이때 그룹 함수를 가지고 조건을 줄 수 있는 절이 바로 having이다.
select userid as '사용자 아이디', sum(price*amount) as '총구매액'
from buytbl
where sum(price*amount) > 1000
group by userid
order by sum(price*amount) desc;

-- having도 역시 조건절이다. 단, 그룹에 관련된 함수들에 조건을 줄때 사용할 수가 있다.
select userid as '사용자 아이디', sum(price*amount) as '총구매액'
from buytbl
group by userid
having sum(price*amount) > 1000
order by sum(price*amount) desc;

-- 이제 with rollup에 대해서 살펴보면, 아래 쿼리를 결과를 보면 각각 groupname 별로
-- 소합계를 내어주고 마지막에는 총합계를 보여준다.
-- 아주 유용한 키워드이니깐 기억하도록 하자.
select num, groupname, sum(price*amount)
from buytbl
group by groupname, num
with rollup;

-- 만약 건바이건으로 되어있는 데이터를 보기 싫다면 당연히 num을 제외하면 된다.
select groupname, sum(price*amount)
from buytbl
group by groupname
with rollup;