-- 2번 다음 요구사항을 읽고 개체, 속성, 관계를 식별할 후 “학사관리DB”를 구축하시오

drop database if exists 학사관리_DB;
drop user if exists 학사관리_DB@localhos;
create database if not exists 학사관리_DB;
-- create user 학사관리_DB@localhost  identified with mysql_native_password by 'qwer1234!';
grant all privileges on 학사관리_db.* to pam7462@localhost with grant option;
use 학사관리_DB;

create table 학과(
	학과번호 varchar(10) not null,
    학과명 varchar(20) not null,
    학과전화번호 varchar(14) not null,
    primary key(학과번호)
);
desc 학과;

create table 학생(
	학생번호 varchar(10) not null,
    학생이름 varchar(20) not null,
    학생주민번호 varchar(14) not null,
    학생주소 varchar(100) not null,
    학생전화번호 varchar(14) not null,
	학생이메일  varchar(30) not null,
    소속학과번호  varchar(10) not null,
    primary key(학생번호),
    foreign key(소속학과번호) references 학과(학과번호)
);
desc 학생;

create table 교수(
	교수번호 varchar(10) not null,
    교수이름 varchar(20) not null,
    교수주민번호 varchar(14) not null,
    교수주소 varchar(100) not null,
    교수전화번호 varchar(30) not null,
    교수이메일 varchar(20) not null,
    소속학과번호  varchar(10) not null,
    primary key(교수번호),
    foreign key(소속학과번호) references 학과(학과번호)
);
desc 교수;

create table 담당(
	학생번호 varchar(10) not null,
    교수번호 varchar(10) not null,
    학년학기 varchar(10), 
    primary key(학생번호,교수번호),
    foreign key(학생번호) references 학생(학생번호),
    foreign key(교수번호) references 교수(교수번호)
);
desc 담당;

create table 강좌(
	강좌번호 varchar(10) not null,
    교수번호 varchar(10) not null,
    강좌명 varchar(45) not null,
    취득학점 varchar(5),
    강의시간 varchar(45),
    강의실정보 varchar(45),
    primary key(강좌번호),
    foreign key(교수번호) references 교수(교수번호)
);
desc 강좌;

create table 수강내역(
	출석점수 varchar(5),
    중간고사점수 varchar(5),
    기말고사점수 varchar(5),
    기타점수 varchar(5),
    총점 varchar(5),
    평점 varchar(5),
    학생번호 varchar(10) not null,
    강좌번호 varchar(10) not null,
    교수번호 varchar(10) not null,
    primary key(학생번호,강좌번호,교수번호),
    foreign key(학생번호) references 학생(학생번호),
    foreign key(강좌번호) references 강좌(강좌번호),
    foreign key(교수번호) references 교수(교수번호)
);
desc 수강내역;

-- 3번 구현된 데이터베이스에 관련 자료를 입력하시오(자료의 개수는 상관이 없으며 무결성이 유지되도록 입력하시오)

insert into 학과 values('0001','컴퓨터학과','010-1111-1111');
insert into 학과 values('0002','학과1','010-1111-1112');
select * from 학과;

insert into 학생 values('s001','학생1','111111-1111111','인천','010-1111-2222','s1@gmail.com','0001');
insert into 학생 values('s002','학생2','111111-1111112','인천','010-1111-3333','s2@gmail.com','0001');
insert into 학생 values('s003','학생3','111111-1111113','부천','010-1111-4444','s3@gmail.com','0002');
insert into 학생 values('s004','학생4','111111-1111114','부천','010-1111-5555','s4@gmail.com','0002');
select * from 학생;

insert into 교수 values('p001','교수1','222222-2222221','인천','010-2222-3333','p1@gamil.com','0001');
insert into 교수 values('p002','교수2','222222-2222222','부천','010-2222-4444','p2@gamil.com','0001');
insert into 교수 values('p003','교수3','222222-2222223','부천','010-2222-5555','p3@gamil.com','0002');
insert into 교수 values('p004','교수4','222222-2222224','인천','010-2222-6666','p4@gamil.com','0002');
select * from 교수;

insert into 담당 values('s001','p001','1/1');
insert into 담당 values('s002','p002','1/1');
insert into 담당 values('s003','p003','2/1');
select * from 담당;

insert into 강좌 values('c001','p001','강좌1',1,'40','1호');
insert into 강좌 values('c002','p002','강좌2',2,'60','2호');
insert into 강좌 values('c003','p003','강좌3',null,null,null);
insert into 강좌 values('c004','p004','강좌4',2,'60','4호');

select * from 강좌;

insert into 수강내역 values('A','B','C','D','A','B','s001','c001','p001');
insert into 수강내역 values('B','C','D','A','B','C','s002','c002','p001');
insert into 수강내역 values('C','D','A','B','C','D','s003','c004','p002');
insert into 수강내역 values(null,null,null,null,null,null,'s001','c002','p002');
select * from 수강내역;

-- 4번 수강하지 않은 학생의 명단을 출력하시오
select 학생.학생번호 as 학번 , 학생.학생이름 as 성명
from 학생 
where 학생번호 not in(
	select 학생번호 from 수강내역
);

-- 5번 교수별 담당학생 명단을 출력하시오.
select 교수.교수번호 as 교번, 교수.교수이름 as 교수자명, 학생.학생번호 as 학번, 학생.학생이름 as 학생명
from 교수 join 학생 on 교수.소속학과번호=학생.소속학과번호 join 담당 on 교수.교수번호 = 담당.교수번호
group by 학생명;

-- 6번 학과명이 ‘컴퓨터학과’인 자료의 학과번호와 학과명을 각각 ‘0111“,”컴퓨터공학과“로 변경하시오
update 학과 set 학과명='컴퓨터공학과' where 학과명='컴퓨터학과';
SET foreign_key_checks = 0;   
update 학과 set 학과번호='0111' where 학과번호 = '0001';
SET foreign_key_checks = 1;
select * from 학과;

-- 7번 강좌를 진행하지 않는 교수와 관련된 자료를 삭제하시오
select *
from 강좌 join 교수 on 강좌.교수번호=교수.교수번호;

SET foreign_key_checks = 0;   
delete from 교수 where 교수이름 = '교수3';
SET foreign_key_checks = 1;
select * from 교수;


