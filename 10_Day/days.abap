REPORT zdays.

TYPES: BEGIN of lty_employee
         emp_id   TYPE string,
         emp_name TYPE string,
         emp_city TYPE string,
         emp_pin  TYPE string,
         emp_salary  TYPE p DECIMALS 2,
        END of lty_employee.
         
TYPES: BEGIN OF lty_join,
         emp_id   TYPE string,
         emp_name TYPE string,
         city     TYPE string,
       END OF lty_join.
       
TYPES: BEGIN OF lty_city_count,
          city type string,
          cout type i,
       END OF lty_city_count.
         
DATA: lt_emp TYPE TABLE OF lty_employee,
      wa_emp type lty_employee.
DATA: lt_data TYPE TABLE OF lty_join,
      wa_data TYPE lty_join.
DATA: lt_city_count TYPE TABLE OF lty_city_count,
      wa_city_count TYPE lty_city_count.
DATA: lv_data type i.
DATA: lv_mx_salary  TYPE p DECIMALS 2.
DATA: lv_avg_salary  TYPE p DECIMALS 2.


" Get count of Employees
SELECT COUNT(*) INTO lv_data FROM zemployee.

" Get Max salary of Employee
SELECT MAX(emp_salary) INTO lv_mx_salary FROM zemployee.

" Get Average of Employee
SELECT AVG(emp_salary) INTO lv_avg_salary FROM zemployee.

" Select  All data
SELECT emp_id emp_name emp_city emp_pin emp_salary 
  FROM zemployee 
  INTO TABLE lt_emp.

" Select data using JOIN
SELECT a~emp_id a~emp_name b~city 
  FROM zemployee AS a
  INNER JOIN zaddress AS b
    ON a~emp_id = b~emp_id
  INTO TABLE lt_data.

" Group BY
SELECT emp_city AS city
   COUNT(*) AS cout
  FROM zemployee
  GROUP BY emp_city
  INTO TABLE lt_city_count.

wa_emp-emp_id='1001'.
wa_emp-emp_name='Rohit'.
wa_emp-emp_city='Delhi'.
wa_emp-emp_pin='121212'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id='1002'.
wa_emp-emp_name='Mohit'.
wa_emp-emp_city='Noida'.
wa_emp-emp_pin='313131'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id='1003'.
wa_emp-emp_name='Sohit'.
wa_emp-emp_city='Greater Noida'.
wa_emp-emp_pin='515151'.
APPEND wa_emp TO lt_emp.

LOOP AT lt_emp INTO wa_emp .
  WRITE: wa_emp-emp_id, wa_emp-emp_name.
ENDLOOP.