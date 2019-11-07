#set($h1 = '#')
#set($h2 = '##')
#set($h3 = '###')
#set($h4 = '####')

$h1 ${addon-name}
${addon-description}

$h2 How to deploy on the remote host
$h3 Execute the command
```
$ ansible-playbook install_addon.yml -i inventories/<environment>/hosts.yml --vault-password-file <path to the vault password file> --extra-vars="groupId=<addon group identifier> artifactId=<addon artifact identifier> version=<version> force_execute=<true | false> [file=<local archive full path> force_execute=<true | false>]"
```

$h3 Description
| Option | Description |
|---|---|
| -i inventories/<environment>/hosts.yml | **Mandatory  :** specify the target environment to deploy the version to. Could be _development, staging, production..._|
| --vault-password-file | **Mandatory  :** specify the file which stores the vault password to use to decrypt the scripts' variables files.|
| groupId | **Mandatory  :** specify the Maven group identifier of the Alambic addon.|
| artifactId | **Mandatory  :** specify the Maven artifact identifier of the Alambic addon.|
| version | **Mandatory  :** specify the Alambic addon version to deploy.|
| file | Only to deploy a SNAPSHOT version stored locally. Specify the addon marketplace full path.|
| force_execute | Set this parameter to _true_ in order to bypass the confirmation prompt when targeting the production environement (useful for scripting purpose).|

$h3 Example
```
$ ansible-playbook install_addon.yml -i inventories/development/hosts.yml --vault-password-file ~/.vault_pass.txt --extra-vars="groupId=${groupId} artifactId=${artifactId} version=1.0.0"
```

$h2 Execution on the remote host
The following commands execute either a Shell script or single job stored respectively within the addon directory _scripts_ or _jobs_.
The produced files will be placed within the directory _output_.

$h3 How to run an single job
The following command line aims to execute a job as defined by the file _```jobs/jobs.xml```_ of an installed Alambic addon.
As default, the *all* job is executed from the file *jobs/jobs.xml* and outputs are placed into the directory _output_.

$h4 Execute the command
```
$ ansible-playbook run_addon_job.yml -i inventories/<environment>/hosts.yml --vault-password-file <path to the vault password file> --extra-vars="addon_name=<the addon name> job_parameters=<optional job's parameters> clean_output=<True/False> debug_mode=<True/False> job_poll_period=<poll every n seconds> job_timeout=<max execution duration> job_file_name=<the jobs file name> job_name=<the name of the job to execute> force_execute=<true | false>"
```

$h4 Description
| Option | Description |
|---|---|
| -i inventories/<environment>/hosts.yml | **Mandatory  :** specify the target environment to run the job to. Could be _development, staging, production..._|
| --vault-password-file | **Mandatory  :** specify the file which stores the vault password to use to decrypt the scripts' variables files.|
| addon_name | **Mandatory  :** specify the name of the addon whose job will be executed. Usually, it deals with the addon Maven artifact identifier. Despite multiple versions might be installed, only the latest installed one will be used.|
| job_file_name | The name of the XML file containing all jobs definition. As default, _```jobs.xml```_ is used.|
| job_name | The name of the job to execute. As default, the job named "all" is executed. Use ':' for multiple jobs, ex: _job_name=job1:job2_|
| job_parameters | Specify the list of parameters (separated with the comma character ',') passed-to the job.
| job_poll_period | The period (unit is _second_) to poll the execution status of the job. Polling mechanism permit to release the ssh connection after the job is launched since this one can be quite long. The command returns to prompt only after the job is completed. As default, value "0" is used which leads to "run & forget" the job (the command returns immediately).|
| job_timeout | The maximum execution timeout (unit is _second_). **/!\\** as default, is 3600 seconds.|
| clean_output | Specify whether the output result directory must be cleaned before job execution.|
| debug_mode | Specify whether the debug mode must be enabled while the job is executed. As default, the debug mode is disabled (the port "8787" is configured by the environment's variables).|
| force_execute | Set this parameter to _true_ in order to bypass the confirmation prompt when targeting the production environement (useful for scripting purpose).|

$h4 Example
```
$ ansible-playbook run_addon_job.yml -i inventories/development/hosts.yml --vault-password-file ~/.vault_pass.txt --extra-vars="addon_name=${addon-name} job_parameters='p1,p2' clean_output=True job_name=do-something job_poll_period=5"
```

$h3 How to run a shell script
The following command line aims to execute a shell script embedded into an installed addon.
As default, the shell script _```scripts/script.sh```_ is executed and outputs are placed into the directory _output_.

$h4 Execute the command
```
$ ansible-playbook run_addon_script.yml -i inventories/<environment>/hosts.yml --vault-password-file <path to the vault password file> --extra-vars="addon_name=<the addon name> script_file_name=<the script file name> script_parameters=<optional script's parameters> clean_output=<True/False> debug_mode=<True/False> job_poll_period=<poll every n seconds> job_timeout=<max execution duration> force_execute=<true | false>"
```

$h4 Description
| Option | Description |
|---|---|
| -i inventories/<environment>/hosts.yml | **Mandatory  :** specify the target environment to runt the script to. Could be _development, staging, production..._|
| --vault-password-file | **Mandatory  :** specify the file which stores the vault password to use to decrypt the scripts' variables files.|
| addon_name | **Mandatory  :** specify the name of the addon whose job will be executed. Usually, it deals with the addon Maven artifact identifier. Despite multiple versions might be installed, only the latest installed one will be used.|
| script_file_name | The name of the shell script file to execute. As default, _```script.sh```_ is executed.
| script_parameters | Specify the list of parameters (separated with the comma character ',') passed-to the script.|
| job_poll_period | The period (unit is _second_) to poll the execution status of the job. Polling mechanism permit to release the ssh connection after the job is launched since this one can be quite long. The command returns to prompt only after the job is completed. As default, value "0" is used which leads to "run & forget" the job (the command returns immediately).|
| job_timeout | The maximum execution timeout (unit is _second_). **/!\\** as default, is 3600 seconds.|
| clean_output | Specify whether the output result directory must be cleaned before job execution.|
| debug_mode | Specify whether the debug mode must be enabled while the job is executed. As default, the debug mode is disabled (the port "8787" is configured by the environment's variables).|
| force_execute | Set this parameter to _true_ in order to bypass the confirmation prompt when targeting the production environement (useful for scripting purpose).|

$h4 Example
```
$ ansible-playbook run_addon_script.yml -i inventories/development/hosts.yml --vault-password-file ~/.vault_pass.txt --extra-vars="addon_name=${addon-name} debug_mode=False clean_output=True job_poll_period=5 script_parameters='-f mydir/hello-world.xml'"
```

$h2 How to get the execution report
The following command line aims to fetch the execution reports and logs built by the ETL when either the job or script is completed.

> **/i\\** All reports are fetched, whatever the addon is, not only the latest one.

$h3 Execute the command
```
$ ansible-playbook fetch_reports.yml -i inventories/<environment>/hosts.yml --vault-password-file <path to the vault password file> --extra-vars="age=<files max age>"
```

$h3 Description
| Option | Description |
|---|---|
| -i inventories/<environment>/hosts.yml | **Mandatory  :** specify the target environment to fetch the logs from. Could be _development, staging, production..._|
| --vault-password-file | **Mandatory  :** specify the file which stores the vault password to use to decrypt the scripts' variables files.|
| age | Specify the report & log files max age (unit is day). As default, all files are fetched.|

$h3 Example
```
$ ansible-playbook fetch_reports.yml -i inventories/development/hosts.yml --vault-password-file ~/.vault_pass.txt
```