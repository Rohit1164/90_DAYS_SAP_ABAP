" Adding Custom Buttons in ALV Toolbar
" OO ALV me toolbar change event hota hai:
" Register Event:

SET HANDLER lcl_event=>on_toolbar FOR lo_grid.

" Event Handler:
CLASS lcl_event DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar
       FOR EVENT toolbar OF cl_gui_alv_grid
       IMPORTING e_object e_interactive.
ENDCLASS.

" Add Custom Button:

METHOD on_toolbar.
  DATA ls_button TYPE stb_button.

  ls_button-function = 'EXCEL'.
  ls_button-icon = icon_xls.
  ls_button-quickinfo = 'Download Excel'.
  ls_button-text = 'Excel'.
  APPEND ls_button TO e_object->mt_toolbar.
ENDMETHOD.


" 📌 Output:
" ALV ke upar ek naya Excel button add ho jayega.
" 2️⃣ Handling Custom Button Click
" Register user command:

SET HANDLER lcl_event=>on_user_command FOR lo_grid.

" Method:

METHOD on_user_command.
  CASE e_ucomm.
    WHEN 'EXCEL'.
      PERFORM download_excel.
  ENDCASE.
ENDMETHOD.

" 3️⃣ Excel Download Logic
" Use this FM:

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename = 'C:\temp\employee.xlsx'
  TABLES
    data_tab = lt_emp.