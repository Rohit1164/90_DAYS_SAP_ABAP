
TYPES: mara.

DATA: gt_mara TYPE STANDARD TABLE OF mara,
      gs_mara TYPE mara.
DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

SELECT matnr mtart matkl ersda
  FROM mara   
  INTO TABLE gt_mara.

gs_fcat-fieldname = matnr.
gs_fcat-edit = 'x'.
APPEND gs_fcat TO gt_fcat.

" Task 1
" MEINS field ke liye validation lagao:
" Blank ❌
" Error message show ho "Unit cannot be blank"

CLASS lcl_event_handler DEFINITION.
  public section.
    METHODS: on_data_changed FOR EVENTS data_changed OF cl_gui_alv_grid
              IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_data_changed.

  DATA ls_mod TYPE lvc_s_modi.
    LOOP AT er_data_changed->mt_good_cells INTO ls_mod.
      IF ls_mod-fieldname = 'MEINS' AND ls_mod-value IS NOT INITIAL.
       er_data_changed->add_protocol_entry(
        i_msgid = '00'
        i_msgno = '001'
        i_msgty = 'E'
        i_msgv1 = 'Unit Cannot be blankk'
        i_fieldname = 'MEINS'
        i_row_id = ls_mod-matnr
       ).
      ENDIF.
ENDLOOP.
ENDMETHOD.


" ✅ Task 2
" SAVE button create karo:
" Data DB me save ho
" Success message aaye

MODULE user_command_0100 INPUT.
 CASE sy-ucomm.
  WHEN 'SAVE'.
    PERFORM save_data.
  WHEN 'BACK'.
    PERFORM LEAVE.
 ENDCASE.
ENDMODULE.

FORM save_data.
LOOP AT gt_mara INTO gs_mara.
  UPDATE mara SET MEINS = gs_mara-MEINS
  WHERE matnr = gs_mara-matnr.
ENDLOOP.

 IF sy-subrc = 0.
    COMMIT WORK.
      MESSAGE 'Data saved successfully ' TYPE 's'
  ELSE
    COMMIT ROLLBACK.
      MESSAGE 'Error when data saving ' TYPE 'e'
 ENDIF.
ENDFORM.
