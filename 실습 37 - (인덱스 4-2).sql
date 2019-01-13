-- 실습 37
use indexdb;

-- 현재 emp테이블은 인덱스가 하나도 없다.
-- 그럼 select 문을 실행하면 풀테이블 스캔밖에 할 수 없는 것이다.
-- (execution plan)에서 알 수 있다.
-- 여기서는 약 1000페이지 정도를 읽었는 것으로 나온다.
-- 1000페이지 = 쿼리 실행 후 읽은 페이지수 - 쿼리 실행전 읽은 페이지 수

-- 쿼리 실행 전의 읽은 페이지 수를 알아보는 명령문이다.
show global status like 'innodb_pages_read';
select * from emp where emp_no = 100000;
-- 쿼리 실행 후 읽은 페이지 수를 알아봄
show global status like 'innodb_pages_read';

-- 이제는 클러스터형 인덱스가 존재하는 emp_c테이블의 실행 결과를 보자
-- 선생님 노트북에서는 3페이지 정도를 읽고 출력된 것을 볼 수 있다.
-- 가히 300배 이상 속도 차이가 나는 것이다.
show global status like 'innodb_pages_read';
select * from emp_c where emp_no = 100000;
show global status like 'innodb_pages_read';

-- 이번에는 보조인덱스가 있는 emp_se의 실행결과를 보자.
-- 약 5페이지를 읽었다.
show global status like 'innodb_pages_read';
select * from emp_se where emp_no = 100000;
show global status like 'innodb_pages_read';

-- 이로써 인덱스가 있고 없고에 따라 DB의 성능이 엄청나게 차이가 나는 것을 알 수가 있다.

-- 이제는 범위 검색을 해보자
-- 인덱스가 없는 emp실행하면 역시 풀 테이블 스캔을 하여 약 1000페이지 읽는다.
use indexdb;

show global status like 'innodb_pages_read';
select * from emp where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 클러스터형 인덱스가 있는 emp_c의 실행은 약 17페이지 읽었다.
-- 그림 9-50을 보면 이미 정렬된 상태에서 쿼리를 실행하니 엄청 줄어든 것임을 알 수 있다.
show global status like 'innodb_pages_read';
select * from emp_c where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 하지만, where 절이 없다면 어떨까? where 절이 없으니 풀테이블 스캔을 하여 900페이지 정도 읽는 것을 알 수 있다.
show global status like 'innodb_pages_read';
select * from emp_c limit 1000000;
-- where emp_no <11000;
show global status like 'innodb_pages_read';

-- 보조 인덱스가 있는 emp_se의 실행은 약 877페이지 읽었다.
show global status like 'innodb_pages_read';
select * from emp_se where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 하여 위의 결론은 범위검색에서는 클러스터형 인덱스가 가장 성능적으로 좋다는 것을 알 수가 있다.
-- 하지만 mysql이 알아서 검색해줄 수도 있다.
-- emp_se에는 분명 보조 인덱스가 있다. 하지만 실행 계획을 보면 아래 것은
-- 인덱스를 사용하지 않고 풀테이블 스캔을 했음을 알 수 있다.
-- 하여 이런 보조인덱스에는 있으나 마나 하는 것이니 제거해주는게 좋다.
-- 물리적 공간도 확보에 좋으니 말이다.
-- mysql이 인덱스를 사용할 것인지 풀테이블 스캔을 할 것인지는
-- 해당 테이블의 약 20프로 이상 스캔하는 경우는 인덱스를 사용하지 않는다.
-- 하여 어떤 응용프로그램에서 주로 전체 데이터의 20프로 이상의 범위의
-- 데이터 검색을 한다면 차라리 인덱스가 없는 것이 낫다.
-- 실제 선생님이 튜닝할때 필요없는 인덱스만 제거해도 성능이 향상되는 것을 경험했다고 한다.

show global status like 'innodb_pages_read';
select * from emp_se where emp_no < 400000 limit 500000;
show global status like 'innodb_pages_read';

-- 아래 쿼리는 클러스터형 인덱스를 사용해서 3페이지만 읽고 결과를 출력한다.
show global status like 'innodb_pages_read';
select * from emp_c where emp_no = 100000;
show global status like 'innodb_pages_read';

