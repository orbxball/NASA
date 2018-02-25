#!/usr/bin/env bash

lvresize -r -L-100G /dev/nasavg/home_ta
lvresize -r -L+100G /dev/nasavg/home_student
