date ���� �ǽ� fn3]

���ڿ�         =>              ��¥      ==>     ������ ��¥�� ����      ==>         ����
    TO_DATE('201912', 'YYYYMM')

SELECT TO_DATE(:YYYYMM, 'YYYYMM'),
       LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),
       TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';
      (empno = 7369)

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


Plan hash value: 3956160932
 
 �����ȹ�� ���� ����(id) ***sql d ���� �߿� ���� ���� --����(?) ��� �� �ڼ��� ���
 * �鿩���� �Ǿ� ������ �ڽ� ���۷��̼�
 1. ������ �Ʒ���
   *�� �ڽ� ���۷��̼��� ������ �ڽĺ��� �д´�.
   
   1 ==> 0
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 | -- �÷� 8���� ���� �׳� ������
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 | --1�� 0�� �ڽ� ���۷��̼� / ���� �б�
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
    1 - filter("EMPNO"=7369) -- 14�� ������ �߿� ���� ������ �����ϴ� �����͸� ����� �������� ���͸��� ��
    

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter(TO_CHAR("EMPNO")='7369')
    
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("EMPNO"=7369)
   
-- emp ���̺����� �μ����� ����.
-- ���̺��� �������� �� ��, � ���� ���� ���� ���� �����ȹ�� Ȯ���ؾ� �Ѵ�.

SELECT ename, sal, TO_CHAR(sal, 'L0009,999.00') fm_sal --L : ������
FROM emp;

NULL�� ���õ� �Լ�
NVL
NVL2
NULLIF
COALESCE;

�� null ó���� �ؾ��ұ�?
NULL�� ���� �������� NULL�̴�.

���� �� emp ���̺��� �����ϴ� sal, comm �ΰ��� �÷� ���� ���� ���� �˰� �;
������ ���� SQL�� �ۼ�.

SELECT empno, ename, sal, comm, sal + comm AS sal_plus_comm
FROM emp;

NVL(exprl, expr2)
expr1�� null�̸� expr2���� �����ϰ�
expr1�� null�� �ƴϸ� expr1�� ����

SELECT empno, ename, sal, comm, sal + NVL(comm, 0) sal_plus_comm
FROM emp;

REG_DT �÷��� NULL�� ��� ���� ��¥�� ���� ���� ������ ���ڷ� ǥ��
SELECT userid, usernm, reg_dt
FROM users;

SELECT userid, usernm, NVL(reg_dt, LAST_DAY(SYSDATE))
FROM users;