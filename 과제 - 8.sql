use mydb;

-- 문제 87
select A.ename as '사람', B.ename as '매니저', B.mgr as '사원번호'
from emp A
inner join emp B
on A.mgr = B.empno;

-- 문제 88
select A.ename as '사원', B.deptno as '부서번호', B.dname as '부서명'
from emp A
inner join dept B
on A.deptno = B.deptno
where A.ename = '이문세';

-- 문제 89
drop table if exists dept01;

create table dept01(
	deptno int not null primary key,
    dname varchar(14) not null,
    location varchar(13) not null
    );

-- 문제 90
insert into dept01 values (10, '경리부', '서울'), (20, '인사부', '인천');

-- 문제 91
drop table if exists dept02;

create table dept02(
	deptno int not null ,
    dname varchar(14) not null,
    location varchar(13) not null,
    foreign key (`deptno`) references `dept` (`deptno`)
    );
    
-- 문제 92
insert into dept02 values (10, '경리부', '서울'), (30, '영업부', '용인');
-- 외래키 참조를 받아야하는데 dept01에는 30이 없음. dept테이블에서 불러왔다.

-- 문제 93
select *
from dept01 A
inner join dept02 B
on A.deptno = B.deptno;

-- 문제 94
select *
from dept01 A
left outer join dept02 B
on A.deptno = B.deptno;

-- 문제 95
select *
from dept01 A
right outer join dept02 B
on A.deptno = B.deptno;

-- 문제 96
select B.dname, B.loc, count(A.ename = B.deptno) as '사원수', round(avg(A.sal)) as '급여'
from dept B
inner join emp A
on A.deptno = B.deptno
group by B.deptno;

-- 문제 97
select A.empno, A.ename, A.job,
case
	when A.job = '부장' then A.sal*1.05
    when A.job = '과장' then A.sal*1.10
    when A.job = '대리' then A.sal*1.15
    when A.job = '사원' then A.sal*1.20
else A.sal
end as '급여'
from emp A;