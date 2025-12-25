DATA: lv_message TYPE String.

"<---------------------- sRFC -------------------------------
CALL FUNCTION 'z_rfc_call'.
  DESTINATION 'Z_RFC_SALES'
  IMPORTING 
    iv_text = 'rohit'
  EXPORTING
    ev_text = lv_message
  EXCEPTIONS
    system_failure = 1

WRITE : / 'Message for ' , lv_message.

" <----------------------aRFC--------------------------------
CALL FUNCTION 'Z_RFC_CALL'
  STARTING NEW TASK 'TASK1'  
  DESTINATION 'Z_RFC_HR'
  IMPORTING
    iv_emp_salary = 10000
  EXPORTING 
   ev_text = lv_message
  EXCEPTIONS 
    system_failure = 1

WRITE: / 'Your salary is ',lv_message.

" <-----------------------tRFC-------------------------------
CALL FUNCTION 'Z_RFC_CALL'
  IN BACKGROUND TASK
  DESTINATION 'Z_RFC_HR'  
  IMPORTING
    iv_empid      = 102
    iv_emp_salary = 120000

COMMIT WORK.
" <-----------------------qRFC-------------------------------
CALL FUNCTION 'Z_RFC_CALL'
  IN BACKGROUND TASK
  DESTINATION 'Z_RFC_HR'  
  IMPORTING
    iv_empid      = 102
    iv_emp_salary = 120000
COMMIT WORK.