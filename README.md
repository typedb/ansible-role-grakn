# grakn

[![Build Status](https://travis-ci.org/graknlabs/ansible-role-grakn.svg?branch=master)](https://travis-ci.org/graknlabs/ansible-role-grakn)

Installs and configures [GRAKN.AI](https://github.com/graknlabs/grakn) on Ubuntu servers.

## Requirements
* Ansible >2.3.1
* Tested on Ubuntu 16.04

The role needs to be run as root or with 'become: yes'.

Grakn itself requires:
* Oracle Java 8 on the target server.
* Cassandra
* Redis
* Zookeeper
* Kafka

For Analytics, you will need:
* Apache Spark cluster
* Apache Hadoop node

## Role variables
For defaults values of the variables below, see `defaults/main.yml`.

Grakn version:
```
grakn_engine_version: "0.14.0"
```

Backend configuration:
```
storage_hostname: 10.0.0.1,10.0.0.2,10.0.0.3
storage_cassandra_replication_strategy_class: org.apache.cassandra.locator.SimpleStrategy
storage_cassandra_replication_strategy_options: "replication_factor,1"
```
See [Cassandra documentation](http://docs.datastax.com/en/cql/3.1/cql/cql_reference/create_keyspace_r.html) for more information.

Auxiliary server configuration:
```
kafka_hosts: ['localhost']
zookeeper_hosts: ['localhost']
redis_host: "localhost" # single server
```

Java options passed directly to the JVM on the command line:
```
grakn_engine_extra_options: "-Xmx12g -XX:+HeapDumpOnOutOfMemoryError"
```
Log level for Grakn:
```
grakn_engine_log_level: "INFO"
```
### Deploying custom releases
Your package needs to be named `grakn-dist-SOME_VERSION.tar.gz`.  
This can be obtain by [compiling Grakn from source](https://grakn.ai/pages/documentation/resources/downloads.html#building-the-code)

####  Download from URL
By default, the role will download the release available on GitHub and install it on the server.  
To download from a custom location, add this to `group_vars/all`:
```
grakn_engine_version: SOME_VERSION
grakn_download_url: "https://example.com/path/to/grakn-dist-SOME_VERSION.tar.gz"
```
You must specify the version so the playbook extracts the correct directory from archive and deploys the matching configuration.

#### Upload from local machine
The distribution archive must be located in `files/` of the playbook's directory.  
Add the following to your `group_vars/all`:
```
upload_release: true
grakn_engine_version: SOME_VERSION
```
If you want to specify an alternative directory, use:
```
grakn_engine_package_directory: "/full/path/to/tar/"
```

#### Upgrade / re-deploy Grakn
We currently don't have a way of checking if the installed and uploaded version of Grakn match for idempotence so to force a re-deploy, add this variable to your Grakn hosts:
```
redeploy: true
```
From the CLI you can run it as follows:
```
ansible-playbook -i inventory grakn_test.yml --tags role:grakn -e "{redeploy: true}"
```

## Example playbook:
`playbook.yml`
```yaml
- name: Grakn deployment
  hosts:
    - "grakn"
  become: yes
  roles:
    - { role: grakn }
```

`group_vars/all`
```yaml
storage_hostname: "10.0.0.1,10.0.0.2,10.0.0.3"
zookeeper_hosts: [ 10.0.0.11 ]
kafka_hosts: [ 10.0.0.21,10.0.0.22,10.0.0.23 ]
redis_host: "10.0.0.31"
```

## License
Apache 2.0
