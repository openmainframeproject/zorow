--#SET TERMINATOR @
create variable devservices.C_VARIABLE varchar(10) default 'variable'@
create variable devservices.C_DATATYPE varchar(10) default 'datatype'@
create variable devservices.C_DATABASE varchar(10) default 'database'@
create variable devservices.C_TRIGGER  varchar(10) default 'trigger'@
create variable devservices.C_ROUTINE  varchar(10) default 'routine'@
create variable devservices.C_PACKAGE  varchar(10) default 'package'@
create variable devservices.C_TABLE    varchar(10) default 'table'@
create variable devservices.C_SYNONYM  varchar(10) default 'synonym'@
create variable devservices.C_SEQUENCE varchar(10) default 'sequence'@

commit @

--
-- Provision report will provide a list of objects that are
-- provisioned by a specific schema name or a collection id if
-- the object is a package.
--
create table devservices.provisionreport (
    owner       varchar(128), -- schema or collection id
    obj_name    varchar(128), -- object name
    sysobj      varchar(20),  -- type of object
    obj_type    char(1),      -- subtype of object
    status      char(1),      -- A=active, D=Dropped, F=Failed to drop
    createdts   timestamp,    -- when the obectj was created
    message     varchar(2000) -- additional info regarding status.
  )@


--
-- Routine to initialize a table that will contain a list of
-- objects belonging to a specific schema name and packages
-- belonging to a specific collection ID.
--
create procedure devservices.init_provision_report ()
  language SQL
begin
  declare ycount    integer;

  select count(*) into ycount
  from devservices.provisionreport;

  if (ycount <> 0) then
    delete from devservices.provisionreport;
    commit;
  end if;

end @


--
-- Routine that will add an object to the devservices.provisionreport
-- table.
--
create procedure devservices.add_row_to_results (
  in in_owner       varchar(128),
  in in_obj_name    varchar(128),
  in in_sysobj      varchar(20),
  in in_obj_type    char(1),
  in in_status      char(1),
  in in_createdts   timestamp,
  in in_message     varchar(2000)
  )
  language SQL
begin
  insert into devservices.provisionreport
    (owner, obj_name, sysobj, obj_type, status, createdts, message)
    values (
            in_owner,
            in_obj_name,
            in_sysobj,
            in_obj_type,
            in_status,
            in_createdts,
            in_message);
  commit;
end @


--
-- Routine that will update the message colomn for an
-- existing object in the devservices.provisionreport table.
--
create procedure devservices.update_result_set_row_message (
  in in_owner       varchar(128),
  in in_obj_name    varchar(128),
  in in_sysobj      varchar(20),
  in in_obj_type    char(1),
  in in_status      char(1),
  in in_message     varchar(2000)
  )
  language SQL
begin
  update devservices.provisionreport
    set message = in_message, status = in_status
    where owner = in_owner
      and obj_name = in_obj_name
      and sysobj = in_sysobj
      and obj_type = in_obj_type;
  commit;
end @


--
-- Routine to drop triggers and stored procedures.
-- This is to be done before we can free packages.
--
create procedure devservices.drop_trigger_and_SP (
      in in_schema varchar(128)
  )
  language SQL
  dynamic result sets 1
