create database mvc2_db;
use mvc2_db;

create table board(
	BOARD_NUM int, 								#게시글 번호
    BOARD_NAME varchar(20) not null,            #작성자 
    BOARD_PASS varchar(20) not null,			#암호  
    BOARD_SUBJECT varchar(500) not null,		#제목  
    BOARD_CONTENT varchar(5000) not null,       #내용  
    BOARD_FILE varchar(500) not null,			#첨부파일
    BOARD_RE_REF int not null,
    BOARD_RE_LEV int not null,
    BOARD_RE_SEQ int not null,
    BOARD_READCOUNT int default 0,				  #조회수
    BOARD_DATE date,   							  #작성일
    PRIMARY KEY(BOARD_NUM)
    );
    
delete from board where board_num = 2;
drop table board;
select * from board;
truncate board;

select max(board_num)+1 from board; 
select BOARD_PASS from board where BOARD_NUM = 1;
show engine innodb status;
show processlist;
kill 62;

update board set BOARD_SUBJECT = '섹스', BOARD_CONTENT = '하고싶다', BOARD_NAME = '이수호' where BOARD_NUM = 1;