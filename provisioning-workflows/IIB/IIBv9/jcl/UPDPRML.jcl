;******************************************************************
;*              IBM Integration Bus                               *
;*                                                                *
;* Dsnaoini for an integration node.                              *
;*                                                                *
;******************************************************************
ÝCOMMON¨
APPLTRACE=0
APPLTRACEfilename="DD:APPLTRC"
TRACETIMESTAMP=3
TRACEPIDTID=1
CONNECTTYPE=2
DIAGTRACE=0
DIAGTRACE_NO_WRAP=0
MAXCONN=0
MULTICONTEXT=0
MVSDEFAULTSSID=${instance-IIB_DBSRV_NAME}

; SUBSYSTEM
Ý${instance-IIB_DBSRV_NAME}¨
MVSATTACHTYPE=RRSAF
PLANNAME=DSNACLI

; DATASOURCES
Ý${instance-IIB_DBSRV_NAME}¨
CURRENTSQLID=${instance-IIB_CURRENTSQLID}
AUTOCOMMIT=0
CONNECTTYPE=2
CURRENTAPPENSCH=UNICODE
MULTICONTEXT=0
MVSATTACHTYPE=RRSAF
PLANNAME=DSNACLI
TXNISOLATION=2