begin
  declare SQLCODE       integer;
  declare SQLSTATE      char(5);
  declare y_sqlcode     integer;
  declare y_sqlstate    char(5);
  declare y_sqlerrtxt   varchar(100);

  declare dynSQL        varchar(4000);
  declare y_msg_text    varchar(2000);
  declare y_status      char(1);

  declare continue handler for sqlexception, sqlwarning
    begin
      values (SQLCODE, SQLSTATE) into y_sqlcode, y_sqlstate;
      set y_msg_text = 'SQLCODE: '||strip(char(y_sqlcode),B)||
          ', SQLSTATE: '||y_sqlstate;

      if (y_sqlcode <> 0) then
        set y_status = 'F';

        if (y_sqlcode = -204) then
          set y_msg_text = y_msg_text||
              ', THE OBJECT THAT IS NOT DEFINED IN Db2';
        end if;
        if (y_sqlcode = -478) then
          set y_msg_text = y_msg_text||', DROP ON OBJECT CANNOT '||
              'BE PROCESSED BECAUSE ANOTHER OBJECT IS DEPENDENT ON IT';
        end if;
      end if;

    end;

  for loopObj as
    curObj cursor with hold for
      select owner, obj_name, sysobj, obj_type, createdts
      from devservices.provisionreport
      where owner = in_schema
      order by createdts desc
    do

      set dynSQL = '';

      if (sysobj = devservices.C_TRIGGER) then
        set dynSQL = 'drop trigger '||in_schema||'.'||obj_name;
      elseif (sysobj = devservices.C_ROUTINE and obj_type = 'P') then
        set dynSQL = 'drop procedure '||in_schema||'.'||obj_name;
      end if;

      if (dynSQL <> '') then
        set y_msg_text = 'Dropped';
        set y_status = 'D';
        execute immediate dynSQL;
        call devservices.update_result_set_row_message (
                owner,
                obj_name,
                sysobj,
                obj_type,
                y_status,
                y_msg_text);
        commit;
      end if;
    end for;

end @



--
-- Routine that drops objects with a given schema.
--
create procedure devservices.drop_objects (
      in in_schema      varchar(128),
      in unrestricted   char(1))
  language SQL
  dynamic result sets 1
begin
  declare SQLCODE       integer;
  declare SQLSTATE      char(5);
  declare y_sqlcode     integer;
  declare y_sqlstate    char(5);
  declare y_sqlerrtxt   varchar(100);

  declare dynSQL        varchar(4000);
  declare yDBName       varchar(24);
  declare yTSName       varchar(24);
  declare yClusterType  char(1);

  declare y_status      char(1);
  declare y_msg_text    varchar(2000);

  declare continue handler for sqlexception, sqlwarning
    begin
      values (SQLCODE, SQLSTATE) into y_sqlcode, y_sqlstate;
      set y_msg_text = 'SQLCODE: '||strip(char(y_sqlcode),B)||
          ', SQLSTATE: '||y_sqlstate;

      if (y_sqlcode <> 0) then
        set y_status = 'F';

        if (y_sqlcode = -204) then
          set y_msg_text = y_msg_text||
              ', OBJECT IS NOT DEFINED IN Db2';
        end if;
        if (y_sqlcode = -478) then
          set y_msg_text = y_msg_text||', DROP ON OBJECT CANNOT '||
              'BE PROCESSED BECAUSE ANOTHER OBJECT IS DEPENDENT ON IT';
        end if;
        if (y_sqlcode = -672) then
          set y_msg_text = y_msg_text||', DROP STATEMENT CANNOT '||
              'BE EXECUTED ON TABLE THAT IS RESTRICTED ON DROP. '||
              'SET unrestricted to "Y" TO FORCE DROP';
        end if;
      end if;

    end;

  for loopObj as
    curObj cursor with hold for
      select owner, obj_name, sysobj, obj_type, createdts
      from devservices.provisionreport
      where owner = in_schema and status <> 'D'
      order by createdts desc
    do

      set dynSQL = '';

      if (sysobj = devservices.C_TABLE) then

        if (obj_type = 'T' or obj_type = 'M')  then

          set yDBName = '',
              yTSName = '',
              yClusterType = '';

          select dbname, tsname, clustertype
          into yDBName, yTSName, yClusterType
          FROM SYSIBM.SYSTABLES
          where name = obj_name and creator = in_schema;

          if (yDBName <> '' and yTSName <> '') then
            if (yClusterType = 'Y' and unrestricted = 'Y') then
              set dynSQL = 'alter table '||in_schema||'.'||
                  obj_name||' drop restrict on drop';
              execute immediate dynSQL;
            end if;
            set dynSQL = 'drop tablespace '||yDBName||'.'||yTSName;
          end if;
        end if;

        if (obj_type = 'G') then
          set dynSQL = 'drop table '||in_schema||'.'||obj_name;
        end if;

        if (obj_type = 'A') then
          set dynSQL = 'drop alias '||in_schema||'.'||obj_name;
        end if;

        if (obj_type = 'V') then
          set dynSQL = 'drop view '||in_schema||'.'||obj_name;
        end if;
      end if;

      if (sysobj = devservices.C_ROUTINE and obj_type = 'P') then
        set dynSQL = 'drop procedure '||in_schema||'.'||obj_name;
      end if;

      if (sysobj = devservices.C_ROUTINE and obj_type = 'F') then
        set dynSQL = 'drop specific function '||
            in_schema||'.'||obj_name;
      end if;

      if (sysobj = devservices.C_SEQUENCE) then
        set dynSQL = 'drop sequence '||in_schema||'.'||obj_name;
      end if;

      if (sysobj = devservices.C_VARIABLE) then
        set dynSQL = 'drop variable '||in_schema||'.'||obj_name;
      end if;

      if (sysobj = devservices.C_DATATYPE) then
        set dynSQL = 'drop distinct type '||in_schema||'.'||obj_name;
      end if;

      if (sysobj = devservices.C_SYNONYM) then
        set dynSQL = 'drop synonym '||obj_name;
      end if;

      if (dynSQL <> '') then
        set y_msg_text = 'Dropped';
        set y_status = 'D';
        execute immediate dynSQL;
        call devservices.update_result_set_row_message (
                owner,
                obj_name,
                sysobj,
                obj_type,
                y_status,
                y_msg_text);
        commit;
      end if;
  end for;

  set yDBName = '';
  select obj_name into yDBName
  from devservices.provisionreport
  where sysobj = devservices.C_DATABASE;
  if (yDBName <> '') then
    set dynSQL = 'drop database '||yDBName;
    set y_msg_text = 'Dropped';
    set y_status = 'D';
    execute immediate dynSQL;
    update devservices.provisionreport
      set message = y_msg_text, status = y_status
      where obj_name = yDBName
        and sysobj = devservices.C_DATABASE;
    commit;
  end if;

