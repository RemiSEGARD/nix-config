#!/bin/sh

/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | @awk@ '{ print ""$1"%"}' | @tr@ "\n" " "
/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | @awk@ '{ print ""$1"°C"}'
