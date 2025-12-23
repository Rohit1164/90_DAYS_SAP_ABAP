" Task 9: Reusable Validation FM
" Objective: Validate email ID
" Input: IV_EMAIL
" Output: EV_VALID (X / SPACE)
FUNCTION 'z_email'.
  IMPORTING
   IV_EMAIL TYPE String
  EXPORTING
    EV_VALID TYPE String.
  
  DATA: lv_at TYPE i,
        lv_dot TYPE i.
  ev_valid = SPACE.

  FIND @ IN iv_email MATCH OFFSET lv_at.
  FIND '.' IN iv_email MATCH OFFSET lv_dot.



  IF sy-subrc = 0.
    AND lv_at < 0.
    AND lv_dot -> lv_at + 1.
    AND iv_email ='*@*.*'.
    iv_email = 'X'.
  ENDIF.
ENDFUNCTION.

" Task 10: Authorization Check FM
" Objective: Check whether user has authorization for T-Code
" Inputs:
" IV_UNAME
" IV_TCODE
" Output: EV_AUTHORIZED

" 📌 Use AUTHORITY-CHECK
FUNCTION 'z_authorized'.
  IMPORTING
   IV_UNAME TYPE syuname.
   IV_TCODE TYPE tcode.
  EXPORTING
   EV_AUTHORIZED TYPE c.

  EV_AUTHORIZED = SPACE.

    " Authority Check for Transaction Code
  AUTHORITY-CHECK OBJECT 'S_TCODE'
  ID 'TCD ' FIELD IV_TCODE.

IF sy-subrc = 0.
  EV_AUTHORIZED = 'x'.
ENDIF.
ENDFUNCTION.

" Task 11: Logging FM
" Objective:
" Save error logs into ZLOG table
" Inputs: user, date, time, message
" No output

" 📌 Use this FM inside other programs
FUNCTION 'Z_LOGGING_FM'.
  IMPORTING
    DATA(iv_uname) TYPE uname.
    DATA(iv_message) TYPE String.

DATA: ls_log TYPE zlog.
 
ls_log-mandt    = sy-mandt.
  ls_log-uname    = iv_uname.
  ls_log-log_date = sy-datum.
  ls_log-log_time = sy-uzeit.
  ls_log-message  = iv_message.

  INSERT zlog FROM ls_log.
  
 IF sy-subrc <> 0.
    " In real projects this can be extended to SLG1 or dump log
  ENDIF.

ENDFUNCTION.

" Call the method
CALL FUNCTION 'Z_SAVE_LOG'
  EXPORTING
    iv_uname   = sy-uname
    iv_message = 'Invalid company code entered'.

" Task 12: Exception Handling FM
" Objective:
" Create FM with custom exceptions
" ZERO_DIVISION
" INVALID_INPUT

" 📌 Call FM and handle exceptions in report

FUNCTION  'Z_TWO_NUM'.
  IMPORTING
    VALUE(iv_num1) TYPE i.
    VALUE(iv_num2) TYPE i.
  EXPORTING
    VALUE(ev_result) TYPE P DESIMALS 2.
  Exception
  ZERO_DIVISION
  INVALID_INPUT

 IF iv_num1 IS INITIAL AND iv_num2 IS INITIAL.
    RAISE invalid_input.
  ENDIF.

  " Zero division check
  IF iv_num2 = 0.
    RAISE zero_division.
  ENDIF.

  ev_result = iv_num1 / iv_num2.

ENDFUNCTION.