#Tables

create table jobs(
jobid int PRIMARY KEY,
jobTitle varchar(20),
maxSalary double,
minSalary double
);

create table departments(
departmentid int PRIMARY KEY,
dapartmentName varchar(20)
);

alter table departments rename column dapartmentName to departmentName;

create table employee(
employeeid int PRIMARY KEY,
firtname varchar(20),
lastname varchar(20),
email varchar(20),
mobile long,
hireDate date,
salary double,
jobid int,
departmentid int,
FOREIGN KEY (jobid) references jobs(jobid),
FOREIGN KEY (departmentid) references departments(departmentid)
);
alter table employee  rename column firtname to firstname;

alter table employee rename to employees;

create table salaries(
salaryid int PRIMARY KEY,
employeeid int,
SalaryAmount double,
SalaryDate date,
FOREIGN KEY (employeeid) references employee(employeeid)
);

INSERT INTO jobs (jobid, jobTitle, maxSalary, minSalary) VALUES
(1, 'Software Engineer', 120000.00, 50000.00),
(2, 'Data Analyst', 100000.00, 45000.00),
(3, 'Project Manager', 150000.00, 80000.00),
(4, 'HR Manager', 90000.00, 40000.00),
(5, 'Database Developer', 130000.00, 60000.00);

INSERT INTO departments (departmentid, departmentName) VALUES
(1, 'Engineering'),
(2, 'Data Science'),
(3, 'Project Management'),
(4, 'Human Resources'),
(5, 'IT Support');

INSERT INTO employees (employeeid, firstname, lastname, email, mobile, hireDate, salary, jobid, departmentid) VALUES
(1, 'John', 'Doe', 'john@email.com', 9876543210, '2023-01-15', 85000.00, 1, 1),
(2, 'Jane', 'Smith', 'jane@email.com', 9876543211, '2022-06-10', 75000.00, 2, 2),
(3, 'Alice', 'Brown', 'alice@email.com', 9876543212, '2021-09-25', 120000.00, 3, 3),
(4, 'Bob', 'Johnson', 'bob@email.com', 9876543213, '2020-11-18', 95000.00, 4, 4),
(5, 'Charlie', 'Davis', 'charlie@email.com', 9876543214, '2019-05-30', 100000.00, 5, 5),
(6, 'David', 'Wilson', 'david@email.com', 9876543215, '2023-03-12', 93000.00, 1, 1),
(7, 'Eve', 'Moore', 'eve@email.com', 9876543216, '2022-07-20', 88000.00, 2, 2),
(8, 'Frank', 'Miller', 'frank@email.com', 9876543217, '2021-12-01', 115000.00, 3, 3),
(9, 'Grace', 'Clark', 'grace@email.com', 9876543218, '2020-08-14', 125000.00, 4, 4), 
(10, 'Hank', 'Evans', 'hank@email.com', 9876543219, '2018-10-05', 135000.00, 5, 5);

INSERT INTO salaries (salaryid, employeeid, salaryAmount, salaryDate) VALUES
(1, 1, 85000.00, '2024-01-01'),
(2, 2, 75000.00, '2024-01-01'),
(3, 3, 120000.00, '2024-01-01'),
(4, 4, 95000.00, '2024-01-01'),
(5, 5, 100000.00, '2024-01-01'),
(6, 6, 93000.00, '2024-01-01'),
(7, 7, 88000.00, '2024-01-01'),
(8, 8, 115000.00, '2024-01-01'),
(9, 9, 125000.00, '2024-01-01'),
(10, 10, 135000.00, '2024-01-01');

#
commit;

#Retrive All Records
select * from employees;
select * from jobs;
select * from departments;
select * from salaries;

#Retrieve first & last names from employees
select firstname, lastname from employees;

#Retrieve employees who hired after 2020
select * from employees where year(hireDate) > 2020;

#Retrieve employees who's salary greater than 50k
select * from employees where salary > 50000;

#Count number of employees in each department
select count(e.employeeid) as 'no.of employees', d.departmentName  
from employees e, departments d where e.departmentid = d.departmentid group by d.departmentid;

#Retrieve employees descending order by date
select * from employees order by hireDate desc;

#Retrieve employees based on salary between 40k and 90k
select * from employees where salary>40000 and salary < 90000;
select * from employees where salary between 40000 and 90000;

#Get department name of specific employee
select concat(e.firstname, e.lastname) as employeeName, d.departmentName  
from employees e, departments d where e.departmentid = d.departmentid group by e.employeeid;

#Retrieve employees whose firstname starts with J
select * from employees where firstname like 'J%';

#Get the top 3 highest-paid employees
select * from employees order by salary desc limit 3;

#Highest salary of each department
select max(e.salary) as highestSalary, d.departmentName from employees e, departments d 
      where e.departmentid = d.departmentid group by d.departmentid  order by highestSalary desc;

#List employees along with their job titles
select e.*, j.jobTitle from employees e join jobs j on e.jobid = j.jobid;

#Employee who don't have any department
select * from employees where departmentid = null;

#Department wise average salary
select avg(e.salary) as averageSalary, d.departmentName from employees e, departments d 
      where e.departmentid = d.departmentid group by d.departmentid;
      
#Employees with thier jobs      
select * from employees e left join jobs j on e.jobid = j.jobid order by e.employeeid;

#Total salary paid by each department
select sum(e.salary) as totalSalary, d.departmentName from employees e, departments d 
 where e.departmentid = d.departmentid group by d.departmentid;
      
#Employees salary more then department's average salary
select * from employees e1 where e1.salary > 
                         (select avg(e2.salary) from employees e2 
                                         where e1.departmentid = e2.departmentid);
                                                                                  
#Second highest salary
select * from employees order by salary desc limit 1,1;

#Increment 10% on salary
delimiter //
create procedure increment()
    begin
      select *, (salary * 10/100) as increment from employees ;
    end //

call increment(); //

#To prevent inserting employees with a salary lower than minimum salary for their job
DELIMITER $$
create trigger min_sal
     before insert on employees
     for each row
     begin
       declare min_sal_value double;
     
     select minSalary into min_sal_value
         from jobs where jobid = new.jobid;
         
     if new.salary < min_sal_value then
		signal sqlstate '45000'
        set message_text = 'Salary cannot be lower than the minimum salary for this job..!';
     end if;
 end $$
 DELIMITER ; 

#Check above trigger working or not
INSERT INTO employees (employeeid, firstname, lastname, email, mobile, hireDate, salary, jobid, departmentid) VALUES
(11, 'stephen', 'hanks', 'stephen@email.com', 9556646529, '2025-02-05', 55000.00, 5, 5);     

#Optimized query for fetch employess along department and job details
select * from employees e 
			   inner join departments d using(departmentid)
               inner join jobs using(jobid); 
               
#Total salary of each department
select sum(e.salary) as totalSalary, d.departmentName from employees e , departments d
                              where e.departmentid = d.departmentid group by d.departmentid;               

#Index creation for salary queries better performance
create index salaries on employees (salary);

#Checking index
explain select * from employees where salary > 95000;

select * from salaries;

#Implement a view that shows employees along with department and salary details
create view fullemployee as
select concat(e.firstname, e.lastname) as fullname, (e.email), (e.mobile), (e.hireDate)
                 , (d.departmentName), (s.SalaryAmount), (s.SalaryDate) from employees e 
                 inner join departments d using(departmentid)
                             inner join salaries s using(employeeid);
                             
#fullemployee view Check    
select * from fullemployee; 

#Employees works more than 5 years
select * from employees where timestampdiff(year,hireDate, curdate())>5;                       

