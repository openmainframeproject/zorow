//*
//*        STEP  1: CREATE SAMPLE STORAGE GROUPS, TABLESPACES
//*
//PH01S01 EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//STEPLIB  DD DSN=${instance-DSNLOAD},DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(${instance-MVSSNAME})
  RUN  PROGRAM(${instance-PROGNAME}) PLAN(${instance-PLANNAME}) -
       LIB('${instance-RUNLIB}')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID = '${instance-SQLID}';

  CREATE DATABASE ${instance-DBASEA}
    STOGROUP ${instance-STOGROUP}
    BUFFERPOOL ${instance-BP}
    INDEXBP ${instance-BP}
    CCSID EBCDIC;

  CREATE DATABASE ${instance-DBASEP}
    STOGROUP ${instance-STOGROUP}
    BUFFERPOOL ${instance-BP}
    INDEXBP ${instance-BP}
    CCSID EBCDIC;

  CREATE DATABASE ${instance-DBASEX}
    STOGROUP ${instance-STOGROUP}
    BUFFERPOOL ${instance-BP}
    INDEXBP ${instance-BP}
    CCSID EBCDIC;

  CREATE TABLESPACE ${instance-TSPREFIX}D
    IN ${instance-DBASEA}
    USING STOGROUP ${instance-STOGROUP}
    ERASE NO
    LOCKSIZE PAGE LOCKMAX SYSTEM
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  COMMIT ;

  CREATE TABLESPACE ${instance-TSPREFIX}E
    IN ${instance-DBASEA}
    USING STOGROUP ${instance-STOGROUP}
    ERASE NO
    NUMPARTS 4
       (PART 1 USING STOGROUP ${instance-STOGROUP}
       ,PART 3 USING STOGROUP ${instance-STOGROUP}
       )
    SEGSIZE 0
    LOCKSIZE PAGE LOCKMAX SYSTEM
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    COMPRESS YES
    CCSID EBCDIC;

  COMMIT ;

  CREATE TABLESPACE ${instance-TSPREFIX}C
    IN ${instance-DBASEP}
    USING STOGROUP ${instance-STOGROUP}
    SEGSIZE 4
    LOCKSIZE TABLE
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  COMMIT ;

  CREATE TABLESPACE ${instance-TSPREFIX}Q
    IN ${instance-DBASEP}
    USING STOGROUP ${instance-STOGROUP}
    SEGSIZE 4
    LOCKSIZE PAGE
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  COMMIT ;

  CREATE TABLESPACE ${instance-TSPREFIX}R
    IN ${instance-DBASEA}
    USING STOGROUP ${instance-STOGROUP}
    ERASE NO
    LOCKSIZE PAGE LOCKMAX SYSTEM
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  CREATE TABLESPACE ${instance-TSPREFIX}P
    IN ${instance-DBASEA}
    USING STOGROUP ${instance-STOGROUP}
    SEGSIZE 4
    LOCKSIZE ROW
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  COMMIT ;

  CREATE TABLESPACE ${instance-TSPREFIX}S
    IN ${instance-DBASEA}
    USING STOGROUP ${instance-STOGROUP}
    ERASE NO
    LOCKSIZE PAGE LOCKMAX SYSTEM
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  CREATE TABLESPACE ${instance-TSPREFIX}X
    IN ${instance-DBASEX}
    USING STOGROUP ${instance-STOGROUP}
    ERASE NO
    LOCKSIZE PAGE LOCKMAX SYSTEM
    BUFFERPOOL ${instance-BP}
    CLOSE NO
    CCSID EBCDIC;

  COMMIT;

