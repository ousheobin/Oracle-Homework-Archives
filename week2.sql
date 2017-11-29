-- 创建class、student两个表
CREATE TABLE Class(
  Cno	Number(2) PRIMARY KEY,
  Cname	VARCHAR2(20),
  Num	NUMBER(3)	
);

DESC Class;

CREATE TABLE Student(
  SNO	NUMBER(4) PRIMARY KEY,
  SNAME	VARCHAR2(10) UNIQUE,
  SAGE	NUMBER,
  SEX	CHAR(2),
  CNO	NUMBER(2)
);

DESC Student;

-- 为student表添加一个可以延迟的外键约束，其CNO列参照class表的CNO列。
ALTER TABLE Student ADD CONSTRAINT fk_cno FOREIGN KEY (CNO) REFERENCES Class (Cno) DEFERRABLE;

-- 为student表的SAGE列添加一个检查约束，保证该列取值在0～100之间。
ALTER TABLE Student ADD CONSTRAINT chk_sage CHECK( SAGE BETWEEN 0 AND 100 );

-- 为student表的SEX列添加一个检查约束，保证该列取值为“M”或“F”，且默认值为“M”。
ALTER TABLE student ADD CONSTRAINT chk_sex CHECK(SEX = 'F' OR SEX = 'M' ) MODIFY SEX DEFAULT 'M';

-- 在class表的CNAME列上创建一个唯一性索引。
CREATE UNIQUE INDEX index_unique_cname ON Class(Cname);

-- 利用子查询分别创建一个事务级的临时表和会话级的临时表，其结构与student表的结构相同
--   temp_student_session 会话级临时表
CREATE GLOBAL TEMPORARY TABLE temp_student_session(
  SNO	NUMBER(4) PRIMARY KEY,
  SNAME	VARCHAR2(10) UNIQUE,
  SAGE	NUMBER,
  SEX	CHAR(2),
  CNO	NUMBER(2)
)ON COMMIT PRESERVE ROWS;

--   temp_student_transaction 事务级临时表
CREATE GLOBAL TEMPORARY TABLE temp_student_transaction (
  SNO	NUMBER(4) PRIMARY KEY,
  SNAME	VARCHAR2(10) UNIQUE,
  SAGE	NUMBER,
  SEX	CHAR(2),
  CNO	NUMBER(2)
)ON COMMIT DELETE ROWS;

-- 为SCOTT模式下的表创建一个视图，包含员工号、员工名和该员工领导的员工号、员工名
--   为SCOTT提供创建授权
CONN sys/a AS sysdba;
GRANT CREATE VIEW TO scott;
CONN scott/a;

--   创建视图
CREATE VIEW view_employees AS 
SELECT employee.EMPNO AS emp_no,
       employee.ENAME AS emp_name,
       manager.EMPNO AS mgr_no,
       manager.ENAME AS mgr_name
FROM EMP employee
LEFT OUTER JOIN EMP manager
ON employee.MGR = manager.EMPNO;