end @


--
-- Routine that will scan through various catalog tables in
-- order to populate the devservices.provisionreport table.
--
create procedure devservices.get_provision_report (
    in in_schema  varchar(128),
    in in_colid   varchar(128),
    in in_dbName  varchar(24)
  )
  language SQL
  dynamic result sets 1
begin
  declare SQLCODE       integer;
  declare SQLSTATE      char(5);

  declare y_msg_text    varchar(2000);
  declare y_status      char(1);

  -- declare c_result cursor with hold with return for
  --   select * from devservices.provisionreport;

  declare continue handler for sqlexception
    set y_msg_text = 'SQLCODE: '||strip(char(SQLCODE),B)||
        ', SQLSTATE: '||SQLSTATE;

  call devservices.init_provision_report();

  for loopObj as
    curObj cursor with hold for
      select owner, obj_name, sysobj, obj_type, createdts
        from (
          (select schema as owner, name as obj_name,
                  devservices.C_VARIABLE as sysobj,
                  ownertype as obj_type, createdts
            from sysibm.sysvariables
            where schema = in_schema)
          union all
          (select schema as owner, name as obj_name,
                  devservices.C_DATATYPE as sysobj,
                  metatype as obj_type, createdts
            from sysibm.sysdatatypes
            where schema = in_schema)
          union all
          (select creator as owner, name as obj_name,
                  devservices.C_DATABASE as sysobj,
                  type as obj_type, createdts
            from sysibm.sysdatabase
            where name = in_dbName)
          union all
          (select collid as owner, name as obj_name,
                  devservices.C_PACKAGE as sysobj,
                  type as obj_type, timestamp as createdts
            from sysibm.syspackage
            where collid = in_colid)
          union all
          (select creator as owner, name as obj_name,
                  devservices.C_TABLE as sysobj,
                  type as obj_type, createdts
            from sysibm.systables
            where creator = in_schema)
          union all
          (select schema as owner, name as obj_name,
                  devservices.C_ROUTINE as sysobj,
                  routinetype as obj_type, createdts
            from sysibm.sysroutines
            where schema = in_schema and cast_function <> 'Y')
          union all
          (select tbcreator as owner, name as obj_name,
                  devservices.C_SYNONYM as sysobj,
                  creatortype as obj_type, createdts
            from sysibm.syssynonyms
            where tbcreator = in_schema)
          union all
          (select schema as owner, name as obj_name,
                  devservices.C_TRIGGER as sysobj,
                  ownertype as obj_type, createdts
            from sysibm.systriggers
            where schema = in_schema)
          union all
          (select schema as owner, name as obj_name,
                  devservices.C_SEQUENCE as sysobj,
                  seqtype as obj_type, createdts
            from sysibm.syssequences
            where schema = in_schema and seqtype = 'S')
        ) as utable
        order by createdts desc
    do

      set y_msg_text = '';
      set y_status = 'A';
      call devservices.add_row_to_results(
                owner,
                obj_name,
                sysobj,
                obj_type,
                y_status,
                createdts,
                y_msg_text);
    end for;

    -- open c_result;

