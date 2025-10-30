-- ============================================
-- EMPLOYEE DATABASE - ALL 17 QUERIES
-- Project: ScienceQtech Employee Performance
-- Date: October 27-30, 2025
-- ============================================

USE employee;

-- ============================================
-- QUERY 1: Database Creation
-- ============================================

CREATE DATABASE IF NOT EXISTS employee;
USE employee;

-- Import CSV files using Table Data Import Wizard:
-- 1. emp_record_table.csv
-- 2. data_science_team.csv  
-- 3. proj_table.csv


-- ============================================
-- QUERY 2: ER Diagram
-- ============================================

-- ER Diagram created in MySQL Workbench
-- Relationships:
-- 1. emp_record_table (1) ↔ data_science_team (N) via EMP_ID
-- 2. emp_record_table (1) ↔ proj_table (N) via EMP_ID
-- 3. emp_record_table (1) ↔ emp_record_table (N) via MANAGER_ID (self-reference)


-- ============================================
-- QUERY 3: Basic Employee List
-- ============================================

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    GENDER, 
    DEPT AS DEPARTMENT
FROM emp_record_table;


-- ============================================
-- QUERY 4: Rating-Based Filtering
-- ============================================

-- Employees with rating less than 2
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    GENDER, 
    DEPT AS DEPARTMENT, 
    EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;

-- Employees with rating greater than 4
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    GENDER, 
    DEPT AS DEPARTMENT, 
    EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;

-- Employees with rating between 2 and 4
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    GENDER, 
    DEPT AS DEPARTMENT, 
    EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;


-- ============================================
-- QUERY 5: Name Concatenation (Finance Dept)
-- ============================================

SELECT 
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'Finance';


-- ============================================
-- QUERY 6: Reporting Structure
-- ============================================

SELECT 
    e.EMP_ID, 
    e.FIRST_NAME, 
    e.LAST_NAME, 
    e.MANAGER_ID,
    COUNT(r.EMP_ID) AS REPORTER_COUNT
FROM emp_record_table e
LEFT JOIN emp_record_table r ON e.EMP_ID = r.MANAGER_ID
WHERE e.MANAGER_ID IS NOT NULL
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.MANAGER_ID
HAVING COUNT(r.EMP_ID) > 0
ORDER BY REPORTER_COUNT DESC;


-- ============================================
-- QUERY 7: UNION (Healthcare + Finance)
-- ============================================

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    DEPT AS DEPARTMENT
FROM emp_record_table
WHERE DEPT = 'Healthcare'

UNION

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    DEPT AS DEPARTMENT
FROM emp_record_table
WHERE DEPT = 'Finance';


-- ============================================
-- QUERY 8: Department Summary with Max Rating
-- ============================================

SELECT 
    DEPT AS DEPARTMENT,
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    ROLE, 
    EMP_RATING,
    MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_RATING_IN_DEPT
FROM emp_record_table
ORDER BY DEPT, EMP_RATING DESC;


-- ============================================
-- QUERY 9: Min and Max Salary by Role
-- ============================================

SELECT 
    ROLE, 
    MIN(SALARY) AS MIN_SALARY, 
    MAX(SALARY) AS MAX_SALARY,
    COUNT(*) AS EMPLOYEE_COUNT
FROM emp_record_table
GROUP BY ROLE
ORDER BY ROLE;


-- ============================================
-- QUERY 10: Experience-Based Ranking
-- ============================================

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    EXP AS EXPERIENCE,
    RANK() OVER (ORDER BY EXP DESC) AS EXPERIENCE_RANK
FROM emp_record_table
ORDER BY EXPERIENCE_RANK;


-- ============================================
-- QUERY 11: VIEW Creation (High Salary)
-- ============================================

CREATE OR REPLACE VIEW high_salary_employees AS
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    COUNTRY, 
    SALARY
FROM emp_record_table
WHERE SALARY > 6000;

-- Query the view
SELECT * FROM high_salary_employees;


-- ============================================
-- QUERY 12: Nested Query (High Experience)
-- ============================================

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    EXP AS EXPERIENCE
FROM emp_record_table
WHERE EXP > (
    SELECT AVG(EXP) + 10 
    FROM emp_record_table
);


-- ============================================
-- QUERY 13: Stored Procedure
-- ============================================

DROP PROCEDURE IF EXISTS GetExperiencedEmployees;

DELIMITER //

CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT 
        EMP_ID, 
        FIRST_NAME, 
        LAST_NAME, 
        EXP AS EXPERIENCE,
        ROLE,
        DEPT
    FROM emp_record_table
    WHERE EXP > 3
    ORDER BY EXP DESC;
END //

DELIMITER ;

-- Call the procedure
CALL GetExperiencedEmployees();


-- ============================================
-- QUERY 14: Stored Function (Job Profile)
-- ============================================

DROP FUNCTION IF EXISTS CheckJobProfile;

DELIMITER //

CREATE FUNCTION CheckJobProfile(p_emp_id VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_years INT DEFAULT 0;
    DECLARE v_profile VARCHAR(50);
    
    SELECT IFNULL(EXP, 0) INTO v_years 
    FROM data_science_team 
    WHERE EMP_ID = p_emp_id 
    LIMIT 1;
    
    IF v_years <= 2 THEN 
        SET v_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF v_years <= 5 THEN 
        SET v_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF v_years <= 10 THEN 
        SET v_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF v_years <= 12 THEN 
        SET v_profile = 'LEAD DATA SCIENTIST';
    ELSEIF v_years <= 16 THEN 
        SET v_profile = 'MANAGER';
    ELSE 
        SET v_profile = 'NOT DEFINED';
    END IF;
    
    RETURN v_profile;
END //

DELIMITER ;

-- Use the function
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    EXP,
    CheckJobProfile(EMP_ID) AS JOB_PROFILE
FROM data_science_team
ORDER BY EXP;


-- ============================================
-- QUERY 15: Index Creation
-- ============================================

CREATE INDEX idx_first_name 
ON emp_record_table(FIRST_NAME);

-- Verify index usage
EXPLAIN SELECT * 
FROM emp_record_table 
WHERE FIRST_NAME = 'Eric';

-- Show all indexes
SHOW INDEX FROM emp_record_table;


-- ============================================
-- QUERY 16: Bonus Calculation
-- ============================================

SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    SALARY, 
    EMP_RATING,
    ROUND(SALARY * EMP_RATING * 0.05, 2) AS BONUS
FROM emp_record_table
ORDER BY BONUS DESC;


-- ============================================
-- QUERY 17: Average Salary by Geography
-- ============================================

SELECT 
    CONTINENT, 
    COUNTRY, 
    ROUND(AVG(SALARY), 2) AS AVG_SALARY,
    COUNT(*) AS EMPLOYEE_COUNT,
    MIN(SALARY) AS MIN_SALARY,
    MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, AVG_SALARY DESC;


-- ============================================
-- END OF QUERIES
-- ============================================

-- Summary:
-- Total Queries: 17
-- Database: employee
-- Tables: emp_record_table, data_science_team, proj_table
-- Functions: CheckJobProfile
-- Procedures: GetExperiencedEmployees
-- Views: high_salary_employees
-- Indexes: idx_first_name