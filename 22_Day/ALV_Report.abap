report zreport.

TABLES:mara.
DATA:slic.

TYPES: begin of lty_mara,
          matnr TYPE mara-matnr,
          ersda TYPE mara-ersda,
          matkl TYPE mara-matkl,
        end of lty_mara.

DATA: it_emp TYPE TABLE OF lty_mara,
      wa_emp TYPE  lty_mara.

DATA: gt_emp TYPE TABLE OF slic_t_fieldcat_alv,
      gs_emp TYPE  slic_fieldcat_alv.

select matnr ersda matkl from mara UP TO 50 ROWS into TABLE it_emp.


" IT_LIST_HEADER — header (optional)
" IT_FIELDCAT — field catalog (mandatory for control)
" I_CALLBACK_PROGRAM / I_CALLBACK_PF_STATUS — events (advanced)
" I_SAVE — save layout (optional)
" FIELDNAME — internal table का field name (मस्ट)
" COLTEXT — column header text (display name)
" OUTPUTLEN — column width
" DATATYPE — डेटा का type (optional)
" DECIMALS — decimal places (numeric के लिए)
" NO_OUT — यदि column hide करना हो
" HOTSPOT / ICON / EMPHASIZE — formatting options (advanced)

"--- build fieldcatalog
CLEAR gs_emp.
gs_emp-fieldname = 'MATNR'. " must match structure field name (uppercase)
gs_emp-coltext   = 'Material No'.
gs_emp-outputlen = 18.
APPEND gs_emp TO gt_emp.

CLEAR gs_emp.
gs_emp-fieldname = 'ERSDA'.
gs_emp-coltext   = 'Created On'.
gs_emp-outputlen = 12.
APPEND gs_emp TO gt_emp.

CLEAR gs_emp.
gs_emp-fieldname = 'MATKL'.
gs_emp-coltext   = 'Material Group'.
gs_emp-outputlen = 10.
APPEND gs_emp TO gt_emp.

"--- call ALV
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program = sy-repid
  TABLES
    t_fieldcat         = gt_emp
    t_outtab           = it_mara.