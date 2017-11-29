-- (8) 查询所有员工工作与奖金的和；
SELECT SUM(SAL)+SUM(COMM) AS SUM  FROM emp;

-- (11)查询工龄大于或等于10年的员工信息；
SELECT * FROM emp WHERE TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')) - TO_NUMBER(TO_CHAR(HIREDATE,'yyyy')) >= 10;

-- (12)查询员工信息，要求以首字母大写的方式显示所有员工的姓名；
SELECT EMPNO,NLS_INITCAP(ENAME) AS ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO FROM emp;

-- (13)查询员工名正好为6个字符的员工信息；
SELECT * FROM emp WHERE LENGTH(ENAME) = 6;

-- (16)查询所有员工姓名的前3个字符；
SELECT SUBSTR(ENAME,1,3) AS ENAME FROM emp;

-- (17)查询所有员工的姓名，如果包含字母“s” ，则用“S” 替换；
SELECT REPLACE(ENAME,'s','S') AS ENAME FROM emp;

-- (20)显示所有员工的姓名、入职的年份和月份，按入职日期所在的月份排序，若月份相同则按入职的年份排序；
SELECT ENAME , TO_NUMBER(TO_CHAR(HIREDATE,'yyyy')) AS HIRE_YEAR , TO_NUMBER(TO_CHAR(HIREDATE,'mm')) AS HIRE_MONTH 
FROM emp ORDER BY HIRE_YEAR ASC , HIRE_MONTH ASC;

-- (21)查询在2月份入职的所有员工信息；
SELECT * FROM emp WHERE TO_NUMBER(TO_CHAR(HIREDATE,'mm')) = 2;

-- (22)查询所有员工入职以来的工作期限，用“**年**月**日”的形式表示；
SELECT ENAME, 
	   (TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')) - TO_NUMBER(TO_CHAR(HIREDATE,'yyyy')))||'年'
	   ||FLOOR(MOD(MONTHS_BETWEEN(SYSDATE,HIREDATE),12))||'月'
	   ||FLOOR(MOD(MONTHS_BETWEEN(SYSDATE,HIREDATE),1)*31)||'日' AS JOB_YEARS,
	   HIREDATE
FROM emp;

-- (37)查询每个部门中的员工数量、平均工资和平均工作年限；
SELECT DEPTNO,
	   COUNT(*) AS EMP_AMOUNT , 
	   AVG(SAL) AS AVG_SAL , 
	   AVG(TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')) - TO_NUMBER(TO_CHAR(HIREDATE,'yyyy'))) AS AVG_YEAR 
FROM emp
GROUP BY DEPTNO;

-- (42)查询10号部门员工及其领导的信息；
SELECT * FROM emp WHERE DEPTNO = 10 OR EMPNO IN (SELECT MGR FROM emp WHERE DEPTNO = 10)

-- (43)查询各个部门的人数及平均工资；
SELECT DEPTNO,COUNT(*) AS EMP_AMOUNT ,AVG(SAL) AS AVG_SAL FROM emp GROUP BY DEPTNO; 

-- (44)查询工资为某个部门平均工资的员工信息；
SELECT emp.*
FROM emp
WHERE emp.SAL IN (
	SELECT AVG(SAL) AS AVG_SAL FROM emp GROUP BY DEPTNO
) ;

-- (45)查询工资高于本部门平均工资的员工信息；
SELECT emp.*
FROM emp
JOIN(
	SELECT DEPTNO,AVG(SAL) AS AVG_SAL FROM emp GROUP BY DEPTNO
) temp
ON temp.DEPTNO = emp.DEPTNO
WHERE emp.SAL > temp.AVG_SAL;

-- (46)查询工资高于本部门平均工资的员工信息及其部门的平均工资；
SELECT emp.*,temp.AVG_SAL
FROM emp
JOIN(
	SELECT DEPTNO,AVG(SAL) AS AVG_SAL FROM emp GROUP BY DEPTNO
) temp
ON temp.DEPTNO = emp.DEPTNO
WHERE emp.SAL > temp.AVG_SAL;
