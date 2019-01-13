-- 트리거에 대해서 알아보자.
-- ppt에서 말했듯이 트리거는 어떤 특정한 테이블에 부착이 되어
-- 그 테이블에 삽입, 수정, 삭제의 작업이 일어나면 자동실행되는
-- 스토어드 프로그램의 부류이다.
-- 물론 스토어드, 스토어드 프로시져 처럼 IN, OUT등 인자값을 가질 수는 없다.

use testdb;
drop table if exists testtbl;
create table testtbl(
					id int,
					txt varchar(10)
                    );

insert into testtbl values (1, "이엑스아이디"), (2, "애프터스쿨"), (3, "아이오아이");

-- 이제, testtbl에 부착시킬 트리거를 만들어 본다.
drop trigger if exists trgtrigger;
delimiter //
create trigger trgtrigger
		after delete 	-- 트리거 명
		on testtbl		
        for each row	-- 각 행마다 적용시킨다. (문법이기에 암기)
begin
	declare txt_singer varchar(10);
    set txt_singer = old.txt;
    set @msg = concat('삭제된 가수 이름: ', txt_singer);
end //
delimiter ;

-- 삽입을 했음에도 msg가 출력되지 않았다. 그 이유는 무엇인가?
-- 트리거를 정의 했을 때 delete부분 트리거만 부착시킨 것이다.
set @msg = '';
insert into testtbl values(4, '나인뮤지스');
select @msg;

-- 역시 수정부분에도 트리거를 부착시키지 않아 결과가 나오지 않는다.
set @msg = '';
update testtbl set txt = '에이핑크' where id = 3;
select @msg;

-- 하지만, 삭제는 트리거를 부착시켰기 때문에 결과값이 도출된다.
set @smg = '';
delete from testtbl where id = 4;
select @msg;

select * from testtbl;

-- 이제 로그데이터를 남기는 트리거를 만들어보자.
-- 먼저 sqldb를 초기화시킨다.

use sqldb;
drop table buytbl;

-- 로그 데이터를 남기기 위해 usertbl의 백업테이블인 backup_usertbl을 생성해보자.
-- 기존 usertbl에 3개의 컬럼을 더 추가했다.

drop table if exists backup_usertbl;
create table backup_usertbl(
	userID		char(8) not null primary key,
    name		varchar(10) not null,		
    birthyear	int not null,				
    addr		char(2) not null,			
    mobile1		char(3),					
    mobile2		char(8),					
    height		smallint,					
    mdate		date,							
    
    modtype char(2), -- 변경된 작업을 명시하기 위해 추가 (수정? 삭제?)
    moddate datetime, -- 변경된 날짜 저장
    moduser varchar(256) -- 변경한 사용자
);

-- 이제 usertbl 수정시 자동실행되는 트리거를 생성하여 부착시키자.
drop trigger if exists backusertbl_updatetrg;
delimiter //
create trigger backusertbl_updatetrg
	after update
    on usertbl
    for each row
begin
	-- 데이터를 update후 자동으로 실행되는 트리거이다.
    -- 여기서 old는 시스템 db로서 트리거에 의해서 변경되기 전 데이터를
    -- 잠시 보관하는 것이다. 하여, 위에서 3개 추가한 컬럼에 각각 데이터를 삽입하고 있다.
    insert into backup_usertbl values(old.userid, old.name, old.birthyear, old.addr,
										old.mobile1, old.mobile2, old.height, old.mdate,
										'수정', sysdate(), current_user() 
									);
end //
delimiter ;
select * from backup_usertbl;
select * from usertbl;
-- 데이터를 수정했다.
update usertbl
set birthyear = 1885
where userid = 'BBK';

-- 각 테이블마다 확인해보자.
select * from usertbl;
select * from backup_usertbl;

-- 이제는 삭제될 때 자동실행되는 트리거를 만들어보자.
drop trigger if exists backusertbl_deletetrg;
delimiter //
create trigger backusertbl_deletetrg
	after delete
    on usertbl
    for each row
