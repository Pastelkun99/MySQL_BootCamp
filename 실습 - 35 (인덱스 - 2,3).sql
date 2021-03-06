-- 실습-32(인덱스-2,3)
-- testdb를 하나 만들고, mixedtbl도 만들고, 데이터를 10건 삽입해보자
create database if not exists testdb;

use testdb;

drop table if exists mixedtbl;
create table mixedtbl (
   userid char(8) not null,
   name varchar(10) not null,
    addr char(2)
);
insert into mixedtbl values ('LSH','이승기','서울');
insert into mixedtbl values ('KBS','김범수','경남');
insert into mixedtbl values ('KKH','김경호','전남');
insert into mixedtbl values ('JYP','조용필','경기');
insert into mixedtbl values ('SSK','성시경','서울');
insert into mixedtbl values ('LJB','임재범','서울');
insert into mixedtbl values ('YJS','윤종신','경남');
insert into mixedtbl values ('EJW','은지원','경북');
insert into mixedtbl values ('JKW','조관우','경기');
insert into mixedtbl values ('BBK','바비킴','서울');

-- 자 위의 mixedtbl테이블은 PK나 UNIQUE제약조건등이 하나도 없다.
-- select를 하면 우리가 입력한 순서대로 출력해준다. 즉 인덱스가 없다는 것이다.
select *
from mixedtbl;
-- mixedtbl에 userid를 PX_mixedtbl_pk란 명으로 PK를 추가해보자.
-- 그럼 어떻게 되는가 ? 바로 userid가 PK가 됨과 동시에 클러스터형 인덱스가 생성되는것이다.
alter table mixedtbl
   add constraint PK_mixedtbl_pk primary key(userid);
-- 확인해보면 역시 확인할 수 있다.
show index from mixedtbl;
-- 위에서 조회한것과는 다르다. 즉 PK컬럼으로 오름차순 정렬이 되어있는 것을 확인할 수 있다.
-- 이렇게 된것은 클러스터형 인덱스가 만들어진 것을 의미한다. 즉 영어사전을 만든것이다.
select *
   from mixedtbl;
-- 자 이번에는 name에다가 unuque제약 조건을 걸어보자.
alter table mixedtbl
   add constraint UK_mixedtbl_name unique(name);
   
-- 확인해보면 역시 확인할 수 있다.
show index from mixedtbl;

-- 자 한 테이블에 클러스터형 인덱스와 보조인덱스가 각각 생성되었다.
-- 그럼 내부적으로 구성되는 것은 책 337페이지의 그림의 형태로 구성이 된다.
-- 의문점이 들지 않는가? 김경호의 주소를 찾기 위해서는 4개의 페이지를 읽어야 된다.
-- 하지만 보조인덱스에서 리프페이지에서는 그 주소를 가지고 있으면 3페이지만 읽어서
-- 속도가 향상될 것인데 말이다. 맞는 말이다. 하지만, 데이터가 삽입이 되었다고
-- 가정해보자. 데이터가 만약 삽입이 되었거나 아니면 삭제가 되었다면 그러한 명령이 수행
-- 되면 보조인덱스의 리프페이지의 주소는 매번 바뀌게 될 것이다. 아울러 클러스터형 인덱스의
-- 데이터 페이지 분할이 일어나던지 줄어지던지 할 것이다. 이러한 작업은
-- DBMS에게 상당히 부하를 많이 주게 된다.

select *
  from mixedtbl;

-- 먼저 sqldb를 초기화 시키자.
use sqldb;

select *
from usertbl;

-- 인덱스가 있는지 확인
show index from usertbl;

-- 앞에서도 했지만, usertbl의 상태를 보는 것이다. data_length가 클러스터형 인덱스의 크기이다.
-- index_length는 보조인덱스의 크기를 나타내는 것이다.지금은 없다.
show table status like 'usertbl';

-- 인덱스를 생성해보았다. addr컬럼을 보조인덱스로 생성한 것이다.
create index idx_usertbl_addr
   on usertbl(addr);
    
-- 근데 확인해봐도 index_length가 0이다. 아직 테이블에 적용이 되지 않은 것이다.
show table status like 'usertbl';

-- 테이블에 적용시켜보자.
analyze table usertbl;

-- 테이블에 적용시키고 확인 해보니 index_length가 역시 16키로바이트로 잡힌것을 확인할 수 있다.
show table status like 'usertbl';

-- birth_year컬럼에다가 unique index를 만들어주고 실행해보니 에러가 난다.
-- 왜일까? unique제약조건이 무엇인가? 중복을 허용 하지 않는다는 것이다.
-- 즉,birth_year컬럼에 무언가 중복이 되었다는 것이다. 확인해보자
create unique index idx_usertbl_birthyear
   on usertbl(birthyear);
    
-- 확인해보니 성시경과 김범수가 1979로 중복이 되어있다. 하여 uninstall unique가 적용이 되질 않는 것이다.
select *
   from usertbl;
    
