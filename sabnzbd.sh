#!/bin/bash

exec /sbin/setuser htpc /usr/bin/sabnzbdplus --config-file /config --server 0.0.0.0:8080
