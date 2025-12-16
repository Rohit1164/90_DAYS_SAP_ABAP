REPORT zreports;

PARAMETERS: p_emp_id TYPE string.

TYPES: BEGIN OF lty_employee
        emp_id TYPE string,
        emp_name TYPE string,
        emp_dept TYPE string,
        emp_salary TYPE i,
END OF lty_employee.

DATA: lt_employee STANDARD TABLE OF lty_employee,
      wa_employee TYPE lty_employee.

SELECT emp_id emp_name emp_dept emp_salary 
  FROM ZEMPLOYEE 
  INTO TABLE lt_employee  
  WHERE emp_id = p_emp_id OR p_emp_id IS INITIAL.

  SELECT emp_id emp_name emp_dept emp_salary 
  FROM ZEMPLOYEE 
  INTO TABLE lt_employee  
  WHERE emp_salary = 20000.

wa_employee-emp_id='1001'.
wa_employee-emp_name='Rohit'.
wa_employee-emp_dept='IT'.
wa_employee-emp_salary= 30000.
APPEND WA_employee TO lt_employee.

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

LOOP AT lt_employee INTO wa_employee.
  WRITE: /  'EMP ID',wa_employee-emp_id,
            'EMP NAME',wa_employee-emp_name,
            'EMP DEPARTMENT',wa_employee-emp_dept.
ENDLOOP.