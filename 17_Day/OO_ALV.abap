DATA: lo_container TYPE REF TO cl_gui_custom_container,
      lo_grid      TYPE REF TO cl_gui_alv_grid.

" Create Container
CREATE OBJECT lo_container
  EXPORTING container_name = 'MY_CONT'.

" Create Grid
CREATE OBJECT lo_grid
  EXPORTING i_parent = lo_container.

" Display Data in ALV
CALL METHOD lo_grid->set_table_for_first_display
  EXPORTING i_structure_name = 'LTY_EMPLOYEE'
  CHANGING  it_outtab        = lt_employee.

  FIELD-SYMBOLS <fs_fieldcat> TYPE lvc_s_fcat.
DATA lt_fcat TYPE lvc_t_fcat.

CALL METHOD lo_grid->get_frontend_fieldcatalog
  IMPORTING et_fieldcatalog = lt_fcat.

LOOP AT lt_fcat ASSIGNING <fs_fieldcat>.
  <fs_fieldcat>-edit = 'X'.  "Make field editable
ENDLOOP.

CALL METHOD lo_grid->set_frontend_fieldcatalog
  EXPORTING it_fieldcatalog = lt_fcat.

  SET HANDLER lcl_handler=>handle_double_click FOR lo_grid.

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: handle_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
         IMPORTING e_row e_column.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD handle_double_click.
    MESSAGE |Row: { e_row-index } Column: { e_column-fieldname } clicked| TYPE 'I'.
  ENDMETHOD.
ENDCLASS.
