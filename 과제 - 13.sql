use mydb;

-- 문제 143
drop table if exists emp_index;
create table emp_index ( select * from emp);

select * from emp_index;

-- 문제 144
show index from emp_index;

-- 문제 145
alter table emp_index
add constraint PK_emp_index_pk primary key(empno);

show index from emp_index;

-- 문제 146
delete from emp_index
where empno = 1010;

alter table emp_index
add constraint UK_emp_index_name unique key(ename);

show index from emp_index;


-- 문제 147
show table status like 'emp_index';

analyze table emp_index;

show table status like 'emp_index';

-- 문제 148
alter table emp_index
add constraint UK_emp_index_job unique key(job);

-- emp_index의 job 열에는 중복된 값이 있다. unique키는 중복을 허용하지 않는다. null만 중복 가능

-- 문제 149
drop index UK_emp_index_name on emp_index;
alter table emp_index drop primary key;

show index from emp_index;

-- 문제 150
-- 1. 인덱스는 열 단위에 생성
-- 2. where 절에 사용되는 열에 인덱스 생성 (자주 사용해야 가치가 있다.)
-- 3. join에 자주 사용되는 열에 인덱스 생성
-- 4. 데이터의 변경이 잦은 곳에서는 인덱스를 만들지 말자.
-- 5. 사용하지 않는 인덱스는 과감히 삭제