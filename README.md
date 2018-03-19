ansible-hypothesis
=========

An ansible role used to install and configure the OpenStax Hypothes.is [H server fork](https://github.com/openstax/hypothesis-server).


## Documentation

This ansible role is scoped around the task of deploying the H application and getting it configured in the capacity that it is used by OpenStax. We currently only use the H web api endpoints and block access to the homepage so that we can avoid it being indexed by Google.

This role does the following things:

1. Clones the GitHub repository to the server
2. Installs Python2 and creates a virtualenv.
3. Configures the virtualenv and installs Gunicorn + dependencies.
4. Initializes the H application by preparing the database.
5. Installs [box-exporter](https://github.com/openstax/box-exporter) and creates a cron job to run a research export.


Requirements
------------

The H application requires the following services:

1. RabbitMQ
2. Elasticsearch
3. PostgreSQL

Role Variables
--------------

| Name                            | Default Value    | Description |
|---------------|------------------|--------------------------------|
| `h_application_name` | h | the name of the application (used to create app directory names) |
| `h_user` | h-user |  the username that will own directories and files created for the application |
| `h_user_group` | www-data | the group that will own directories and files created for the application |
| `h_directory` | "/var/www/{{ h_application_name }}" | the directory that the application files will live |
| `h_conf_directory` | "{{ h_directory }}/conf" | the directory the configuration where the configuration files are kept |
| `h_bin_directory` | "{{ h_directory }}/bin" | the directory where the scripts are kept |
| `h_log_directory` | "/var/log/{{ h_application_name }}" | the directory where application logs are kept|
| `h_error_log` | "{{ h_log_directory }}/error.log" | the name of the application error log file |
| `h_access_log` | "{{ h_log_directory }}/access.log" | the name of the web application access log file |
| `h_worker_log` | "{{ h_log_directory }}/celery.log" | the name of the celery worker log file |
| `h_celery_beat_log` | "{{ h_log_directory }}/celery-beat-log.log" | the name of the celery beat log file |
| `h_app_url` | *required* | the application url ex. `hdev.openstax.org` |
| `h_virtualenv_base` | "{{ h_directory }}/.env" | the directory where the virtualenv will be created |
| `h_virtualenv_python` | /usr/bin/python | the python interpreter to use when creating the virtualenv |
| `h_virtualenv_requirements_path` | *required* | the path to the pip requirements file to be installed |
| `h_authority` | *required* | the authority to be used by the hypothesis application |
| `h_client_id` |  *required* | the client_id used to authenticate JWT tokens |
| `h_client_secret` | *required* | the client_secret used to authenticate JWT tokens |
| `h_secret_key` | *required* | the secret key used to create CSRF tokens |
| `h_db_user` | postgres | the postgres database user |
| `h_db_password` | omitted | the database user password |
| `h_db_name` | hypothesis | the database name |
| `h_db_host` | localhost | the database host|
`h_db_url`| "postgresql://{{ h_db_user }}:{{ h_db_password }}@{{ h_db_host }}/{{ h_db_name }}" | the database url used to connect to the database |
| `h_box_exporter_enabled` | false | if the box-exporter application should be installed |
| `h_box_exporter_home` |  /opt/box_exporter | the location where box exporter files should be located |
| `h_box_exporter_query_file` | annotation-query.sql | the name of the query file to be used |
| `h_box_exporter_script_file` | annotation-export.sh | the script file that should run the box exporter application |
| `h_box_client_id` | *required* | the client_id to authenticate with the box service |
| `h_box_client_secret` | *required* | the client_secret used to authenticate with the box service |
| `h_box_folder_id` | *required* | the folder_id to upload files to the box service |
| `h_box_rsa_private_key_pass` | *required* | the rsa private key password for rsa private key |
| `h_box_rsa_private_key_path` | *required* | the file path where the private key should be saved |
| `h_box_rsa_private_key_content` | *required* | the content of the box private key |
| `h_box_jwt_key_id` | *required* | the box jwt_key_id used to authenticate with the box service |
| `h_box_enterprise_id` | *required* | the enterprise_id used to authenticate with the box service |
| `gh_repo` | https://github.com/openstax/hypothesis-server.git | the location of the H GitHub repo |
| `gh_dest_dir` | "{{ h_directory}}" | the destination directory where the GitHub repo should be copied |
| `gh_dest_dir_user` | "{{ h_user }}" | the owner of the destination directory |
| `gh_dest_dir_group` | "{{ h_user_group }}" | the owner group of the destination directory |
| `nodejs_npm_global_packages` | ['gulp-cli'] | npm packages that need to be installed globally |
| `nodejs_install_npm_user` | "{{ h_user }}" | the user to be used to install npm packages|
| `nodejs_package_json_path` | "{{ h_directory }}" | the directory where the package.json is located|

There are a number of of other variables used to configure the services. Examples can be found in the [defaults/main.yml](defaults/main.yml) folder

Dependencies
------------

This role depends on two other roles:

* [openstax.nodejs](https://github.com/openstax/ansible-role-nodejsgit)
* [openstax.github](https://github.com/openstax/ansible-github)

Example Playbook
----------------

Please refer to the [hypothesis-deployment](https://github.com/openstax/hypothesis-deployment/blob/master/hypothesis.yml) playbook.

License
-------

GPLv3
