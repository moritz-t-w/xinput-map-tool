#!/bin/bash

echo "Please unplug the relevant devices and press Enter..."
read

initial_xinput=$(xinput --list)
initial_xrandr=$(xrandr)

if [ $? -ne 0 ]; then
   echo "Error: Failed to get initial device state"
   exit 1
fi

echo "Please plug in the relevant devices and press Enter..."
read

new_xinput=$(xinput --list)
new_xrandr=$(xrandr)

if [ $? -ne 0 ]; then
   echo "Error: Failed to get new device state"
   exit 1
fi

output_device=$(diff <(echo "$initial_xrandr") <(echo "$new_xrandr") | grep -oP '(?<=\> )[^ ]+(?= connected)')
input_device=$(diff <(echo "$initial_xinput") <(echo "$new_xinput") | grep -oP '(?<=id=)[0-9]+(?=\t)')

if [ -z "$output_device" ] || [ -z "$input_device" ]; then
   echo "Error: Failed to detect devices"
   exit 1
fi

echo "Mapping input \"$input_device\" to output \"$output_device\"..."
xinput map-to-output $input_device $output_device

if [ $? -ne 0 ]; then
   echo "Error: Failed to map input to output"
   exit 1
fi

echo "Done."
