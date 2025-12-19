PROCESS AFTER INPUT.
  CHAIN.
    FIELD gv_matnr.
    FIELD gv_meins.
    MODULE validate_chain.
  ENDCHAIN.
 
MODULE validate_chain INPUT.
  IF gv_matnr IS INITIAL.
    MESSAGE 'Material Number is mandatory' TYPE 'E'.
  ENDIF.
  IF gv_meins IS INITIAL.
    MESSAGE 'Unit of Measure is mandatory' TYPE 'E'.
  ENDIF.
ENDMODULE.


" ✅ Task 2
" MATNR par:
" ON INPUT message show karo
" ON REQUEST F4 logic add karo (dummy ok).
PROCESS AFTER INPUT.
  FIELD matnr 
  MODULE matnr_on_input ON INPUT.

  MODULE matnr_on_input INPUT.
  IF matnr IS INITIAL.
    MESSAGE 'Please enter Material Number' TYPE 'E'.
  ENDIF.
ENDMODULE.

PROCESS AFTER INPUT.
  FIELD matnr MODULE matnr_f4 ON REQUEST.

MODULE matnr_f4 INPUT.
  MESSAGE 'F4 Help triggered (Dummy Logic)' TYPE 'I'.
ENDMODULE.


" ✅ Task 3
" SAVE button:
" Valid data → success message
AT SELECTION-SCREEN.
  IF sy-ucomm = 'SAVE'.
    MODULE save_data.
  ENDIF.

MODULE save_data.
  IF gv_matnr IS NOT INITIAL AND gv_meins IN NOT INITIAL.
    MESSAGE 'Data saved successfully' TYPE 'S'.
  ELSE.
    MESSAGE 'Please fill all mandatory fields' TYPE 'E'.
  ENDIF.
ENDMODULE.

" ✅ Task 4
" BACK button:
" LEAVE TO SCREEN 0
  IF sy-ucomm = 'BACK'.
    LEAVE TO SCREEN 0.
  ENDIF.