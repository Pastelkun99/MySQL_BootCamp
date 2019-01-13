use mydb2;

-- 문제 134
create table emp_copy (select empno, ename, deptno from mydb.emp);

select *
from emp_copy;

-- 문제 135
create or replace view emp_view30
as
	select empno, ename, deptno
    from emp_copy
    where deptno = 30;

drop view emp_view30;

select * from emp_view30;

-- 문제 136
insert into emp_view30 values(1111, 'aaaa', 30);

select *
from emp_view30;

-- 문제 137
create or replace view emp_view_dept
as
	select E.empno, E.ename, E.deptno, D.dname, D.loc
    from emp_copy E
    inner join mydb.dept D
    on E.deptno = D.deptno;
    
select * from emp_view_dept;

-- 문제 138
create or replace view emp_view
as
	select empno, ename, job, mgr, hiredate, deptno
    from mydb.emp;
    
select * from emp_view;

-- 문제 139
alter view emp_view30
as
	select empno, ename, deptno, sal, comm
    from mydb.emp;
    
select * from emp_view30;

-- 문제 140
update emp_view30 
set deptno = 20
where sal >= 600;

select * from emp_view30;

-- 문제 141
create or replace view sal_max_min_view
as
	select deptno, min(sal) as '최소 급여', max(sal) as '최대 급여'
    from mydb.emp 
    group by deptno
    order by deptno;
    
select * from sal_max_min_view;

-- 문제 142
drop view emp_view30;
drop view emp_view_dept;
drop view sal_max_min_view;
drop view emp_view;

    