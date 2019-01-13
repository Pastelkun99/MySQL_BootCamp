-- 테이블을 압축하여 사용할 수 있는가를 확인하는 시스템 변수들이다.
-- innodb_file_format의 값이 'Barracuda'이고 innodb_large-prefix가 'ON'이 되어 있으면
-- 압축하여 사용 가능하다.

show variables like 'innodb_file_format';
show variables like 'innodb_large_prefix';

-- db 생성
drop database if exists compressdb;
create database compressdb;

use compressdb;

-- 테이블 생성
drop table if exists normaltbl;
create table normaltbl (emp_no int, first_name varchar(14));

-- 테이블 생성하는데 row_format=compressed를 설정하여, 이 테이블은 앞으로 물리적으로
-- 데이터를 압축하여 쓰겠다는 의미이다.

drop table if exists compresstbl;
create table compresstbl (emp_no int, first_name varchar(14))
						 row_format = compressed; -- 압축하여 쓰겠다는 키워드

select *
from employees.employees;

-- employees.employees 테이블에는 30만건 이상의 데이터가 들어있다.
-- 비교를 해보자. 삽입에 걸리는 시간을
-- PC마다 차이는 있겠지만 통상 normaltbl보다 compresstbl의 시간이 더 걸린다.
-- 이유는 데이터를 넣을때마다, 압축하고 있기 때문인 것이다.

insert into normaltbl (select emp_no, first_name from employees.employees);
insert into compresstbl (select emp_no, first_name from employees.employees);

-- compresstbl에 있는 테이블의 상태를 살펴보는 코드이다.
-- 확인해보면 확실히 compresstbl이 normal보다 압축이 되어서 data_length가 45%정도
-- 물리적 공간을 절약하고 있는 것을 볼 수가 있다.
-- 하지만, 압축 테이블은 기존테이블에 비해서 성능은 좀 떨어진다.
-- 서버의 공간을 절약하고 싶을때 실수가 있겠다.(돈없는 회사 등)

show table status from compressdb;