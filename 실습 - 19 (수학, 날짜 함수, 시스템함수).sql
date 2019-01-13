-- 수학 함수들
-- 절대값 구하기
select abs(-100);

-- ceiling()는 올림, floor()는 내림, round()는 반올림 함수
select ceiling(4.7), floor(4.7), round(4.7);

-- conv()는 진법 변환시켜줌, 16진수 -> 2진수, 10진수 -> 8진수로 바꾸는 쿼리다.
select conv('AA', 16, 2), conv(100, 10, 8);

-- mod()는 나머지 값을 구하는 함수
select mod(157, 10), 157 % 10, 157 mod 10;

-- pow()는 몇 승을 구함, sqrt()는 제곱근을 구하는 함수
select pow(2,3), sqrt(9);

-- rand() 함수는 0.0000... ~0.999... 를 임의대로 리턴한다.
-- 우측 컬럼은 주사위 눈을 랜덤으로 구하는 공식이다.
select rand(), floor(1 + (rand() * (6-1)) );

-- sign()은 양수인지 0인지 음수인지 확인하는 부호함수이다.
select sign(100), sign(0), sign(-100);

-- truncate()는 해당 자릿수까지 출력하고 나머지는 버린다.
select truncate(12345.12345, 2), truncate(12345.12345, -2);


-- 날짜 함수들
-- adddate()는 day, month, year단위로 interval을
-- 주면 그 interval만큼의 뒷날을 리턴한다. (더하는 개념)
select adddate('2020-02-01', interval 31 day),
	   adddate('2020-02-01', interval 1 month);
       
-- subdate() 는 day, month, year 단위로 interval을 주면
-- 그 interval만큼의 앞날을 리턴한다. ( 빼는 개념)
select subdate('2020-02-01', interval 31 day),
	   subdate('2020-02-01', interval 1 month);
       
-- addtime()은 시간을 더하는 함수이다.
select addtime('2020-02-01 23:59:59', '1:1:1'),
	   addtime('15:00:00', '2:10:10');
       
-- year()는 년도, month()는 월, day(), dayofmonth()는 일,
-- dayofyear()는 일년의 몇번째 일을 리턴한다.
select year(curdate()), month(curdate()), day(curdate()),
			dayofmonth(curdate()), dayofyear(curdate());
            
-- hour() 는 시간, minute()는 분, second()는 초를 리턴함.
select hour(curtime()), minute(current_time()), second(curtime());

-- now()는 현재 날짜 시간을 리턴한다.
select now();

-- date()는 날짜, time()은 시간만 리턴한다.
select date(now()), time(now());

-- 현재부터 인자값까지의 날짜 차이를 리턴한다.
-- 역으로 인자값을 주면 -값이 나온다.
select datediff('20200101', now());
select datediff(now(), '20200101');

-- 아래는 시간차이를 리턴한다. -(하이픈)을 넣으나 안넣으나 결과값이 동일하다.
select timediff('232323', '121212');
select timediff('23:23:23', '12:12:12');

-- dayofweek()은 요일을 리턴하는데 상수값을 리턴한다. 일요일이 1, 월요일이 2... 이렇게 나간다.
-- monthname()은 달의 영어이름을 리턴, dayofyear()는 1년에서 몇번쨰 일이냐를 리턴한다.
select dayofweek(curdate()), monthname(curnate()), dayofyear(curdate());

-- 그 달의 마지막 일을 리턴한다.
select last_day('20200201');

-- makedate()는 2020년에서 32일이 지난 날짜를 리턴한다.
select makedate(2020, 32);

-- maketime()은 인자값으로 시간을 만든다.
select maketime(12,11,10);

-- period_add()는 더하고, period_diff()는 차이를 리턴한다.
select period_add('202001', 11), period_diff('202001', 201812);

-- quarter()는 몇 사분기인지 리턴한다.
select concat(quarter(20170909), '사분기') as '분기';

-- time_to_sec()는 시간을 초로 바꿔준다.
select time_to_sec('12:11:10');


-- 시스템 함수
-- 현재 사용자와 DB명을 리턴한다.
select current_user(), database();

use sqldb;
select *
from usertbl;

-- found_rows()는 방금 조회된 rows의 건수를 리턴한다.
select found_rows();

update buytbl
set price = price/2;

-- row_count()는 방금 update한 건수가 리턴된다.(근데 버젼별로 이상하다.)
select row_count();

-- sleep()는 잠깐 멈추는 기능을 지니고 있다.
select sleep(3);
select '3초 후에 이게 보입니다.';
