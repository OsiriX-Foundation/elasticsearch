#!/bin/bash

curl -XPUT "http://localhost:9200/_snapshot/kheops_backup/%3Csnapshot-%7Bnow%2Fd%7D%3E"

