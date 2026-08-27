UPDATE Employees
SET Salary = ROUND(Salary * 1.10, 2)
WHERE Department = 'HR';

UPDATE Employees
SET Department = 'Senior IT'
WHERE Salary > 70000.00;

DELETE FROM Employees AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM EmployeeProjects AS ep
    WHERE ep.EmployeeID = e.EmployeeID
);

BEGIN;

INSERT INTO Projects (ProjectName, Budget, StartDate, EndDate)
VALUES ('Data Warehouse', 120000.00, CURRENT_DATE, NULL);

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES (
    (SELECT EmployeeID FROM Employees
     WHERE FirstName = 'Alice' AND LastName = 'Smith'),
    (SELECT ProjectID FROM Projects WHERE ProjectName = 'Data Warehouse'),
    40
);

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES (
    (SELECT EmployeeID FROM Employees
     WHERE FirstName = 'Bob' AND LastName = 'Johnson'),
    (SELECT ProjectID FROM Projects WHERE ProjectName = 'Data Warehouse'),
    60
);

COMMIT;
