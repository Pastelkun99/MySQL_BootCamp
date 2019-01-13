-- 예전에 만들었던 sqldb초기화 코드를 가져와서 확인해보자.
-- usertbl을 새로 만들어서 조회까지 해보자.

alter table buytbl
drop foreign key buytbl_ibfk_1;

use sqldb;

-- 자 조회를 하면 order by를 주지도 않았는데도 불구하고 삽입할 때와 다르게 userid가 알파벳순으로
-- 정렬이 되었다. 즉 클러스터 인덱스인 것이다. 영어사전의 단어 역할을 하는 것이다.
-- 즉 다시말해 테이블에 PK를 주면 그것이 클러스터형 인덱스가 되어서 정렬이 되어진다는 것이다.

select *
from usertbl;

use sqldb;

-- 테이블을 하나 만들어보자.
drop table if exists tbl1;
create table tbl1 (
	a int primary key,
    b int,
    c int
    );

-- tbl1의 인덱스를 살펴보는 명령이다
-- 보면 non_unique로 거꾸로 되어 있다. 0이라면 unique라는 것이다.
-- 또한, key_name이 primary로 되어있다면, 클러스터형 인덱스라고 생각하면 된다.
-- primary가 아니라면, 보조인덱스라고 생각하면 된다. 아울러, 그 필드가 a라는 것을 나타낸다.
show index from tbl1;

drop table if exists tbl2;
create table tbl2 (
	a int primary key,	-- 무조건 중복 불가
    b int unique,		-- unique제약 조건은 중복불가이지만 null은 허용, 이 중복도 허용함
    c int unique
    );
    
-- tbl2에서 보면 a는 primary key로 클러스터형 인덱스이고, b와 c는 unique제약조건으로
-- 보조인덱스가 되는 것이다.
show index from tbl2;

drop table if exists tbl3;
create table tbl3 (
	a int unique,
    b int unique,
    c int unique
);

-- 확인해보니 보조 인덱스로만 구성되어진 테이블이다.
-- 하여 클러스터형 인덱스가 필수인 것은 아니란 것을 알 수가 있다.
show index from tbl3;

drop table if exists tbl4;
create table tbl4 (
	-- unique 제약조건인데 not null을 붙였다. 그렇게 되면 클러스터형 인덱스가 되는 것이다.
    a int unique not null,
    b int unique,
    c int unique,
    d int
);

-- 확인해보면 a필드에 null값을 허용하지 아니한다라고 나온다.
-- 그럼 클러스터형 인덱스가 되는 것이다.
-- 정리를 하자면, 클러스터형 인덱스는 2가지가 될 수 있다.
-- 첫 번째 PK이거나, 아님 UNIQUE이면서 NOT NULL일때 클러스터형 인덱스가 된다.

show index from tbl4;
-- 데이터를 삽입해보고 조회를 해보자.
-- 분명 3부터 삽입을 했음에도 불구하고 a필드가 클러스터형 인덱스라 정렬이 되어진 것을 확인 가능하다.
insert into tbl4 values(3, 3, 3, 3);
insert into tbl4 values(2, 2, 2, 2);
insert into tbl4 values(1, 1, 1, 1);

select * from tbl4;

-- 만약에 테이블에 PK와 UNIQUE NOT NULL이 같이 있으면 어떻게 되나?
-- 결과론적으로 얘기하면 PK가 클러스터형 인덱스가 되고, UNIQUE NOT NULL은 보조인덱스가 된다.

drop table if exists tbl5;
create table tbl5 (
	-- PK가 없다면 당연 클러스터형 인덱스가 되지만, 여기서는 보조 인덱스가 된다.
    -- (이유는 d필드가 PK이기 때문)
    a int unique not null,
    b int unique,
    c int unique,
    d int primary key 	-- 항상 PK가 클러스터형 인덱스가 된다는 것을 명심하자.
);

show index from tbl5;
-- 하여, 위의 usertbl은 클러스터형 인덱스인 userid(PK)를 기준으로
-- 영어사전처럼 정렬이 되는 것이다.
-- 이제는 usertbl의 PK를 userid가 아니라 name으로 다시 수정해보고 조회를 해보자.
alter table usertbl
drop primary key;

-- name을 기본키로 설정하였다.
alter table usertbl
add constraint pk_name primary key(name);

-- 조회를 해보면 name의 가나다.. 순으로 자동정렬이 되는 것을 볼 수가 있다.
-- name의 영어사전의 단어인 것이다.
-- 그러나 이런 작업은 현업에서는 절대 하면 안된다. 미친 짓이다.
-- PK를 드랍하는 것은 상상할 수도 없는 일이다.
-- 배우는 과정이기에 보여주는 것.
select *
from usertbl;
