drop database if exists tabledb;
create database tabledb;
use tabledb;
drop table if exists usertbl;
create table usertbl(
						userid char(8) not null primary key,
                        name varchar(10) not null,
                        birthyear int(11) not null,
                        addr char(2) not null,
                        mobile1 char(3) null,
                        mobile2 char(8) null,
                        height smallint(6) null,
                        mDate date null
					);

-- 위의 테이블을 만들고 PK를 설정해주면 자동적으로 index가 만들어진다.
-- 이부분은 index에서 집중적으로 다룰 것이니, 일단 PK설정 시 index가 만들어진다는 것만 기억하자.
-- 아래 테이블을 만들고 외래키를 설정하는데, 외래키를 설정시는 참조하는 테이블의 컬럼명과 동일한 이름으로 해주고
-- 아울러 데이터타입도 일치되게 설정해주는것이 관례이다. 물론 다르게 설정해도 되지만
-- 쿼리시 상당히 짜증나게 하는 경향도 있다. 헷갈리기 때문.
drop table if exists buytbl;
create table buytbl (
						num int(11) not null auto_increment primary key,
                        userID char(8) not null,
                        prodname char(6) not null,
                        groupname char(4) null,
                        price smallint(6) not null,
                        -- 외래키 추가부분 통상 외래키가 있는 테이블이 자식테이블이 되고,
                        -- PK가 있는 테이블이 부모테이블이 된다.
                        -- 그리고 외래키가 꼭 PK와 연동되는 것은 아니다.
                        -- unique key와도 연동이 된다.
                        -- foreign key(userid) references usertbl(userid)
                        
                        -- 외래키의 이름을 직접 지정해주고 싶다면 아래와 같이 해도 무방하다.
                        constraint FK_usertbl_buytbl foreign key (userid) references usertbl(userid)
					);

-- 만약 위와 다르게 테이블을 만들 당시에 외래키 설정을 안했다면, 아래와 같이 테이블 수정을 통해서도 외래키 제약조건을 추가할 수 있다.
-- (이 방법을 현업에서 가장 많이 쓴다. 왜? 계속 수정되는 부분이 생기기 때문이다.)
alter table buytbl
drop foreign key buytbl_ibfk_1;
    
-- 외래키 추가부분
alter table buytbl
add constraint FK_usertbl_buytbl
foreign key (userid) references usertbl(userid);
    
-- 제약 조건 확인 방법
show index from buytbl;
desc buytbl;

select *
from tabledb.usertbl;

select *
from tabledb.buytbl;

insert into usertbl values( 'KBS', '김범수', 1979, '경남', '011', '22222222', 173, 20120404);
insert into usertbl values( 'KKH', '김경호', 1971, '전남', '019', '33333333', 177, 20070707);
insert into usertbl values( 'LSG', '이승기', 1987, '서울', '011', '11111111', 182, 20080808);
-- 아래 코드를 입력하고 동시에 실행시키면 에러가 난다. 왜일까?
-- 바로 JYP에서 에러가 나는 것을 확인할 수 있다. 그 이유는 JYP를 외래키로 성정했는데 참조하는 테이블,
-- 즉 usertbl에는 아직 JYP라는 놈이 없어서 에러가 뜨는 것이다.
-- 회원도 없는데 어떻게 구매를 할 수가 있나?
-- 방법은 2가지가 있다. 고민해보자.
insert into buytbl values(null, 'KBS', '운동화', null, 30, 2);
insert into buytbl values(null, 'KBS', '노트북', '전자', 1000, 1);
insert into buytbl values(null, 'JYP', '모니터', '전자', 200, 1);
                        