/*REXX*/
/************************************************************************/
/* Copyright Contributors to the zOS-Workflow Project.                  */
/* SPDX-License-Identifier: Apache-2.0                                  */
/*                                                                      */
/* Execute shell script via JCL.                                        */
/*                                                                      */
/* This Rexx places the SYSIN shell script in a temporary unix          */
/* file and forwards this file for input to BPXBATCH.                   */
/* The procedure supports switching to superuser, stoponerror and       */
/* allowing additional user supplied parameters.                        */
/*                                                                      */
/*                                                                      */
/* Sample Procedure:                                                    */
/* -----------------                                                    */
/*                                                                      */
/* //USSBATCH PROC SU=NO,ERRSTOP=NO,USERPARM=''                         */
/* //PRSTEP1  EXEC PGM=IKJEFT1A,PARM='USSBATCH &SU &ERRSTOP &USERPARM', */
/* //         REGION=256M                                               */
/* //SYSEXEC  DD DSN=<Your.own.proclib.here>,DISP=SHR                   */
/* //SYSTSPRT DD SYSOUT=*                                               */
/* //SYSPRINT DD DUMMY                                                  */
/* //STDOUT   DD SYSOUT=*                                               */
/* //SYSTSIN  DD DUMMY                                                  */
/* //SYSIN    DD DUMMY                                                  */
/*                                                                      */
/* Sample Job:                                                          */
/* -----------                                                          */
/*                                                                      */
/* //S010      EXEC USSBATCH,SU='Y',ERRSTOP='Y',USERPARM='-x'           */
/* //STDOUT  DD SYSOUT=*                                                */
/* //STDERR  DD SYSOUT=*                                                */
/* //SYSIN   DD *                                                       */
/*  print 'hello world!'                                                */
/*                                                                      */
/* Parameters:                                                          */
/* -----------                                                          */
/*                                                                      */
/* SU = Y | N                                                           */
/*      Specify whenever the script should run as uid = 0.              */
/*      (Permit on BPX.SUPERUSER in the Facility class required.)       */
/*      The default is NO.                                              */
/*                                                                      */
/* ERRSTOP = Y | N                                                      */
/*      Specify if the running script should stop when shell scripts    */
/*      returns an error.                                               */
/*      The default is NO.                                              */
/*                                                                      */
/* USERPARM = '%%%%%%%%%%%%'                                            */
/*      Specify additional parameters. (similar to the -set command)    */
/*      There is no default.                                            */
/*                                                                      */
/************************************************************************/
superuser = 0
stoponerror = 0
userparms_given = 0
realuser = -1
if syscalls('ON')>3 then do
  say 'Unable to establish the syscall environment'
  return
end
parse arg su errstop userparm       /* get parms             */
if substr(su,1,1) = 'Y' |  ,
   substr(su,1,1) = 'y' then do     /* superuser requested ? */
  address syscall 'getuid'          /* save real user        */
  realuser= retval

  address syscall 'setuid 0'
  if retval ^= 0 then do
   x= rexxwto("Switch to superuser not successful",
               "check Racf profile BPX.SUPERUSER")
    say 'Switch to superuser (Setuid) not successful, check',
        'RACF profile BPX.SUPERUSER'
    return 12
  end
  else do
    say 'Switched to SUPERUSER authority'
    superuser = 1
  end
end

if substr(errstop,1,1) = 'Y' | ,
   substr(errstop,1,1) = 'y' then do     /* stop on err req? */
  stoponerror = 1
end

if length(userparm) \= 0     then do     /* parse userparms  */
   userparms_given = 1
end

jobname =  MVSVAR('SYMDEF','JOBNAME')
jobname = translate(jobname,"abcdefghijklmnopqrstuvwxyz",,
          "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
address syscall 'getpid'
pid = retval
sysin  = "/tmp/bcmd."||jobname||".p"||pid||".sysin"

Address syscall 'OPEN 'sysin  O_CREAT+O_RDWR+O_TRUNC 760
fdin = retval

readerror = 0
"EXECIO * DISKR SYSIN(STEM INPUTLINE. FINIS"
if RC = 20 /* error reading sysin  */
   Then Do
        readerror = 1
        End

s = 'echo "**************************************************"'
s = s||ESC_N
Address syscall 'WRITE' fdin 's'

s = 'echo "***USSBATCH     Version 1.3         17 mar 2010***"'
s = s||ESC_N
Address syscall 'WRITE' fdin 's'

If superuser
   Then Do
        s = "echo '*** Commands executed with Superuser authority ***'"
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        End
If stoponerror
   Then Do
        s = "echo '*** Commands executed with Stop on Error       ***'"
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        End
s = 'echo "**************************************************"'
s = s||ESC_N
Address syscall 'WRITE' fdin 's'

If userparms_given
   Then Do
        s = "echo '*** User specified parameters are:" userparm "'"
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        s = "set " userparm
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        End

s = 'echo "`date `                 $LPAR"'
s = s||ESC_N
Address syscall 'WRITE' fdin 's'

s = 'echo "**************************************************"'
s = s||ESC_N
Address syscall 'WRITE' fdin 's'

s = 'echo "  " '
s = s||ESC_N
Address syscall 'WRITE' fdin 's'
If stoponerror
   Then Do
        s="trap 'exit 1' ERR"
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        end

Address syscall 'WRITE' fdin 's'

If readerror = 1
   Then Do
        s = "echo '*** SYSIN read error occurred  ***'"
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        s = "kill -s ABRT $$"
        s = s||ESC_N
        Address syscall 'WRITE' fdin 's'
        End
    Else Do i = 1 To inputline.0
            Parse Var inputline.i s 73 .
            s = strip(s,"T")
            s = s||ESC_N
            Address syscall 'WRITE' fdin 's'
         End
Address syscall 'CLOSE' fdin

"bpxbatch PGM /bin/sh -L "sysin
return_code = RC

if rc >= 256 then return_code = return_code/256
Address syscall 'UNLINK ' sysin

exit return_code
