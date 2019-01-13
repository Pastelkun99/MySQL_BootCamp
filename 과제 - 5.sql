use mydb;

-- 문제 39
select max(sal), min(sal), sum(sal), avg(sal)
from emp;

-- 문제 40
select deptno, max(sal), min(sal), sum(sal), avg(sal)
from emp
group by deptno;

-- 문제 41
select job, count(*)
from emp
group by job;

-- 문제 42
select job, count(*)
from emp
where job = '과장';

-- 문제 43
select max(sal)-min(sal) as '최대 - 최소'
from emp;

-- 문제 44
select job, min(sal)
from emp
group by job
order by min(sal) desc;

-- 문제 45
select deptno, count(deptno), avg(sal)
from emp
group by deptno
order by avg(sal);

-- 문제 46
select deptno, max(sal), min(sal)
from emp
group by deptno;

-- 문제 47
select deptno, count(deptno), count(comm)
from emp
group by deptno;

-- 문제 48
select deptno, avg(sal)
from emp
group by deptno
having avg(sal) > 500;

-- 문제 49
select max(sal), min(sal), deptno
from emp
group by deptno
having max(sal) > 500;

-- 문제 50
select deptno, sum(sal)
from emp
group by deptno
with rollup;

-- 문제 51
select job, deptno, sum(sal)
from emp
group by deptno, job
with rollup;