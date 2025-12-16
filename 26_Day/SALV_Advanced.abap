REPORT z_salv_advanced.

TABLES: mara.

DATA: gt_mara TYPE TABLE OF mara.
DATA: go_salv TYPE REF TO cl_salv_table.

SELECT matkl matnr mtart meins
  FROM mara
  INTO TABLE gt_mara
  UP TO 20 ROWS.

  cl_salv_table=>factory(
  IMPORTING
    r_salv_table = go_salv
  CHANGING
    t_table      = gt_mara  
).
" Task 1:
DATA(lo_col) = go_salv->get_columns()-get_columns('MARA-MATNR').
lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
go_salv->get_functions( )->set_all( abap_true ).
go_salv->get_display_settings()-set_striped_pattern( abap_true ).
go_salv->get_columns()->set_optimize( abap_true ).

" Task 2:
go_salv->get_sorts( )->add_sort(
  columnname = 'MTART'
  sequence   = if_salv_c_sort=>sort_up ).

" Task 3:
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    METHODS 
    on_link_click FOR EVENT link_click OF cl_salv_events_table
    IMPORTING row column.

    on_double_click FOR EVENT double_click OF cl_salv_events_table
    IMPORTING row column.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_link_click.
    READ TABLE it_mara INTO DATA(ls_mara) INDEX row.
    MESSAGE |Material clicked: { ls_mara-matnr }| TYPE 'I'.
  ENDMETHOD.
  
  "Task 4:
  METHOD on_double_click.
    READ TABLE it_mara INTO DATA(ls_mara) INDEX row.
    MESSAGE |Material double-clicked: { ls_mara-matnr }| TYPE 'I'.
  ENDMETHOD
ENDCLASS.

DATA(lo_events) = go_salv->get_event( ).
DATA(lo_handler) = NEW lcl_handler( ).
SET HANDLER lo_handler->on_link_click FOR lo_events
SET HANDLER lo_handler->on_double_click FOR lo_events

go_salv.display( ).