end @


--
-- Routine scans the report table and checks to see if any object
-- still exists in the catalog. If the object no longer exists then
-- it was passively dropped.
--
create procedure devservices.finalize_deprovision_report (
      in in_schema varchar(128),
      in in_colid varchar(128),
      in in_dbName varchar(24)
    )
  language SQL
  dynamic result sets 1
begin
  declare SQLCODE       integer;
  declare SQLSTATE      char(5);
  declare y_sqlcode     integer;
  declare y_sqlerrtxt   varchar(100);
  declare y_test        integer;

  declare y_msg_text    varchar(2000);
  declare y_status      char(1);

  declare dynSQL        varchar(4000);

  declare continue handler for sqlexception
    set y_msg_text = 'SQLCODE: '||strip(char(SQLCODE),B)||
        ', SQLSTATE: '||SQLSTATE;


  for loopObj as
    curObj cursor with hold for
      select owner, obj_name, sysobj, obj_type, status, createdts
      from devservices.provisionreport
      where (owner = in_schema or owner = in_colid) and status <> 'D'
      order by createdts desc
    do
      set y_status = -1;

      if (sysobj = devservices.C_TABLE) then
        select count(*) into y_test
        from sysibm.systables
        where creator = in_schema and name = obj_name;
      end if;

      if (sysobj = devservices.C_ROUTINE) then
        select count(*) into y_test
        from sysibm.sysroutines
        where schema = in_schema and name = obj_name;
      end if;

      if (sysobj = devservices.C_TRIGGER) then
        select count(*) into y_test
        from sysibm.systriggers
        where schema = in_schema and name = obj_name;
      end if;

      if (sysobj = devservices.C_PACKAGE) then
        select count(*) into y_test
        from sysibm.syspackage
        where collid = in_colid and name = obj_name;
      end if;

      if (sysobj = devservices.C_SYNONYM) then
        select count(*) into y_test
        from sysibm.syssynonyms
        where tbcreator = in_schema and name = obj_name;
      end if;

      if (sysobj = devservices.C_SEQUENCE) then
        select count(*) into y_test
        from sysibm.syssequences
        where schema = in_schema and name = obj_name;
      end if;

      if (sysobj = devservices.C_DATABASE) then
        select count(*) into y_test
        from sysibm.sysdatabase
        where name = in_dbName;
      end if;

      if (sysobj = devservices.C_VARIABLE) then
          select count(*) into y_test
          from sysibm.sysvariables
          where schema = in_schema;
      end if;

      if (sysobj = devservices.C_DATATYPE) then
          select count(*) into y_test
          from sysibm.sysdatatypes
          where schema = in_schema;
      end if;

      if (y_test = 0 and status = 'A') then
        set y_msg_text = 'object passively dropped';

        if (sysobj = devservices.C_PACKAGE) then
          set y_msg_text = 'Dropped';
        end if;

        set y_status = 'D';
        call devservices.update_result_set_row_message (
                  owner,
                  obj_name,
                  sysobj,
                  obj_type,
                  y_status,
                  y_msg_text);
      end if;
  end for;

end @

