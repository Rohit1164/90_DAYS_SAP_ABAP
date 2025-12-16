LOOP AT lt_fcat INTO ls_fcat.
  IF ls_fcat-fieldname = 'EMP_SALARY'.
    ls_fcat-edit = 'X'.
  ENDIF.
  MODIFY lt_fcat FROM ls_fcat.
ENDLOOP.

" Register DATA_CHANGED Event
SET HANDLER lcl_event=>on_data_changed FOR lo_grid.


" Class define kare:

CLASS lcl_event DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.


" DATA_CHANGED Event Logic (Validation Example)
" Example → If user enters salary < 1000 → show error
CLASS lcl_event IMPLEMENTATION.
  METHOD on_data_changed.
    DATA ls_mod TYPE lvc_s_modi.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod.
      IF ls_mod-fieldname = 'EMP_SALARY' AND ls_mod-value < 1000.
        er_data_changed->add_protocol_entry(
          i_msgid = 'ZMSG'
          i_msgno = '001'
          i_msgty = 'E'
          i_fieldname = 'EMP_SALARY'
          i_row_id = ls_mod-row_id
        ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


" Saving Updated Data Back to Internal Table

" User edit karta hai → ALV me value badalti hai
" But internal table me update karna hota hai manually.

" Use method:

CALL METHOD lo_grid->get_changed_data
  IMPORTING er_data_changed = ls_changed.


" Then update table:

LOOP AT ls_changed->mt_good_cells INTO ls_mod.
  READ TABLE lt_emp ASSIGNING <fs_emp> INDEX ls_mod-row_id.
  <fs_emp>-emp_salary = ls_mod-value.
ENDLOOP.