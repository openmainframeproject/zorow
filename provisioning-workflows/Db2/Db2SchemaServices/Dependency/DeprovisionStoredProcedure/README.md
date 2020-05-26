![](https://img.shields.io/badge/Syntax-complete-green.svg)
![](https://img.shields.io/badge/Build-working-green.svg)
# De-provisioning a schema:-
The DEPROVISION_SCHEMA stored procedure drops objects, such as databases, tables, packages, and more, under the input schema name, database name, and collection id. It is used to de-provision objects that are provisioned in Db2 for z/OS Create Schema Like as a Service.


## Db2 privilege requirements for building and running the de-provision process:

**Building the de-provision process**
- The CREATEIN privilege on the schema and the required authorization to add a new package or a new version of an existing package depending on the value of the BIND NEW PACKAGE field on installation panel DSNTIPP.
- The CREATETAB privilege for the database explicitly specified by the IN clause.
If the IN clause is not specified, the CREATETAB privilege on database DSNDB04 is required.

**Running the de-provision process**
- The EXECUTE privilege on the stored procedure.
- At least one of the following:
    - Ownership of the objects to de-provision and DROP privilege on the database.
    - DBADM or DBCTRL authority for the database
    - SYSADM or SYSCTRL authority
    - System DBADM

## How to install
- `build.sql` creates stored procedures and a report table under the DEVSERVICES schema.
- `clean.sql` removes all of these objects.
- `build.jcl` job card does the same as the above two sql scripts but in a TSO/VM environment.


### Syntax

```
>>-CALL--DEVSERVICES.DEPROVISION_SCHEMA--(----schema_prefix----,--+-collection_ID-+--,---->
                                                                  '-NULL----------'

>-+--database-+-,---unrestricted---,---object_count---,---package_count---,---->
  '--NULL-----'

>----message---,---return_code--)----><


```
#### Option descriptions
- **schema_prefix**

    Specifies the schema name that qualifies objects to be de-provisioned. Type is a varchar(128) and is a required input. The input schema name is checked to ensure that it is not a protected prefix (DSN.., SYSIBM, etc.). If this parameter is left null the procedure fails.

- **collection_ID**

    Specifies the ID of the package that is requested to be freed. This parameter can be left null.

- **database**

    Specifies the name of the database to be de-provisioned. If left null, the underlying database for the schema is not dropped.

- **unrestricted**

    Specifies whether the RESTRICT ON DROP attribute is ignored. This flag must be set to 'Y' to drop tables that have the RESTRICT ON DROP attribute.

- **object_count**

    An output parameter that contains the number of objects that where successfully dropped, not including objects that are dropped automatically like views or indexes.

- **package_count**

     An output parameter that contains the number of packages that where successfully freed.

- **return_code**

    An output parameter that contains the return code from the stored procedure. It contains one of the following values:

    **0** Call completed successfully.

    **4** De-provision could not fully de-provision every object but some objects where dropped.

    **8** Execution could not complete and the error-message contains the reason.

- **message**

    Output parameter containing the error message when return-code is 8.

- **result set**

    Example result set:

    OWNER     |OBJ_NAME      |SYSOBJ   |OBJ_TYPE  |STATUS  |CREATEDTS                   |MESSAGE
    ---       |---           |---      |---       |---     |---                         |---
    TESTID01  |INSROWS       |package  |          |D       |2018-06-22 18:27:09.700943  |Dropped
    T1        |ADD_INTEREST  |routine  |P         |D       |2018-06-22 18:27:05.476323  |Dropped
    T1        |DECRYPT       |routine  |F         |D       |2018-06-22 18:27:04.68743   |Dropped
    T1        |CUSTOMERLIST  |table    |V         |D       |2018-06-22 18:27:04.196804  |object passively dropped
    T1        |ACCOUNT       |table    |T         |D       |2018-06-22 18:27:03.934643  |Dropped

    - **OWNER**

        Schema or Collection ID that owns the object in the result set.
    - **OBJ_NAME**

        Name of the object in the result set.
    - **SYSOBJ**

        Name of the object category that the object belongs to (table, routine, etc.)
    - **OBJ_TYPE**

        Sub type of object (T for table, V for view, etc.). These types are propagated from the catalog
    - **STATUS**

        Status of the object (D = dropped, A = active, F = failed drop attempt)
    - **CREATEDTS**

        Timestamp when the object was created.
    - **MESSAGE**

        Message expanding on the current status.
