# 문제 151
use mydb;
drop procedure if exists empproc;
delimiter $$
create procedure empproc()
begin
	select ename, empno
    from emp;
end $$
delimiter ;

call empproc();

# 문제 152
drop procedure if exists empproc2;
delimiter $$
create procedure empproc2(in empname varchar(10))
begin
	select *
    from emp
    where ename = empname;
end $$
delimiter ;

call empproc2('김사랑');

# 문제 153
drop procedure if exists empproc3;
delimiter $$
create procedure empproc3(in deptname varchar(10))
begin
	select *
    from dept
    where dname = deptname;
end $$
delimiter ;

call empproc3('영업부');

# 문제 154
drop procedure if exists empproc4;
delimiter $$
create procedure empproc4(in grade varchar(7), in edate date)
begin
	select *
    from emp
    where job = grade
    and edate < hiredate;
end $$
delimiter ;

call empproc4('사원', '2004-01-01');

# 문제 155
drop procedure if exists empproc5;
delimiter $$
create procedure empproc5(in eno int, out empname varchar(8))
begin
	select ename into empname
    from emp
    where eno = empno;
end $$
delimiter ;

call empproc5(1001, @str);
select concat('입력된 사원의 이름 : ', @str);

# 문제 156
drop procedure empproc5;
delimiter $$
create procedure empproc5(in empname varchar(5))
begin
	declare jobm varchar(10);
    
    select job into jobm
    from emp
    where ename = empname;
    
    if(jobm = '사원') then
		select concat(empname, '님은 초지일관하십시오.');
	elseif(jobm = '대리') then
		select concat(empname, '님은 더욱 분발하십시오.');
	elseif(jobm = '과장') then
		select concat(empname, '님은 더욱 분발하십시오.');
	elseif(jobm = '부장') then
		select concat(empname, '님은 이제 정년이 다되어가는군요!');
	elseif(jobm = '차장') then
		select concat(empname, '님은 이제 정년이 다되어가는군요!');
	elseif(jobm = '사장') then
		select concat(empname, '님은 이제 정년이 다되어가는군요!');
	end if;
end $$
delimiter ;

call empproc5('김사랑');
call empproc5('오지호');
call empproc5('장동건');

# 문제 157
drop procedure if exists empproc5case;
delimiter $$
create procedure empproc5case(in empname varchar(10))
begin
	declare jobm varchar(8);
    
    select job into jobm
    from emp
    where ename = empname;
    
    case
		when (jobm = '사원') then
			select concat(empname, '님은 초지일관 하십시오.');
		when (jobm = '대리') then
			select concat(empname, '님은 좀 더 분발하십시오.');
        when (jobm = '과장') then
			select concat(empname, '님은 좀 더 분발하십시오.');   
		when (jobm = '부장') then
			select concat(empname, '님은 정년이 다되어가는군요!');
		when (jobm = '차장') then
			select concat(empname, '님은 정년이 다 되어가는군요!');
		when (jobm = '사장') then
			select concat(empname, '님은 정년이 다 되어가는군요!');
	end case;
end $$
delimiter ;

call empproc5case('김사랑');
call empproc5case('오지호');

# 문제 158
create table multiple(
						no int auto_increment primary key,
                        prime_number int
					);
                    
select * from multiple;

# 문제 159
drop procedure if exists multi_proc;
delimiter $$
create procedure multi_proc(in num int)
begin

   declare i int;
    declare j int;
    set i=2;
   
    select prime_number
      from multiple;
      
   
    while(i <= num) do   -- 외부 반복문
      
      set j=2;
      
      while(j <= i) do      -- 내부 반목문
      
        -- i를 2~j로 나눠서 0으로 나눠 떨어지고, i=j이면 i는 소수이다. i를 저장하고 i를 넘긴다.
        -- i를 2~j로 나눠서 0으로 나눠 떨어졌는데 i=j이면 i는 소수가 절대 아님 i를 넘긴다.
        -- i를 2~j로 나눠서 0으로 나눠 떨어지지지 않고 있으면 i는 소수 일 수도 있다. -> i를 j만큼 마저 진행한다. -> j=j+1
        if(mod(i,j) = 0) then
        
			if(i=j) then
				insert into multiple values (null, i);
				set j=i+1;
			else
				set j=i+1;
			end if;
         
        else
			set j=j+1;
            
		end if;
        
       end while;
      
       set i=i+1;
       
   end while;

end $$
delimiter ;

call multi_proc(1000);

select *
  from multiple;
# 문제 160
drop procedure if exists sawon;
delimiter $$
create procedure sawon(in jobname varchar(20))
begin
	set @sqlquery = concat('select * from emp where job = "', jobname, '";');
    prepare myquery from @sqlquery;
    execute myquery;
    deallocate prepare myquery;
end $$
delimiter ;

call sawon('사원');

# 문제 161
drop procedure if exists gupyeo;
delimiter $$
create procedure gupyeo(in empname varchar(8))
begin
	declare dno int;
	select deptno into dno from emp where ename = empname;
    
    if(dno = 20) then
		update emp set sal = sal*1.1 where ename = empname;
	else
		update emp set sal = sal*1.05 where ename = empname;
	end if;
    
end $$
delimiter ;

call gupyeo('김사랑');
call gupyeo('한예슬');