create procedure devservices.validate_input (
      in schema_prefix varchar(128),
      in collection_ID varchar(128),
      in database varchar(24),
      inout o_msg varchar(4000),
      inout retcode integer
    )
  language SQL
begin
  declare yTest   varchar(128);

  set yTest = upper(substr(schema_prefix,1,3));
  if (yTest = '') then
    set o_msg = ' Error, schema_prefix: '||
      'Cannot be null. Must provide a schema name!';
    set retcode = 4;
    return;
  elseif (yTest = 'SYS') then
    set o_msg = ' Error, schema_prefix: '||
      schema_prefix||' cannot start with the prefix "SYS"!';
    set retcode = 4;
    return;
  elseif (yTest = 'DSN') then
    set o_msg = ' Error, schema_prefix: '||
      schema_prefix||' cannot start with the prefix "DSN"!';
    set retcode = 4;
    return;
  end if;

  -- set yTest = upper(substr(collection_ID,1,3));
  -- if (yTest = 'SYS') then
  --   set o_msg = ' Error, collection_ID: '||
  --     collection_ID||' cannot start with the prefix "SYS"!';
  --   set retcode = 4;
  --   return;
  -- elseif (yTest = 'DSN') then
  --   set o_msg = ' Error, collection_ID: '||
  --     collection_ID||' cannot start with the prefix "DSN"!';
  --   set retcode = 4;
  --   return;
  -- end if;

  set yTest = upper(substr(database,1,3));
  if (yTest = 'SYS') then
    set o_msg = ' Error, database: '||
      database||' cannot start with the prefix "SYS"!';
    set retcode = 4;
    return;
  elseif (yTest = 'DSN') then
    set o_msg = ' Error, database: '||
      database||' cannot start with the prefix "DSN"!';
    set retcode = 4;
    return;
  end if;

end @


--
-- Routine to deprovion objects belonging to a given schema
-- and free packages given a specific collection ID.
--
create procedure devservices.deprovision_schema (
      in  schema_prefix	varchar(128),
      in  collection_ID varchar(128),
      in  database      varchar(24),
      in  unrestricted  char(1),
      out object_count  integer,
      out package_count integer,
      out message       varchar(4000),
      out return_code   integer
    )
  language SQL
  dynamic result sets 1
begin
  declare SQLCODE       integer;
  declare SQLSTATE      char(5);
  declare y_sqlcode     integer;
  declare y_sqlstate    char(5);
  declare dynSQL        varchar(4000);
  declare yDSNComand    varchar(2000);
  declare failcount     integer;

  declare c_result cursor with hold with return for
    select * from devservices.provisionreport;

  declare continue handler for sqlexception, sqlwarning
    begin
      values (SQLCODE, SQLSTATE) into y_sqlcode, y_sqlstate;
      -- ignore result set of DSN command..
      if (y_sqlcode <> 466) then
        set message = message|| '... SQLCODE: '||
            strip(char(y_sqlcode),B)||', SQLSTATE: '||y_sqlstate;
      end if;
    end;

  set unrestricted = upper(unrestricted);
  set return_code = 0;
  set message = '';

  call devservices.validate_input(
        schema_prefix,
        collection_ID,
        database,
        message,
        return_code);

  if (return_code = 0) then
    call devservices.get_provision_report(
            schema_prefix,
            collection_ID,
            database);

    call devservices.drop_trigger_and_SP(schema_prefix);

    if (collection_ID <> '') then
      set yDSNComand = 'FREE PACKAGE ('||collection_ID||'.*.(*))';
      CALL SYSPROC.ADMIN_COMMAND_DSN (yDSNComand,message);
    end if;

    call devservices.drop_objects(schema_prefix, unrestricted);

    call devservices.finalize_deprovision_report(
            schema_prefix,
            collection_ID,
            database);

    select count(*) into object_count
    from devservices.provisionreport
    where owner = schema_prefix;

    select count(*) into package_count
    from devservices.provisionreport
    where owner = collection_ID;

    select count(*) into failcount
    from devservices.provisionreport
    where status <> 'D';

    if (failcount > 0) then
      set return_code = 4;
    end if;
  end if;

  open c_result;

end @
