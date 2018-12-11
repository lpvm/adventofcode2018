Red [ 
	Title:  "Advent of Code 2018 - Day 05 - Part 02" 
	Date:   2018-12-11
	File:   %day05_part02.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]

time-start: now/time/precise
input-txt: read %input.txt

; input-txt: "QqS"
; input-txt: "dabAcCaCBAcCcaDA"
; probe rejoin ["input-txt: " input-txt]

; remove ending newline
input-txt: trim/all input-txt


get-polymer: func [input-str [string!]
					/local reacted
							new-polymer
							size-last
][
	reacted: true
	new-polymer: make string! length? input-str
	size-last: length? input-str
	
	while [reacted] [

		either ((first input-str) <> (second input-str))
			and (((first input-str) = (uppercase second input-str))
				or ((uppercase first input-str) = (second input-str))) [
			; same type and opposite polarity
			input-str: next next input-str	
			; case when QqS, two similar were removed just before the last type
			if tail? next input-str [
				append new-polymer copy/part input-str 1
				input-str: copy head new-polymer
				new-polymer: copy ""
				if (length? input-str) <= 1 [reacted: false]
			]
			if tail? input-str [
				size-last: length? head new-polymer
				input-str: copy head new-polymer
				new-polymer: copy ""
			]
		][
	
			; not (same type and opposite polarity)
			append new-polymer copy/part input-str 1
			input-str: next input-str
	
			if tail? next input-str [
				append new-polymer copy/part input-str 1
				either (length? new-polymer) < size-last [
					size-last: length? new-polymer
				][
					reacted: false
				]
				input-str: copy head new-polymer
				new-polymer: copy ""
			]
		]
	
	]
	input-str
] 



chrs: copy []
repeat i 26 [append chrs #"`" + i]
minimum-reacted: length? input-txt
removed-unit: #"?"

foreach ch chrs [
	units: copy ""
	append units to-string ch append units to-string uppercase ch
	trimmed-input: copy input-txt
	trimmed-input: trim/with trimmed-input units
	good-polymer: get-polymer trimmed-input
	if (length? good-polymer) < minimum-reacted [
		removed-unit: ch
		minimum-reacted: length? good-polymer
	]	
]

print rejoin ["Execution time: " now/time/precise - time-start]
print rejoin ["Removing units: " removed-unit uppercase removed-unit "   produces a minimum length polymer of length: " minimum-reacted]

