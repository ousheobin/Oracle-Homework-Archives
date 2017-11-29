-- 1.创建数据表
-- 1.1 创建 student 表
CREATE TABLE student (
  sno CHAR(10) PRIMARY KEY,
  sname VARCHAR(8),
  sex CHAR(2) DEFAULT '男',
  birthday DATE,
  sdept CHAR(20),
  CONSTRAINT chk_sex CHECK(SEX = '男' OR SEX = '女' )
);

-- 1.2 创建课程表
CREATE TABLE course (
  cno CHAR(10) PRIMARY KEY,
  cname  CHAR(30) UNIQUE,
  ccredit  NUMBER(3)
);

-- 1.3 创建成绩表
CREATE TABLE score (
  sno CHAR(10),
  cno CHAR(10),
  grade NUMBER(3),
  CONSTRAINT pk_score PRIMARY KEY(sno,cno),
  CONSTRAINT chk_grade CHECK( grade >= 0 AND grade <= 100),
  CONSTRAINT fk_score_sno FOREIGN KEY (sno) REFERENCES student(sno), 
  CONSTRAINT fk_score_cno FOREIGN KEY (cno) REFERENCES course(cno) 
);

-- 2. 增加、修改和删除字段

-- 2.1 向student表新增memo字段
ALTER TABLE student ADD memo VARCHAR2(200);
-- 2.2 修改memo的字段类型
ALTER TABLE student MODIFY (memo VARCHAR2(300));
-- 2.3 删除memo字段
ALTER TABLE student DROP COLUMN memo;

-- 3.向表中添加数据，更新数据，删除数据并验证约束
-- 3.1 插入若干行，验证主键约束，唯一性约束以及默认值约束
-- 3.1.1 Student 学生表
INSERT INTO student(sno,sname,sex,birthday,sdept) VALUES ('2017001','Sam','男',to_date('1999-07-01','YYYY-MM-DD'),'计算机工程学院');
-- 验证主键约束
INSERT INTO student(sno,sname,sex,birthday,sdept) VALUES ('2017001','Tom','男',to_date('1999-07-01','YYYY-MM-DD'),'计算机工程学院');
-- 验证性别约束
INSERT INTO student(sno,sname,sex,birthday,sdept) VALUES ('2017002','Jenny','哈',to_date('1999-07-01','YYYY-MM-DD'),'计算机工程学院');
-- 验证默认值
INSERT INTO student(sno,sname,birthday,sdept) VALUES ('2017003','Raj',to_date('1999-07-01','YYYY-MM-DD'),'计算机工程学院');

-- 3.1.2 Course 课程表
INSERT INTO course(cno,cname,ccredit) VALUES ('001','Oracle 数据库设计',2);
-- 验证课程名唯一性约束
INSERT INTO course(cno,cname,ccredit) VALUES ('002','Oracle 数据库设计',2);
-- 验证主键唯一性约束
INSERT INTO course(cno,cname,ccredit) VALUES ('001','Mysql 课程设计',2);
-- 验证学分限制
INSERT INTO course(cno,cname,ccredit) VALUES ('003','Sql Server 数据库设计',2000);

-- 3.1.3 Score 成绩表
INSERT INTO score(sno,cno,grade) VALUES ('2017001','001',90);
-- 验证主键唯一性约束
INSERT INTO score(sno,cno,grade) VALUES ('2017001','001',80);
-- 验证成绩约束
INSERT INTO score(sno,cno,grade) VALUES ('2017002','001',101);
INSERT INTO score(sno,cno,grade) VALUES ('2017002','001',-1);
-- 验证学生表外键约束
INSERT INTO score(sno,cno,grade) VALUES ('2017002','005',90);
-- 验证课程表外键约束
INSERT INTO score(sno,cno,grade) VALUES ('2017000','001',90);

-- 3.2 使用UPDATE更新数据 验证外键约束
-- 验证课程-成绩约束
UPDATE score SET CNO = '005' WHERE sno = '2017001' AND cno = '001'; 
UPDATE course SET CNO = '005' WHERE cno = '001';
-- 验证学生-成绩约束
UPDATE score SET SNO = '2017002' WHERE sno = '2017001' AND cno = '001'; 
UPDATE student SET SNO = '2017101' WHERE sno = '2017001';
-- 正确修改
UPDATE score SET sno = '2017003' WHERE sno = '2017001' AND cno = '001'; 

-- 3.3 使用DELETE删除数据
DELETE FROM score WHERE sno = '2017003' AND cno = '001'; 
DELETE FROM course WHERE cno = '001'; 
DELETE FROM student WHERE sno = '2017001'; 
DELETE FROM student;

-- 4.删除表
DROP TABLE score;
DROP TABLE course;
DROP TABLE student;