begin
	-- 데이터를 delete 자동으로 실행되는 트리거이다.
    -- 여기서 old는 시스템 db로써 트리거에 의해 변경되기 전 데이터를 잠시 보관하는 것이다.
    -- 하여, 위에서 3개 추가한 컬럼에 각각데이터를 삽입하고 있다.
    insert into backup_usertbl values(old.userid, old.name, old.birthyear, old.addr,
										old.mobile1, old.mobile2, old.height, old.mdate,
										'삭제', sysdate(), current_user() 
										);
end //
delimiter ;

-- 데이터를 삭제했다.
delete from usertbl where height = 174;

-- 각 테이블마다 확인해보자.
select * from usertbl;
select * from backup_usertbl;

-- 근데 truncate는 어떻게 될까? truncate는 dml이 아니라 ddl이다.
-- 하여 트랜잭션이 발생하지 않아 트리거가 작동하지 않는다.
truncate table usertbl;

-- usertbl의 데이터는 다 제거되었다.
select * from usertbl;

-- 하지만 backup_usertbl을 확인해보면 역시나 르티거가 작동안한것을 볼 수 있다.
-- 하여 권한 설정시 일반유저한테다 초보 전산직이라면 truncate권한을 주지 않도록 하자.

select * from backup_usertbl;

-- 권한설정으로 insert나 delete, update등을 사용자 별로 제한 할 수도 있지만,
-- 아래와 같이 오류를 강제로 발생시켜 입력을 테이블에 못하도록 할 수도 있다.
drop trigger if exists usertbl_inserttrg;
-- 트리거 생성구문
delimiter //
create trigger usertbl_inserttrg
		after insert
        on usertbl
        for each row
begin
	signal sqlstate '45000' -- 사용자가 강제로 오류를 발생시키는 함수이다.
    set message_text = '데이터를 저장할 수 없습니다. 전산팀에 문의 하세요.';
end //
delimiter ;

-- 삽입을 시도했지만 삽입이 되지 않는다.
insert into usertbl values('BBC', '비비씨', 1977, '현풍', '010', '0000000', 176, '2013-5-5');

-- 조회를 해봐도 역시 없다.
select * from usertbl;

-- 하지만 가장 깔끔한 방법은 권한을 주지 않는것이다.
-- 위처럼 일일히 테이블 마다 해주면 번거롭다. 그냥 저런 방법도 있음을 알아두자.

-- 트리거는 임시테이블을 생성한다. 즉 앞서 보았던 new, old가 바로 시스템 임시 테이블인 것이다.
-- 하지만, insert시에는 new임시테이블만 생성되고, delete시에는 old테이블만 생성된다.
-- 하지만 updqte에서는 new,old테이블 2개 다 생성한다. 기억하도록 하자.

-- 이번에는 before트리거에 대해서 알아보자.
-- before트리거는 테이블에 데이터를 저장하기 위해 new임시테이블로 값들을 유효성 전처리를 할 수 있다.
-- 하여, 잘못된 입력값을 바꿔서 입력시킬 수도 잇다.

-- 다시 sqldb를 초기화하여 before트리거를 만들어서 실습해보도록 하자.
use sqldb;
drop trigger if exists usertbl_beforeinserttrg;
-- before트리거를 생성하는데 insert시 자동 발생하도록 함.
delimiter //
create trigger usertbl_beforeinserttrg
	before insert
    on usertbl
    for each row
begin
	if new.birthyear < 1900 then -- 입력데이터의 연도가 1900년 이전이면 0 으로 값 지정
    set new.birthyear = 0;
    -- 입력데이터가 현재년도 이후라면 현재연도를 값으로 지정
    elseif new.birthyear > year(curdate()) then
		set new.birthyear = year(curdate());
	end if;
end //
delimiter ;

-- 데이터의 출생년도가 잘못되었다. 하지만 저장은 잘됐다. 하지만 입력값은 분명 달라질 것이다.
insert into usertbl values('CCC', '씨씨씨', 1898, '현풍', '010', '0000000', 176, '2017-10-10');
insert into usertbl values('AAA', '에에에', 2995, '대구', '010', '1234567', 210, '2013-5-5');

-- 확인해보자.
select * from usertbl;

-- 해당 db에 있는 트리거들을 볼 수 있다.
show triggers from sqldb;

-- 트리거 삭제할 수도 있다.
drop trigger usertbl_beforeinserttrg;

