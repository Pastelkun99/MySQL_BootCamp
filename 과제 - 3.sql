drop table if exists emp;

select *
from dept;

-- 문제 15
create table emp (
	EMPNO 		int not null primary key,
    ENAME 		varchar(20) not null,
    JOB 		varchar(8) not null,
    MGR 		varchar(10) not null,
    HIREDATE 	date not null,
    SAL 		int not null,
    COMM 		int,
    DEPTNO		int not null,
    foreign key(deptno) references dept(DEPTNO)
    );

-- 문제 16
insert into emp values (1001, '김사랑', '사원', 1013, '2007-03-01', 300, null, 20);
insert into emp values (1002, '한예슬', '대리', 1005, '2008-10-01', 250, 80, 30);
insert into emp values (1003, '오지호', '과장', 1005, '2005-02-10', 500, 100, 30);
insert into emp values (1004, '이병헌', '부장', 1008, '2003-09-02', 600, null, 20);
insert into emp values (1005, '신동협', '과장', 1005, '2010-02-09', 450, 200, 30);
insert into emp values (1006, '장동건', '부장', 1008, '2003-10-09', 480, null, 30);
insert into emp values (1007, '이문세', '부장', 1008, '2004-01-08', 520, null, 10);
insert into emp values (1008, '감우성', '차장', 1003, '2004-03-08', 500, 0, 30);
alter table emp modify mgr varchar(10);
insert into emp values (1009, '안성기', '사장', null, '1996-10-04', 1000, null, 20);
insert into emp values (1010, '이병헌', '과장', 1003, '2005-04-07', 500, null, 10);
insert into emp values (1011, '조향기', '사원', 1007, '2007-03-01', 280, null, 30);
insert into emp values (1012, '강혜정', '사원', 1006, '2007-08-09', 300, null, 20);
insert into emp values (1013, '박중훈', '부장', 1003, '2002-10-09', 560, null, 20);
insert into emp values (1014, '조인성', '사원', 1016, '2007-11-09', 250, null, 10);

select *
from emp;

-- 문제 17
create table salgrade (
	GRADE		int auto_increment not null primary key,
    LOSAL		int not null,
    HISAL		int not null
    );
 
-- 문제 18
insert into salgrade values(null, 700, 1200);
insert into salgrade values(null, 1200, 1400);
insert into salgrade values(null, 1700, 2000);
insert into salgrade values(null, 2000, 3000);
insert into salgrade values(null, 3000, 9999);

-- 문제 19
select empno, hiredate, sal
from emp
where deptno = any(select deptno from dept);

-- 문제 20
select deptno as '부서번호', dname as '부서명' from dept;

-- 문제 21
select *
from emp;
select distinct job from emp;

-- 문제 22
select empno, ename, sal 
from emp 
where sal <= 300;

-- 문제 23
select empno, ename, sal 
from emp 
where ename like '오지호';

-- 문제 24
select empno, ename, sal 
from emp 
where sal in(250, 300, 500);

select empno, ename, sal 
from emp 
where sal = 250 or sal = 300 or sal = 500;

-- 문제 25
select empno, ename, sal 
from emp 
where sal not in (250, 300, 500);

select empno, ename, sal 
from emp 
where not sal = 250 and not sal = 300 and not sal = 500;

-- 문제 26
select empno, ename 
from emp 
where ename like '김%' or ename like '%기%';

-- 문제 27
select *
from emp 
where job = '사장';

-- 문제 28
select *
from emp 
where sal > 500 and deptno = any(select deptno from dept);

-- 문제 29
create table emp_copy select * from emp;

select *
from emp_copy;

select *
from emp;

-- 문제 30
select ename, sal, job
from emp_copy
where sal > (select min(sal) from emp_copy where job = '과장') and job != '과장';

-- 문제 31
update emp_copy
set sal = sal + 100
where deptno = (select deptno from dept where loc = '인천');

-- 문제 32i
delete from emp_copy
where deptno = (select deptno from dept where dname = '경리부');

select *
from emp_copy;

-- 문제 33
select *
from emp
where job = (select job from emp where ename = '이문세')
and ename not in('이문세');

-- 문제 34
select *
from emp
where sal >= (select sal from emp where ename = '이문세');

-- 문제 35
select ename, deptno
from emp
where deptno = (select deptno from dept where loc = '인천');


