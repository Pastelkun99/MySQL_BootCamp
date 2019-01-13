-- mysql의 내장 함수들

-- if는 '만약 ~~라면' 이라는 뜻이다. 즉 100>200 결과가 참이면 1번째 값 출력,
-- 거짓이면 2번째 값 출력한다.
select if ( 100 > 200, '참이다', '거짓이다');

-- ifnull은 1번째 인자가 null이면 2번째 인자값을 출력하고
-- 1번째 인자값이 null이 아니면 그 값을 출력한다.
select ifnull(null, '널이군요'), ifnull(100, '널이군요');

-- nullif는 1번째 인자값과 2번쨰 인자값이 같으면 null을 반환한다.
-- 같지 않다면 1번째 인자값을 출력한다.
select nullif(100,100), ifnull(200, '널이군요');

-- 프로그래밍 언어에서도 나오는 switch문과 비슷하다.
-- case가 10이면 when 10에 걸려서 then 그때 '십'을 출력한다.
-- case when then else and 형태로 기억하면 된다.
select case 10
	   when 1 then '일'
	   when 5 then '오'
       when 10 then '십'
       else '모름'
       end;
       
-- ascII 함수는 인자의 값을 아스키코드값으로 출력한다.
-- 'A'는 아스키코드 값으로 65이다. 아스키코드표를 출력해서 자신의 PC옆에 붙여 두도록 하자.
select ascii('A'),char(65);

-- mysql은 문자셋을 utf-8을 사용한다. utf-8의 경우는 영문은 1바이트, 한글은 3바이트를 사용한다.
-- 하여, bit_length()는 비트수를 반환하고, char_length()는 문자열의 길이를 반환하고,
-- length()는 바이트수를 리턴하여 준다.
-- 한가지 더 말해주면 앞으로 배우게 될 자바는 euc-kr을 사용한다.
-- 근데 이 문자셋은 한글이 2바이트이다. 하지만, 네트워크 송수신이나 파일 입출력에서는 통상 utf-8을 사용한다.

select bit_length('abc'), char_length('abc'), length('abc');
select bit_length('가나다'), char_length('가나다'), length('가나다');

-- 문자열 함수를 시작

-- concat_ws()는 첫번쨰 인자값을 가지고 뒤에 오는 인자값들을 구분 지어준다.
select count_ws('/', '2020', '02', '09');

-- 찾기 함수들이다.
-- 결과를 보면 이해하기 수월하다. elt()는 첫번째 인자값의 인자값의 인덱스에 가서 있는 것을 출력해주는 것이고,
-- field는 첫번째 값과 동일한 것의 인덱스를 반환해준다.
-- find_in_set()은 첫번째 인자값을 문자열의 값중 어디 있는지 위치를 반환해주고,
-- instr()은 첫번째 인자값중
-- 두 번째 인자값이 시작하는 위치를 반환한다. locate()는 instr()과 동일하지만 인자값만 뒤바뀌었다.
select elt(2, '하나', '둘', '셋'), field('둘', '하나', '둘','셋'),
		find_in_set('둘', '하나,둘,셋'), instr('하나둘셋', '둘'),
        locate('둘', '하나둘셋');
        
-- format은 엑셀의 round()와 유사하다. 소숫자리 지졍하는데 반올림을 해준다.
-- 그리고 1000단위 구분도 해준다.
select format(123456, 123456, 4);

-- bin()은 인자값을 이진수로, hex()는 16진수로, oct()는 8진수로 변환해준다.
-- 진법변환 못하면 안된다. 모르면 강의하자.

select bin(31), oct(31), hex(31);

-- insert()는 replace개념과 같다. 3번째부터 4번쨰 자리를 !!!!로 대체하라는 함수이다.
select insert('abcdefghi', 3, 4, '!!!!'), insert('abcdefghi', 3, 2, '!!!!');

-- left()는 왼쪽에서 3자를, right() 오른쪽에서 3자를 출력한다.
select left('abcdefg', 3), right('abcdefg', 3);

-- ucase는 대문자로, lcase는 소문자로 변환한다.
select ucase('abCd'), lcase('AbCD');

-- 뒤의 결과와 동일하다. 둘중 하무거나 사용해도 된다.
select lower('abCd'), upper('AbCD');

-- ltrim(), rtrim()은 문자열의 왼쪽/오른쪽 공백을 제거한다. 단 중간의 공백은 사라지지 않는다.
select ltrim('		mysql'), rtrim('mysql			');

-- trim()은 양쪽 공백 다 제거한다. trim(both.. from..)은 양쪽의 'ㅋ'문자를 지운다.
select trim('	이것이 mysql이다. 		'), trim(both 'ㅋ' from 'ㅋㅋㅋㅋ재밌네요ㅋㅋㅋㅋ');

-- trim(leading ... from) 왼쪽의 'ㅋ'문자를 지운다.
select trim(leading 'ㅋ' from 'ㅋㅋㅋㅋㅋ재밌네요ㅋㅋㅋㅋㅋ');

-- trim(trailing 'ㅋ' from) 은 오른쪽의 'ㅋ'문자를 지운다.
select trim(trailing 'ㅋ' from 'ㅋㅋㅋㅋㅋ재밌네요ㅋㅋㅋㅋㅋ');

-- repeat은 인자값을 반복한다.
select repeat('이것이 mysql이다.', 5);

-- replace()는 문자열 대치 함수이다.
select replace('이것이 mysql이다.', 'mysql이', 'java');

-- reverse() 는 문자열 뒤집기
select reverse('mysql');

-- space()는 공백을 만들어준다.
select concat('이것이', space(30), 'mysql이다.');

-- substring()는 문자열 잘라내기 함수이다.
select substring('우리나라만세', 5, 2);

-- substring_index() 는 구분자 . 을 가지고 2쨰 이후는 출력하지 않게 한다.
select substring_index('cafe.naver.com', '.', 2);

-- -2가 되어버리면 오른쪽부터 시작하여 2번째로는 출력하지 않게된다.
select substring_index('cafe.naver.com', '.', -2);