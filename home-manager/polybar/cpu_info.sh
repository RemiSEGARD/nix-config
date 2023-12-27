#!/bin/sh

CPU_TEMP_FILE=$(@grep@ -l "Tctl" /sys/class/hwmon/hwmon*/temp*_label)
CPU_TEMP_FILE=${CPU_TEMP_FILE%_*}_input

PREV_TOTAL=0
PREV_IDLE=0
 
while true; do
  @cat@ /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq | @awk@ '{ sum += $1; n++ } END { if (n > 0) printf "%d", sum * 1000 / n; }' | @numfmt@ --to=iec | @awk@ '{ printf "%sHz", $1 }'
  CPU=(`@cat@ /proc/stat | @grep@ '^cpu '`) # Get the total CPU statistics.
  unset CPU[0]                          # Discard the "cpu" prefix.
  IDLE=${CPU[4]}                        # Get the idle CPU time.
 
  # Calculate the total CPU time.
  TOTAL=0
  for VALUE in "${CPU[@]}"; do
    let "TOTAL=$TOTAL+$VALUE"
  done
 
  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
  echo -en " $DIFF_USAGE%"
 
  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_IDLE="$IDLE"

  echo " $((`@cat@ $CPU_TEMP_FILE` / 1000))°C"
 
  # Wait before checking again.
  @sleep@ 3
done

