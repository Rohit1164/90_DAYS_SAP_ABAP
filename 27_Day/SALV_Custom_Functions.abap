REPORT z_salv_advanced.

TABLES: mara.

DATA: gt_mara TYPE TABLE OF mara,
      go_salv TYPE REF TO cl_salv_table,
      lv_count TYPE i ,
      go_events   TYPE REF TO cl_salv_events_table,
      go_columns  TYPE REF TO cl_salv_columns_table,
      go_column   TYPE REF TO cl_salv_column_table.
      lv_count = lines( gt_mara ).


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
" SALV report banao jisme:
" Custom button “SHOW COUNT”
" Click par message:
" Total materials = <number>

DATA(lo_events) = go_salv->get_event( ).
DATA(lo_functions) = go_salv->get_functions( ).
lo_functions->add_button(
  name        = 'ZCOUNT'
  icon        = '@11@'
  text        = 'SHOW COUNT'
  tooltip     = 'Show total material count'
   position = if_salv_c_function_position=>right_of_salv_functions
  ).

"   SALV me:
" MATNR hotspot
" Zebra ON
" Column optimize ON
  go_salv->get_display_settings()->set_striped_pattern( abap_true ).
  
  go_columns = go_salv->get_columns( ).
go_columns->set_optimize( abap_true ).

TRY.
    go_column ?= go_columns->get_column( 'MATNR' ).
    go_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    CATCH cx_salv_not_found.
ENDTRY.

" Task 3:
" Sorting lagao by MTART.
go_salv->get_sorts()->add_sort(
  columnname = 'MTART'
  sequence   = if_salv_c_sort=>sort_up ).

go_salv->refresh( ).

CLASS lcl_Button_handler DEFINITION.
  PUBLIC SECTION.
    METHODS on_added_function FOR EVENT added_function OF cl_salv_events_table
    IMPORTING r_salv_table.
ENDCLASS.
CLASS lcl_Button_handler IMPLEMENTATION.
  METHOD on_added_function.
    CASE r_salv_table.
      WHEN ZCOUNT.
      MESSAGE |Total materials = { lv_count }| TYPE 'I'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

DATA(lo_handler) = NEW lcl_Button_handler( ).
SET HANDLER lo_handler->on_show_count FOR lo_events.

" Task 4:
" Code ko production-style me clean karo (comments + naming).

go_salv->display( ).