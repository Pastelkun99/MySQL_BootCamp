-- 문제 162
use mydb2;
drop table sungjuk;
create table sungjuk(
						hakbun int primary key,
						hakname varchar(10) not null,
                        kor int not null,
                        eng int not null,
                        mat int not null,
                        tot int,
                        avg int,
                        rank int
					);

insert into sungjuk values(1, '임길동', 90, 70, 80, kor+eng+mat, (tot/3), null);
insert into sungjuk values(2, '김민수', 100, 80, 60, kor+eng+mat, (tot/3), null);
insert into sungjuk values(3, '김은수', 90, 75, 88, kor+eng+mat, (tot/3), null);
insert into sungjuk values(4, '하연주', 100, 100, 34, kor+eng+mat, (tot/3), null);
insert into sungjuk values(5, '오지랍', 100, 70, 50, kor+eng+mat, (tot/3), null);
insert into sungjuk values(6, '최정연', 90, 75, 77, kor+eng+mat, (tot/3), null);
insert into sungjuk values(7, '임시', 55, 66, 77, kor+eng+mat, (tot/3), null);

select * from sungjuk;
select sum(kor), sum(eng), sum(mat) from sungjuk;

# 문제 163
drop procedure if exists sjf1;
delimiter $$
create procedure sjf1()
begin
	declare subscore int;
	declare scoretotal int default 0;
    declare cnt int default 0;
    declare endofrow boolean default false;
    
    declare scorecursor cursor for
		select tot from sungjuk;
        
	declare continue handler
		for not found set endofrow = true;
        
	open scorecursor;
    
    cursor_loop : loop
		fetch scorecursor into subscore;
        if endofrow then
			leave cursor_loop;
		end if;
        
        set cnt = cnt + 1;
        set scoretotal = scoretotal + subscore;
	end loop cursor_loop;
    
    select concat('총점 : ', scoretotal, '  평균 : ', (scoretotal / cnt)) as 'Result';
    close scorecursor;
end $$
delimiter ;

call sjf1();
select tot 
from sungjuk
order by tot desc;

select tot from sungjuk order by tot desc;



# 문제164   
# sungjuk테이블의 총합을 기준으로 하여 rank(순위)를 추가하는    
# 프로시져를 만들어보시오   
# (역시, 커서를 이용합니다.)

drop procedure if exists myproc2;
delimiter $$
create procedure myproc2()
begin
   -- 저장용 세가지
    declare usertot int;
    declare usercount int default 0;   -- 카운트
    declare usergrade int;
    
    -- 행의 끝인지 아닌지를 알아보는 변수(플래그 변수 개념) 기본값 : false 로 설정
    declare endofrow boolean default false;
    
    declare usercursor cursor for
      select tot from sungjuk order by tot desc;
   
    declare continue handler
      for not found set endofrow = true;
      
   open usercursor; -- 커서를 연다.
    
    cursor_loop : loop
    
      fetch usercursor into usertot;
        
		if endofrow then
		leave cursor_loop;
        end if;
        
      update sungjuk set rank = usercount+1 where tot= usertot;
      set usercount = usercount + 1;  
        
   end loop cursor_loop;
    
   select usertot;
    
   close usercursor; -- 커서를 닫는다.

end $$
delimiter ;


call myproc2();
select * from sungjuk;

    
