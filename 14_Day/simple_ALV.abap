REPORT zsimple_ALV.

TYPE-POOLS: slis.

TYPES: BEGIN OF lty_employee,
        emp_id TYPE string,
        emp_name TYPE string,
        emp_dept TYPE string,
        emp_salary TYPE p DECIMALS 2.
      END OF lty_employee.
DATA: lt_employee STANDARD TABLE OF lty_employee,
      wa_employee TYPE lty_employee.
DATA: lt_field TYPE  slis_t_fieldcat_alv,
      ls_field TYPE slis_fieldcat_alv.

SELECT emp_id emp_name emp_dept emp_salary 
  FROM ZEMPLOYEE
  INTO TABLE lt_employee.
  
CLEAR ls_field.
ls_field-fieldname='EMP_ID'.
ls_field-seltext_m='ID'.
APPEND ls_field TO lt_field.

CLEAR ls_field.
ls_field-fieldname='EMP_NAME'.
ls_field-seltext_m='name'.
APPEND ls_field TO lt_field.

CLEAR ls_field.
ls_field-fieldname='EMP_DEPT'.
ls_field-seltext_m='Department'.
APPEND ls_field TO lt_field.

CLEAR ls_field.
ls_field-fieldname='EMP_SALARY'.
ls_field-seltext_m='salary'.
APPEND ls_field TO lt_field.

" Display ALV
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat = lt_field
  TABLES 
    t_outtab = lt_employee
  EXCEPTIONS
    OTHERS      = 1.