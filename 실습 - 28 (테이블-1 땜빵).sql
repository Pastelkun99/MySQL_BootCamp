drop database if exists tabledb;
create database tabledb;
use tabledb;
drop table if exists usertbl;
create table usertbl (
                  userid char(8) not null primary key,
                        name varchar(10) not null,
                        birthYear int(11) not null,
                        addr char(2) not null,
                        mobile1 char(3) null,
                        mobile2 char(8) null,
                        height smallint(8) NULL,
                        mDate date null
                );
-- 위의 테이블을 만들고 PK를 설정을 해주면 자동적으로 index가 만들어진다.
-- 이부분은 index에서 집중적으로 다룰 것이니, 일단 PK설정시 index가 만들어진다는
-- 것만 기억하도록 하자.
-- 아래 테이블을 만들고 외래키를 설정하는데, 외래키를 설정시는 참조하는 테이블의 컬럼명과 동일한
-- 이름으로 해주고 아울러 데이터타입도 일치되게 설정해주는것이 관례이다. 물론 다르게 설정해도
-- 되지만 쿼리시 상당히 짜증나게 하는 경향도 있다. 왜냐 헷갈리니깐!
drop table if exists buytbl;
CREATE table buytbl (
						num int(11) not null AUTO_INCREMENT primary key,   -- 자동증가 부분
                        userID char(8) not null,
                        prodName char(6) not null,
                        groupName char(4) null,
                        price int(11) not null,
                        amount smallint(6) not null,
                        -- 외래키 추가부분 통상 외래키가 있는 테이블이 자식테이블이 되고
                        -- PK가 있는 테이블이 부모테이블이 된다.
                        -- 그리고 외래키가 꼭 PK와 연동되는 것은 아니다.
                        -- unique key와도 연동이 된다.
                        -- foreign key (userid) references usertbl(userid),
                        
                        -- 외래키의 이름을 직접 지정해주고 싶다면 아래와 같이 해도 무방하다.
                        constraint FK_usertbl_buytbl foreign key (userid) references usertbl(userid)
                );
-- 만약 위와 다르게 테이블을 만들 당시에 외래키를 설정을 안했다면, 아래와 같이 테이블 수정을
-- 통해서도 외래키 제약조건을 추가해줄 수가 있다.(이 방법을 현업에서는 가장 많이 쓴다.)
-- 왜? 계속 수정되는 부분이 생기거든요)
alter table buytbl
	add constraint FK_usertbl_buytbl
	foreign key (userid) references usertbl(userid);
    
-- 제약 조건 확인 방법
show index from buytbl;

select *
  from tabledb.usertbl;    
  
select *
  from tabledb.buytbl;    
  
insert into usertbl values ( 'KBS', '김범수', 1979, '경남', '011', '22222222', 173, 20120404);  
insert into usertbl values ( 'KKH', '김경호', 1971, '전남', '019', '33333333', 177, 20070707);
insert into usertbl values ( 'LSG', '이승기', 1987, '서울', '011', '11111111', 182, 20080808);
insert into usertbl values ( 'JYP', '조용필', 1967, '서울', '011', '55511111', 180, 20100808);
-- 자 아래 코드를 입력하고 동시에 실행을 시키면 에러가 난다. 왜일까?
-- 바로, JYP에서 에러가 나는것을 확인할수가 있다. 그 이유는 JYP를 외래키로
-- 설정을 했는데 참조하는 테이블 즉, usertbl에는 아직 JYP란 놈이 없어서 에러를 치는 것이다.
-- 회원도 없는데 어떻게 구매를 할 수가 있나?
-- 항상 회원가입을 하고 구매를 할 수가 있지 않는가?
-- 방법은 2가지가 있다. 뭘까? 고민해보고 발표해보자.
insert into buyTBL values (null, 'KBS', '운동화', null, 30, 2);
insert into buyTBL values (null, 'KBS', '노트북', '전자', 1000, 1);
insert into buyTBL values (null, 'JYP', '모니터', '전자', 200, 1);

drop table usertbl;