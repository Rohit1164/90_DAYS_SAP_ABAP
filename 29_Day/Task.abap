REPORT z_task_29_day.

TABLES mara.

DATA: gt_mara TYPE TABLE OF mara,
      go_container TYPE REF TO cl_gui_alv_container,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      gt_fcat      TYPE lvc_t_fcat.

FUNCTION get_data.
  SELECT * FROM mara
    INTO TABLE gt_mara
    UP TO 20 ROWS.
ENDFUNCTION.

" Task 1:
" OO ALV banao jisme:
" MEINS editable ho
" MATNR display only
FUNCTION edit_fcat.
DATA: gs_fcat TYPE lvc_s_fcat.

  gs_fcat-fieldname = 'MATNR'.
  gs_fcat-coltext = 'Material'.
  APPEND gs_fcat TO gt_fcat.

  gs_fcat-fieldname = 'MEINS'.
  gs_fcat-coltext = 'UOM'. 
  gs_fcat-edit = 'X'.

  APPEND gs_fcat TO gt_fcat.
ENDFUNCTION.

" Task 2:
" Data_changed event add karo (sirf message enough).
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS on_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_data_changed.
    IF er_data_changed is INITIAL.
      MESSAGE 'Data changed in ALV' TYPE 'I'.
      ENDIF.
  ENDMETHOD.
ENDCLASS.

" Task 3:
" Screen 0100 me ALV display verify karo.
" I'm not understanding this task.
