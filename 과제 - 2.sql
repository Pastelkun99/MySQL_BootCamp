use mydb;

create table videotbl(
	video_id int not null auto_increment,
    title varchar(20) not null,
    genre varchar(8) not null,
    star varchar(10),
    primary key(video_id)
    );
    
    insert into videotbl values(null, '태극기휘날리며','전쟁','장동건');
    insert into videotbl values(null, '대부','액션', null);
    insert into videotbl values(null, '반지의 제왕','액션','일라이저우드');
    insert into videotbl values(null, '친구','액션','유오성');
    insert into videotbl values(null, '해리포터','환타지','다니엘');
    insert into videotbl values(null, '형','코미디','조정석');
    
    select *
    from videotbl;
    
    #문제 9
    select *
    from videotbl
    where star is null;
    
    #문제 10
    select *
    from videotbl
    where genre = '액션';
    
    #문제 11
    delete from videotbl where star = '유오성';
    
    select *
    from videotbl;
    
    #문제 12
    update videotbl set title = '동생'
    where title = '형';
    
    select *
    from videotbl;
    
    #문제 13
    truncate videotbl;
    
    select *
    from videotbl;
    
    #문제 14
    drop table videotbl;
    