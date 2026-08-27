CREATE OR REPLACE FUNCTION CalculateAnnualBonus(
    employee_id INT,
    employee_salary NUMERIC
)
RETURNS NUMERIC(10, 2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN ROUND(employee_salary * 0.10, 2);
END;
$$;

SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       CalculateAnnualBonus(EmployeeID, Salary) AS AnnualBonus
FROM Employees
ORDER BY EmployeeID;

CREATE OR REPLACE VIEW IT_Department_View AS
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE Department = 'IT';

SELECT * FROM IT_Department_View ORDER BY EmployeeID;
