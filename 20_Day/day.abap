" How To Call SmartForm From ABAP Program
" Step 1: Get FM name
CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname = 'Z_SMARTFORM_EMP'
  IMPORTING
    fm_name  = lv_fm_name.

" Step 2: Execute SmartForm FM
CALL FUNCTION lv_fm_name
  EXPORTING
    it_data = lt_employee.

    " PDF Conversion Example:
CALL FUNCTION 'CONVERT_OTF'
  EXPORTING
    format = 'PDF'
  IMPORTING
    bin_file = lv_pdf
  TABLES
    otf = otf_data
    lines = pdf_lines.


" Download PDF:

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename = 'C:\temp\employee_report.pdf'
  TABLES
    data_tab = pdf_lines.