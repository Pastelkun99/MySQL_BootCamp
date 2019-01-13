-- 문제 36
select ename, sal, deptno
from emp
where deptno in (select distinct deptno from emp where sal > 500);


-- 문제 37
select ename, sal
from emp
where sal > (select max(sal) from emp where deptno = 30);


-- 문제 38
select ename, sal
from emp
where sal > (select min(sal) from emp where deptno = 30);