-- 그러나, 만약 where절의 조건 컬럼에다가 연산을 하면 어떻게 될까?
-- 해보니 풀테이블 스캔을 하여 900 여 페이지를 읽는 것을 볼 수가 있다.
-- 결론은 조건절에서 필드에 연산이 들어가면 인덱스를 사용하지 아니한다는 것이다.
show global status like 'innodb_pages_read';
select * from emp_c where emp_no*1 = 100000;
show global status like 'innodb_pages_read';

-- 하지만 컬럼명이 아닌 대입연산자를 기준으로 하여 오른쪽 오퍼랜드의 연산은 전혀 영향을 끼치지 않는다.
-- 꼭 기억할 것은 컬럼명에는 연산을 하지 않도록 하자.
show global status like 'innodb_pages_read';
select * from emp_c where emp_no = 100000/1;
show global status like 'innodb_pages_read';

-- 이제는 데이터의 중복도를 살펴보자.
select * from emp;

-- emp를 조회해보니 gender 컬럼은 M, F로 2개밖에 형식이 없고
-- 아울러 30만건에서 둘 중에 하나이니깐 중복도가 엄청난 것이다.
-- 이 gender를 인덱스를 추가해보자.

alter table emp
	add index idx_gender (gender);
    
alter table emp
	add primary key pk_emp_empno (emp_no);
    
-- 테이블에 적용 시킴
analyze table emp;

-- idx_gender가 추가된 것을 볼 수가 있다.
-- 여기서 유심히 살펴볼 항목은 바로 cardinality이다. 이 카디널리티는
-- 관계대수를 의미하는 것이다. 즉, 다시말해 테이블간의 릴레이션을 구성하는 행(row)의 수를 말한다.
-- 수학에서는 집합을 구성하는 원소들의 개수를 말한다.
-- 하여, 1:1관계대수 다라고 함은 두 집합의 원소가 같다는 것을 의미한다
-- 1:N은 1행에 N개의 행이 연결되는 것이다.
-- 하여, Cardinality가 낮을 수록 데이터 중복도가 엄청 높다는 것이고, 높을수록 데이터 중복도가 낮다는 것이다.

-- 확인해보니 emp_no컬럼은 엄청 높다는 것을 알 수 있고 gender는 1로써 엄청 낮다는 것을 알 수 있다.

alter table emp drop primary key;

show index from emp;

-- 자 이제 데이터 중복도가 굉장히 높은 gender를 가지고 한 번 조회를 해보자.
-- 확인해보니 실행계획을 보면 인덱스를 사용한 것을 알 수가 있는데 약 18만건을 조회한 것을 알 수 있다.
select * from emp where gender = 'M' limit 500000;

-- 이제는 인덱스를 사용하지 않고 위와 동일하게 조회를 해보자.
-- 해보니 조회건수는 비슷하나 걸리는 시간이 차이가 난다.
-- 왜냐? 인덱스를 사용하면 루트페이지에서 데이터페이지로 왔다갔다 하는 시간이 더 소요가 되니
-- 시간이 더 걸릴 수 밖에 없다.
-- 이럴 때는 그냥 인덱스를 사용하지 않는 것이 훨씬 낫다.
select * from emp 
ignore index(idx_gender) -- 인덱스를 사용하지 않겠다고 명시적으로 알리는 코드
where gender = 'M'
limit 500000;

-- 결론
-- 1. 인덱스는 열(컬럼) 단위에 생성해야 한다.
-- 2. 인덱스는 where절에서 자주 사용되는 열에 만들어야 효율성이 높다.
-- 3. 데이터의 중복도가 높은 열은 인덱스를 만들어도 효과가 없다.
-- 4. 외래 키 지정한 열의 경우는 자동 인덱스 생성된다.
-- 5. JOIN에 자주 사용되는 열의 경우는 인덱스를 생성해주자.
-- 6. 인덱스는 단지 읽기에서만 성능 향상되므로, 얼마나 데이터의 변경이 자주 일어나는지를 고민해봐야 한다.
-- 7. 클러스터형 인덱스는 테이블당 하나만 생성 가능하다.
-- 8. 사용하지 않는 인덱스는 과김히 제거하자.
-- (저장공간 확보 및 데이터 입력시 부하를 줄여준다.)