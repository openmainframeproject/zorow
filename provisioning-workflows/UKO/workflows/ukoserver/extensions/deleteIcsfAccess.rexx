/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

SERVER_STC_GROUP="${instance-UKO_SERVER_STC_GROUP}"

"PERMIT  CSFDSG  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFDSV  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFEDH  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFHMG  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFHMV  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKGN  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKGN2 CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKRC  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKRC2 CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKRR  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKRR2 CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKRW  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKRW2 CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKYT  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKYT2 CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFKYTX CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFOWH  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKG  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKI  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKRC CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKRR CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKRW CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKT  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFPKX  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFRNG  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFRNGL CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFSAD  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFSAE  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFSYI  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFSYI2 CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFSYX  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"
"PERMIT  CSFIQF  CLASS(CSFSERV) DELETE ID("||SERVER_STC_GROUP||")"


"SETROPTS RACLIST(CSFSERV) REFRESH"

