#!/bin/bash

scp setup.sh root@$REMOTE_HOST:/root/
scp ~/fede.pub root@$REMOTE_HOST:/root
ssh root@$REMOTE_HOST 'setup.sh'
