#!/usr/bin/env bash

resolutions=(
	16
	32
	64
	128
	1024
)

inputimage=$1

if [[ ${inputimage} != *.png ]]
then
	echo Input images must be of type png due to transparency.
	exit
fi

for i in "${resolutions[@]}"
do
	sips --resampleWidth "$i" $inputimage --out "$i"x"$i".png
	echo Image "$i" generated
done
