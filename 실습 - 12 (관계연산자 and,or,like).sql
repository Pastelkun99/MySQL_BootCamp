use sqldb;

-- name이 김경호인 것만 출력한다. 이미 잘 알고 있다.
select *
from usertbl
where name = '김경호';

-- 관계연산자와 and를 이용하여 조건을 준다.
-- and는 둘다 참이어야 참을 반환하여 준다.
-- 하여 아래 쿼리는 usertbl에서 userid와 name을 가져오는데
-- 그 조건이 출생년도(year)이 1970년을 포함한 이후의 조건과
-- 키(height)가 182이상인 조건을 둘다 만족하는 데이터를 출력한다.

select userID, name
from usertbl
where birthyear >= 1970
and height >= 182;

-- 아래는 or가 조건에 들어간다. or은 둘중 하나만 참이면 무조건 참을 반환하기 때문에
-- 출생년도가 1970년 이후이거나 키가 182이상인 데이터는 다 출력하게 되어있다.
select userID, name
from usertbl
where birthyear >= 1970
or height >= 182;

-- 아래 쿼리는 키가 180이상이고 183이하의 조건을 충족하는 데이터만 출력한다.
select userID, name, height
from usertbl
where height >= 180
and height <= 183;

-- 위의 코드는 between(사이) ~ and 구문으로도 바꿀 수가 있다.
-- 역시 의미는 위와 동일하다.
-- 위의 코드보다 between ~ and 구문이 훨씬 시각적으로 보기가 좋다. (현업에서 많이 사용함)
-- 통상 수치데이터에 많이 쓰인다. (연속적인 데이터)
select userID name
from usertbl
where height between 180 and 183;

-- 아래 코든느 addr(지역)이 경남이거나, 전남이거나, 경북이거나, 전북인 것을 만족하는 데이터를 출력한다.
select name, addr
from usertbl
where addr = '경남'
	or addr = '전남'
    or addr = '경북'
    or addr = '전북';
    
-- 위의 코드와 완전 동일한 결과를 나타낸다.
-- in은 수치데이터(연속적 데이터)가 아닌 이산적(떨어져 있는) 데이터에 자주 사용된다.
-- 역시 아래코드가 시각적으로나 코드줄수에서도 효율적인 것을 알 수 있다.
select name, addr
from usertbl
where addr('경남', '전남', '경북', '전북');

-- 성이 김씨인 데이터를 다 출력해준다.
-- like와 %구문은 통상 검색할때 이런 형태로 많이 쓰인다.
select name, addr
from usertbl
where name like '김%';

-- 한글자에 대한 것은 _(언더바)로써 대체하여 검색할 수 있다.
select name, addr
from usertbl
where name like '_종신';
