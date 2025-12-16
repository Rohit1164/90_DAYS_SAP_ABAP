REPORT zrohit_first.

TYPES: BEGIN OF lty_data,
         emp_id   TYPE string,
         emp_name TYPE string,
         emp_dept TYPE string,
         emp_add  TYPE string,
       END OF lty_data.

DATA: lt_emp   TYPE TABLE OF lty_data,
      wa_emp   TYPE lty_data,
      lt_delhi TYPE TABLE OF lty_data.

" Sabhi employees database se fetch karo internal table lt_emp me
"SELECT * FROM zemployee INTO TABLE lt_emp.
SELECT * FROM zemployee INTO TABLE lt_emp ORDER BY emp_id DESCENDING.


" Manual records add karne ke liye
wa_emp-emp_id = '1001'.
wa_emp-emp_name = 'Rohit kumar'.
wa_emp-emp_dept = 'finance'.
wa_emp-emp_add = 'Delhi'.
APPEND wa_emp TO lt_emp.

wa_emp-emp_id = '1002'.
wa_emp-emp_name = 'Jitendra kumar'.
wa_emp-emp_dept = 'IT'.
wa_emp-emp_add = 'Noida'.
APPEND wa_emp TO lt_emp.

CLEAR wa_emp.

LOOP AT lt_emp INTO wa_emp WHERE emp_add = 'Delhi'.
  APPEND wa_emp TO lt_delhi.
ENDLOOP.

LOOP AT lt_delhi INTO wa_emp.
  WRITE: / wa_emp-emp_id, wa_emp-emp_name, wa_emp-emp_dept, wa_emp-emp_add.
ENDLOOP.
