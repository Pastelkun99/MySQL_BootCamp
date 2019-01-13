use mydb;

-- 룡구씨
select A.ename, A.empno, A.deptno, B.dname
from emp A
inner join dept B
on A.deptno = B.deptno
where A.empno = 1001;


-- 문제 98
drop procedure if exists deptname_if_proc;

delimiter //
create procedure deptname_if_proc()
begin
	declare empt int;
    
    select deptno into empt
    from emp
    where empno = 1001;
    
    if empt = 20 then
		select ename, empno, concat('인사부') as '부서명'
        from emp
        where empno = 1001;
	end if;
    
end //
delimiter ;

call deptname_if_proc();

-- 문제 99
drop procedure if exists yearsal_if_else_proc;

delimiter //
create procedure yearsal_if_else_proc()
begin
	declare salary int;
    declare commision int;
    
    select sal into salary
    from emp
    where empno = 1001;
    
    select comm into commision
    from emp
    where empno = 1001;
    
    if (commision is null) then set salary = (salary*12);
    else set salary = (salary*12)+commision;
    end if;
    
    select ename, empno, salary as '연봉'
    from emp
    where empno = 1001;
    
end // 
delimiter ;
call yearsal_if_else_proc();
		
        
-- 문제 100
drop procedure if exists deptname_if_proc;

delimiter //
create procedure deptname_if_proc()
begin
	declare empt int;
    
    select deptno into empt
    from emp
    where empno = 1001;
    
    if empt = 10 then
		select ename, empno, concat('경리부') as '부서명'
        from emp
        where empno = 1001;
	elseif empt = 20 then
		select ename, empno, concat('인사부') as '부서명'
        from emp
        where empno = 1001;
	elseif empt = 30 then
		select ename, empno, concat('영업부') as '부서명'
        from emp
        where empno = 1001;
	elseif empt = 40 then
		select ename, empno, concat('전산부') as '부서명'
        from emp
        where empno = 1001;
	end if;
end //
delimiter ;
call deptname_if_proc();

-- 문제 101
drop procedure if exists usp_emp;

delimiter //
create procedure usp_emp()
begin
		select empno, ename, sal, comm, deptno
        from emp
        where comm is null
        order by empno;
end //
delimiter ;

call usp_emp();

-- 문제 102
drop procedure if exists hakjum;

delimiter //
create procedure hakjum()
begin
	declare jumsu int;
    declare hak varchar(2);
    
    set jumsu = 88;
    
    if jumsu >= 95 then
		set hak = 'A+';
	elseif jumsu >= 90 then
		set hak = 'A';
	elseif jumsu >= 85 then
		set hak = 'B+';
	elseif jumsu >= 80 then
		set hak = 'B';
	elseif jumsu >= 75 then
		set hak = 'C+';
	elseif jumsu >= 70 then
		set hak = 'C';
	elseif jumsu >= 65 then
		set hak = 'D+';
	elseif jumsu >= 60 then
		set hak = 'D';
	elseif jumsu < 60 then
		set hak = 'F';
	end if;
    
	select concat('취득점수는 ', jumsu, '이며, 학점은 ', hak, '입니다.') as '출력결과';
    
end //
delimiter ;
call hakjum();

-- 문제 103
drop procedure if exists hakjum2;

delimiter //
create procedure hakjum2()
begin
	declare jumsu int;
    declare hak varchar(2);
    
    set jumsu = 88;
    
    case
		when jumsu >= 95 then
			set hak = 'A+';
		when jumsu >= 90 then
			set hak = 'A';
		when jumsu >= 85 then
			set hak = 'B+';
		when jumsu >= 80 then
			set hak = 'B';
		when jumsu >= 75 then
			set hak = 'C+';
		when jumsu >= 70 then
			set hak = 'C';
		when jumsu >= 65 then
			set hak = 'D+';
		when jumsu >= 60 then
			set hak = 'D';
		when jumsu < 60 then
			set hak = 'F';
		end case;
        
	select concat('취득점수는 ', jumsu, '이며, 학점은 ', hak, '입니다.') as '출력결과';
    
end //
delimiter ;
call hakjum2();

-- 문제 104
drop procedure if exists salavg;

