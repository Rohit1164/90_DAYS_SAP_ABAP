
TYPES: BEGIN OF ty_emp,
         empid   TYPE zemployee-empid,
         ename   TYPE zemployee-ename,
         dept    TYPE zemployee-dept,
         salary  TYPE zemployee-salary,
       END OF ty_emp.

DATA: gt_emp TYPE STANDARD TABLE OF ty_emp,
      gs_emp TYPE ty_emp.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

SELECT empid ename dept salary
  FROM zemployee
  INTO TABLE gt_emp.

gs_fcat-fieldname = 'SALARY'.
gs_fcat-coltext  = 'Employee Salary'.
gs_fcat-edit =  'x'.
APPEND gs_fcat TO gt_fcat.
CLEAR gs_fcat.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: on_data_changed FOR EVENTS data_changed OF cl_gui_alv_grid
              IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_data_changed.
   DATA ls_mod TYPE lvc_s_modi.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod. 
      IF ls_mod-fieldname = 'SALARY'. AND ls_mod-value IS NOT INITIAL.
        er_data_changed->add_protocol_entry(
        i_msgid = '00'
        i_msgno = '001'
        i_msgty = 'E'
        i_msgv1 = 'Unit cannot be blank'
        i_fieldname = 'SALARY'.
        i_row_id = ls_mod-empid
        ).
      ENDIF.  
  ENDLOOP.
  ENDMETHOD.
ENDCLASS.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'SAVE'.
      PERFORM save_data.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

FORM save_data.
  LOOP AT gt_emp INTO gs_emp.
    UPDATE zemployee SET salary = gs_emp-salary
      WHERE empid = gs_emp-empid.
  ENDLOOP.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Data saved successfully' TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Error saving data' TYPE 'E'.
  ENDIF.
ENDFORM.