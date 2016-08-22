{%- from 'jira/conf/settings.sls' import jira with context %}

include:
  - sun-java
  - sun-java.env
#  - apache.vhosts.standard
#  - apache.mod_proxy_http

### APPLICATION INSTALL ###
unpack-jira-tarball:
  archive.extracted:
    - name: {{ jira.prefix }}
    - source: {{ jira.source_url }}/atlassian-jira-software-{{ jira.version }}-jira-{{jira.version}}.tar.gz
    - source_hash: {{ salt['pillar.get']('jira:source_hash', '') }}
    - archive_format: tar
    - user: jira 
    - tar_options: z
    - if_missing: {{ jira.prefix }}/atlassian-jira-{{ jira.version }}-standalone
    - runas: jira
    - keep: True
    - require:
      - module: jira-stop
      - file: jira-init-script
    - listen_in:
      - module: jira-restart

fix-jira-filesystem-permissions:
  file.directory:
    - user: jira
    - recurse:
      - user
    - names:
      - {{ jira.prefix }}/atlassian-jira-{{ jira.version }}-standalone
      - {{ jira.home }}
      - {{ jira.log_root }}
    - watch:
      - archive: unpack-jira-tarball

create-jira-symlink:
  file.symlink:
    - name: {{ jira.prefix }}/jira
    - target: {{ jira.prefix }}/atlassian-jira-{{ jira.version }}-standalone
    - user: jira
    - watch:
      - archive: unpack-jira-tarball

create-logs-symlink:
  file.symlink:
    - name: {{ jira.prefix }}/jira/logs
    - target: {{ jira.log_root }}
    - user: jira
    - backupname: {{ jira.prefix }}/jira/old_logs
    - watch:
      - archive: unpack-jira-tarball

### SERVICE ###
jira-service:
  service.running:
    - name: jira
    - enable: True
    - require:
      - archive: unpack-jira-tarball
      - file: jira-init-script

# used to trigger restarts by other states
jira-restart:
  module.wait:
    - name: service.restart
    - m_name: jira

jira-stop:
  module.wait:
    - name: service.stop
    - m_name: jira  

jira-init-script:
  file.managed:
    - name: '/etc/init.d/jira'
    - source: salt://jira/templates/jira.init.tmpl
    - user: root
    - group: root
    - mode: 0755
    - template: jinja
    - context:
      jira: {{ jira|json }}

### FILES ###
{{ jira.home }}/jira-config.properties:
  file.managed:
    - source: salt://jira/templates/jira-config.properties.tmpl
    - user: {{ jira.user }}
    - template: jinja
    - listen_in:
      - module: jira-restart

{{ jira.home }}/dbconfig.xml:
  file.managed:
    - source: salt://jira/templates/dbconfig.xml.tmpl
    - user: {{ jira.user }}
    - template: jinja
    - listen_in:
      - module: jira-restart

{{ jira.prefix }}/jira/atlassian-jira/WEB-INF/classes/jira-application.properties:
  file.managed:
    - source: salt://jira/templates/jira-application.properties.tmpl
    - user: {{ jira.user }}
    - template: jinja
    - listen_in:
      - module: jira-restart

{{ jira.prefix }}/jira/bin/setenv.sh:
  file.managed:
    - source: salt://jira/templates/setenv.sh.tmpl
    - user: {{ jira.user }}
    - template: jinja
    - mode: 0644
    - listen_in:
      - module: jira-restart

# {{ jira.prefix }}/jira/conf/logging.properties:
#   file.managed:
#     - source: salt://jira/templates/logging.properties.tmpl
#     - user: {{ jira.user }}
#     - template: jinja
#     - watch_in:
#       - module: jira-restart

