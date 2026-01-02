TYPES: BEGIN OF ty_input,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         meins TYPE mara-meins,
       END OF ty_input.

DATA: gt_input TYPE TABLE OF ty_input,
      gs_input TYPE ty_input.

FORM bdc_dynpro USING program dynpro.
  CLEAR ls_bdcdata.
  ls_bdcdata-program  = program.
  ls_bdcdata-dynpro   = dynpro.
  ls_bdcdata-dynbegin = 'X'.
  APPEND ls_bdcdata TO lt_bdcdata.
ENDFORM.

FORM bdc_field USING fnam fval.
  CLEAR ls_bdcdata.
  ls_bdcdata-fnam = fnam.
  ls_bdcdata-fval = fval.
  APPEND ls_bdcdata TO lt_bdcdata.
ENDFORM.

LOOP AT gt_input INTO gs_input.

  CLEAR: lt_bdcdata, lt_msg.

  PERFORM bdc_dynpro USING 'SAPLMGMM' '0060'.
  PERFORM bdc_field  USING 'BDC_OKCODE' '=ENTR'.
  PERFORM bdc_field  USING 'RMMG1-MATNR' gs_input-matnr.
  PERFORM bdc_field  USING 'RMMG1-MTART' gs_input-mtart.

  CALL TRANSACTION 'MM01'
    USING lt_bdcdata
    MODE 'E'
    UPDATE 'S'
    MESSAGES INTO lt_msg.

  READ TABLE lt_msg WITH KEY msgtyp = 'E' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    WRITE: / 'Error for material:', gs_input-matnr.
  ELSE.
    WRITE: / 'Material created:', gs_input-matnr.
  ENDIF.

ENDLOOP.
