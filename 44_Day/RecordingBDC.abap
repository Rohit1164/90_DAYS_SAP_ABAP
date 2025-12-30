
" Task 2
PROGRAM  ZMM01_BDC.

DATA: lt_bdcdata TYPE TABLE OF bdcdata,
      ls_bdcdata TYPE bdcdata.

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

" Task 3
START-OF-SELECTION.

  PERFORM bdc_dynpro USING 'SAPLMGMM' '0060'.
  PERFORM bdc_field  USING 'BDC_OKCODE' '=ENTR'.
  PERFORM bdc_field  USING 'RMMG1-MBRSH' 'M'.
  PERFORM bdc_field  USING 'RMMG1-MTART' 'FERT'.

  PERFORM bdc_dynpro USING 'SAPLMGMM' '0070'.
  PERFORM bdc_field  USING 'BDC_OKCODE' '=ENTR'.

  PERFORM bdc_dynpro USING 'SAPLMGMM' '4004'.
  PERFORM bdc_field  USING 'BDC_OKCODE' '=BU'.
  PERFORM bdc_field  USING 'MAKT-MAKTX' 'BDC TEST MATERIAL'.

  CALL TRANSACTION 'MM01'
    USING lt_bdcdata
    MODE  'E'        "ERROR SCREEN MODE
    UPDATE 'S'.

  IF sy-subrc = 0.
    WRITE: 'Material Created Successfully'.
  ELSE.
    WRITE: 'Error Occurred during BDC'.
  ENDIF.
