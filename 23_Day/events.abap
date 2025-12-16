*---------------------------------------------------------------------*
* FULL COMBINED ALV EVENTS PROGRAM
*---------------------------------------------------------------------*
REPORT z_full_alv_events.

TABLES: mara.

DATA: gt_data   TYPE TABLE OF mara,
      gs_data   TYPE mara,
      gt_fcat   TYPE slis_t_fieldcat_alv,
      gs_fcat   TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv,
      gs_sort   TYPE slis_sortinfo_alv.

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

"------------------------------------------------------------
" Internal table to capture changed data
"------------------------------------------------------------
DATA: gt_changed TYPE REF TO cl_alv_changed_data_protocol.

*---------------------------------------------------------------------*
* EVENT HANDLER CLASS
*---------------------------------------------------------------------*
CLASS lcl_events DEFINITION.

  public section
    METHODS
    on_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column,

    on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id

    on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,
    
    on_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data.

ENDCLASS.

*---------------------------------------------------------------------*
* IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_events IMPLEMENTATION.

  "----------------------------------------------------------
  " DOUBLE CLICK → Show MATNR
  "----------------------------------------------------------
  METHOD on_double_click.
    READ TABLE gt_data INTO gs_data INDEX e_row-index.
    IF sy-subrc = 0.
      MESSAGE |Double-click MATNR: { gs_data-matnr }| TYPE 'I'.
    ENDIF.
  ENDMETHOD.

  "----------------------------------------------------------
  " HOTSPOT CLICK → Show MATNR
  "----------------------------------------------------------
  METHOD on_hotspot_click.
    READ TABLE gt_data INTO gs_data INDEX e_row_id.
    IF sy-subrc = 0.
      MESSAGE |Hotspot clicked: { gs_data-matnr }| TYPE 'I'.
    ENDIF.
  ENDMETHOD.

  
  "----------------------------------------------------------
  " CUSTOM TOOLBAR BUTTONS
  "----------------------------------------------------------
  METHOD on_toolbar.
    Data: ls_btn TYPE stb_button.

    " Refresh button
    ls_btn-function = 'REFRESH'.
    ls_btn-icon     = '@03@'.
    ls_btn-text     = 'Refresh'.
    ls_btn-quickinfo = 'Refresh ALV'.
    APPEND ls_btn TO e_object->mt_toolbar.

    "Details
    ls_btn-function = 'DETAIL'.
    ls_btn-icon     = '@0k@'.
    ls_btn-text     = 'Detail'.
    ls_btn-quickinfo = 'show details'.
    APPEND ls_btn TO e_object->mt_toolbar.

    " Delete button
    ls_btn-function = 'DELETE'.
    ls_btn-icon     = '@04@'.
    ls_btn-text     = 'Delete'.
    ls_btn-quickinfo = 'Delete Row'.
    APPEND ls_btn TO e_object->mt_toolbar.

  ENDMETHOD.


  "----------------------------------------------------------
  " HANDLE BUTTON ACTIONS
  "----------------------------------------------------------
   METHOD on_user_command.
    CASE e_ucomm.

      WHEN 'REFRESH'.
        go_alv->refresh_table_display( ).
        MESSAGE 'ALV refreshed successfully.' TYPE 'S'.

      WHEN 'DETAIL'.
        READ TABLE gt_data INTO gs_data INDEX 1.
        MESSAGE |MATNR Detail Example: { gs_data-matnr }| TYPE 'I'.

      WHEN 'DELETE'.
        DELETE gt_data INDEX 1.
        go_alv->refresh_table_display( ).
        MESSAGE 'Top row deleted.' TYPE 'S'.

    ENDCASE.
  ENDMETHOD.

  "----------------------------------------------------------
  " DATA_CHANGED EVENT (Editable ALV)
  "----------------------------------------------------------
  METHOD on_data_changed.
    DATA(ls_mod) = er_data->mt_good_cells.

    LOOP AT ls_mod INTO DATA(ls_cell).
      READ TABLE gt_data INTO gs_data INDEX ls_cell-row_id.
      IF sy-subrc = 0.
        ASSIGN COMPONENT ls_cell-fieldname OF STRUCTURE gs_data TO FIELD-SYMBOL(<fs>).
        IF <fs> IS ASSIGNED.
          <fs> = ls_cell-value.
          MODIFY gt_data FROM gs_data INDEX ls_cell-row_id.
        ENDIF.
      ENDIF.
    ENDLOOP.

    MESSAGE 'Data changed in ALV.' TYPE 'S'.
  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* CREATE SELECTION SCREEN 
*---------------------------------------------------------------------*

select * FROM mara INTO TABLE gt_data UP TO 30 ROWS.

CALL SCREEN 100.

*---------------------------------------------------------------------*
* SCREEN 100 PBO
*---------------------------------------------------------------------*
MODULE pbo OUTPUT.

  SET PF-STATUS 'MAIN'.

  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING container_name = 'CC_ALV'.

    CREATE OBJECT go_alv
      EXPORTING i_parent = go_container.

    "------------------------------------------
    " Build automatic field catalog (TASK 4)
    "------------------------------------------
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_program_name     = sy-repid
        i_internal_tabname = 'GT_DATA'
        i_inclname         = sy-repid
      CHANGING
        ct_fieldcat        = gt_fcat.

    " Make MATNR hotspot
    LOOP AT gt_fcat INTO gs_fcat.
      IF gs_fcat-fieldname = 'MATNR'.
        gs_fcat-hotspot = 'X'.
      ENDIF.
      MODIFY gt_fcat FROM gs_fcat.
    ENDLOOP.

    " Make FIELD editable
    LOOP AT gt_fcat INTO gs_fcat.
      IF gs_fcat-fieldname = 'MEINS'.
        gs_fcat-edit = 'X'.
      ENDIF.
      MODIFY gt_fcat FROM gs_fcat.
    ENDLOOP.

    "------------------------------------------
    " Create event handler object
    "------------------------------------------
    DATA(lo_events) = NEW lcl_events( ).

    SET HANDLER lo_events->on_double_click FOR go_alv.
    SET HANDLER lo_events->on_hotspot_click FOR go_alv.
    SET HANDLER lo_events->on_toolbar FOR go_alv.
    SET HANDLER lo_events->on_user_command FOR go_alv.
    SET HANDLER lo_events->on_data_changed FOR go_alv.

    "------------------------------------------
    " Display ALV
    "------------------------------------------
    go_alv->set_table_for_first_display(
      EXPORTING
        is_layout       = gs_layout
        it_fieldcatalog = gt_fcat
      CHANGING
        it_outtab       = gt_data ).

  ENDIF.

ENDMODULE.

*---------------------------------------------------------------------*
* SCREEN 100 PAI
*---------------------------------------------------------------------*
MODULE pai INPUT.
  " Nothing required
ENDMODULE.