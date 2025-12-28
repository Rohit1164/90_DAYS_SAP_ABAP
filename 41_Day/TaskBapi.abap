REPORT Ztaskbapi.

DATA: ls_head TYPE bapimathead,
      ls_client TYPE bapi_mara,
      ls_clientx TYPE bapi_marax,
      lt_return TYPE TABLE OF bapiret2,
      ls_return TYPE bapiret2,
      lv_error type bapi_bool.

ls_head-material = 'ZMAT1001'.
ls_head-basic_view = 'x'

" ✅ Task 1
ls_client-base_uom = 'KG'.
ls_clientx-base_uom = 'x'.

CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
  EXPORTING
    headdata = ls_head
    clientdata = ls_client
    clientdatax = ls_clientx
  EXPORTING
    return = ls_client


lv_error = abap_false.

LOOP AT lt_return INTO ls_return.
  WRITE: / ls_return-type, ls_return-message.

  IF ls_return-type = 'E' OR ls_return-type = 'A'.
    lv_error = abap_true.
  ENDIF.

ENDLOOP.

IF lv_error = abap_true.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  WRITE: / '❌ Error found – ROLLBACK executed'.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
  WRITE: / '✅ Material updated successfully – COMMIT done'.
ENDIF.