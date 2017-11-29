-- (1)编写一个PL/SQL块，输出所有员工的员工姓名、员工号、工资和部门号。
DECLARE
	CURSOR c_emp IS SELECT * FROM emp;
	r_emp c_emp%ROWTYPE;
BEGIN
	OPEN c_emp;
	LOOP
		FETCH c_emp INTO r_emp;
		EXIT WHEN c_emp%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Emp Name:'||r_emp.ENAME||' Emp Number: '||r_emp.EMPNO||' Salary: ' ||r_emp.SAL||' Department Number: '||r_emp.DEPTNO);
	END LOOP;
	CLOSE c_emp;
END;

-- (2)编写一个PL/SQL块,输出所有比本部门平均工资高的员工信息。
DECLARE
	CURSOR c_dept_emp IS SELECT * FROM dept;
	r_dept dept%ROWTYPE;
	dept_number dept.DEPTNO%TYPE;
	CURSOR c_emp IS SELECT * FROM emp WHERE DEPTNO = dept_number;
	r_emp c_emp%ROWTYPE;
	v_avg_sal NUMBER;
BEGIN
	OPEN c_dept_emp;
	LOOP
		FETCH c_dept_emp INTO r_dept;
		EXIT WHEN c_dept_emp%NOTFOUND;
		dept_number := r_dept.DEPTNO;
		SELECT AVG(SAL) INTO v_avg_sal FROM emp WHERE DEPTNO = dept_number;
		OPEN c_emp;
		LOOP
			FETCH c_emp INTO r_emp;
			EXIT WHEN c_emp%NOTFOUND;
			IF r_emp.SAL > v_avg_sal THEN
				DBMS_OUTPUT.PUT_LINE('Emp Name:'||r_emp.ENAME||
					' Emp Number: '||r_emp.EMPNO||' Salary: ' ||r_emp.SAL||
					' Department Number: '||r_emp.DEPTNO);
			END IF;
		END LOOP;
		CLOSE c_emp;
	END LOOP;
	CLOSE c_dept_emp;
END;

-- (3)编写一个PL/SQL块,输出所有员工及其部门领导的姓名、员工号及部门号。
DECLARE
	CURSOR c_emp IS SELECT * FROM emp;
	r_emp emp%ROWTYPE;
	r_mgr emp%ROWTYPE;
BEGIN
	OPEN c_emp;
	LOOP
		FETCH c_emp INTO r_emp;
		EXIT WHEN c_emp%NOTFOUND;
		IF r_emp.MGR IS NOT NULL THEN
			SELECT * INTO r_mgr FROM emp WHERE EMPNO = r_emp.MGR;
			DBMS_OUTPUT.PUT_LINE('EMPNO:'||r_emp.EMPNO||' ENAME:'||r_emp.ENAME||' DEPTNO:'||r_emp.DEPTNO
				||' MGRNO:'||r_mgr.EMPNO||' MGRNAME:'||r_mgr.ENAME||' MGRDEPT:'||r_mgr.DEPTNO);
		ELSE
			DBMS_OUTPUT.PUT_LINE('EMPNO:'||r_emp.EMPNO||' ENAME:'||r_emp.ENAME||' DEPTNO:'||r_emp.DEPTNO
				||' MGRNO:NULL MGRNAME:NULL MGRDEPT:NULL');
		END IF;
		
	END LOOP;
	CLOSE c_emp;
END;

-- (4)查询姓为“SMITH"的员工信息，并输出其员工号、姓名、工资、部门号。
--如果该员工不存在，则插入一条新记录，员工号为2012，员工姓名为“Smith”,工资为7500元，入职日期为“2002年3月5日”，部门号为50。
--如果存在多个名“Smith”的员工，则输出所有名为“Smith”的员工号、姓名、工资、入职日期、部门号L。
DECLARE
	CURSOR c_emp IS SELECT * FROM emp WHERE ENAME='SMITH';
	r_emp emp%ROWTYPE;
	v_smith_count NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_smith_count FROM emp WHERE ENAME = 'SMITH';
	IF v_smith_count < 1 THEN
		INSERT INTO emp(EMPNO,ENAME,SAL,HIREDATE,DEPTNO) VALUES (2012,'SMITH',7500,TO_DATE('2002-03-05','yyyy-mm-dd'),50);
	ELSE
		OPEN c_emp;
		LOOP
			FETCH c_emp INTO r_emp;
			EXIT WHEN c_emp%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('Emp Name:'||r_emp.ENAME||' Emp Number: '||r_emp.EMPNO||' Salary: ' ||r_emp.SAL||' Department Number: '||r_emp.DEPTNO);
		END LOOP;
		CLOSE c_emp;
	END IF;
END;

