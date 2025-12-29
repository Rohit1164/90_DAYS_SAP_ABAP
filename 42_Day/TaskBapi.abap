REPORT 'ztaskbapi'

DATA: lt_data STANDARD TABLE TYPE OF lty_data,
      ls_data TYPE lty_data,
      lt_return STANDARD TABLE TYPE OF bapiret2,
      ls_return TYPE bapiret2,
      lv_error TYPE bapi_bool.

" ✅ Task 2
LOOP AT lt_data INTO ls_data.
  CALL FUNCTION 'BAPI_XXXX_CREATE'
    IMPORTING
      input_feild1 = ls_data-feild1 
      input_feild2 = ls_data-feild2
    EXPORTING
      return = lt_return

      lv_error = abap_false.

    LOOP AT lt_return INTO ls_return.
      IF ls_return-TYPE = 'E'.
        lv_error = abap_true.
        EXIT.
      ENDIF
    ENDLOOP.

    IF lv_error = abap_true.
      EXIT.
    ENDIF.

ENDLOOP.

IF lv_error = abap_true.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    EXPORTING
      WRITE: / ' Data not saved ' .
ELSE
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
    wait = 'x'.
      WRITE : 'Data saved Successfully' .
ENDIF.