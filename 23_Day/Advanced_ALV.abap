report zadvanced.

types:slis.
tables:mara.

types: begin of lty_emp,
        id type string,
        name type string,
        salary type i,
       end of lty_emp.

data: it_emp type table of lty_emp,
      wa_emp type lty_emp.
data: it_field  type slis_t_fieldcat_alv,
      wa_field  type slis_fieldcat_alv,
      it_sort   type slis_t_sortinfo_alv
      wa_sort   type slis_sortinfo_alv
      it_event  type slis_t_event,
      gs_layout type slis_layout_alv.

" Fetch Data
select id name salary 
from employee 
into table it_emp 
up to 50 rows.

" layout
gs_layout-zebra='x'.
gs_layout-colwidth_optimize='x'.
gs_layout-title='Master Material Table'.

" Field Catalog (auto)
CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
    i_program_name = sy-repid
    i_internal_tabname = 'it_emp'
    i_inclname     = sy-repid
  CHANGING
    ct_fieldcat    = it_field.

"sort
wa_data-fieldname='id'
wa_sort-upto='x'.
wa_sort-subtot='x'.
APPEND wa_sort to it_sort.

" Events get
CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
  IMPORTING
    et_events = it_events.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    is_layout = gs_layout
    it_fieldcat = it_field
    it_sort     = it_sort
  TABLES
    t_outtab    = it_data.