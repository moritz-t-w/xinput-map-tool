#!/bin/bash

echo "Please unplug the relevant devices and press Enter to continue..."
read

initial_xinput=$(xinput --list)
initial_xrandr=$(xrandr)

echo "Please plug in the relevant devices and press Enter to continue..."
read

final_xinput=$(xinput --list)
final_xrandr=$(xrandr)

output_device=$(diff <(echo "$initial_xrandr") <(echo "$final_xrandr") | grep -oP '(?<=\> )[^ ]+(?= connected)')
input_device=$(diff <(echo "$initial_xinput") <(echo "$final_xinput") | grep -oP '(?<=id=)[0-9]+(?=\t)')

xinput map-to-output $input_device $output_device
