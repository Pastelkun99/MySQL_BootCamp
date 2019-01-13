drop database if exists mydb3;
create database mydb3;
use mydb3;

-- 문제 127
drop table if exists emp03;
create table emp03 (
	empno int,
    ename varchar(20) not null,
    job varchar(20),
    deptno int
    );
    
-- 문제 128
-- alter table emp03 add unique key(empno);

alter table emp03
	add constraint UK_empno
	unique key (empno);
    
desc emp03;

-- 문제 129
insert into emp03 values(1000, '김주화', '사원', 30);
insert into emp03 values(1000, '이길동', '사원', 40);
-- 1. empno를 128번 문항에서 unique키로 설정했으므로, 중복된 값 입력 불가. 따라서 empno에 설정된 unique키 제약 조건 해제
-- 2. 추가하고자 하는 사원의 번호를 바꾼다. 충돌을 피하기 위함.

-- 문제 130
insert into emp03 values(1001, '이길동', '사원', 40);

-- 문제 131
show index from emp03;
alter table emp03 drop index UK_empno;

-- 문제 132
alter table emp03
add column location varchar(13);

alter table emp03
alter column location set default '서울';

select * from emp03;

-- 문제 133
insert into emp03 values(1003, '신은비', '사원', 30, default);
