" Task 1:
" Ek ALV banao jisme:
" MATNR hotspot
" MEINS editable
" Zebra ON
" Column width optimize ON
REPORT zalv_task.

TABLES:mara.

DATA: gt_data TYPE TABLE OF mara,
      gs_data TYPE mara,
      gt_fcal TYPE TABLE OF slis_t_fieldcat_alv,
      gs_fcat TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv.

" DATA: go_container TYPE REF TO cl_gui_custom_container,
"       go_alv TYPE REF TO cl_gui_alv_grid.

select * from mara INTO Table gt_data UP TO 50 ROWS.

"-------------------------------
" Field Catalog – MATNR (Hotspot)
"-------------------------------
CLEAR gs_fcat.
gs_fcat-fieldname = 'MATNR'.
gs_fcat-seltext_m = 'Material'.
gs_fcat-hotspot   = 'X'.
APPEND gs_fcat TO gt_fcat.

"-------------------------------
" Field Catalog – MEINS (Editable)
"-------------------------------
CLEAR gs_fcat.
gs_fcat-fieldname = 'MEINS'.
gs_fcat-seltext_m = 'UOM'.
gs_fcat-edit     = 'X'.
APPEND gs_fcat TO gt_fcat.

"-------------------------------
" Layout Settings
"-------------------------------
gs_layout-zebra             = 'X'.
gs_layout-colwidth_optimize = 'X'.

"-------------------------------
" ALV Display
"-------------------------------
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program = sy-repid
    is_layout          = gs_layout
    it_fieldcat        = gt_fcat
  TABLES
    t_outtab           = gt_data.

" Task 2:
" Custom button “SHOW MATERIAL COUNT” banao jiska function code ZSHOW ho.
" Click karne par message:
" Total materials = <number>

" Task 3:
" Hotspot click par selected MATNR popup me show karo.

" Task 4:
" Editable MEINS change karke refresh update check karo.