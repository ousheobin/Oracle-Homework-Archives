-- (26)查询入职日期早于其上级领导的所有员工信息；
SELECT emps.* 
FROM emp emps
INNER JOIN emp mgrs
ON mgrs.EMPNO = emps.MGR
WHERE emps.HIREDATE < mgrs.HIREDATE;

-- (27)查询所有部门及其员工信息，包括那些没有员工的部门；
SELECT dept.DNAME , dept.LOC , emps.* 
FROM dept
LEFT OUTER JOIN emp emps
ON emps.DEPTNO = dept.DEPTNO;

-- (28)查询所有员工及其部门信息，包括那些还不属于任何部门的员工；
SELECT emps.* , dept.DNAME , dept.LOC
FROM emp emps
LEFT OUTER JOIN dept
ON emps.DEPTNO = dept.DEPTNO;

-- (29)查询所有工种为“CLERK” 的员工的姓名及其部门名称；
SELECT ENAME , DNAME
FROM emp 
LEFT OUTER JOIN dept
ON dept.DEPTNO = emp.DEPTNO
WHERE JOB = 'CLERK';

-- (30)查询最低工资大于2500的各种工作；
SELECT JOB 
FROM emp 
GROUP BY JOB
HAVING MIN(SAL) > 2500;

-- (31)查询平均工资低于2000的部门及其员工信息；
SELECT emp.* , dept.DNAME , dept.LOC
FROM dept
INNER JOIN emp
ON emp.DEPTNO = dept.DEPTNO
WHERE dept.DEPTNO IN(
	SELECT DEPTNO 
	FROM emp 
	GROUP BY DEPTNO
	HAVING AVG(SAL) < 2000
);

-- (32)查询在 SALES 部门工作的员工的姓名信息；
SELECT emp.ENAME
FROM dept
INNER JOIN emp
ON emp.DEPTNO = dept.DEPTNO
WHERE DNAME = 'SALES';


-- (33)查询工资高于公司平均工资的所有员工信息；
SELECT * FROM emp
WHERE SAL > (
	SELECT DISTINCT AVG(SAL) 
	FROM emp
);

-- (34)查询与SMITH 员工从事相同工作的所有员工信息；
SELECT * FROM emp
WHERE JOB = (
	SELECT DISTINCT JOB 
	FROM emp 
	WHERE ENAME = 'SMITH'
);

-- (35)列出工资等于30号部门中某个员工工资的所有员工的姓名和工资；
SELECT ENAME,SAL FROM emp WHERE SAL IN(
	SELECT SAL 
	FROM emp 
	WHERE DEPTNO = 30
);

-- (36)查询工资高于30号部门中工作的所有员工的工资的员工姓名和工资；
SELECT ENAME,SAL FROM emp WHERE SAL > (
	SELECT MAX(SAL) 
	FROM emp 
	WHERE DEPTNO = 30
);

-- (38)查询不同部门的同一种工作；
SELECT JOB
FROM(
	SELECT DISTINCT JOB,DEPTNO FROM emp ORDER BY JOB DESC
)jobs_count
GROUP BY JOB
HAVING COUNT(*) > 1;

-- (39)查询各个部门的详细信息以及部门人数、部门平均工资；
SELECT dept.* , 
	   NVL(MEMBER_COUNT,0) AS MEMBER_COUNT,
	   NVL(AVG_SAL,0) AS AVG_SAL
FROM dept 
LEFT OUTER JOIN(
	SELECT DEPTNO , 
		   COUNT(*) AS MEMBER_COUNT , 
		   AVG(SAL) AS AVG_SAL
	FROM emp 
	GROUP BY DEPTNO
)emps
ON emps.DEPTNO = dept.DEPTNO;

-- (40)查询各种工作的最低工资；
SELECT JOB,
	   MIN(SAL) AS MIN_SAL 
FROM emp 
GROUP BY JOB;

-- (41)查询各个部门中不同工种的最高工资；
SELECT dept.*,
	   JOB,
	   temp.MAX_SAL
FROM(
	SELECT DEPTNO,
		   JOB,
		   MAX(SAL) AS MAX_SAL
	FROM emp
	GROUP BY DEPTNO,JOB
)temp
LEFT OUTER JOIN dept
ON dept.DEPTNO = temp.DEPTNO;