create database mydb;

use mydb;

create table DEPT(
	DEPTNO int not null,
    DNAME varchar(14) not null, 
    LOC varchar(30),
    primary key(deptno)
    );
    
    -- drop table DEPT;
    
    insert into DEPT values(10, '경리부', '서울');
    insert into DEPT values(20, '인사부', '인천');
    insert into DEPT values(30, '영업부', '용인');
    insert into DEPT values(40, '전산부', '수원');
    
    select *
    from DEPT;
    
create table EMP(
	deptNo int not null,
    deptName char(10) not null,
    job char(5) not null,
    sal int not null,
    primary key(deptNo)
    );
    
    insert into EMP values(10, '인사팀', '사원', 250);
    insert into EMP values(20, '재무팀', '대리', 300);
    insert into EMP values(30, '법무팀', '과장', 350);
    insert into EMP values(40, '영업팀', '사원', 250);
    insert into EMP values(50, '설계팀', '부장', 500);
    
    select *
    from EMP;
    
    update EMP set sal = 180 
    where job = '사원';
    
    delete from EMP where deptName = '법무팀';
    