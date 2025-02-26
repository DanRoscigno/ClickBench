#!/bin/bash

# Install

curl https://clickhouse.com/ | sh
sudo DEBIAN_FRONTEND=noninteractive ./clickhouse install
sudo clickhouse start

# Load the data

clickhouse-client < create.sql

wget --continue 'https://datasets.clickhouse.com/hits_compatible/hits.tsv.gz'
gzip -d hits.tsv.gz

clickhouse-client --time --query "INSERT INTO hits FORMAT TSV" < hits.tsv

# Run the queries

./run.sh

clickhouse-client --query "SELECT total_bytes FROM system.tables WHERE name = 'hits' AND database = 'default'"
