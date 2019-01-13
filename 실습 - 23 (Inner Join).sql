-- inner join 통상 조인이라 칭한다.
-- 조인은 2테이블 이상을 결합하여 쿼리하여 결과를 출력하는 sql고급 부분에 해당한다.
-- 의미를 잘 이해하고 잘 활용하도록 하자. 현업에서도 굉장히 많이 쓰인다.

use sqldb;
-- 아래 코드는 buytbl과 usertbl을 inner join하였다.
-- 근데 조인의 조건이 buytbl.userid와 usertbl.userid가 같은걸 조인한 것이다.
-- 그것을 대상으로 하여 또한 조건을 주었는데, buytbl.userid가 'JYP'인것만 출력하도록 한 것이다.

select *
from buytbl 
inner join usertbl
	on buytbl.userid = usertbl.userid
where buytbl.userid = 'JYP';

select *
from buytbl;
select *
from usertbl;

-- where 절을 주지 않으면 모든 데이터를 가져온다.
select *
from buytbl
inner join usertbl
	on buytbl.userid = usertbl.userid;

-- 통상 위의 코드와 동일한 결과를 출력하기 위해 아래와 같이 쿼리를 만드는 개발자도 있다.
-- 보통 아래 코드를 많이 사용하며, 현업에 가면 이런 코드를 많이 보게 될 것이다.
select *
from buytbl, usertbl
where buytbl.userid = usertbl.userid
and buytbl.userid = 'JYP';

-- 아래 쿼리를 실행하면 오류가 난다. 왜 에러가 날까?
-- 바로 userid때문이다. userid는 buytbl, usertbl 모두에 있다.
-- 따라서 userid가 어느 테이블의 것인지 알 수 없기 때문에 에러가 나는 것이다.
select userid, name, prodname, addr, mobile1 + mobile2 as '연락처'
from buytbl
inner join usertbl
	on buytbl.userid = usertbl.userid;

-- 원래 조인을 할 때는 필드명 앞에 테이블명을 적어주는게 원칙이다.
-- 하지만, 이렇게 하면 쿼리문이 상당히 길어진다. 이때 테이블에 알리아스를 주어 쉽게 해결 가능하다.
-- 역시 현업에서도 이렇게 많이 사용한다.
select buytbl.userid, usertbl.name, buytbl.prodname,
	   usertbl.addr, usertbl.mobile1 + usertbl.mobile2 as '연락처'
	from buytbl
    inner join usertbl
    on buytbl.userid = usertbl.userid;
    
-- 아래 쿼리는 테이블에 직접 알리아스를 주고 활용한 쿼리문이다.
-- 확실히 같은 결과를 내지만, 코드는 줄어든 것을 확인 가능하다.
select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from buytbl as B
inner join usertbl as U
	on B.userid = U.userid
where B.userid = 'JYP';

-- 아래 쿼리는 전체 회원들을 구하려고 한 쿼리문이다.
-- 하지만, 이승기, 임재범, 윤종신, 조관우가 나타나지 않았다.
-- 다시 말해 구매한 기록이 있는 사람들의 목록일 뿐이다.
-- 무엇을 의미하는가? inner join은 buytbl의 userid와 usertbl의 userid가 같은 것만
-- 출력하는 것이다. 그럼 전체 회원들을 다 보기 위해서는 outter join을 사용해야 다 보인다.

select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from usertbl as U
inner join buytbl as B
	on U.userid = B.userid
order by U.userid;

-- 먼저 이 부분을 쿼리하고 위의 것을 해보자.
select *
from usertbl;

-- 아래 쿼리가 바로 left outer join이다. 즉, 왼쪽 테이블을 다 출력해라는 것이다.
select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from usertbl as U
left outer join buytbl as B
	on U.userid = B.userid
order by U.userid;


