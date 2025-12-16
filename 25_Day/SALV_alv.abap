REPORT z_salv_basic.

TABLES: mara.

DATA: gt_mara TYPE TABLE OF mara.
DATA: go_salv TYPE REF TO cl_salv_table.

" Task 3: fetch sirf 20 records
SELECT MATKL matnr mtart meins
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
" SALV use karte hue ek ALV banao jisme:
" Title: "Material Master SALV Report"
" Zebra pattern ON
" Column optimize ON

go_salv->get_display_settings()->set_list_title( 'Material Master SALV Report' ).
go_salv->get_display_settings( )->set_striped_pattern( 'X' ).
go_salv->get_columns( )->set_optimize('x' ).

" Task 2:
" MATKL column ko hide karo.
go_salv->get_columns()->set_column( 'mara-MATKL')->set_visible( 'X' ).


DATA lv_date TYPE string.
lv_date = |Material Report - { sy-datum }|.
lo_alv->get_display_settings( )->set_list_header( lv_date ).


go_salv->display( ).
