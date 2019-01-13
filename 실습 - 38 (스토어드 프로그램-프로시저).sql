-- 실습-38(스토어드프로그램-프로시져)
use sqldb;

drop procedure if exists userproc;

delimiter $$
create procedure userproc()
-- 실제 스토어드프로시져의 내용은 begin ~ end사이의 내용이다.
-- 물론 지금은 쿼리문 하나밖에 없지만 프로그래밍으로 하다보면 몇백줄 몇천줄이 될 수도 있다.
-- 이 장에서는 begin ~ end사이의 내용을 집중적으로 배우고 호출하면서 얼마나 편리한지 보도록 하자.
begin
   select *
      from usertbl;
end $$
delimiter ;

-- 만든 userproc()스토어드 프로시져를 호출함.
-- 실행되는 내용은 앞서 강의 했지만 begin ~ end사이의 내용이 된다.
call userproc();

-- 자 실습을 하기 위해 sqldb를 초기화시키도록 하자.
-- 초기화가 다 되었다면 아래코드를 실습하자.

-- 입력매개변수가 있을때의 프로그래밍
use sqldb;
drop procedure if exists userproc2;

-- 여기서는 in이란 매개변수(파라메터, 인자값)를 이용해서
-- 쿼리문의 조건의 대입값으로 활용하고 있다.
-- usertbl의 name필드의 값과 매개변수값을 조건으로 주어
-- 쿼리를 하고 있는 것이다.

delimiter $$
create procedure userproc2(in username varchar(10))

begin
   select *
      from usertbl
      where name = username;
end $$
delimiter ;

-- 매개변수 username의 데이터 형식에 맞게끔 값을 주어야 된다.
call userproc2('조관우');
call userproc2('임재범');

-- 매개변수 username의 데이터 형식이 아닌 것을 보내면 아무런 결과가 출력이 되질 아니함을 볼 수가 잇다.
call userproc2(100);

-- 이번에는 매개변수가 2개 인것을 알아보자.
desc usertbl;
drop procedure if exists userproc3;


delimiter $$
-- 매개변수는 무한대로 줄 수가 있다. 아래와 같이 2개가 주어졌다면, 구분을 지어주면 된다.
-- 아울러 이 2개의 매개변수는 각각 조건절에 대입된걸 볼 수가 있다.
create procedure userproc3(in userbirth int, in userheight int)
begin
   select *
      from usertbl
      where birthyear > userbirth   -- 출생년도 비교
        and height > userheight;   -- 키비교
end $$
delimiter ;

call userproc3(1970, 178); -- 1970이후 태어났으며 키가 178이상이 사람을 검색하는 것이다.

-- 이번에는 출력 매개변수에 대해서 알아보자.
drop procedure if exists userproc4;

delimiter $$
-- 여기서는 입력매개변수 1개, 출력매개변수 1개로 되어있다.
-- 근데, 중요한 것은 지금 현재 sqldb에는 testtbl이 없다.
-- 그럼에도 불구하고 procedure는 만들어진다.
-- 단지 실행만 안하면 문제 없다는 것이다. 즉, call할때는 반드시 testtbl이 있어야
-- procedure가 실행될 것이다.

create procedure userproc4(in txtvalue char(10), out outvalue int)
begin
   insert into testtbl values ( null, txtvalue);   -- txtvalue가 testtbl에 자동 저장된다.
    -- 그리고 testtbl에서 출력매개변수인 outvalue에 id의 최대값을 저장하고 있다.
   select max(id) into outvalue
      from testtbl;
end $$
delimiter ;

-- 위의 userproc3()에 필요한 testtbl을 아래와 같이 정의하자
drop table if exists testtbl;
create table testtbl (
   id int auto_increment primary key,   -- id는 데이터가 자동증가
    txt char(10)
);

-- @가 붙으면 변수라는 것을 앞에서 배웠다.
-- 위에 출력 매개변수값이 변수값에 들어가는 것이다.
call userproc4('테스트값', @myvalue);
select concat('현재 입력된 아이디 값 -->> ', @myvalue);

-- 조회를 해보면 역시나 데이터가 들어가있는 것을 알 수가 있다.
select *
  from testtbl;
  
-- ifelse문을 이용하는 스토어드프로시져
drop procedure if exists ifelseproc;
delimiter $$
create procedure ifelseproc(in username char(10))
begin
   declare byear int;   -- 변수 선언하는 부분
    
    -- 조건절에서 매개변수로 넘어오는 값을 가지고 조회해서
    -- 출생년도(birthyear)를 변수 byear에 대입함
   select birthyear into byear
      from usertbl
     where name = username;
   -- 대입된 변수값을 가지고 if~else구문을 이용하여 출력함.
    if(byear >= 1980) then
      select concat(username,'님은 아직 젊으시군요!!');
   else
      select concat(username,'님은 노화되셨군요!!');
   end if;
end $$
delimiter ;

call ifelseproc('이승기');
call ifelseproc('임재범');

-- case문을 이용하는 예제이다.
drop procedure if exists caseproc;
delimiter $$
create procedure caseproc(in username varchar(10))
begin
   declare byear int;      -- 출생년도 저장할 변수
    declare tti char(3);   -- 띠를 저장할 변수
    -- 역시 조건절에서 매개변수를 가지고 비교하여 조회하여 출생년도를 byear변수에 저장함.
   select birthyear into byear
      from usertbl
     where name = username;
      
   -- byear변수에 저장된 출생년도 값을 이용하여 아래와 같이 띠를 구한다.
    case
      when (byear % 12 = 0)
         then set tti = '원숭이';
      when (byear % 12 = 1)
         then set tti = '닭';
      when (byear % 12 = 2)
         then set tti = '개';
      when (byear % 12 = 3)
         then set tti = '돼지';
      when (byear % 12 = 4)
         then set tti = '쥐';
      when (byear % 12 = 5)
         then set tti = '소';
      when (byear % 12 = 6)
         then set tti = '호랑이';
      when (byear % 12 = 7)
         then set tti = '토끼';
      when (byear % 12 = 8)
         then set tti = '용';
      when (byear % 12 = 9)
         then set tti = '뱀';
      when (byear % 12 = 10)
         then set tti = '말';
      else set tti = '양';
   end case;
    
    -- tti와 username에 저장된 값을 이용하여, 보기 좋게 출력하도록 한다.
    select concat(username, '------> 의 띠는 바로 ' , tti);
