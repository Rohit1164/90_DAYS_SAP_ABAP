REPORT zreports;
"ABAP Internal Tables: Sorting, Searching, LOOP Variants


TYPES: BEGIN OF lty_employee,
        emp_id TYPE string,
        emp_name TYPE string,
        emp_dept TYPE string,
        emp_salary TYPE i,
       END OF lty_employee.

DATA: lt_employee STANDARD TABLE OF lty_employee,
      wa_employee TYPE lty_employee,
      lv_count TYPE i.

      
SELECT emp_id emp_name emp_dept emp_salary 
    FROM ZEMPLOYEE 
    INTO TABLE lt_employee.
      
SORT lt_employee BY emp_dept ASCENDING.

READ TABLE lt_employee INTO wa_employee WITH KEY emp_dept='Finance'.
  IF sy-subrc = 0.
    WRITE: 'EMP found',wa_employee-emp_name.
  ENDIF.

wa_employee-emp_id='1001'.
wa_employee-emp_name='Rohit'.
wa_employee-emp_dept='IT'.
wa_employee-emp_salary= 30000.
APPEND wa_employee TO lt_employee.

wa_employee-emp_id='1002'.
wa_employee-emp_name='Mohit'.
wa_employee-emp_dept='Mechanical'.
wa_employee-emp_salary= 20000.
APPEND wa_employee TO lt_employee.

wa_employee-emp_id='1003'.
wa_employee-emp_name='Sohit'.
wa_employee-emp_dept='Finance'.
wa_employee-emp_salary= 35000.
APPEND wa_employee TO lt_employee.

" Count Finance Employees
CLEAR lv_count.
LOOP AT lt_employee INTO wa_employee WHERE emp_dept = 'Finance'.
    lv_count = lv_count + 1 .
ENDLOOP.
WRITE : / 'Total Finance Employees: ', lv_count .

LOOP AT lt_employee INTO wa_employee.
  WRITE: /  'Employee ID',wa_employee-emp_id,
            'Employee name',wa_employee-emp_name,
            'Employee department',wa_employee-emp_dept,
            'Employee salary',wa_employee-emp_salary.
ENDLOOP.