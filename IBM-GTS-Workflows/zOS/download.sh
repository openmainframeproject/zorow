#/bin/sh
zowe profiles set zosmf LBI9
bd="/_APPS/mfauto/workflows/ZOS"
zowe files ls uss $bd \
     | grep -i zos  \
     | awk {'print $1'}  \
     | while read line; 
        do zowe files dl uf $bd/$line -b; 
      done