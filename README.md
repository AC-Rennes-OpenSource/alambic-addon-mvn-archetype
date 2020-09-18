# ALAMBIC ADDON ARCHETYPE
This addon aims to ease the creation of a new addon of the [Alambic ETL](https://github.com/AC-Rennes-OpenSource/alambic) product.
Then, this is time saving as it helps focusing on the actual business operations to implement.

# Packaging
Run the command ```$ mvn clean install``` to package the project and install it within the local Maven repository.

The built ZIP archive stands for a maketplace than can be deployed via the Ansible scripts of the .

# How to create the skeleton of a new Alambic addon
## Execute the command
```
$ mvn archetype:generate -DarchetypeGroupId=alambic-addon.archetype -DarchetypeArtifactId=alambic-addon-archetype -DarchetypeVersion=<version of artefact from the local maven repository or Nexus server> -DgroupId=<Maven group identifier of the new addon> -DartifactId=<Maven artifact identifier of the new addon>
```

### Description
| Option | Description |
|---|---|
| archetypeVersion | **Mandatory :** the latest stable Alambic addon archetype version |
| groupId | **Mandatory :** the group identifier of the newly created Alambic addon (Maven - GAV) |
| artifactId | **Mandatory :** the artifact identifier of the newly created Alambic addon (Maven - GAV) |

### Example to create the Alambic addon "my-addon"
```
$ mvn archetype:generate -DarchetypeGroupId=alambic-addon.archetype -DarchetypeArtifactId=alambic-addon-archetype -DarchetypeVersion=1.0.0-RC01-SNAPSHOT -DgroupId=alambic-addon.my-new-addon -DartifactId=alambic-addon-my-new-addon
```

Here is the example console :

![The console logs](images/console-create-addon.png "Console")

You will be prompted to type-in the following information :
- the version : the one typed-in the command line,
- the addon name : as default, is set with the artifact identifier typed-in the command line,
- the addon description : as default, the string "Alambic addon".


# Addon content
| Directory | Description |
|---|---|
| devops/ | Will be deployed on the control machine, in a path `<path_to_alambic_devops>/<addon_name>`. It may contain the following elements :<ul><li>**env/** : Contains *<environment>.yml* files, named after the inventories (development, production…). These variables will be usable as environment variables in custom scripts, as they will automatically be loaded by the alambic playbook `run_addon_script`.</li><li>**roles/** : Contains custom ansible roles which can be used in custom playbooks.</li><li>*<playbook_name>.yml* : Custom playbooks. In order to load the environment variables, the alambic role `load_env_vars` can be loaded. The variables will then be accessible from the playbook in the dictionary `addon_env`.</li><li>*<playbook_script>.sh* : Scripts generally intended to be launched directly from the control machine, to perform complex operations (launch several playbooks with different parameters for example)</li><li>*ansible.cfg* : Allows to use default alambic roles in custom playbooks</li></ul> |
| jobs/ | Will be deployed on the remote host. Contains `jobs.xml` file, describing all the jobs callable through the alambic application (usually via the `run_addon_job` playbook). |
| scripts/ | Will be deployed on the remote host. Contains custom shell scripts, usually called via the `run_addon_script` playbook from alambic application. |
| output/ | Will be deployed on the remote host. This diretory is empty on deployment, results from addon jobs executions will be found here. |
| resources/ | Will be deployed on the remote host. This directory contains resources needed for the jobs or the scripts for example. Among other things we can frequently find freemarker templates here. |


For more details regarding usage of alambic playbooks in order to execute jobs and/or scripts, please refer to the documentation of [Alambic ETL project](https://github.com/AC-Rennes-OpenSource/alambic).
