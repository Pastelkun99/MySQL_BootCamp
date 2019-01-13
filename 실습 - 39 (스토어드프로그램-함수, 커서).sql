-- 스토어드 함수에 대해서 알아보자.

-- 스토어드프로시저와 스토어드 함수는 매우 유사하지만 활용도는
-- 역시 스토어드 프로시져가 많이 활용된다.
-- 하지만, 한번씩 스토어드 함수를 사용할 때도 있다.
-- 일단, 차이점을 보자면
-- 1. 스토어드 함수
-- 		- 파라미터에 in, out등을 사용할 수 없음
-- 		- 모두 입력 파라미터로 사용
-- 		- returns문으로 반환할 값의 데이터 형식 지정
--  	- 본문 안에서는 return문으로 하나의 값 반환
-- 		- select문장 안에서 호출
-- 2. 스토어드 프로시저
-- 		- 파라미터에 in, out 등을 사용가능
-- 		- 별도의 반환 구문이 없음
-- 		- 꼭 필요하다면 여러 개의 out파라미터 사용해서 값 반환 가능
-- 		- call로 호출
-- 		- 안에 select문 사용 가능
-- 		- 여러 sql문이나 숫자 계산 등의 다양한 용도로 사용


-- 일단 먼저 sqldb를 초기화하자.
use sqldb;

-- 스토어드 함수는 procedure가 아니라 function이다. 헷갈리지 않도록 하자
-- 아래 함수는 2개의 매개변수를 받아서 더하여 하나의 int값을 리턴하는 것이다.
drop function if exists userfunc;

delimiter $$
-- 매개변수가 2개이면 반환(리턴값)값의 데이터 형식이 int형이다.
create function userfunc(value1 int, value2 int)
				returns int
begin
	return value1 + value2; -- int 형 반환
end $$
delimiter ;

select userfunc(1000, -700); -- 스토어드 함수는 select구문안에서 호출하는게 대부분이다.

-- 이제는 출생년도를 입력하면 나이를 반환하는 스토어드 함수를 만들어보자.
use sqldb;
drop function if exists getagefunc;
delimiter $$
-- 매개변수 int 형 하나 받아서 그 값을 이용하여 int형 데이터를 리턴한다.
create function getagefunc(byear int)
				returns int
begin
	declare age int; -- 변수 선언
    set age = year(curdate()) - byear; -- 현재 년도에서 매개변수값인 년도를 빼면 나이가 나온다.
    return age; -- 나이를 리턴한다.
end $$
delimiter ;

select getagefunc(1978) as '만 나이';

-- 두 개의 나이차를 구하고 싶다면 변수를 이용해서 저장해두고 사용하면 될 것이다.

select getagefunc(1978) into @age1978; -- 1978년생의 만나이를 @age1978변수에 저장함.
select getagefunc(2007) into @age2007; -- 2007년생의 만나이를 @age1978변수에 저장함.

select concat('2007년생과 1978년생의 나이 차이는 : ', @age1978 - @age2007, '살입니다.') as '나이 차이';

-- 아래와 같은 용도로 스토어드 함수는 많이 쓰인다. 하지만 빈도수는 스토어드 프로시저보다는 미미하다.
select userid, name, getagefunc(birthyear) as '만 나이' from usertbl;

-- 저장되어 있는 스토어드 함수에 내용을 보고 싶다면 아래와 같이 하면 된다.
show create function getagefunc;

-- 함수를 제거하고 싶다면
drop function getagefunc;

-- 커서를 학습해보자.
-- 커서는 테이블을 쿼리한 후, 쿼리의 결과인 행 집합을 한 행씩 처리하기 위한 방식이다.
-- C나 자바에서 파일입출력과 비슷한 개념임
-- 파일을 처리하기 위해서 먼저 파일을 열고, 첫 번째 데이터를 읽고 다음 데이터가 저장되어있는 공간으로
-- 파일 포인터가 이동한다.
-- 이런식으로 파일의 끝(EOF)까지 반복한다.
-- 그리고 파일 포인터를 닫는다.

-- 예제를 하나 쳐보자. 고객의 평균키를 구하는 것이다.
-- 물론 집계함수의 avg()를 이용하면 쉽게 구할 수 있지만,
-- 커서를 리용해서도 할 수 있으니 알아 둘 필요가 있다.

