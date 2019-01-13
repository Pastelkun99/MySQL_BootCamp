use sqldb;

-- 대용량 데이터 삽입해보기
-- 일단, 먼저 maxtbl을 만들자. 근데 필드의 데이터 타입이 longtext이다.
-- longtext는 4GB만큼 text데이터를 넣을 수 있다는 것을 이미 배웠다.
drop table if exists maxtbl;
create table maxtbl (col1 longtext, col2 longtext);

desc maxtbl;
-- 'A'라는 문자를 10만번 반복해서 col1에 넣고, '가'라는 한글을 10만번 col2에 넣자.
insert into maxtbl values( repeat('A', 100000), repeat('가', 100000));

-- 앞에서 배운 length()는 필드의 바이트 수를 리턴한다. col1은 영어라서 1바이트를 가진다고 했고,
-- 한글은 3바이트를 가진다고 했다. UTF-8 문자셋에서는 그렇다.
select length(col1), length(col2) -- col1은 0.1mb, col2는 약 0.3mb
from maxtbl;

-- 분명 longtext는 4gb저장할 수 있다고 했는데 1000만 바이트가 안들어간다고 에러를 낸다.
-- 기본적으로 mysql은 4mb까지만 저장을 허용한다. 이때는 워크벤치의 설정을 바꿔줘야 한다.
-- C:/ProgramData/MySQL/MySQL Server 5.7/my.ini파일에 max_allow부분이 기본적으로
-- 설정이 바뀌면 재부팅을 하는 것이 원칙이나, cmd창을 관리자모드로 열고
-- net stop mysql을 치자. 그럼 mysql서버가 중지되고, net start mysql을 치면
-- 서비스를 시작하여 적용이 된다. 이제 아래코드를 치면 에러가 발생하지 아니한다.
insert into maxtbl values( repeat('A', 10000000), repeat('가', 10000000));

-- 방금 수정한 my.ini의 시스템변수들을 보는 쿼리문이다.
show variables like 'max%';

-- 다시 말하지만 my.ini파일을 수정하게 되면 mysql서비스를 중단했다가 다시 시작해야 한다. 명심할 것.
-- 설정이 되었는지 확인해보자.
show variables like 'secure%';

use sqldb;

-- 버전이 바뀌면서 책과는 다르게 역슬래시 2개를 표시해야만 경로를 인식한다.
-- into outfile 경로는 usertbl의 내용을 텍스트파일로 내보내겠다는 것이다.
-- 파일을 열어보면 깨지는 경우도 있고 한데 ms-word에서 열면 잘 보이는 것을 알 수 있다.

-- 텍스트 파일로 내보내기
select * from usertbl
 into outfile 'C:\\temp\\usertbl.txt' character set utf8
 fields terminated by ',' optionally enclosed by '"'
 escaped by '\\'
 lines terminated by '\n';
 
 -- 엑셀 파일로 내보내기
 select * from employees.employees
 into outfile 'C:\\temp\\employees.csv' character set euckr
 fields terminated by ',' optionally enclosed by '"'
 escaped by '\\'
 lines terminated by '\n';

select *
into outfile 'C:\\TEMP\\userTBL.csv' char set euckr
from usertbl;

select *
from membertbl;

-- 이제는 외부데이터를 가져와보자. 먼저 기존에 썼던 membertbl을 날리자
drop table if exists membertbl;

-- 그리고 하기 쿼리는 테이블의 구조를 복사해오는 것이다. ( 물론 PK까지 복사해온다.)
create table membertbl like usertbl;

desc membertbl;

-- 이제 불러와서 import해보자.
load data local infile 'C:\\TEMP\\userTBL.txt' into table membertbl character set utf8
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'C:\\TEMP\\userTBL.csv' into table membertbl character set euckr
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- 잘 불러온걸 확인할 수 있다.
select *
from membertbl;

-- 위의 파일로 내보내는 것, 파일로부터 테이블로 데이터 옮기는 것 정말 중요하다.
-- 현업에서 많이 쓰니까 잊어버리지 않도록 하자.
-- 1. 파일내보내기 : select * into outfile '파일경로' from '내보낼 테이블명'
-- 2. 파일 테이블로 가져오기 : load data local infile '가져올 파일 경로' into table
-- 데이터 넣을 테이블명