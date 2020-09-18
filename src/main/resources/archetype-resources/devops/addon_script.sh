#!/bin/bash

VERBOSE=0

#----------------------------------------------
# functions
#----------------------------------------------
logger() {
  if [ "ERROR" = $1 ] || [ "WARN" = $1 ] || [ $VERBOSE -eq 2 ] || [ $1 = "INFO" -a $VERBOSE -eq 1 ]
  then
    echo "[$1]" $2
  fi
}

usage() {
  echo "Usage: \"$0 -e <name of Ansible inventory defining target environment> [-v (verbose)]\""
}

finally() {
  logger "INFO" "Completed processing"
  exit $1
}

#---------------------------------------------
# Controls
#---------------------------------------------
# parse the command options
while getopts "ve:" opt
do
  case $opt in
    e)
      #
      ANSIBLE_ENVIRONMENT=$OPTARG
      ;;
    v)
        # enable verbose simple logs
        VERBOSE=1
        ;;
    \?)
      logger "ERROR" "Invalid argument: -$OPTARG" >&2
      usage
      finally 1
      ;;
  esac
done

if [ -z "${ANSIBLE_ENVIRONMENT}" ]
then
  logger "ERROR" "Target environment is not set"
  usage
  finally 1
fi

# Local playbook
logger "INFO" "Launch local playbook"
ansible-playbook addon_playbook.yml -i ../inventories/${ANSIBLE_ENVIRONMENT}/hosts.yml --vault-password-file ~/.vault_pass.txt --extra-vars="force_execute=true"

# Run script
logger "INFO" "Run addon script using alambic playbook"
ansible-playbook ../run_addon_script.yml -i ../inventories/${ANSIBLE_ENVIRONMENT}/hosts.yml --vault-password-file ~/.vault_pass.txt --extra-vars="addon_name=${addon-name} clean_output=True debug_mode=False job_timeout=3600 job_poll_period=5 script_file_name=script_log_var.sh force_execute=true"
finally 0
