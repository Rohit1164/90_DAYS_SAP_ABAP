REPORT zdays.

TYPES: BEGIN of lty_employee
         emp_id   TYPE string,
         emp_name TYPE string,
         emp_city TYPE string,
         emp_pin  TYPE string,
         emp_dept  TYPE string,
         emp_salary  TYPE p DECIMALS 2,
        END of lty_employee.

DATA: lt_emp TYPE TABLE OF lty_employee,
      wa_emp TYPE lty_employee.

wa_emp-emp_id='1001'.
wa_emp-emp_name='Rohit'.
wa_emp-emp_city='Delhi'.
wa_emp-emp_pin='121212'.
wa_emp-emp_dept='Machenical'.
wa_emp-emp_salary='12000'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id='1002'.
wa_emp-emp_name='Mohit'.
wa_emp-emp_city='Noida'.
wa_emp-emp_dept='Finance'.
wa_emp-emp_salary='139999'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id='1003'.
wa_emp-emp_name='Sohit'.
wa_emp-emp_city='Greater Noida'.
wa_emp-emp_dept='HR'.
wa_emp-emp_salary='12300'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id='1004'.
wa_emp-emp_name='jit'.
wa_emp-emp_city='Buland shahr'.
wa_emp-emp_dept='ADMIN'.
wa_emp-emp_salary='43000'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id='1005'.
wa_emp-emp_name='Devesh'.
wa_emp-emp_city='Aligarh'.
wa_emp-emp_salary='51200'.
wa_emp-emp_dept='TECHNICIAL'.
APPEND wa_emp TO lt_emp.

SORT lt_emp BY emp_salary ASCENDING.
DELETE lt_emp WHERE emp_city='Delhi'.

data(lv_delhi)= FILTER #(lt_emp WHERE emp_dept='IT'). 
WRITE : / lv_delhi.

LOOP AT lt_emp INTO wa_emp.
  WRITE: /
    'ID', wa_emp-emp_id, 
    'Name ',wa_emp-emp_name,
    'City ',wa_emp-emp_city,
    'Department',wa_emp-emp_dept,
    'Salary',wa_emp-emp_salary.
ENDLOOP.

READ  TABLE lt_emp INTO wa_emp WITH KEY emp_id='1001'.
IF sy-subrc=0.
   WRITE: / 
    'ID', wa_emp-emp_id, 
    'Name ',wa_emp-emp_name,
    'Salary',wa_emp-emp_salary.
ENDIf.

LOOP AT lt_emp INTO wa_emp GROUP BY wa_emp-emp_dept ASCENDING INTO data(ls_group).
  WRITE: / 'Department', ls_group.
ENDLOOP.