delimiter //
create procedure salavg()
begin
	declare sazang int;
    declare buzang int;
    declare chazang int;
    declare gwazang int;
    declare daeri int;
    declare sawon int;
    
    select sum(sal) into sazang
    from emp
    where job = '사장';
    
    select sum(sal) into buzang
    from emp
    where job = '부장';
    
    select sum(sal) into gwazang
    from emp
    where job = '과장';
    
    select sum(sal) into chazang
    from emp
    where job = '차장';
    
    select sum(sal) into daeri
    from emp
    where job = '대리';
    
    select sum(sal) into sawon
    from emp
    where job = '사원';
    
    if sazang >= 1 then
     set sazang = sazang;
	elseif buzang >= 1 then
     set buzang = buzang/4;
	elseif chazang >= 1 then
	 set chazang = chazang;
	elseif sawon >= 1 then
     set sawon = sawon/4;
	elseif daeri >= 1 then
     set daeri = daeri;
	elseif gwazang >= 1 then
     set gwazang = gwazang/3;
	end if;
     
	select concat('사장의 직급별 평균 급여 : ', sazang),
		   concat('과장의 직급별 평균 급여 : ', gwazang),
           concat('부장의 직급별 평균 급여 : ', buzang),
           concat('차장의 직급별 평균 급여 : ', chazang),
           concat('대리의 직급별 평균 급여 : ', daeri),
           concat('사원의 직급별 평균 급여 : ', sawon);
end //
delimiter ;

call salavg();
    

-- 문제 105
drop procedure if exists season;

delimiter //
create procedure season()
begin

	declare dal int;
    declare ss varchar(3);
    
    set dal = 5;

    case
		when (dal = 1 || dal = 12 || dal = 2) then
			set ss = '겨울';
		when (dal = 3 || dal = 4 || dal = 5) then
			set ss = '봄';
		when (dal = 6 || dal = 7 || dal = 8) then
			set ss = '여름';
		when (dal = 9 || dal = 10 || dal = 11) then
			set ss = '가을';
	end case;
    
    select concat(dal, '월은 ', ss, '입니다.') as '출력결과';

end //
delimiter ;

call season();

-- 문제 106
drop procedure if exists calculator;

delimiter //
create procedure calculator()
begin
	declare firstint int;
    declare secondint int;
    declare result int;
	declare buho varchar(1);
    declare gyesan varchar(10);
    
    set firstint = 10;
    set secondint = 5;
    set buho = '*';
    
	case
		when buho = '+' then
			set result = firstint + secondint;
            set gyesan = '합';
		when buho = '-' then
			set result = firstint - secondint;
            set gyesan = '차';
		when buho = '*' then
			set result = firstint * secondint;
            set gyesan = '곱';
		when buho = '/' then
			set result = firstint / secondint;
            set gyesan = '몫';
	end case;
    
    select concat(firstint, '와 ', secondint, '의 ', gyesan, '은',  result, '입니다.') as '출력결과';
end //
delimiter ;
call calculator();

-- 문제 107
drop procedure if exists jumin;

delimiter //
create procedure jumin()
begin
	declare bunho varchar(20);
    declare beforeafter varchar(5);
    declare gender varchar(5);
	
    set bunho = '9304241676235';
    
    if substring(bunho, 7, 1) = 1 then
		set beforeafter = '이전에';
        set gender = '남자';
	elseif substring(bunho, 7, 1) = 2 then
		set beforeafter = '이전에';
        set gender = '여자';
	elseif substring(bunho, 7, 1) = 3 then
		set beforeafter = '이후에';
        set gender = '남자';
	elseif substring(bunho, 7, 1) = 4 then
		set beforeafter = '이후에';
        set gender = '여자';
	end if;
    
    select concat('당신은 2000년 ', beforeafter, ' 출생한 ', gender, '입니다.') as '출력결과';
    
end //
delimiter ;

call jumin();

-- 문제 108
drop procedure if exists happroc;

delimiter //
create procedure happroc()
begin
	declare i int;
    declare hap int;
    
    set i = 0;
    set hap = 0;
    
    while(i <= 100) do
    if( (i % 6 ) = 0) then
		set i = i + 1;
        set hap = hap + 0;
	else
		set i = i + 1;
		set hap = hap + i;
	end if;
    end while;
    
    select hap as '합계';
    
end //
delimiter ;

call happroc();
    
-- 문제 109
drop procedure if exists happroc2;

delimiter //
create procedure happroc2()
begin
	declare i int;
    declare hap int;
    
    set i = 0;
    set hap = 0;
    
    while(i <= 1000) do
    if ( (i % 7) = 0) then
		set i = i + 1;
	elseif ( (i % 9) = 0) then
		set i = i + 1;
	else
		set i = i + 1;
        set hap = hap + i;
	end if;
    end while;
    
    select hap as '합계';
end //
delimiter ;

call happroc2();

-- 문제 110
drop procedure if exists wolgup;

delimiter //
create procedure wolgup()
begin
	declare job varchar(5);
    declare don varchar(10);
    
    set job = '차장';
    
    case
		when job = '상무' then
			set don = '1000만원';
		when job = '부장' then
			set don = '800만원';
		when job = '차장' then
			set don = '600만원';
		when job = '과장' then
			set don = '400만원';
		when job = '대리' then
			set don = '250만원';
		when job = '사원' then
			set don = '180만원';
	end case;
    
    select concat(job, '의 월급은 ', don, '입니다.') as '출력결과';
    
end //
delimiter ;

call wolgup();
    
