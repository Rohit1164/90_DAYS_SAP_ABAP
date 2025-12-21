" Task 1: Simple Addition FM
FUNCTION Z_ADD_NUMBERS.
  IMPORTING
      iv_num1 type I
      iv_num2 type I
  exporting
      ev_result type I.
  ev_result = iv_num1 + iv_num2.
ENDFUNCTION.


Call FUNCTION 'Z_ADD_NUMBERS'
  EXPORTING
    iv_num1 = 10
    iv_num2 = 20
  IMPORTING
    ev_result = DATA(lv_sum).

    if lv_sum / 2 = 0.
      write: / 'The sum is even:', lv_sum.
    else.
      write: / 'The sum is odd:', lv_sum.
    endif.
ENDFUNCTION.

" Task 2: String Concatenation FM
FUNCTION Z_CONCAT_STRINGS.
  IMPORTING
      iv_str1 type STRING
      iv_str2 type STRING
  exporting
      ev_result type STRING.
  ev_result = iv_str1 && iv_str2.
ENDFUNCTION.

Call FUNCTION 'Z_CONCAT_STRINGS'
  EXPORTING
    iv_str1 = 'Hello, '
    iv_str2 = 'World!'
  IMPORTING
    ev_result = DATA(lv_concatenated).

  write: / 'Concatenated String:', lv_concatenated.
ENDFUNCTION.

" Task 4: User Name Fetch
" Objective: Get user full name using system user
" Input: IV_UNAME (TYPE SY-UNAME)
" Output: EV_NAME (TYPE AD_NAMTEXT)

FUNCTION Z_GET_USER_NAME.
  IMPORTING
      iv_uname type SY-UNAME
  exporting
      ev_name type AD_NAMTEXT.
  DATA: ls_user TYPE USR02.
  SELECT SINGLE * FROM USR02 INTO ls_user WHERE BNAME = iv_uname.
  IF sy-subrc = 0.
    ev_name = ls_user-NAME_TEXT.
  ELSE.
    ev_name = 'User not found'.
  ENDIF.
ENDFUNCTION.
