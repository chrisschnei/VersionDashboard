#! /bin/bash

resolutions=(
	20
	29
	40
	50
	57
	58
	60
	72
	76
	80
	87
	100
	114
	120
	144
	152
	167
	180
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