//*
//*        STEP  2: CREATE SAMPLE TABLES, VIEWS
//*
//PH01S02 EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//STEPLIB  DD DSN=${instance-DSNLOAD},DISP=SHR
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(${instance-MVSSNAME})
  RUN  PROGRAM(${instance-PROGNAME}) PLAN(${instance-PLANNAME}) -
       LIB('${instance-RUNLIB}')
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSIN    DD  *
  SET CURRENT SQLID = '${instance-SQLID}';

  CREATE TABLE ${instance-SCHEMANAME}.DEPT
                (DEPTNO   CHAR(3)        NOT NULL,
                 DEPTNAME VARCHAR(36)    NOT NULL,
                 MGRNO    CHAR(6)                ,
                 ADMRDEPT CHAR(3)        NOT NULL,
                 LOCATION CHAR(16)               ,
                 PRIMARY KEY(DEPTNO))
     IN ${instance-DBASEA}.${instance-TSPREFIX}D
     CCSID EBCDIC;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XDEPT1
                   ON ${instance-SCHEMANAME}.DEPT
                       (DEPTNO   ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE INDEX ${instance-SCHEMANAME}.XDEPT2
                   ON ${instance-SCHEMANAME}.DEPT
                       (MGRNO   ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE INDEX ${instance-SCHEMANAME}.XDEPT3
                   ON ${instance-SCHEMANAME}.DEPT
                       (ADMRDEPT ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VDEPT
     AS SELECT ALL      DEPTNO  ,
                        DEPTNAME,
                        MGRNO   ,
                        ADMRDEPT
     FROM ${instance-SCHEMANAME}.DEPT;

  CREATE VIEW ${instance-SCHEMANAME}.VHDEPT
     AS SELECT ALL      DEPTNO  ,
                        DEPTNAME,
                        MGRNO   ,
                        ADMRDEPT,
                        LOCATION
     FROM ${instance-SCHEMANAME}.DEPT;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.EMP
                (EMPNO     CHAR(6)        NOT NULL,
                 FIRSTNME  VARCHAR(12)    NOT NULL,
                 MIDINIT   CHAR(1)        NOT NULL,
                 LASTNAME  VARCHAR(15)    NOT NULL,
                 WORKDEPT  CHAR(3)                ,
                 PHONENO   CHAR(4) CONSTRAINT NUMBER CHECK
                  (PHONENO >= '0000' AND PHONENO <= '9999'),
                 HIREDATE  DATE                   ,
                 JOB       CHAR(8)                ,
                 EDLEVEL   SMALLINT               ,
                 SEX       CHAR(1)                ,
                 BIRTHDATE DATE                   ,
                 SALARY    DECIMAL(9, 2)          ,
                 BONUS     DECIMAL(9, 2)          ,
                 COMM      DECIMAL(9, 2)          ,
                 PRIMARY KEY(EMPNO),
                 FOREIGN KEY RED (WORKDEPT)
           REFERENCES ${instance-SCHEMANAME}.DEPT
                   ON DELETE SET NULL)
         PARTITION BY RANGE (EMPNO)
                (PARTITION 1 ENDING AT('099999'),
                 PARTITION 2 ENDING AT('199999'),
                 PARTITION 3 ENDING AT('299999'),
                 PARTITION 4 ENDING AT('999999'))
         EDITPROC  DSN8EAE1
    IN ${instance-DBASEA}.${instance-TSPREFIX}E
         CCSID EBCDIC;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XEMP1
                   ON ${instance-SCHEMANAME}.EMP
                       (EMPNO    ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE INDEX ${instance-SCHEMANAME}.XEMP2
                   ON ${instance-SCHEMANAME}.EMP
                       (WORKDEPT ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VEMP
     AS SELECT ALL      EMPNO   ,
                        FIRSTNME,
                        MIDINIT ,
                        LASTNAME,
                        WORKDEPT
     FROM ${instance-SCHEMANAME}.EMP;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.PROJ
                (PROJNO   CHAR(6) PRIMARY KEY NOT NULL,
                 PROJNAME VARCHAR(24)    NOT NULL WITH DEFAULT
                   'PROJECT NAME UNDEFINED',
                 DEPTNO   CHAR(3)        NOT NULL REFERENCES
                   ${instance-SCHEMANAME}.DEPT
                   ON DELETE RESTRICT,
                 RESPEMP  CHAR(6)        NOT NULL REFERENCES
                   ${instance-SCHEMANAME}.EMP
                   ON DELETE RESTRICT,
                 PRSTAFF  DECIMAL(5, 2)          ,
                 PRSTDATE DATE                   ,
                 PRENDATE DATE                   ,
                 MAJPROJ  CHAR(6))
    IN ${instance-DBASEA}.${instance-TSPREFIX}P
         CCSID EBCDIC;

  ALTER TABLESPACE
   ${instance-DBASEA}.${instance-TSPREFIX}P
   CLOSE NO;

  ALTER  TABLESPACE
   ${instance-DBASEA}.${instance-TSPREFIX}E
         PART 3 COMPRESS NO;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XPROJ1
                   ON ${instance-SCHEMANAME}.PROJ
                       (PROJNO   ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE INDEX ${instance-SCHEMANAME}.XPROJ2
                   ON ${instance-SCHEMANAME}.PROJ
                       (RESPEMP  ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VPROJ
     AS SELECT ALL
               PROJNO, PROJNAME, DEPTNO, RESPEMP, PRSTAFF,
               PRSTDATE, PRENDATE, MAJPROJ
     FROM ${instance-SCHEMANAME}.PROJ ;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.ACT
                (ACTNO    SMALLINT       NOT NULL,
                 ACTKWD   CHAR(6)        NOT NULL,
                 ACTDESC  VARCHAR(20)    NOT NULL,
                 PRIMARY KEY(ACTNO))
    IN ${instance-DBASEA}.${instance-TSPREFIX}P
    CCSID EBCDIC;

  ALTER  TABLESPACE
    ${instance-DBASEA}.${instance-TSPREFIX}P
    CLOSE NO;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XACT1
                   ON ${instance-SCHEMANAME}.ACT
                       (ACTNO    ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XACT2
                   ON ${instance-SCHEMANAME}.ACT
                       (ACTKWD   ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VACT
        AS SELECT ALL      ACTNO   ,
                        ACTKWD  ,
                        ACTDESC
             FROM ${instance-SCHEMANAME}.ACT ;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.PROJACT
                (PROJNO   CHAR(6)        NOT NULL,
                 ACTNO    SMALLINT       NOT NULL,
                 ACSTAFF  DECIMAL(5, 2)          ,
                 ACSTDATE DATE           NOT NULL,
                 ACENDATE DATE                   ,
                 PRIMARY KEY(PROJNO,ACTNO,ACSTDATE),
                 FOREIGN KEY RPAP (PROJNO)
               REFERENCES ${instance-SCHEMANAME}.PROJ
                 ON DELETE RESTRICT,
                 FOREIGN KEY RPAA (ACTNO)
               REFERENCES ${instance-SCHEMANAME}.ACT
                   ON DELETE RESTRICT)
     IN ${instance-DBASEA}.${instance-TSPREFIX}P
     CCSID EBCDIC;

  ALTER  TABLESPACE
    ${instance-DBASEA}.${instance-TSPREFIX}P
    CLOSE NO;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XPROJAC1
                   ON ${instance-SCHEMANAME}.PROJACT
                       (PROJNO   ASC,
                        ACTNO    ASC,
                        ACSTDATE ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VPROJACT
        AS SELECT ALL
              PROJNO,ACTNO, ACSTAFF, ACSTDATE, ACENDATE
              FROM ${instance-SCHEMANAME}.PROJACT ;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.EMPPROJACT
                (EMPNO    CHAR(6)        NOT NULL,
                 PROJNO   CHAR(6)        NOT NULL,
                 ACTNO    SMALLINT       NOT NULL,
                 EMPTIME  DECIMAL(5, 2)          ,
                 EMSTDATE DATE                   ,
                 EMENDATE DATE                   ,
                 FOREIGN KEY REPAPA (PROJNO, ACTNO, EMSTDATE)
           REFERENCES ${instance-SCHEMANAME}.PROJACT
           ON DELETE RESTRICT,
           FOREIGN KEY REPAE (EMPNO)
           REFERENCES ${instance-SCHEMANAME}.EMP
           ON DELETE RESTRICT)
    IN ${instance-DBASEA}.${instance-TSPREFIX}P
    CCSID EBCDIC;

  ALTER  TABLESPACE
    ${instance-DBASEA}.${instance-TSPREFIX}P
    CLOSE NO;

  CREATE UNIQUE INDEX
             ${instance-SCHEMANAME}.XEMPPROJACT1
             ON ${instance-SCHEMANAME}.EMPPROJACT
                       (PROJNO   ASC,
                        ACTNO    ASC,
                        EMSTDATE ASC,
                        EMPNO    ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE INDEX ${instance-SCHEMANAME}.XEMPPROJACT2
              ON ${instance-SCHEMANAME}.EMPPROJACT
                       (EMPNO    ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VEMPPROJACT
        AS SELECT ALL
            EMPNO, PROJNO, ACTNO, EMPTIME, EMSTDATE, EMENDATE
            FROM ${instance-SCHEMANAME}.EMPPROJACT ;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.PARTS
                (ITEMNUM   CHAR(6)        NOT NULL,
                 DESCRIPT  VARCHAR(30)    NOT NULL,
                 COLOR     VARCHAR(8)             ,
                 SUPPLIER  VARCHAR(15)    NOT NULL)
     IN ${instance-DBASEA}.${instance-TSPREFIX}S
     CCSID EBCDIC;

  CREATE INDEX ${instance-SCHEMANAME}.XPARTS
                   ON ${instance-SCHEMANAME}.PARTS
                       (ITEMNUM  ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.TCONA
                (CONVID   CHAR(16)       NOT NULL,
                 LASTSCR  CHAR(8)        NOT NULL,
                 LASTPOS  CHAR(254)      NOT NULL,
                 LASTPOSC CHAR(254)      NOT NULL,
                 LASTMSG  VARCHAR(1609)  NOT NULL)
     IN ${instance-DBASEP}.${instance-TSPREFIX}C
     CCSID EBCDIC;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XCONA1
                   ON ${instance-SCHEMANAME}.TCONA
                       (CONVID   ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VCONA
     AS SELECT ALL
                 CONVID, LASTSCR, LASTPOS, LASTPOSC, LASTMSG
     FROM ${instance-SCHEMANAME}.TCONA ;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.TOPTVAL
                (MAJSYS   CHAR(1)        NOT NULL,
                 ACTION   CHAR(1)        NOT NULL,
                 OBJFLD   CHAR(2)        NOT NULL,
                 SRCHCRIT CHAR(2)        NOT NULL,
                 SCRTYPE  CHAR(1)        NOT NULL,
                 HEADTXT  CHAR(50)       NOT NULL,
                 SELTXT   CHAR(50)       NOT NULL,
                 INFOTXT  CHAR(79)       NOT NULL,
                 HELPTXT  CHAR(79)       NOT NULL,
                 PFKTXT   CHAR(79)       NOT NULL,
                 DSPINDEX CHAR(2)        NOT NULL)
     IN ${instance-DBASEP}.${instance-TSPREFIX}C
     CCSID EBCDIC;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XOPTVAL1
                   ON ${instance-SCHEMANAME}.TOPTVAL
                       (MAJSYS   ASC,
                        ACTION   ASC,
                        OBJFLD   ASC,
                        SRCHCRIT ASC,
                        SCRTYPE  ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VOPTVAL
     AS SELECT ALL
          MAJSYS, ACTION, OBJFLD, SRCHCRIT, SCRTYPE, HEADTXT,
          SELTXT, INFOTXT, HELPTXT, PFKTXT, DSPINDEX
     FROM ${instance-SCHEMANAME}.TOPTVAL ;

  COMMIT ;

  CREATE TABLE ${instance-SCHEMANAME}.TDSPTXT
                (DSPINDEX CHAR(2)        NOT NULL,
                 LINENO   CHAR(2)        NOT NULL,
                 DSPLINE  CHAR(79)       NOT NULL)
     IN ${instance-DBASEP}.${instance-TSPREFIX}C
     CCSID EBCDIC;

  CREATE UNIQUE INDEX ${instance-SCHEMANAME}.XDSPTXT1
                   ON ${instance-SCHEMANAME}.TDSPTXT
                       (DSPINDEX ASC,
                        LINENO   ASC)
                   USING STOGROUP ${instance-STOGROUP}
                   ERASE NO
                   BUFFERPOOL ${instance-BP}
                   CLOSE NO;

  CREATE VIEW ${instance-SCHEMANAME}.VDSPTXT
     AS SELECT ALL
                 DSPINDEX, LINENO, DSPLINE
     FROM ${instance-SCHEMANAME}.TDSPTXT ;

  COMMIT;

  ALTER TABLE ${instance-SCHEMANAME}.DEPT
     FOREIGN KEY RDD (ADMRDEPT)
     REFERENCES ${instance-SCHEMANAME}.DEPT
       ON DELETE CASCADE;
  ALTER TABLE ${instance-SCHEMANAME}.DEPT
     FOREIGN KEY RDE (MGRNO)
     REFERENCES ${instance-SCHEMANAME}.EMP
       ON DELETE SET NULL;
  ALTER TABLE ${instance-SCHEMANAME}.PROJ
     FOREIGN KEY RPP (MAJPROJ)
     REFERENCES ${instance-SCHEMANAME}.PROJ
       ON DELETE CASCADE;

  COMMIT;

  CREATE TABLE ${instance-SCHEMANAME}.EDEPT
   LIKE ${instance-SCHEMANAME}.DEPT
   IN ${instance-DBASEA}.${instance-TSPREFIX}R;
  CREATE TABLE ${instance-SCHEMANAME}.EEMP
   LIKE ${instance-SCHEMANAME}.EMP
   IN ${instance-DBASEA}.${instance-TSPREFIX}R;
  CREATE TABLE ${instance-SCHEMANAME}.EPROJ
   LIKE ${instance-SCHEMANAME}.PROJ
   IN ${instance-DBASEA}.${instance-TSPREFIX}R;
  CREATE TABLE ${instance-SCHEMANAME}.EACT
   LIKE ${instance-SCHEMANAME}.ACT
   IN ${instance-DBASEA}.${instance-TSPREFIX}R;
  CREATE TABLE ${instance-SCHEMANAME}.EPROJACT
   LIKE ${instance-SCHEMANAME}.PROJACT
   IN ${instance-DBASEA}.${instance-TSPREFIX}R;
  CREATE TABLE ${instance-SCHEMANAME}.EEPA
   LIKE ${instance-SCHEMANAME}.EMPPROJACT
   IN ${instance-DBASEA}.${instance-TSPREFIX}R;

  COMMIT;

  ALTER TABLE ${instance-SCHEMANAME}.EDEPT
        ADD RID      CHAR(4);
  ALTER TABLE ${instance-SCHEMANAME}.EDEPT
        ADD TSTAMP   TIMESTAMP;
  ALTER TABLE ${instance-SCHEMANAME}.EEMP
        ADD RID      CHAR(4);
  ALTER TABLE ${instance-SCHEMANAME}.EEMP
        ADD TSTAMP   TIMESTAMP;
  ALTER TABLE ${instance-SCHEMANAME}.EPROJ
        ADD RID      CHAR(4);
  ALTER TABLE ${instance-SCHEMANAME}.EPROJ
        ADD TSTAMP   TIMESTAMP;
  ALTER TABLE ${instance-SCHEMANAME}.EACT
        ADD RID      CHAR(4);
  ALTER TABLE ${instance-SCHEMANAME}.EACT
        ADD TSTAMP   TIMESTAMP;
  ALTER TABLE ${instance-SCHEMANAME}.EPROJACT
        ADD RID      CHAR(4);
  ALTER TABLE ${instance-SCHEMANAME}.EPROJACT
        ADD TSTAMP   TIMESTAMP;
  ALTER TABLE ${instance-SCHEMANAME}.EEPA
        ADD RID      CHAR(4);
  ALTER TABLE ${instance-SCHEMANAME}.EEPA
        ADD TSTAMP   TIMESTAMP;

  COMMIT;

  CREATE SEQUENCE ${instance-SCHEMANAME}.POID
    AS BIGINT
    START WITH 1000
    INCREMENT BY 1;

  CREATE SEQUENCE ${instance-SCHEMANAME}.CID
    AS BIGINT
    START WITH 1000
    INCREMENT BY 1;

  CREATE TABLE ${instance-SCHEMANAME}.PRODUCT
    ( PID              VARCHAR(10)   NOT NULL PRIMARY KEY
     ,NAME             VARCHAR(128)
     ,PRICE            DECIMAL(30, 2)
     ,PROMOPRICE       DECIMAL(30, 2)
     ,PROMOSTART       DATE
     ,PROMOEND         DATE
     ,DESCRIPTION      XML )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.PROD_NAME_PIDX
    ON ${instance-SCHEMANAME}.PRODUCT(PID)
    USING STOGROUP ${instance-STOGROUP};

  CREATE INDEX
    ${instance-SCHEMANAME}.PROD_NAME_XMLIDX
    ON ${instance-SCHEMANAME}.PRODUCT(DESCRIPTION)
    GENERATE KEY USING XMLPATTERN '/product/description/name'
      AS SQL VARCHAR(128)
    USING STOGROUP ${instance-STOGROUP};

  CREATE INDEX
    ${instance-SCHEMANAME}.PROD_DETAIL_XMLIDX
    ON ${instance-SCHEMANAME}.PRODUCT(DESCRIPTION)
    GENERATE KEY USING XMLPATTERN '/product/description/detail'
      AS SQL VARCHAR(128)
    USING STOGROUP ${instance-STOGROUP};

  CREATE TABLE ${instance-SCHEMANAME}.INVENTORY
    ( PID              VARCHAR(10)  NOT NULL PRIMARY KEY,
      QUANTITY         INTEGER,
      LOCATION         VARCHAR(128) )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.INVENTORY_PIDX
    ON ${instance-SCHEMANAME}.INVENTORY(PID)
    USING STOGROUP ${instance-STOGROUP};

  CREATE TABLE ${instance-SCHEMANAME}.CUSTOMER
    ( CID              BIGINT       NOT NULL PRIMARY KEY,
      INFO             XML,
      HISTORY          XML )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.CUSTOMER_CIDX
    ON ${instance-SCHEMANAME}.CUSTOMER(CID)
    USING STOGROUP ${instance-STOGROUP};

  CREATE TABLE ${instance-SCHEMANAME}.PURCHASEORDER
    ( POID             BIGINT       NOT NULL PRIMARY KEY,
      STATUS           VARCHAR(10)  NOT NULL WITH DEFAULT 'New',
      PORDER           XML )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.PURCHASEORDER_POIDX
    ON ${instance-SCHEMANAME}.PURCHASEORDER(POID)
    USING STOGROUP ${instance-STOGROUP};

  CREATE TABLE ${instance-SCHEMANAME}.CATALOG
    ( NAME             VARCHAR(128) NOT NULL PRIMARY KEY,
      CATLOG           XML )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.CATALOG_NAMEX
    ON ${instance-SCHEMANAME}.CATALOG(NAME)
    USING STOGROUP ${instance-STOGROUP};

  CREATE TABLE ${instance-SCHEMANAME}.SUPPLIERS
    ( SID              VARCHAR(10) NOT NULL PRIMARY KEY,
      ADDR             XML )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.SUPPLIERS_SIDX
    ON ${instance-SCHEMANAME}.SUPPLIERS(SID)
    USING STOGROUP ${instance-STOGROUP};

  CREATE TABLE ${instance-SCHEMANAME}.PRODUCTSUPPLIER
    ( PID              VARCHAR(10) NOT NULL,
      SID              VARCHAR(10) NOT NULL,
      PRIMARY KEY(PID,SID) )
    IN ${instance-DBASEX}.${instance-TSPREFIX}X
    CCSID EBCDIC;

  CREATE UNIQUE INDEX
    ${instance-SCHEMANAME}.PRODUCTSUPPLIER_PID_SIDX
    ON ${instance-SCHEMANAME}.PRODUCTSUPPLIER(PID,SID)
    USING STOGROUP ${instance-STOGROUP};

//*
//*        STEP  4: CREATE SAMPLE VIEWS
//*
//PH01S04 EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//STEPLIB  DD DSN=${instance-DSNLOAD},DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(${instance-MVSSNAME})
  RUN  PROGRAM(${instance-PROGNAME}) PLAN(${instance-PLANNAME}) -
       LIB('${instance-RUNLIB}')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID = '${instance-SQLID}';

  CREATE VIEW ${instance-SCHEMANAME}.VDEPMG1
        (DEPTNO, DEPTNAME, MGRNO, FIRSTNME, MIDINIT, LASTNAME, ADMRDEPT)
      AS SELECT ALL
         DEPTNO, DEPTNAME, EMPNO, FIRSTNME, MIDINIT, LASTNAME, ADMRDEPT
          FROM ${instance-SCHEMANAME}.DEPT
          LEFT OUTER JOIN ${instance-SCHEMANAME}.EMP
          ON MGRNO = EMPNO ;

  CREATE VIEW ${instance-SCHEMANAME}.VEMPDPT1
        (DEPTNO, DEPTNAME, EMPNO, FRSTINIT, MIDINIT,
         LASTNAME, WORKDEPT)
      AS SELECT ALL
         DEPTNO, DEPTNAME, EMPNO, SUBSTR(FIRSTNME, 1, 1), MIDINIT,
         LASTNAME, WORKDEPT
          FROM ${instance-SCHEMANAME}.DEPT
          RIGHT OUTER JOIN ${instance-SCHEMANAME}.EMP
          ON WORKDEPT = DEPTNO ;

  CREATE VIEW ${instance-SCHEMANAME}.VASTRDE1
      (DEPT1NO,DEPT1NAM,EMP1NO,EMP1FN,EMP1MI,EMP1LN,TYPE2,
       DEPT2NO,DEPT2NAM,EMP2NO,EMP2FN,EMP2MI,EMP2LN)
      AS SELECT ALL
          D1.DEPTNO,D1.DEPTNAME,D1.MGRNO,D1.FIRSTNME,D1.MIDINIT,
          D1.LASTNAME, '1',
          D2.DEPTNO,D2.DEPTNAME,D2.MGRNO,D2.FIRSTNME,D2.MIDINIT,
          D2.LASTNAME
          FROM ${instance-SCHEMANAME}.VDEPMG1 D1,
               ${instance-SCHEMANAME}.VDEPMG1 D2
          WHERE D1.DEPTNO = D2.ADMRDEPT ;

  CREATE VIEW ${instance-SCHEMANAME}.VASTRDE2
      (DEPT1NO,DEPT1NAM,EMP1NO,EMP1FN,EMP1MI,EMP1LN,TYPE2,
       DEPT2NO,DEPT2NAM,EMP2NO,EMP2FN,EMP2MI,EMP2LN)
      AS SELECT ALL
           D1.DEPTNO,D1.DEPTNAME,D1.MGRNO,D1.FIRSTNME,D1.MIDINIT,
           D1.LASTNAME,'2',
           D1.DEPTNO,D1.DEPTNAME,E2.EMPNO,E2.FIRSTNME,E2.MIDINIT,
           E2.LASTNAME
           FROM ${instance-SCHEMANAME}.VDEPMG1 D1,
                ${instance-SCHEMANAME}.EMP E2
           WHERE D1.DEPTNO = E2.WORKDEPT;

  CREATE VIEW ${instance-SCHEMANAME}.VPROJRE1
    (PROJNO,PROJNAME,PROJDEP,RESPEMP,FIRSTNME,MIDINIT,LASTNAME,MAJPROJ)
     AS SELECT ALL
        PROJNO,PROJNAME,DEPTNO,EMPNO,FIRSTNME,MIDINIT,LASTNAME,MAJPROJ
       FROM ${instance-SCHEMANAME}.PROJ,
            ${instance-SCHEMANAME}.EMP
       WHERE RESPEMP = EMPNO ;

  CREATE VIEW ${instance-SCHEMANAME}.VPSTRDE1
    (PROJ1NO,PROJ1NAME,RESP1NO,RESP1FN,RESP1MI,RESP1LN,
     PROJ2NO,PROJ2NAME,RESP2NO,RESP2FN,RESP2MI,RESP2LN)
     AS SELECT ALL
          P1.PROJNO,P1.PROJNAME,P1.RESPEMP,P1.FIRSTNME,P1.MIDINIT,
          P1.LASTNAME,
          P2.PROJNO,P2.PROJNAME,P2.RESPEMP,P2.FIRSTNME,P2.MIDINIT,
          P2.LASTNAME
       FROM ${instance-SCHEMANAME}.VPROJRE1 P1,
         ${instance-SCHEMANAME}.VPROJRE1 P2
       WHERE P1.PROJNO = P2.MAJPROJ ;

  CREATE VIEW ${instance-SCHEMANAME}.VPSTRDE2
    (PROJ1NO,PROJ1NAME,RESP1NO,RESP1FN,RESP1MI,RESP1LN,
     PROJ2NO,PROJ2NAME,RESP2NO,RESP2FN,RESP2MI,RESP2LN)
     AS SELECT ALL
          P1.PROJNO,P1.PROJNAME,P1.RESPEMP,P1.FIRSTNME,P1.MIDINIT,
          P1.LASTNAME,
          P1.PROJNO,P1.PROJNAME,P1.RESPEMP,P1.FIRSTNME,P1.MIDINIT,
          P1.LASTNAME
       FROM ${instance-SCHEMANAME}.VPROJRE1 P1
         WHERE NOT EXISTS
           (SELECT *
             FROM ${instance-SCHEMANAME}.VPROJRE1 P2
             WHERE P1.PROJNO = P2.MAJPROJ) ;

  CREATE VIEW ${instance-SCHEMANAME}.VFORPLA
    (PROJNO,PROJNAME,RESPEMP,PROJDEP,FRSTINIT,MIDINIT,LASTNAME)
     AS SELECT ALL
        F1.PROJNO,PROJNAME,RESPEMP,PROJDEP, SUBSTR(FIRSTNME, 1, 1),
        MIDINIT, LASTNAME
       FROM ${instance-SCHEMANAME}.VPROJRE1 F1
       LEFT OUTER JOIN
       ${instance-SCHEMANAME}.EMPPROJACT F2
       ON F1.PROJNO = F2.PROJNO;

  CREATE VIEW ${instance-SCHEMANAME}.VSTAFAC1
    (PROJNO, ACTNO, ACTDESC, EMPNO, FIRSTNME, MIDINIT, LASTNAME,
     EMPTIME,STDATE,ENDATE, TYPE)
     AS SELECT ALL
           PA.PROJNO, PA.ACTNO, AC.ACTDESC,' ', ' ', ' ', ' ',
           PA.ACSTAFF, PA.ACSTDATE,
           PA.ACENDATE,'1'
       FROM ${instance-SCHEMANAME}.PROJACT PA,
            ${instance-SCHEMANAME}.ACT AC
       WHERE PA.ACTNO = AC.ACTNO ;

  CREATE VIEW ${instance-SCHEMANAME}.VSTAFAC2
    (PROJNO, ACTNO, ACTDESC, EMPNO, FIRSTNME, MIDINIT, LASTNAME,
     EMPTIME,STDATE, ENDATE, TYPE)
     AS SELECT ALL
           EP.PROJNO, EP.ACTNO, AC.ACTDESC, EP.EMPNO,EM.FIRSTNME,
           EM.MIDINIT, EM.LASTNAME, EP.EMPTIME, EP.EMSTDATE,
           EP.EMENDATE,'2'
       FROM ${instance-SCHEMANAME}.EMPPROJACT EP,
            ${instance-SCHEMANAME}.ACT AC,
            ${instance-SCHEMANAME}.EMP EM
       WHERE EP.ACTNO = AC.ACTNO  AND EP.EMPNO = EM.EMPNO ;

  CREATE VIEW ${instance-SCHEMANAME}.VPHONE
                (LASTNAME,
                 FIRSTNAME,
                 MIDDLEINITIAL,
                 PHONENUMBER,
                 EMPLOYEENUMBER,
                 DEPTNUMBER,
                 DEPTNAME)
     AS SELECT ALL      LASTNAME,
                        FIRSTNME,
                        MIDINIT ,
                        VALUE(PHONENO,'    '),
                        EMPNO,
                        DEPTNO,
                        DEPTNAME
     FROM ${instance-SCHEMANAME}.EMP,
          ${instance-SCHEMANAME}.DEPT
     WHERE WORKDEPT = DEPTNO;

  CREATE VIEW ${instance-SCHEMANAME}.VEMPLP
                (EMPLOYEENUMBER,
                 PHONENUMBER)
     AS SELECT ALL      EMPNO   ,
                        PHONENO
     FROM ${instance-SCHEMANAME}.EMP ;