-- 아래 cast문은 현재 문자열을 date타입으로 캐스팅 해주는 것이다.
-- 각각, 해보면 date는 날짜만, time은 시간만, datetime은 날짜+시간으로 출력이 되는 것을 
-- 알수가 있다.
select cast('2020-10-12 12:22:12:456' as date) as 'DATE'
from dual;
select cast('2020-10-12 12:22:12:456' as time) as 'TIME';
select cast('2020-10-12 12:22:12:456' as datetime) as 'DATETIME';

-- 이제 변수를 한번 사용해보자. 후반부에 스토어드프로시저에서 변수가 자주 등장하므로
-- 개념을 익힐 필요가 있다.
use sqldb;

-- 변수는 set이란 키워드로 시작하여 @변수명으로 지정을 할 수가 있다.
set @myvar1 = 5;
set @myvar2 = 3;
set @myvar3 = 4.25;
set @myvar4 = '가수 이름 -=--> ';

select @myvar1;
select @myvar2 + @myvar3;

-- 보기좋게 출력하기 위하여 변수를 이용한 것이다.
select @myvar4, name
from usertbl
where height > 180;

-- 하지만 변수는 limit다음에는 쓸 수가 없다. error가 발생함
select @myvar4, name
from usertbl
where height > 180;
-- limit @myvar2;

-- 하지만 변수는 limit다음에는 쓸 수가 없다. 에러가 발생한다.
select @myvar4, name
from usertbl
where height > 180
limit 5;	-- limit 뒤에는 변수 못옴.

-- 하여 prepare .. execute ... using문을 사용하면 된다
-- 일단 아래 쿼리는 변수 지정하고, myquary명으로 ''안에 있는 쿼리문을 준비하는 것이다.
-- 근데 ? 있다. 이 ? 는 @myvar1변수값이 저장되어 execute문이 실행되는것이다.
-- 예를 들어 응용프로그램에서 사용자로부터 입력을 받아서 출력한다면 이렇게 변수를 사용하면 좋다.
-- 중요하니 잘 알아두자.
set @myvar1 = 3;

prepare myquery
from 'select name, height
		from usertbl
		order by height
		limit ?';
	
execute myquery using @myvar1;

use sqldb;
-- 아래 쿼리 실행하면 buytbl의 amount평균을 나타낸다.
-- 하지만 소숫점을 반올림하고 싶을 때는 cast, convert를 사용하면 된다.
select avg(amount) as '평균구매갯수'
from buytbl;

-- 똑같은 결과를 주지만 문법한 조금 차이가 있다. cast는 as convert는 , 로 됐다는 것.

select cast(avg(amount) as signed integer) as '평균 구매갯수'
from buytbl;

select convert(avg(amount), signed integer) as '평균 구매갯수'
from buytbl;

-- 날짜 형식 안에 어떤 구분자가 들어가도 상관없이 date 타입으로 cating된다.
select cast('12@12@11' as date);
select cast('12/12/11' as date);
select cast('12?12?11' as date);
select cast('12#12#11' as date);

-- concat()은 문자를 연결해주는 함수이다.
select num, concat(cast(price as char(10)), '*', cast(amount as char(4))) as '단가*수량',
		price*amount as '구매액'
from buytbl;

-- cast나 convert를 쓰면 이것은 명시적 형변환을 의미한다.
-- 하지만 아래의 경우는 묵시적 형변환에 속한다. 용어를 잘 숙지하자.

select '100' + '100'; -- 문자와 문자를 더한다. 이 경우 정수로 변환되어 200을 리턴
select concat('100', '200'); -- concat()은 문자들을 연결하는 함수이다. 하여 100200을 리턴한다.
select concat(100, '200'); -- concat()안에 정수가 있더라고 문자로 변환되어 연결된다. 100200 리턴함.

-- 사실 아래와 같이 쓰는 경우는 잘 없는데 책에 있음.
-- 여기서 기억할 부분은 프로그래밍 언어에서도 마찬가지니 설명한다.
-- 0은 항상 거짓이다. 0을 제외한 나머지 정수는 모두 참이다. 하지만 통상 1을 사용한다.

select 1 > '2mega'
from dual;			-- 이런 구문은 앞에 2로 시작하니 2가 되어 비교한다.
					-- 결과는 false이므로 0값을 리턴한다.
select 3 > '2mege'; -- 결과는 true로 1을 리턴
select 0 = 'mega2'; -- 문자는 0으로 변환되어 비교된다. 하여 true이다. 결과는 1을 리턴한다.