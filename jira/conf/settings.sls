{% set p  = salt['pillar.get']('jira', {}) %}
{% set g  = salt['grains.get']('jira', {}) %}


{%- set default_version      = '6.4' %}
{%- set default_prefix       = '/opt' %}
{%- set default_source_url   = 'https://downloads.atlassian.com/software/jira/downloads' %}
{%- set default_dbdriver_url = 'https://dev.mysql.com/get/Downloads/Connector-J/' %}
{%- set default_log_root     = '/var/log/jira' %}
{%- set default_jira_user    = 'jira' %}
{%- set default_db_server    = 'localhost' %}
{%- set default_db_name      = 'jira' %}
{%- set default_db_username  = 'jira' %}
{%- set default_db_password  = 'jira' %}
{%- set default_jvm_Xms      = '384m' %}
{%- set default_jvm_Xmx      = '768m' %}
{%- set default_jvm_MaxPermSize = '384m' %}

{%- set version        = g.get('version', p.get('version', default_version)) %}
{%- set dbdriver_version = g.get('dbdriver_version', p.get('dbdriver_version', default_version)) %}
{%- set source_url     = g.get('source_url', p.get('source_url', default_source_url)) %}
{%- set dbdriver_url   = g.get('dbdriver_url', p.get('dbdriver_url', default_dbdriver_url)) %}
{%- set log_root       = g.get('log_root', p.get('log_root', default_log_root)) %}
{%- set prefix         = g.get('prefix', p.get('prefix', default_prefix)) %}
{%- set jira_user      = g.get('user', p.get('user', default_jira_user)) %}
{%- set db_server      = g.get('db_server', p.get('db_server', default_db_server)) %}
{%- set db_name        = g.get('db_name', p.get('db_name', default_db_name)) %}
{%- set db_username    = g.get('db_username', p.get('db_username', default_db_username)) %}
{%- set db_password    = g.get('db_password', p.get('db_password', default_db_password)) %}
{%- set jvm_Xms        = g.get('jvm_Xms', p.get('jvm_Xms', default_jvm_Xms)) %}
{%- set jvm_Xmx        = g.get('jvm_Xmx', p.get('jvm_Xmx', default_jvm_Xmx)) %}
{%- set jvm_MaxPermSize = g.get('jvm_MaxPermSize', p.get('jvm_MaxPermSize', default_jvm_MaxPermSize)) %}


{%- set jira_home      = salt['pillar.get']('users:%s:home' % jira_user, '/home/jira') %}

{%- set jira = {} %}
{%- do jira.update( { 'version'        : version,
                      'source_url'     : source_url,
                      'dbdriver_url'   : dbdriver_url,
                      'dbdriver_version': dbdriver_version,
                      'log_root'       : log_root,
                      'home'           : jira_home,
                      'prefix'         : prefix,
                      'user'           : jira_user,
                      'db_server'      : db_server,
                      'db_name'        : db_name,
                      'db_username'    : db_username,
                      'db_password'    : db_password,
                      'jvm_Xms'        : jvm_Xms,
                      'jvm_Xmx'        : jvm_Xmx,
                      'jvm_MaxPermSize': jvm_MaxPermSize,
                  }) %}