-- 통상 outer join을 오라클에서는 아래 쿼리문으로 대체되나, mysql에서는 제대로 작동하지 않는다.
select B.userid, U.name, B.prodname, U.addr, U.mobile1 + U.mobile2 as '연락처'
from usertbl as U, buytbl B
-- where U.userid(+) = B.userid
order by U.userid;

select *
from usertbl;

-- 아래는 구매한 적이 있는 사람들을 조회해보는 쿼리문이다.
-- 중복방지를 위해 distinct키워드를 사용해서 구매한 적이 있는 사람을
-- 일목요연하게 출력하였다.
select distinct U.userid, U.name, U.addr, U.mobile1 + U.mobile2 as '연락처'
from usertbl U
inner join buytbl B
	on U.userid = B.userid
order by U.userid;

-- 아래 쿼리는 위와 같이 distinct와 같은 결과를 출력한다.
-- exists 구문은 서브쿼리에 필드가 존재하는지만 확인하여 리턴한다. 즉
-- boolean 값을 리턴한다. 순서는 먼저 첫번째 select를 실행하고 그 결과를 토대로
-- where exist의 select를 비교해서 맞는 행이 있다면 리턴하여 출력하게 되므로
-- 결과적으로 distinct키워드와 같은 역할을 한다.
select U.userid, U.name, U.addr
from usertbl U
where exists ( select *
				from buytbl B
				where U.userid = B.userid
			 );
             

-- 다대다의 관계를 테이블로 표현해본다.
use sqldb;

-- 다대다 관계를 조인해보기 위해 아래와 같이 3개의 테이블을 만드는 쿼리문을 만들었다.
drop table if exists stdtbl;
create table stdtbl ( stdname varchar(10) not null primary key,
					  addr char(4) not null
                      );

drop table if exists clubtbl;
create table clubtbl ( clubname varchar(10) not null primary key,
				       roomno char(4) not null
                       );
                       
-- stdclubtbl은 외래키(foreign key)를 설정했다. 이부분을 눈여겨 봐야한다.
-- 왜냐하면 외래키는 기본키와 함께 조인을 위해 사용하기 때문에 테이블 생성시
-- 외래키를 설정하는 것이다.
drop table if exists stdclubtbl;
create table stdclubtbl ( num int auto_increment not null primary key,
						  stdname varchar(10) not null,
						  clubname varchar(10) not null,
						  foreign key(stdname) references stdtbl(stdname),
                          foreign key(clubname) references clubtbl(clubname));
                          
-- 각각의 테이블에 데이터를 삽입하였다.
insert into stdtbl values ('김범수', '경남'), ('성시경', '서울'), ('조용필', '경기'),
						  ('은지원', '경북'), ('바비킴', '서울');
                          
insert into clubtbl values ('수영', '101호'), ('바둑', '102호'), ('축구', '103호'),
						   ('봉사', '104호');
                           
insert into stdclubtbl values (null, '김범수', '바둑'), (null, '김범수', '축구'),
							  (null, '조용필', '축구'), (null, '은지원', '축구'),
                              (null, '은지원', '봉사'), (null, '바비킴', '봉사');
                              
-- 이제 만든 3개의 테이블을 조인을 해서 이름/지역/동아리명/동아리방호수 를 출력해보자.
-- 여기서 기억할 것은 조인을 하기 위해서는 대부분 PK와 FK를 가지고 설정하는 경우가 많다는 것이다.

-- 아래 쿼리는 학생명을 기준으로 한 것이다.
select S.stdname, S.addr, C.clubname, C.roomno
from stdtbl S
inner join stdclubtbl SC
	on S.stdname = SC.stdname
inner join clubtbl C
	on SC.clubname = C.clubname
order by S.stdname;

-- 이제는 동아리명을 기준으로 한번 조인을 해보자.
select C.clubname, C.roomno, S.stdname, S.addr
from clubtbl C
inner join stdclubtbl SC
	on C.clubname = SC.clubname
inner join stdtbl S
	on SC.stdname = S.stdname
    order by C.clubname;