use mydb;

-- 문제 52
select *
from emp
where (select substring(hiredate, 6, 2) = '09');

-- 문제 53
select *
from emp
where (select substring(hiredate, 1, 4) = '2003');

-- 문제 54
select *
from emp
where (select substring(ename, 3, 3) = '기');

-- 문제 55
select abs(-44), abs(-77), abs(-100);

-- 문제 56
select cast('2015-09-01 11:22:44:777' as date);

-- 문제 57
select cast('2015-09-01 11:22:44:777' as time);

-- 문제 58
select floor(34.5678);

-- 문제 59
select ceiling(27.8987);

-- 문제 060
select round(19.6678, 1);

-- 문제 061
select truncate(24.4535, -1);

-- 문제 062
select mod(78, 3);

-- 문제 063
select pow(15, 4), sqrt(81);

-- 문제 064
select floor(rand()*(45))+1 as '첫번째', floor(rand()*(45))+1 as '두번째', floor(rand()*(45))+1 as '세번째', 
	   floor(rand()*(45))+1 as '네번째', floor(rand()*(45))+1 as '다섯번째', floor(rand()*(45))+1 as '여섯번째';
       
-- 문제 065
select truncate(34.667788, 2);

-- 문제 066
select lower('Welcome to MySQL');
select upper('Welcome to MySQL');

-- 문제 067
select adddate('2017-10-05', interval 30 day),
	   adddate('2017-10-05', interval 1 month);
       
-- 문제 068
select subdate('2017-10-05', interval 30 day),
	   subdate('2017-10-05', interval 1 month);
       
-- 문제 069
select datediff(now(), '1993-04-24');

-- 문제 070
select curdate(), dayofyear(curdate());

-- 문제 071
select last_day('20210201');

-- 문제 072
select time_to_sec('09:45');

-- 문제 073
select sleep(5);
select '열심히 하자';

-- 문제 074
select concat(quarter(curdate()), '사분기') as '분기';
