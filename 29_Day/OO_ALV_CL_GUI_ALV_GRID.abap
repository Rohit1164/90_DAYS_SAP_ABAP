REPORT z_oo_alv_edit.

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      gt_mara      TYPE TABLE OF mara,
      gt_fcat      TYPE lvc_t_fcat.

"Fetch Data
SELECT matnr mtart meins
  FROM mara
  INTO TABLE gt_mara
  UP TO 20 ROWS.

CALL SCREEN 100.

" PBO (Process Before Output)
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ZALV'.
  SET TITLEBAR 'ALV'.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING container_name = 'CC_ALV'.

    CREATE OBJECT go_grid
      EXPORTING i_parent = go_container.

    PERFORM build_fcat.
    PERFORM display_alv.
  ENDIF.
ENDMODULE.

Field Catalog (Editable Field)
FORM build_fcat.
  DATA ls_fcat TYPE lvc_s_fcat.

  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-coltext = 'Material'.
  APPEND ls_fcat TO gt_fcat.

  ls_fcat-fieldname = 'MEINS'.
  ls_fcat-coltext = 'UOM'.
  ls_fcat-edit = 'X'.
  APPEND ls_fcat TO gt_fcat.
ENDFORM.

FORM display_alv.
  go_grid->set_table_for_first_display(
    EXPORTING
      i_structure_name = 'MARA'
    CHANGING
      it_outtab        = gt_mara
      it_fieldcatalog  = gt_fcat ).
ENDFORM.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS handle_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_data_changed.
    MESSAGE 'Data changed in ALV' TYPE 'I'.
  ENDMETHOD.
ENDCLASS.

DATA go_handler TYPE REF TO lcl_event_handler.
CREATE OBJECT go_handler.
SET HANDLER go_handler->handle_data_changed FOR go_grid.


