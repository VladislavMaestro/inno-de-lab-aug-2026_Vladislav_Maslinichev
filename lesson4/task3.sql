CREATE USER hr_user WITH PASSWORD 'hr_password_1111';

GRANT SELECT ON TABLE Employees TO hr_user;

-- Тест 1 выполняется под hr_user и должен пройти успешно.
--SELECT * FROM Employees;

-- Тест 2 выполняется под hr_user и должен показать ошибку доступа.
--INSERT INTO Employees (FirstName, LastName, Department, Salary, Email)
--VALUES ('Test', 'Denied', 'HR', 50000.00, 'test.denied@company.com');

GRANT INSERT, UPDATE ON TABLE Employees TO hr_user;
GRANT USAGE, SELECT ON SEQUENCE employees_employeeid_seq TO hr_user;

-- Тест 3 выполняется под hr_user после выдачи прав.
--INSERT INTO Employees (FirstName, LastName, Department, Salary, Email)
--VALUES ('Helen', 'Moore', 'HR', 61000.00, 'helen.moore@company.com');

--UPDATE Employees
--SET Salary = 70000.00
--WHERE Email = 'helen.moore@company.com';
