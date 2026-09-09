CREATE TABLE Departments (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(50) UNIQUE NOT NULL,
    Location VARCHAR(50)
);

ALTER TABLE Employees
ADD COLUMN Email VARCHAR(100);

UPDATE Employees
SET Email = LOWER(FirstName || '.' || LastName || EmployeeID || '@company.com');

ALTER TABLE Employees
ADD CONSTRAINT uq_employees_email UNIQUE (Email);

ALTER TABLE Departments
RENAME COLUMN Location TO OfficeLocation;

SELECT EmployeeID, FirstName, LastName, Email
FROM Employees
ORDER BY EmployeeID;
