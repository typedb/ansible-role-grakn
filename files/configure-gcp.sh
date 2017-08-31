#!/bin/bash
# This script automatically configures Grakn running on Google Cloud Platform VMs from the metadata variables.

CONFDIR="/opt/grakn/cluster/grakn/conf/main/"
CASSANDRA_IP=$(curl -f -s 169.254.169.254/computeMetadata/v1beta1/project/attributes/cassandra_grakn)
KAFKA_IP=$(curl -f -s 169.254.169.254/computeMetadata/v1beta1/project/attributes/kafka_grakn)
ZOOKEEPER_IP=$(curl -f -s 169.254.169.254/computeMetadata/v1beta1/project/attributes/zookeeper_grakn)
if [[ -z "${CASSANDRA_IP}" ]]; then
  CASSANDRA_IP="DUMMY"
fi
if [[ -z "${KAFKA_IP}" ]]; then
  KAFKA_IP="DUMMY"
fi
if [[ -z "${ZOOKEEPER_IP}" ]]; then
  ZOOKEEPER_IP="DUMMY"
fi
sed -i "s/storage.hostname=.*/storage.hostname="${CASSANDRA_IP}"/g" "${CONFDIR}/grakn.properties"
sed -i "s/titanmr.ioformat.conf.storage.hostname=.*/titanmr.ioformat.conf.storage.hostname="${CASSANDRA_IP}"/g" "${CONFDIR}/grakn.properties"
sed -i "s/bootstrap.servers=.*/bootstrap.servers="${KAFKA_IP}"/g" "${CONFDIR}/grakn.properties"
sed -i "s/tasks.zookeeper.servers=.*/tasks.zookeeper.servers="${ZOOKEEPER_IP}"/g" "${CONFDIR}/grakn.properties"
