'202005' ==> 일반적인 달력을 row, col;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, SUM(sal)
FROM emp;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);

JOIN 수업할 때
CROSS JOIN : 데이터 복제할 때....

부서번호 별, 전체 행 별 SAL 합을 구하는 3번째 방법
SELECT DECODE(lv, 1, deptno, 2, null) deptno, SUM(sal) sal
FROM emp, (SELECT LEVEL lv
           FROM dual
           CONNECT BY LEVEL <= 2)
GROUP BY DECODE(lv, 1, deptno, 2, null)
ORDER BY 1;


계층형 쿼리 중요**********
START WITH : 계층 쿼리의 시작점 기술
CONNECT BY : 계층(행)간 연결고리를 표현

zz회사로부터 (최상위 노드)에서 부터 하향식으로 조직구조를 탐색하는 오라클 계층형 쿼리 작성
1. 시작점을 선택 : xx 회사
2. 계층간(행과 행) 연결고리 표현
   PRIOR  내가 현재 읽고 있는 행을 표현
   아무 것도 붙이지 않음 : 내가 앞으로 읽을 행을 표현
   
SELECT *
FROM emp, emp b
WHERE emp.mgr = b.empno;

SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

h_1]
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL - 1) * 3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

h_2]
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd 
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

상향식
시작점 : 디자인팀 - dept0_00_0

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

h_3]
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

h_4]
SELECT LPAD(' ', (LEVEL - 1) * 3) || s_id s_id, value 
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

h_5]
SELECT LPAD(' ', (LEVEL - 1) * 3) || org_cd org_cd, no_emp 
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

CONNECT BY 이후에 이어서 PRIOR가 오지 않아도 상관 없다.
PRIOR는 현재 읽고 있는 행을 지칭하는 키워드


Pruning branch : 가지치기
WHERE절에 조건을 기술했을 때 : 계층형 쿼리를 실행 후 가장 마지막에 적용
CONNECT BY 절에 기술했을 때
의 차이 비교
*단 계층형 쿼리에는 FROM -> START WITH -> CONNECT BY -> WHERE절 순으로 처리된다.

1. WHERE절에 조건을 기술한 경우

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd 
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


2. CONNECT BY 절에 조건을 기술한 경우

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd 
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';


계층형 쿼리에서 사용할 수 있는 특수 함수
CONNECT_BY_ROOT(column) : 해당 컬럼의 최상위 데이터를 조회
SYS_CONNECT_BY_PATH(column, 구분자) : 해당 행을 오기까지 거쳐온 행의 column들을 표현하고 구분자를 통해 연결
CONNECT_BY_ISLEAF 인자가 없음 : 해당 행이 연결이 더 이상 없는 마지막 노드인지 (LEAF 노드)
                              LEAF노드 : 1, NO LEAF 노드 : 0

원본글
  ==답글
    ==답글
원본글
  ==답글
  ==답글

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd,
       CONNECT_BY_ROOT(deptnm)
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd,
       CONNECT_BY_ROOT(deptnm),
       SYS_CONNECT_BY_PATH(deptnm, '-')
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd,
       CONNECT_BY_ROOT(deptnm),
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-')
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;
   
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL - 1) * 3) || deptnm deptnm, p_deptcd,
       CONNECT_BY_ROOT(deptnm),
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-'),
       CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

h_6]
SELECT seq, LPAD(' ', (LEVEL - 1) * 4) || title deptnm
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

h_7] ORDER BY를 쓰면 계층구조가 깨진다
ORDER SIBLINGS BY
SELECT seq, LPAD(' ', (LEVEL - 1) * 4) || title deptnm
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;

h_8]
계층형 쿼리를 정렬시 계층 구조를 유지하면서 정렬하는 기능이 제공
SELECT seq, LPAD(' ', (LEVEL - 1) * 4) || title deptnm
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

h_9] 추가적인 컬럼, 값 생성하여 정렬

ALTER TABLE board_test ADD (gp_no NUMBER);

UPDATE board_test SET gp_no = 4
WHERE seq IN (4, 10, 11, 5, 8, 6, 7);

UPDATE board_test SET gp_no = 2
WHERE seq IN (2, 3);

UPDATE board_test SET gp_no = 1
WHERE seq IN (1, 9);
COMMIT;

SELECT gp_no, CONNECT_BY_ROOT(seq), seq, LPAD(' ', (LEVEL - 1) * 4) || title deptnm
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY CONNECT_BY_ROOT(seq) DESC, seq ASC;


전체 직원 중에 가장 높은 급여를 받는 사람의 급여 정보
근데 그게 누군데???

가장 높은 급여를 받는 사람의 이름

emp테이블을 2번 읽어서 목적은 달성 ==> 조금 더 효율적인 방법이 없을까?? ==> WINDOW / ANALYSIS function
SELECT ename
FROM emp
WHERE sal = (SELECT MAX(sal)
             FROM emp);


ana0]
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC;

SELECT f.ename, f.sal, f.deptno, lv sal_rank
FROM
(SELECT c.*, ROWNUM m
FROM
(SELECT a.*, b.lv
FROM 
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno)a, (SELECT LEVEL lv
                     FROM dual
                     CONNECT BY LEVEL <= 6) b
WHERE a.cnt >= lv
ORDER BY a.deptno, b.lv) c) d,

(SELECT ROWNUM w, e.*
FROM
(SELECT *
FROM emp
ORDER BY deptno, sal DESC) e) f
WHERE d.m = f.w;
