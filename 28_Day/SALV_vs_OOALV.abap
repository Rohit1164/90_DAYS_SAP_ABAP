
TABLES:MARA.

DATA: gt_data TYPE TABLE OF mara,
      go_salv TYPE REF TO cl_salv_table,
      go_columns TYPE REF TO cl_salv_columns_table,
      go_column TYPE REF TO cl_salv_column_table,
      go_events TYPE REF TO cl_salv_events_table,
      lv_count TYPE i.

SELECT matkl matnr mtart meins
FROM mara
into TABLE gt_data
up TO 40 ROWS.

lv_count = lines( gt_data ).

cl_salv_table=>factory(
  IMPORTING
    r_salv_table = go_salv
    CHANGING
    t_table      = gt_data
).

go_events = go_salv->get_event().
DATA(lo_functions) = go_salv->get_functions( ).
lo_functions->add_button(
  name    = 'ZCOUNT'
  icon    = '@11@'
  text    = 'SHOW COUNT'
  tooltip = 'Show total material count'
  position = if_salv_c_function_position=>right_of_salv_functions
).

go_salv->get_display_settings()->set_list_header(
  'Material Master Analysis Report').
go_salv->get_display_settings()->set_striped_pattern( abap_true ).

go_columns = go_salv->get_columns().
go_columns->set_optimize( abap_true ).

TRY.
    go_column ?= go_columns->get_column( 'MATNR' ).
    go_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
    CATCH cx_salv_not_found.
ENDTRY.

go_salv->get_sorts(  )->add_sort(
  columnname = 'MATKL'
  sequence = if_salv_c_sort=>sort_up
).

CLASS lcl_Button_handler DEFINITION.
  PUBLIC SECTION.
  METHODS on_added_function
  FOR EVENT added_function OF cl_salv_events_table
  IMPORTING e_salv_function.
ENDCLASS.

CLASS lcl_Button_handler IMPLEMENTATION.
  METHOD on_added_function.
    IF e_salv_function = 'ZCOUNT'.
      MESSAGE |Total materials = { lv_count }| TYPE 'I'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

DATA(lo_handler) = NEW lcl_Button_handler(  ).
SET HANDLER lo_handler->on_added_function FOR go_events.

go_salv->display().