drop procedure if exists cursorproc;
delimiter $$
create procedure cursorproc()
begin
	declare userheight int;					-- 고객의 키를 저장할 변수
    declare cnt int default 0;				-- 고객의 인원수(읽은 행의 갯수가 될 것이다.)
    declare totalheight int default 0;		-- 고객 키의 총합을 저장할 변수
    -- 행의 끝인지 아닌지를 알아보는 변수(플래그 변수 개념) 기본값 : false 로 설정
    declare endofrow boolean default false;
    
    -- 아래와 같이 조회를 하면 키값들이 출력이 될 것이다.
    -- 그러고 난 후 
    declare usercursor cursor for
		select height from usertbl;
        
	-- 만약 커서가 위치를 움직이면서 마지막에 도달하게 되어,
	-- 더 이상 데이터를 발견하지 못하면 endofrow를 true로 설정하게된다.(자동실행됨)
    declare continue handler
		for not found set endofrow = true;
        
    open usercursor; -- 커서를 연다.
    -- 무한 루프를 돈다.
    cursor_loop: loop
		-- 현재 usercursor가 가리키고 있는 height를 userheight에 저장함.
        -- 저장한 후, usercursor는 다음 행으로 위치 이동한다.
		fetch usercursor into userheight;
        -- 만약 endofrow가 false면 루프를 계속 진행할 것이고,
        -- true가 되면 루프문을 빠져나간다.
        if endofrow then
			leave cursor_loop;
		end if;
        
        set cnt = cnt + 1; 					-- 고객 수 증가
        set totalheight = totalheight + userheight;	-- 고객의 키를 계속 누적시킨다.
	end loop cursor_loop;
    
    select concat('고객의 평균 키 : ', (totalheight / cnt));
    close usercursor; -- 커서를 닫는다.
end $$
delimiter ;

call cursorproc();

-- 한가지 더 예제를 해보자.
-- buytbl에 grade컬럼을 일단 추가해보자.
alter table usertbl
	add grade varchar(10);
    
-- 조회를 하면 grade는 전부 null로 되어있다.
select * from usertbl;

-- 이제 스토어드 프로시저를 만들어보자.
drop procedure if exists gradeproc;
delimiter $$
create procedure gradeproc()
begin
	declare id varchar(10); -- 사용할 아이디 저장할 변수
    declare hap bigint; 	-- 총 구매액을 저장할 변수
    declare usergrade char(10); -- 고객 등급을 저장할 변수
    
    -- 행의 끝인지 아닌지 알아보는 변수
    declare endofrow boolean default false;
    
    -- 커서를 아래 조회문에 선언함.
    -- right outer join을 하는 이유가? 하나도 출력하지 않은 고객도 출력하기 위함이다.
    declare usercursor cursor for
		select U.userid, sum(B.price * B.amount)
        from buytbl B
        right outer join usertbl U
        on B.userid = U.userid
        group by U.userid;
        
	-- 가져올 데이터를 발견하지 못하면 true로 설정(물론 자동 실행)
    declare continue handler
		for not found set endofrow = true;
        
	open usercursor; -- 커서 열기
    grade_loop: loop
		-- 위의 조회결과 중 id와 sum값을 각각 대입함. 그리고 커서 이동.
        fetch usercursor into id, hap;
        
        -- 가져올 데이터가 없으면 loop탈출 한다.
        if endofrow then
			leave grade_loop;
		end if;
        
        -- 조회 결과 중 hap에 따라 grade설정한다.
        case
			when(hap >= 1500) then
				set usergrade = '최우수고객';
			when(hap >= 1000) then
				set usergrade = '우수고객';
			when(hap >= 1) then
				set usergrade = '일반고객';
			else
				set usergrade = '유령고객';
		end case;
        -- 위에서 저장되어진 usergrade변수의 값을 usertbl의 grade필드를 수정한다.
        update usertbl set grade = usergrade where userid = id;
        
	end loop grade_loop;
    close usercursor; 		-- 커서 닫는다.
end $$
delimiter ;

call gradeproc();

select U.userid as '고객아이디', U.name as '고객이름', sum(B.amount * B.price) as '총 구매액',
		U.grade as '고객등급'
	from usertbl U
    left outer join buytbl B
    on U.userid = B.userid
    group by U.userid, U.name, U.grade
    order by sum(price * amount) desc;
    
select * from usertbl;
        
