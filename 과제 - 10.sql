drop database if exists mydb2;
create database mydb2;
use mydb2;


-- 문제 111
drop table if exists employee;
create table employee (
						emp_no int not null,
                        emp_name varchar(20) not null,
                        salary int not null,
                        birthday date not null
					  );

drop table if exists project;
create table project (
						pro_no int not null,
						pro_content varchar(20) not null,
						start_date date not null,
						finish_date date not null
					);

drop table if exists speciality;
create table speciality( 
						emp_no int not null,
                        speciality varchar(20) not null
                        );
                        
drop table if exists assign;
create table assign(
					emp_no int not null,
                    pro_no int not null
                    );
                            

-- 문제 112
alter table employee add constraint employee_PK primary key(emp_no);
show index from employee;

-- 문제 113
alter table project add constraint project_PK primary key(pro_no);
show index from project;

-- 문제 114
alter table speciality add constraint speciality_PK primary key(emp_no, speciality);
show index from speciality;

-- 문제 115
alter table assign add constraint assign_PK primary key(emp_no, pro_no);
show index from assign;

-- 문제 116
alter table speciality
	add constraint speciality_FK
	foreign key (emp_no) references employee(emp_no);

-- 문제 117
alter table assign
	add constraint assining_project_FK
	foreign key (pro_no) references project(pro_no);
    
-- 문제 118
alter table assign
	add constraint assining_employee_FK
	foreign key (emp_no) references employee(emp_no);
    
-- 문제 119
drop table if exists dept01;
create table dept01 (
						deptno int not null primary key,
                        dname varchar(14) not null,
                        loc varchar(13) not null
					);

insert into dept01 values(10, '경리부', '서울');
insert into dept01 values(20, '인사부', '인천');

-- 문제 120
drop table if exists emp01;
create table emp01 (
					empno int not null primary key,
                    ename varchar(10) not null,
                    job varchar(13) not null unique key,
                    deptno int
                    );
                    
alter table emp01 add constraint emp_FK foreign key (deptno) references dept01(deptno);
                    
insert into emp01 values(1000, '허준', '사원', 10);
insert into emp01 values(1010, '홍길동', '사원', 50);
-- 해결법 : 부모테이블인 dept01에 deptno 값 50이 없기 때문에, 사원 중 한명의 deptno를 10 또는 20으로 바꾼다.
-- 해결법 : job을 유니크 제한을 해제하는것

-- 문제 121
drop index job on emp01;
insert into emp01 values(1010, '홍길동', '사원', 10);

-- 문제 122
insert into dept01 values(50, '청소부', '본사');
insert into emp01 values(1010, '홍길동', '청소부아저씨', 50);

-- 문제 123
-- 에러 이유 : 외래키가 있는 테이블은 일반적인 drop문으로 삭제가 불가능하다.
-- 해결법 1 : foreign key 삭제 후 테이블 드랍.
-- 해결법 2 : set foreign_key_checks = 0; 이후 삭제

-- 문제 125
alter table emp01 drop foreign key emp_FK;
drop table dept01;

-- 문제 126
set foreign_key_checks = 0;
drop table dept01;
set foreign_key_checks = 1;


                    
