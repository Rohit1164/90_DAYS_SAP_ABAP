" Today task complete after access server
+-------------+
|  ABAP       |
|  Program    |
+-------------+
       |
       v
+-------------+
|  BAPI       |
|  Call       |
+-------------+
       |
       v
+--------------------+
|  BAPI_TRANSACTION  |
|  _COMMIT           |
+--------------------+
       |
       v
+-------------+
|  Database   |
|  (DB)       |
+-------------+