-- 트리거는 테이블에 항상 부착이 되어 자동실행되기 때문에 테이블이 삭제되면
-- 자동으로 그 테이블에 부착되어 있는 트리거는 제거가 된다.
-- 하여 sqldb를 초기화 했기 때문에 당연히 트리거는 없을 것이다.

-- 중첩트리거에 대해 알아보자.
-- 먼저 실습할 공간이 되는 triggerdb를 만들자.
drop database if exists triggerdb;
create database triggerdb;

use triggerdb;
-- 먼저 테이블 3개(구매, 물품, 배송테이블)을 각각 만들어보자.
-- 구매테이블 생성
drop table if exists ordertbl;
create table ordertbl(
					orderno int auto_increment primary key, -- 구매 일려번호
                    userid varchar(5),						-- 구매한 회원 아이디
                    prodname varchar(5),					-- 구매한 물건
                    orderamount int							-- 구매한 개수
                    );
-- 물품 테이블 생성
drop table if exists prodtbl;
create table prodtbl(
					prodname varchar(5), -- 물품이름
                    account int, 		-- 물품 개수(재고)
                    warehousing datetime default now()
                    );

-- 배송테이블 생성
drop table if exists delivertbl;
create table delivertbl(
						deliverno int auto_increment primary key, -- 배송 일련번호
                        prodname varchar(5), 						-- 배송 물건
                        account int unique 							-- 배송할 물건 개수
                        );

drop table prodtbl;
insert into prodtbl values('사과', 100, default);
insert into prodtbl values('배', 100, default);
insert into prodtbl values('귤', 100 ,default);

select * from prodtbl;

-- 이제 중첩트리거를 만들어 구매테이블과 물품테이블에 부착하자.
-- 구매 테이블에 구매가 발생(삽입)이 되면 물품 테이블에서 재고를 감소시키는 트리거를 생성
drop trigger if exists ordertrg;
delimiter //
create trigger ordertrg
		after insert
        on ordertbl
        for each row
begin
	-- 현재 있는 재고 - 주문개수를 하면 현 재고가 다시 업데이트 될 것이다.
    -- 이 update문이 실행되면, prdtrg트리거도 자동 실행된다. 이것이 중첨트리거이다.
		update prodtbl
		set account = account - new.orderamount
        where prodname = new.prodname;
end //
delimiter ;

drop trigger if exists prdtrg;
delimiter //
create trigger prdtrg
	after update
    on prodtbl
    for each row
begin
	declare orderamount int;
    -- 주문개수를 연산하는데 기존의 재고가 100개(old.account)이고
    -- 만약 주문이 10개 들어와서 위의 ordertrg가 실행되면 update후의 값은 90이 된다.
    -- update시에는 임시테이블이 2개 만들어진다고 하였다.
    set orderamount = old.account - new.account;
    -- 배송테이블에 물품명과 배송개수를 삽입한다.
    insert into delivertbl (prodname, account) values (new.prodname, orderamount);
end //
delimiter ;

-- ordertbl에 데이터를 삽입하니 위의 중첩트리거가 자동 실행 된다.
insert into ordertbl values(null, '신은혁', '사과', 10);

-- 각각의 테이블을 다 확인해보면 역시 트리거에 설정한대로 데이터가 들어가 있다.
select * from ordertbl;
select * from prodtbl;
select * from delivertbl;

-- 근데 이번엔 delivertbl의 컬럼 중 하나의 이름을 변경하여 보자.
-- 그럼 당연히 트리거가 실행되면서 오류를 발생시킬 것이다.

-- delivertbl의 prodname 컬럼을 productname으로 변경시켰다.
alter table delivertbl
	change prodname productname varchar(5);
    
    -- 삽입해보지 prdtrg트리거에서 에러가 난것이다.
    -- 필드명이 없다는 것이다. 그럼 앞에 실행한 것은 제대로 되었을까?
    -- 아니다. 이것은 연결된 하나의 작업으로 보아야 하기 때문에
    -- 저장 자체가 안되는 것이다.
insert into ordertbl values(null, '신은비', '귤', 35);

-- 확인을 해보면 역시 저장자체가 안되어 있는 것을 볼 수 있다.
select * from ordertbl;
select * from prodtbl;
select * from delibertbl;