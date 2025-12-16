REPORT zcall_smartform.

*--- Employee structure
TYPES: BEGIN OF ty_emp,
         emp_id  TYPE i,
         name    TYPE string,
         salary  TYPE p LENGTH 10 DECIMALS 2,
       END OF ty_emp.

DATA: it_emp TYPE TABLE OF ty_emp.
*--- SmartForm FM Call
DATA: lv_fm_name TYPE rs38l_fnam.

*--- Sample Data
APPEND VALUE #( emp_id = 101 name = 'Rohit' salary = '55000.50' ) TO it_emp.
APPEND VALUE #( emp_id = 102 name = 'Amit'  salary = '62000.00' ) TO it_emp.
APPEND VALUE #( emp_id = 103 name = 'Neha'  salary = '72000.75' ) TO it_emp.


CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname = 'Z_EMP_SAL_FORM'  "Your SmartForm name
  IMPORTING
    fm_name  = lv_fm_name.

IF lv_fm_name IS NOT INITIAL.
  CALL FUNCTION lv_fm_name
    EXPORTING
      it_emp = it_emp
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.

  IF sy-subrc = 0.
    WRITE: 'SmartForm called successfully ✅'.
  ELSE.
    WRITE: 'Error calling SmartForm ❌ SUBRC:', sy-subrc.
  ENDIF.
ELSE.
  WRITE: 'SmartForm FM Name not generated ❌'.
ENDIF.
