#IndexTBL을 만든다. 쿼리문을 직접 입력하여 만들어본다.
create table indexTBL(first_name varchar(14), last_name varchar(16), hire_date date);

#employees데이터베이스에 있는 employees테이블의 데이터를 가져와라.
select *
from employees.employees;
#다른 스키마에서 긁어오려면 db명.테이블명으로 긁어온다.

#employees 데이터베이스에 있는 employees테이블의 first_name, last_name, hire_date
#데이터 중 500개만 가져와서 indexTBL테이블에 삽입하라.

insert into indexTBL
	select first_name, last_name, hire_date
	from employees.employees
	limit 500;

select *
from indexTBL;

#indexTBL테이블에서 전체 데이터를 다 뒤져서 first_name이 Mary인것만 가져와라.
#상당히 비효율적인 코드이다. 예를 들어 100만건 이상이다? 엄청 오래 걸릴 것이다.
#이래서 indext(색인)을 사용한다.
select *
from indexTBL
where first_name = 'Mary';

#아래코드가 책 뒤에 색인을 만들어주는 형태이다.
#색인을 만들고 위의 쿼리문을 실행해주면 속도 자체가 틀리다.
#실무에서 상당히 많이 사용된다.
create index idx_indexTBL_firstname ON indexTBL(first_name);

show index from indexTBL;