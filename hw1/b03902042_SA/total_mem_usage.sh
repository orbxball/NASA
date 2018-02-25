#!/usr/bin/env bash

ps aux | awk -v u=$1 'BEGIN {sum=0} $1 ~ "^"u {sum+=$5} END {print sum}'
