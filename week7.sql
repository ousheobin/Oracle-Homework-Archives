--  (47)查询工资高于20号部门某个员工工资的员工的信息；
SELECT * FROM emp 
WHERE SAL > (
    SELECT MAX(SAL) 
    FROM emp
    WHERE DEPTNO = 20
);

--  (48)统计各个工种的员工人数与平均工资；
SELECT JOB, COUNT(*) AS EMP_COUNT , AVG(SAL) AS AVG_SAL
FROM emp 
GROUP BY JOB;

--  (49)统计每个部门中各工种的人数与平均工资；
SELECT DEPTNO,JOB, COUNT(*) AS EMP_COUNT , AVG(SAL) AS AVG_SAL
FROM emp 
GROUP BY DEPTNO,JOB;

--  (50)查询工资、奖金与10号部门某员工工资、奖金都相同的员工信息；
SELECT * 
FROM emp 
WHERE (SAL,COMM) IN (
    SELECT SAL,COMM FROM emp WHERE DEPTNO = 10
);

--  (51)查询部门人数大于5的部门的员工信息；
SELECT *
FROM emp
WHERE DEPTNO IN(
    SELECT DEPTNO 
    FROM emp 
    GROUP BY DEPTNO
    HAVING COUNT(*) > 5
);

--  (52)查询所有员工工资都大于2000的部门的信息；
SELECT DEPTNO 
FROM emp 
GROUP BY DEPTNO 
HAVING MIN(SAL) > 2000;

--  (53)查询所有员工工资都大于2000的部门的信息及其员工的信息；
SELECT * 
FROM emp
WHERE DEPTNO IN(
    SELECT DEPTNO 
    FROM emp 
    GROUP BY DEPTNO 
    HAVING MIN(SAL) > 2000
);


--  (54)查询所有员工工资都在2000~3000之间的部门的信息；
SELECT DEPTNO 
FROM emp 
GROUP BY DEPTNO 
HAVING MIN(SAL) >= 2000
AND MAX(SAL) <= 3000;

--  (55)查询所有工资在2000~3000之间的员工所在的部门的员工信息；
SELECT * 
FROM emp
WHERE DEPTNO IN(
    SELECT DEPTNO 
    FROM emp 
    GROUP BY DEPTNO 
    HAVING MIN(SAL) >= 2000
    AND MAX(SAL) <= 3000
);

--  (56)查询每个员工的领导所在部门的信息；

SELECT employees.EMPNO, managers.EMPNO AS MGRNO,manager_dept.*
FROM emp employees
LEFT OUTER JOIN emp managers
ON managers.EMPNO = employees.MGR
LEFT OUTER JOIN dept manager_dept
ON manager_dept.DEPTNO = managers.DEPTNO;


--  (57)查询人数最多的部门信息；
SELECT dept.*
FROM dept 
WHERE DEPTNO = (
    SELECT DEPTNO AS F_COUNT 
    FROM emp 
    GROUP BY DEPTNO
    HAVING COUNT(*) = (
        SELECT MAX(F_COUNT) FROM (
            SELECT DEPTNO,COUNT(*) AS F_COUNT 
            FROM emp 
            GROUP BY DEPTNO
        )temp_count
    )
);

--  (58)查询30号部门中工资排序前3名的员工信息；
SELECT *
FROM(
    SELECT * 
    FROM emp 
    WHERE DEPTNO = 20 
    ORDER BY SAL DESC
)temp
WHERE ROWNUM < 4;

--  (59)查询所有员工中工资排序在5~10名之间的员工信息；
SELECT EMPNO , ENAME ,JOB , MGR , HIREDATE ,SAL ,COMM ,DEPTNO
FROM(
    SELECT ROW_NUMBER() OVER (ORDER BY SAL DESC) AS ROW_NUM ,emp.* 
    FROM emp 
    ORDER BY SAL DESC
)temp
WHERE ROW_NUM >= 5 AND ROW_NUM <= 10;


--  (63)向emp 表中插入一条记录，员工名为FAN，号为8000，其他信息与SMITH员工的信息相同；
INSERT INTO emp 
SELECT 8000 , 'FAN' , JOB , MGR , HIREDATE ,SAL ,COMM ,DEPTNO
FROM emp 
WHERE ENAME = 'SMITH';

--  (64)将各个部门员工的工资修改为该员工所在部门平均工资加1000；     
UPDATE EMP e SET e.SAL = (
    SELECT SAL
    FROM (
        SELECT employees.DEPTNO,AVG(employees.SAL) + 1000 AS SAL
        FROM emp employees
        GROUP BY employees.DEPTNO
    )temp 
    WHERE e.DEPTNO = temp.DEPTNO
);