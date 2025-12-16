REPORT zalv_advanced.

TYPE-POOLS: slis.

TYPES: BEGIN OF lty_emp,
         emp_id     TYPE string,
         emp_name   TYPE string,
         emp_dept   TYPE string,
         emp_salary TYPE i,
         row_color  TYPE slis_specialcol_alv,
       END OF lty_emp.

DATA: lt_emp    TYPE TABLE OF lty_emp,
      wa_emp    TYPE lty_emp,
      lt_field  TYPE slis_t_fieldcat_alv,
      ls_field  TYPE slis_fieldcat_alv.

      "ALV Layout Structure
DATA: ls_layout TYPE slis_layout_alv.

      "ALV events
DATA: lt_events TYPE slis_t_event,
      ls_event  TYPE slis_alv_event,

      "Total & SubTotal
DATA: lt_sort   TYPE slis_t_sortinfo_alv,
      ls_sort   TYPE slis_sortinfo_alv,
    

"Fetch Data
SELECT emp_id emp_name emp_dept emp_salary
  FROM zemployee
  INTO TABLE lt_emp.

"Color Finance department
LOOP AT lt_emp INTO wa_emp.
  IF wa_emp-emp_dept = 'Finance'.
      wa_emp-row_color = 'C600'.
      MODIFY lt_emp TO wa_emp.
  ENDIF.
ENDLOOP.

"Field Catalog
CLEAR ls_field.
ls_field-fieldname = 'EMP_ID'.
ls_field-seltext_m = 'Employee ID'.

" for Clickable event
ls_field-hotspot = 'X'.
APPEND ls_field TO lt_field.

CLEAR ls_field.
ls_field-fieldname = 'EMP_NAME'.
ls_field-seltext_m = 'Name'.
APPEND ls_field TO lt_field.

CLEAR ls_field.
ls_field-fieldname = 'EMP_DEPT'.
ls_field-seltext_m = 'Department'.
APPEND ls_field TO lt_field.

CLEAR ls_field.
ls_field-fieldname = 'EMP_SALARY'.
ls_field-seltext_m = 'Salary'.

"Total salary
ls_field-do_sum = 'X'.  
APPEND ls_field TO lt_field.

"DIFFERENT COLOR
ls_layout-zebra = 'X'.

"Automatically width adjust
ls_layout-colwidth_optimize = 'X'.

ls_sort-fieldname = 'EMP_DEPT'.
ls_field-seltext_m = 'Department'.
APPEND ls_sort TO lt_sort.

ls_event-name = 'USER_COMMAND'.
ls_event-form = 'user_command'.
APPEND ls_event TO lt_events.

"Call By PATTTERN
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    is_layout  = ls_layout
    it_fieldcat = lt_field
    it_sort     = lt_sort
    it_events   = lt_events
  TABLES
    t_outtab   = lt_emp.

"Call By PATTTERN
FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  MESSAGE rs_selfield-value TYPE 'I'.
ENDFORM.
