NVL(expr1, expr2)
if expr1 == null
    return expr2
else 
    return expr1
    
NVL2(expr1, exp2, expr3)
if expr1 != null
    return expr2
else 
    return expr3

SELECT empno, ename, sal, comm, NVL2(comm, 100, 200)
FROM emp;


NULLIF(expr1, expr2)
if expr1 == expr2
    return null
else
    return expr1

sal�÷��� ���� 3000�̸� null�� ����
SELECT empno, ename, sal, NULLIF(sal, 3000)
FROM emp


�������� : �Լ��� ������ ������ ������ ���� ����
         �������ڵ��� Ÿ���� �����ؾ� ��
         display("test"), display("test", "test2", "test3")

���ڵ� �߿� ���� ���� ������ NULL�� �ƴ� ���� ���� ����
coalesce(expr1, expr2, expr3......)
if expr1 != null
    return expr1
else
    coalesce(expr2, expr3......)

mgr �÷� null (king)
comm �÷� null (king);

SELECT empno, ename, comm, sal, coalesce(comm, sal)
FROM emp;

fn4]
SELECT empno, ename, mgr, NVL(mgr, 9999) MGR_N, NVL2(mgr, mgr, 9999) MGR_N_1, coalesce(mgr, 9999) MGR_N_2
FROM emp;

fn5]
SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) n_reg_Dt
FROM users
WHERE userid != 'brown';


condition
���ǿ� ���� �÷� Ȥ�� ǥ������ �ٸ� ������ ��ü
java if, switch ���� ����
1. case ����
2. decode �Լ�

1. CASE
CASE
    WHEN ��/������ �Ǻ��� �� �ִ� �� THEN ������ ��
    [WHEN ��/������ �Ǻ��� �� �ִ� �� THEN ������ ��]
    [ELSE ������ �� (�Ǻ����� ���� WHEN ���� ���� ��� ����)]
END

emp ���̺��� ��ϵ� �����鿡�� ���ʽ��� �߰������� ������ ����
�ش� ������ job�� SALESMA�� ��� SAL���� 5% �λ�� �ݾ��� ���ʽ��� ���� (ex: sal 100 -> 105)
�ش� ������ job�� MANAGER�� ��� SAL���� 10% �λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� PRESIDENT�� ��� SAL���� 20% �λ�� �ݾ��� ���ʽ��� ����
�� �� �������� sal��ŭ�� ����

SELECT empno, ename, job, sal, 
       CASE --���� �����Ӱ� ��� ����, ���� �������� ��� ����, ������ �Ϳ� ��� ����
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END bonus
FROM emp;

2. DECODE(EXPR1, search1, return1, search2, return2, search3, return3......, [default]) -- ==�� ��� ����, ������ ����
   DECODE(EXPR1,
   search1, return1,
   search2, return2,
   search3, return3,
   search4, return4,
   search5, return5,
   default);
   
if EXPR1 == search1
    return return1
else if EXPR1 == search3
    return return2
else if EXPR1 == search3
    return return3
......
else
    return default;
    
SELECT empno, ename, job, sal,
       DECODE(job, 'SALESMAN', sal * 1.05,
                   'MANAGER', sal * 1.10,
                   'PRESIDENT', sal * 1.20,
                   sal) bonus
FROM emp;

cond1]
SELECT empno, ename,
       CASE 
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
       END DNAME
FROM emp;

SELECT empno, ename,
       DECODE(deptno, 10, 'ACCOUTING',
                      20, 'RESEARCH',
                      30, 'SALES',
                      40, 'OPERATIONS',
                      'DDIT') DNAME
FROM emp;

cond2] ���� �⵵ ¦/Ȧ��, ������ ����⵵�� ¦/Ȧ��
(1, 1) ==> �����
(1, 0) ==> ������
(0, 1) ==> ������
(0, 0) ==> �����;

SELECT empno, ename, hiredate,
       CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 0 AND MOD(TO_CHAR(SYSDATE+365, 'YYYY'), 2) = 0 THEN '�ǰ����� �����'
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 1 AND MOD(TO_CHAR(SYSDATE+365, 'YYYY'), 2) = 0 THEN '�ǰ����� ������'
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 0 AND MOD(TO_CHAR(SYSDATE+365, 'YYYY'), 2) = 1 THEN '�ǰ����� ������'
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = 1 AND MOD(TO_CHAR(SYSDATE+365, 'YYYY'), 2) = 1 THEN '�ǰ����� �����'
       END CONTACT_TO_DOCTOR
FROM emp;
       
SELECT empno, ename, hiredate,       
       CASE
        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE+365, 'YYYY'), 2) THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
       END CONTACT_TO_DOCTOR
FROM emp;

cond3]
SELECT userid, usernm, addr1 alias, reg_dt, 
       CASE
        WHEN MOD(TO_CHAR(reg_dt, 'yyyy'), 2) = MOD(TO_CHAR(SYSDATE+365, 'yyyy'), 2) THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
       END CONTACTTODOCTOR
FROM users
ORDER BY userid ASC;