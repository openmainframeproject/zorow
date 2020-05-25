#/bin/sh
zowe profiles set zosmf LBI9
bd="/_APPS/mfauto/workflows/ZOS"
ls . | grep -i ZOS  \
     | awk {'print $1'}  \
     | while read line; 
        do zowe files ul ftu $line $bd/$line -b; 
      done