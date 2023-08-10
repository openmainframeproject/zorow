#########################################
# creating the sed string 
#########################################

sedstring="";

#  /* FOR SQLID, SCHEMA                  */
#  "CHANGE 'KMGSQLID' 'KMGSQLID' ALL"
#  "CHANGE 'KRYTEST1' 'KRYTEST1' ALL"
sedstring="${sedstring} s/KMGSQLID/${instance-DB_CURRENT_SCHEMA}/g;"
sedstring="${sedstring} s/KRYTEST1/${instance-DB_CURRENT_SCHEMA}/g;"

#  /* FOR DATABASE, STORAGE GROUP */
#  "CHANGE 'DKMG0001' 'DKMG0001' ALL"
sedstring="${sedstring} s/DKMG0001/${instance-EKMF_API_DB_NAME}/g;"
#  "CHANGE 'DKMGPE1'  'DKMGPE1'  ALL"
sedstring="${sedstring} s/DKMGPE1/${instance-DATA_SET_DB_NAME}/g;"
#  "CHANGE 'GKMG0001' 'GKMG0001' ALL"
sedstring="${sedstring} s/GKMG0001/${instance-DB_STOGROUP}/g;"

#  /* FOR tablespace bufferpools */
#  "CHANGE 'BUFFERPOOL BP8K0' 'BUFFERPOOL BP8K0' ALL"
sedstring="${sedstring} s/BP8K0/${instance-DB_BUFFERPOOL}/g;"

#  /* FOR DATABASE bufferpools */
#  "CHANGE 'BUFFERPOOL BP1' 'BUFFERPOOL BP1' ALL"
#  "CHANGE 'INDEXBP    BP2' 'INDEXBP    BP2' ALL"

#  /* MISC   */
#  "CHANGE 'PRIQTY 28 SECQTY 28' 'PRIQTY 28 SECQTY 28' ALL"
#  "CHANGE 'CLOSE NO'            'CLOSE NO'            ALL"
#  "CHANGE 'MAXPARTITIONS 128' 'MAXPARTITIONS 128'     ALL"
#  "CHANGE 'FREEPAGE 10'       'FREEPAGE 10'           ALL"
#  "CHANGE 'PCTFREE 10'        'PCTFREE 10'            ALL"

# echo "sedstring: $sedstring"
# echo "instance variables: ${instance-EKMF_API_DB_NAME}, ${instance-DATA_SET_DB_NAME}, ${instance-DB_BUFFERPOOL}, ${instance-DB_STOGROUP}"


#########################################
# creating the list of DDLs
#########################################

#sed -En 's/(\/\/[^\*]).*&SQL\((.*)\).*/\2/gp' "//'ARNOLD.KMG.JCL(${instance-EKMF_DB_MEMBER})'""
# sed -En 's/(\/\/[^\*]).*&SQL\((.*)\).*/\2/gp' ./${instance-EKMF_DB_MEMBER}

for i in `cat ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.files`; do
  # copy the current DDL
  cp "//'${instance-EKMF_DB_HLQ}($i)'" ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.tmp.ddl
  # convert the current DDL
  iconv -f IBM-037 -t ${instance-DB_CODEPAGE} ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.tmp.ddl > ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.conv.ddl
  #check whether the current ddl contains database creation
  if (grep -Fq "CREATE DATABASE" ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.conv.ddl)
  then
      echo "$i contains database creation and will not be added";
  else
    echo "DDL added to list of updates: $i"
    sed -e "$sedstring" ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.conv.ddl >> ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.ddl
    echo "\nCOMMIT;\n" >> ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.ddl;   
  fi
  
  rm ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.tmp.ddl
  rm ${instance-TEMP_DIR}/zosmf-${_workflow-workflowKey}.conv.ddl
done;