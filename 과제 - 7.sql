use mydb;

-- 문제 75

drop table if exists pivot;

create table pivot(
	class char(2) not null,
    subject char(5) not null,
    jumsu int not null
    );
    
-- 문제 76

insert into pivot values 
	('1반', '국어', 95), ('1반', '수학', 80), ('1반', '영어', 77), ('1반', '과학', 95), ('1반', '사회', 87),
    ('2반', '국어', 56), ('2반', '수학', 88), ('2반', '영어', 69), ('2반', '과학', 100), ('2반', '수학', 99),
    ('1반', '국어', 88), ('1반', '수학', 97), ('1반', '영어', 66), ('1반', '과학', 78), ('1반', '사회', 80),
    ('2반', '국어', 100), ('2반', '수학', 99), ('2반', '영어', 66), ('2반', '과학', 88), ('2반', '수학', 97);
    
-- 문제 77

select class,
sum(if(subject = '국어', jumsu, 0))as '국어',
sum(if(subject = '수학', jumsu, 0))as '수학',
sum(if(subject = '영어', jumsu, 0))as '영어',
sum(if(subject = '과학', jumsu, 0))as '과학',
sum(if(subject = '사회', jumsu, 0))as '사회'
from pivot
group by class;

-- 문제 78
select E.deptno, D.dname, E.ename, E.hiredate
from dept as D
inner join emp as E
on D.deptno = E.deptno
where E.deptno = 10
order by E.ename;

-- 문제 79
select E.job as '직급', E.ename as '이름', D.dname as '부서'
from dept as D
inner join emp as E
on D.deptno = E.deptno
where job = '과장';

-- 문제 80
select E.ename as '이름', D.dname as '부서명'
from dept as D
inner join emp as E
on D.deptno = E.deptno;

-- 문제 81
select E.ename, E.sal
from dept as D
inner join emp as E
on D.deptno = E.deptno
where E.deptno = (select deptno from dept where loc = '인천');

-- 문제 82
drop table if exists member;

create table member(
	id int not null,
    name varchar(20) not null,
    tel varchar(13) not null,
    address varchar(50) not null
    );
    
-- 문제 83
insert into member values
	(1, '김우성', '010-6298-0394', '송파구 잠실 2동'), (2, '김태희', '010-9596-2048', '강동구 명일동'),
    (3, '하지원', '010-0859-3948', '강동구 천호동'), (4, '유재석', '010-3045-3049', '강남구 서초동');
    
-- 문제 84
drop table if exists worker;

create table worker (
	number int not null,
    irum varchar(20) not null,
    hp varchar(13) not null,
    location varchar(50) not null
    );
    
-- 문제 85
insert into worker values
(2, '김태희', '010-9596-2048', '강동구 명일동'), (3, '하지원', '010-0859-3948', '강동구 천호동'),
(4, '유재석', '010-3045-3049', '강남구 서초동'), (5, '강호동', '010-2049-5069', '송파구 석촌동'),
(10, '안성기', '010-3050-3049', '강남구 압구정동');

-- 문제 86
select *
from member as M
UNION ALL
select *
from worker as W;


-- 문제 87
select *
from member as M
UNION
select *
from worker as W;
