REPORT z_bdc_error_demo.

DATA: lt_bdcdata TYPE STANDARD TABLE OF bdcdata,
      lt_msg     TYPE STANDARD TABLE OF bdcmsgcoll,
      ls_msg     TYPE bdcmsgcoll,
      lv_msg     TYPE string.

* BDC DATA (Example: XK01)
PERFORM bdc_dynpro USING 'SAPMF02K' '0100'.
PERFORM bdc_field  USING 'BDC_CURSOR' 'RF02K-KTOKK'.
PERFORM bdc_field  USING 'BDC_OKCODE' '/00'.
PERFORM bdc_field  USING 'RF02K-KTOKK' 'Z999'. "❌ Invalid data


CALL TRANSACTION 'XK01'
USING lt_bdcdata
MODE 'E'
UPDATE 'S'
MESSAGES INTO lt_msg.

LOOP AT lt_msg INTO ls_msg.
  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = ls_msg-msgid
      msgnr               = ls_msg-msgnr
      msgv1               = ls_msg-msgv1
      msgv2               = ls_msg-msgv2
      msgv3               = ls_msg-msgv3
      msgv4               = ls_msg-msgv4
    IMPORTING
      message_text_output = lv_msg.

  WRITE: / 'Type:', ls_msg-msgtyp,
           'Message:', lv_msg.
ENDLOOP.

FORM bdc_dynpro USING p_prog p_dynpro.
  APPEND VALUE #( program = p_prog
                  dynpro  = p_dynpro
                  dynbegin = 'X' ) TO lt_bdcdata.
ENDFORM.

FORM bdc_field USING p_name p_value.
  APPEND VALUE #( fnam = p_name
                  fval = p_value ) TO lt_bdcdata.
ENDFORM.
