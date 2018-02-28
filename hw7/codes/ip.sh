#!/bin/bash
ifconfig | grep 192 | sed 's/^.*addr://g' | sed 's/Bcast.*$//g'