end $$
delimiter ;

call caseproc('이승기');
call caseproc('성시경');
call caseproc('김범수');

-- 반복문 예제
drop table if exists gugutbl;

-- 구구단 저장용 테이블 생성
create table gugutbl (
   txt varchar(300)
);

drop procedure if exists whileproc;
delimiter $$
create procedure whileproc()
begin
   declare str varchar(300);   -- 각 단을 문자열로 저장하려고 선언한 변수
    declare i int;            -- 구구단 앞자리
    declare j int;            -- 구구단 뒷자리
    
    set i = 2;               -- 2단부터 있으니깐 2로 저장
    
    while(i < 10) do   -- 외부 반복문
      set str = '';
        set j = 1;      -- 구구단의 뒷자리는 1부터 시작한다.
        
        while(j < 10) do   -- 내부 반복문
         -- 구구단의 결과를 문자열로 계속 이어 나감
         set str = concat(str, '    ' ,i, ' * ', j , ' = ', i * j);
            set j = j + 1;
      end while;
        
        set i = i + 1;   -- 단의 수가 증가
        insert into gugutbl values (str);   -- 한 단이 끝나면 str값을 gugutbl에 저장함.
   end while;
end $$
delimiter ;

call whileproc();
-- truncate table gugutbl;

-- 조회 해보면 결과가 나오는 것을 알 수 있다.
select *
  from gugutbl;
  
-- 이번에는 7장에서 잠깐 봤던 프로그래밍 중 오류 처리에 대한 부분을 알아보자.
drop procedure if exists errorproc;
delimiter $$
create procedure errorproc()
begin
    declare i int;         -- 1씩 증가 하는 값
    declare hap int;      -- 합계(정수형). 오버플로우 발생시킬 예정(그래야 핸들러 실행하니깐)
    declare savehap int;   -- 합계(정수형). 오버플로우 직전의 값 출력하기 위해서..
    
    -- 오버플로우가 발생하는 아래 begin부분 실행함.
    declare exit handler for 1264
    begin
      select concat('int데이터타입의 오버플로우 직전의 합계 -->', savehap);
        select concat('오버플로우 직전의 i값 : ', i);
   end;
    
    set i = 0;
    set hap = 0;
    
    while(1) do
      set savehap = hap;   -- 오버플로우 직전의 합계
        set hap = hap + i;   -- 오버플로우가 나면 핸들러 실행
        set i = i + 1;
   end while;
end $$
delimiter ;
call errorproc();

-- 다음은 만들어놓은 프로시져의 즉 현재 저장된 프로시져의 이름 및 내용을 알고자 할때는
-- 아래와 같이 시스템 DB를 이용하여 출력해보면 된다.
-- 하지만 매개변수값은 보이지 않는다.

select routine_name, routine_definition
  from information_schema.routines   -- 시스템 db
 where routine_schema = 'sqldb'
   and routine_type = 'procedure';
   
-- 매개변수 값을 알고자 한다면 아래와 같이 한다.
-- 먼저 시스템 DB인 mysql.proc테이블을 조회해보면 모든 프로시져가 들어있다.
select *
  from mysql.proc;
  
-- 그 중에서 보고 싶은 값을 쿼리치면 된다.
select specific_name, definer, param_list, body, created
  from mysql.proc
 where db = 'sqldb'
   and type = 'procedure';
   
-- 특정 DB에 특정 프로시져만 보고싶다면 아래코드로 치면 될 것이다.
-- 하지만 위에 2번째 방법이 젤 나을것이다.
show create procedure sqldb.userproc3;

-- 이번에는 테이블명을 매개변수로 가지는 형태를 보자.
drop procedure if exists nameproc;
delimiter $$
create procedure nameproc(in tblname varchar(20))   -- 테이블 이름을 매개변수로 가진다.
begin
   -- 매개변수로 들어온 테이블을 조회한다.
    select *
      from tblname;
end $$
delimiter ;

-- 자 호출을 해보니 오류가 난다.
-- 원래 기본적으로 매개변수값으로 테이블명은 넘어갈 수가 없다.
-- 하여 7장에서 조금 살펴본 동적 sql문(prepare, execute)을 이용하면 가능하다.
call nameproc('usertbl');

drop procedure if exists nameproc;
delimiter $$
create procedure nameproc(in tblname varchar(20))   -- 테이블 이름을 매개변수로 가진다.
begin
   -- declare str varchar(20);      -- 이렇게 변수를 선언해서 해도 가능하다.
    -- set @str = concat('select * from ', tblname);
    -- prepare myquery from @str;
    -- execute myquery;
    
    -- 변수에 쿼리문을 저장한다. 칸 띄우는 것에 신경을 잘 써야 한다.
    set @sqlquery = concat('select * from ', tblname);
    -- 동적 sql문을 prepare를 이용해서 myquery부분에 대입한다.
    prepare myquery from @sqlquery;
    execute myquery;      -- 저장한 sql문을 실행한다.
    deallocate prepare myquery;   -- 메모리에 할당한 동적 sql문을 해제한다.
end $$
delimiter ;
call nameproc('usertbl');