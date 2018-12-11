Red [ 
	Title:  "Advent of Code 2018 - Day 05 - Part 01" 
	Date:   2018-12-11
	File:   %day05_part01.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]

time-start: now/time/precise
input-txt: read %input.txt

; input-txt: "dabAcCaCBAcCcaDA"
; probe rejoin ["input-txt: " input-txt]

reacted: true
new-polymer: make string! length? input-txt
size-last: length? input-txt

while [reacted] [

	either ((first input-txt) <> (second input-txt))
		and (((first input-txt) = (uppercase second input-txt))
			or ((uppercase first input-txt) = (second input-txt))) [
		; same type and opposite polarity
		input-txt: next next input-txt	
		if tail? input-txt [
			size-last: length? head new-polymer
			input-txt: copy head new-polymer
			new-polymer: copy ""
		]
	][

		; not (same type and opposite polarity)
		append new-polymer copy/part input-txt 1
		input-txt: next input-txt
; 		probe rejoin ["new polymer: " new-polymer]
; 		probe rejoin ["at input-txt: " input-txt]

		if tail? next input-txt [
; 			probe ["tail"]
			append new-polymer copy/part input-txt 1
; 			probe rejoin ["new polymer tail: " new-polymer]
; 			probe rejoin ["size-last: " size-last  "    length? new-polymer: " length? new-polymer]
			either (length? new-polymer) < size-last [
				size-last: length? new-polymer
			][
				reacted: false
			]
; 			probe "after either"
			input-txt: copy head new-polymer
			new-polymer: copy ""
		]
	]

]

; remove ending newline
input-txt: trim/all input-txt
print rejoin ["Execution time: " now/time/precise - time-start]
probe length? input-txt


