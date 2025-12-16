REPORT z_bdc_emp.

TYPES: BEGIN OF ty_emp,
         emp_id TYPE char10,
         name   TYPE char40,
         dept   TYPE char20,
       END OF ty_emp.

DATA: lt_emp TYPE TABLE OF ty_emp,
      wa_emp TYPE ty_emp.


DATA: lt_bdc TYPE TABLE OF bdcdata,
      wa_bdc TYPE bdcdata.

*--------------------------------------------------------------------
* STEP 1: Build BDC Table
*--------------------------------------------------------------------

* Screen 0100 of PA30
wa_bdc-program  = 'SAPMPA30'.
wa_bdc-dynpro   = '0100'.
wa_bdc-dynbegin = 'X'.
APPEND wa_bdc TO lt_bdc.

* Send PERNR field value using FORM
PERFORM bdc_field USING 'RP50G-PERNR' wa_emp-emp_id.  "Correct PA30 field

*--------------------------------------------------------------------
* BDC FORM ROUTINES
*--------------------------------------------------------------------
FORM bdc_field USING p_fnam p_fval.
  CLEAR wa_bdc.
  wa_bdc-fnam = p_fnam.
  wa_bdc-fval = p_fval.
  APPEND wa_bdc TO lt_bdc.
ENDFORM.

CALL TRANSACTION 'PA30'
  USING lt_bdc
  MODE   'A'
  UPDATE 'S'.

  CALL FUNCTION 'BDC_OPEN_GROUP'
  EXPORTING
    client = sy-mandt
    group  = 'BDCEMP'
    keep   = 'X'.   "Optional: keep session even after success

CALL FUNCTION 'BDC_INSERT'
  EXPORTING
    tcode = 'PA30'
  TABLES
    dynprotab = lt_bdc.

CALL FUNCTION 'BDC_CLOSE_GROUP'.
