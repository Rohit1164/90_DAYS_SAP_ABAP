
" ✅ Task 1
FUNCTION 'Z_RFC_TEST'
  IMPORTING 
  VALUE(IV_TEXT) TYPE String.
 EXPORTING
  VALUE(EV_TEXT) type String.

  EV_TEXT = | hello { iv_text } from remote system |.

ENDFUNCTION.

" ✅ Task 2

DATA: lv_msg TYPE String.

CALL FUNCTION 'Z_RFC_TEST'
  DESTINATION 'z_rfc_100'
  IMPORTING 
  IV_TEXT = 'ROHIT'. 
 EXPORTING
  EV_TEXT = lv_msg .

  IF sy-subrc = 0.
    WRITE : / lv_msg.
  ELSE
    WRITE : 'RFC Call Failed:' , lv_message.
  ENDIF

ENDFUNCTION.

" ✅ Task 3

DATA: lv_txt type String, 
      lv_msg TYPE String.

lv_txt = 'Your are okk'

CALL FUNCTION 'Z_RFC_TEST'
  DESTINATION 'z_rfc_100'
  IMPORTING 
    IV_TEXT = lv_txt. 
 EXPORTING
    EV_TEXT = lv_msg .
 exceptions
    system_failure        = 1
    communication_failure = 2
    OTHERS                = 3.


  IF sy-subrc = 0.
    WRITE : / 'RFC call successfully'.
    WRITE : / 'RFC called is ' lv_txt.
  ELSE
    WRITE : 'RFC Call Failed:' , lv_message.
  ENDIF

ENDFUNCTION.
