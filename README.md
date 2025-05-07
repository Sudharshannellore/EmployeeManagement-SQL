<body>
  <h1>Employee Management System Database</h1>
  <p>This project involves creating an SQL database schema for managing employee data, jobs, departments, and salaries. The database includes tables for jobs, departments, employees, and salary records, along with their relationships.</p>

  <h2>Table Structure</h2>

  <h3>1. Jobs Table</h3>
  <p>Stores job-related information such as job title and salary range.</p>
  <pre>
  CREATE TABLE jobs (
    jobid INT PRIMARY KEY,
    jobTitle VARCHAR(20),
    maxSalary DOUBLE,
    minSalary DOUBLE
  );
  </pre>

  <h3>2. Departments Table</h3>
  <p>Stores department-related information like department names.</p>
  <pre>
  CREATE TABLE departments (
    departmentid INT PRIMARY KEY,
    dapartmentName VARCHAR(20)
  );

  ALTER TABLE departments RENAME COLUMN dapartmentName TO departmentName;
  </pre>

  <h3>3. Employees Table</h3>
  <p>Stores employee details including their job, department, and salary.</p>
  <pre>
  CREATE TABLE employees (
    employeeid INT PRIMARY KEY,
    firstname VARCHAR(20),
    lastname VARCHAR(20),
    email VARCHAR(20),
    mobile LONG,
    hireDate DATE,
    salary DOUBLE,
    jobid INT,
    departmentid INT,
    FOREIGN KEY (jobid) REFERENCES jobs(jobid),
    FOREIGN KEY (departmentid) REFERENCES departments(departmentid)
  );
  </pre>

  <h3>4. Salaries Table</h3>
  <p>Stores historical salary data for each employee.</p>
  <pre>
  CREATE TABLE salaries (
    salaryid INT PRIMARY KEY,
    employeeid INT,
    SalaryAmount DOUBLE,
    SalaryDate DATE,
    FOREIGN KEY (employeeid) REFERENCES employees(employeeid)
  );
  </pre>

  <h2>Relationships Between Tables</h2>
  <ul>
    <li><strong>jobs</strong> to <strong>employees</strong>: The <code>jobid</code> in the <code>employees</code> table references the <code>jobid</code> in the <code>jobs</code> table.</li>
    <li><strong>departments</strong> to <strong>employees</strong>: The <code>departmentid</code> in the <code>employees</code> table references the <code>departmentid</code> in the <code>departments</code> table.</li>
    <li><strong>employees</strong> to <strong>salaries</strong>: The <code>employeeid</code> in the <code>salaries</code> table references the <code>employeeid</code> in the <code>employees</code> table.</li>
  </ul>

</body>
