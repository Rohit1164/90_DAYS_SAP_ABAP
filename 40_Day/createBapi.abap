REPORT z_bapi_material_create.

DATA: ls_head   TYPE bapimathead,
      ls_client TYPE bapi_mara,
      ls_plant  TYPE bapi_marc,
      ls_return TYPE bapiret2.

* Header Data
ls_head-material  = 'ZMAT1001'.
ls_head-matl_type = 'FERT'.
ls_head-ind_sector = 'M'.
ls_head-basic_view = 'X'.
ls_head-purchase_view = 'X'.

* Client Data
ls_client-base_uom = 'PC'.
ls_client-matl_group = '001'.
ls_client-description = 'BAPI TEST MATERIAL'.

* Plant Data
ls_plant-plant = '1000'.

CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
  EXPORTING
    headdata       = ls_head
    clientdata     = ls_client
    plantdata      = ls_plant
  IMPORTING
    return         = ls_return.

* Print RETURN Message
WRITE: / 'TYPE   :', ls_return-type,
       / 'MESSAGE:', ls_return-message.

* Commit Work
IF ls_return-type = 'S'.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
ENDIF.
