-- (1) 查询20号部门的所有员工信息；
SELECT * FROM emp WHERE DEPTNO = 20;

-- (2) 查询所有工种为CLERK 的员工的员工号、员工名和部门号；
SELECT EMPNO,ENAME,DEPTNO FROM emp WHERE JOB = 'CLERK';

-- (3) 查询奖金(COMM) 高于工资(SAL) 的员工信息；
SELECT * FROM emp WHERE COMM > SAL;

-- (4) 查询奖金高于工资的20%的员工信息；
SELECT * FROM emp WHERE COMM > (SAL * 0.20);

-- (5) 查询10号部门中工种为MANAGER 和20号部门中工种为CLERK 的员工的信息；
SELECT * FROM emp WHERE (DEPTNO = 10 AND JOB = 'MANAGER') OR (DEPTNO = 20 AND JOB = 'CLERK');

-- (6) 查询所有工种不是MANAGER 和CLERK ，且工资大于或等于2000的员工的详细信息；
SELECT * FROM emp WHERE JOB NOT IN ('MANAGER','CLERK') AND SAL >= 2000;

-- (7) 查询有奖金的员工的不同工种；
SELECT DISTINCT JOB FROM emp WHERE COMM IS NOT NULL;

-- (9) 查询没有奖金或奖金低于100的员工信息；
SELECT * FROM emp WHERE COMM IS NULL OR  COMM < 100;

-- (14)查询员工名字中不包含字母“S” 的员工；
SELECT * FROM emp WHERE ENAME NOT LIKE '%S%';

-- (15)查询员工姓名的第二个字母为“M”的员工信息；
SELECT * FROM emp WHERE ENAME LIKE '_M%';

-- (18)查询员工的姓名和入职日期，并按入职日期从先到后进行排序；
SELECT ENAME,HIREDATE FROM emp ORDER BY HIREDATE ASC;

-- (19)显示所有员工的姓名、工种、工资和奖金，按工种降序排序，若工种相同则按工资升序排序；
SELECT ENAME,JOB,SAL,COMM FROM emp ORDER BY JOB DESC , SAL ASC;

-- (23)查询至少有一个员工的部门信息；
SELECT Dept.*
FROM Dept
LEFT OUTER JOIN (
	SELECT DEPTNO,COUNT(*) AS f_count FROM emp GROUP BY DEPTNO
)tmp
ON tmp.DEPTNO = Dept.DEPTNO 
WHERE f_count IS NOT NULL 
  AND f_count > 0;

-- (24)查询工资比“SMITH” 员工的工资高的所有员工信息；
SELECT * FROM emp WHERE SAL < (
	SELECT SAL FROM emp WHERE ENAME = 'SMITH' AND ROWNUM <= 1
);

-- (25)查询所有员工的姓名及其直接上级的姓名；
SELECT  employeer.ENAME AS ENAME,
		managers.ENAME AS MGRName
FROM emp employeer
LEFT OUTER JOIN emp managers
ON managers.EMPNO = employeer.MGR;