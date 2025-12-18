" Task 1
" Module Pool program create karo:
" Name: SAPMZ_DAY31
PROGRAM ModulePool_Programming_Basics.

DATA: gv_name TYPE string,
      gv_city TYPE string.

START-OF-SELECTION.
  CALL SCREEN 0100.

PROCESS BEFORE OUTPUT.
  MODULE status_0100.

" Task 3
" PBO me:
" PF-STATUS set karo
" Title set karo
MODULE status_0100 INPUT.
 SET PF_STATUS 'ZSTATUS'
 SET TITLEBAR 'TITLE'
ENDMODULE.

" ✅ Task 2
" Screen 0100 banao:
" 2 input fields
" 2 buttons (SAVE, EXIT)



PROCESS AFTER INPUT.
  MODULE user_command_0100.

" Task 4
" PAI me:
" SAVE → Message show ho
" EXIT → Program exit
MODULE user_command_0100 INPUT.
  CASE sy-subrc = 0.
    WHEN 'SAVE'.
      MESSAGE 'Saved Pressed' TYPE 'I'.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.