-- name컬럼열을 가지고 unique인덱스를 만들어보자. 중복되는것이 없으니
-- 잘만들어진 것을 확인할수 있다.
create unique index idx_usertbl_name
   on usertbl(name);
    
-- 위에서 만든 인덱스들을 살펴보자. name이 unique라서 데이터 중복 불가이고,
-- addr은 중복을 허가함을 알수 있다.
show index from usertbl;

-- 아래의 데이터를 삽입해보자. 근데 에러가 발생한다.
-- 왜? name을 unique로 index를 만들지 않았던가?
-- 중복을 허용 안하니 에러가 나는 것이다. 근데 이건 좀 잘못된 내용이다.
-- 동명이인도 있는데 이러한 uniqueindex를 name컬럼에다가 잡아버리면,
-- 김범수란 한사람만 유독 저장되게 만든다면 상당히 현실에 맞지 않다.
-- 하여 인덱스를 어느 컬럼에 설정할 지는 정말 고민도 많이 해야되고
-- 아울러 정말 unique한 것(주민번호, 학번, 전화번호 앞자리등)으로 잡아주는게 가장 현명하다.
insert into usertbl values('GPS','김범수',1983,'미국',null,null,162,null);

-- 그래서 위에 인덱스는 제거를 하도록 하자
drop index idx_usertbl_name on usertbl;

show index from usertbl;

-- 이번에는 2개의 컬럼을 이용해서 보조 인덱스를 만들어 보았다.
create index idx_usertbl_name_birth_year
   on usertbl (name,birthyear);
    
-- 확인해보면 2개의 컬럼으로 만든 인덱스는 각각 sequence가 1,2로 구분되어져서 잘 만들어져있다.
show index from usertbl;

-- 아래와 같이 쿼리를 하게 되면 위에 만든 인덱스가 필히 사용되었을 것이다.
-- 인덱스를 만든다고 하여 데이터에 영향을 끼치는 것은 전혀 없다.
-- 다만 속도가 빨라진다는 것이다. 확인해보자 아래쿼리가 인덱스를 사용했는지를
-- execution plan을 보면 역시 idx_usertbl_name_birth_year를 사용한것을 볼수가 잇다.
-- 물론 지금이야 데이터가 몇건 안되니 느끼지 못하지만 대용량데이터베이스에서는
-- 엄청난 효과를 볼수가 있는 것을 자명하다.

select *
   from usertbl
    where name = '윤종신'
    and birthyear = '1969';
    
select * from usertbl where userid = 'YJS';

-- 국번을 가지고 보조인덱스를 만들었다.
create index idx_usertbl_mobile1
   on usertbl(mobile1);
    
-- 역시 위에 만들어진 인덱스가 사용되었다.
-- 하지만 인덱스로 설정한 컬럼의 데이터가 국한되어 있따면 이건 별로 효율적이지 못하다.
-- 왜냐 계속 인덱스 갔다가 페이지 갔다가 하기 때문에 그런것이다.
-- 그래서 대용량 데이터베이스에 해당 컬럼의 값이 다양한 것에다가 인덱스를 설정하는 것이
-- 권장하는 사항이다.

select *
   from usertbl
where mobile1 = '011';

show index from usertbl;
-- 이제는 인덱스를 제거해보자
-- 인덱스를 제거할때도 항상 보조인덱스부터 제거를 해야한다.
-- 클러스터형 인덱스를 먼저 제거해버리면 보조인덱스에서 주소를 지정하는 작업을 DB에서
-- 진행한다. 상당히 부담이 된다.
-- 하여 인덱스 제거 방법은 보조인덱스 제거 ->클러스터형 인덱스 제거
-- 이런 순서로 한다.
drop index idx_usertbl_addr on usertbl;
drop index idx_usertbl_name_birth_year on usertbl;
drop index idx_usertbl_mobile1 on usertbl;

-- 이제 클러스터형 인덱스를 제거해보자.
-- 클러스터형 인덱스는 drop으로 하면 안되는 것을 알고 있다.
-- alter table을 이용해야 한다.

-- 자 근데 에러가 난다. 코드를 보면 외래키가 이 기본키를 참조하고 있다는 것이다.
-- 하여 기본키를 지우기 전에 외래키부터 지우고 기본키를 지우도록 한다.
alter table usertbl
drop primary key;

show table status like 'buytbl';
desc buytbl;

-- 외래키의 이름을 알아내는 방법을 시스템 DB를 이용해서 알아낼 수 있다.
-- 외래키의 이름을 모를 때 아래와 같이 쓰고 알면 그냥 제거해도 무방하다.
select table_name, constraint_name
from information_schema.referential_constraints
where constraint_schema = 'sqldb';

-- 외래키 제거
alter table buytbl
drop foreign key buytbl_ibfk_1;

-- 기본키 제거
alter table usertbl
drop primary key;