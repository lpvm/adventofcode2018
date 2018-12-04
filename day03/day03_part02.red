Red [ 
	Title:  "Advent of Code 2018 - Day 03 - Part 02" 
	Date:   2018-12-04
	File:   %day03_part02.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
	Comment: {Modified the claim cycle so that it could be used for part 02.
				Instead of `+ 1` the number of the claim-id is appended to 
				the value of the inch, so that some inches have only one 
				claim-id (would have count = 1 in the file for part 01), and
				some will have a block with several claim-ids (length of
				block > 1). For part 02, algorthim is:
				1. occupied with only one claim id
				2. from these count how many for each claim id
				3. compare with size of each claim as given by the input (ex: 4x4)
				4. if equal, that claim is not overlapped, hence the solution
			}
]	

side-size: 1000
time-start: now/time/precise
input-txt: read %input.txt
; example input:
; {#1 @ 1,3: 4x4^/#2 @ 3,1: 4x4^/#3 @ 5,5: 2x2^/}

digit: charset [#"0" - #"9"]
claim-id: [thru "#" keep some digit]
from-origin: [keep some digit "," keep some digit ":"]
box-size: [keep some digit "x" keep some digit]

; rule: [collect some collect [thru "#" keep to space skip "@" space keep to "," skip keep to ":" skip space keep to "x" skip keep to newline skip]]
rule: [collect some collect [claim-id space "@" space from-origin space box-size skip]]
claim-block: parse input-txt rule

occupied: #()

comment {A 3 by 3 square will have numbered positions like
		1 2 3
		4 5 6
		7 8 9}

; for part 02
claims-inches: #()

foreach claim claim-block [
	cl-id: to-integer to-string claim/1
	cl-left: to-integer to-string claim/2
	cl-top: to-integer to-string claim/3
	cl-right: cl-left - 1 + to-integer to-string claim/4 
	cl-bottom: cl-top - 1 + to-integer to-string claim/5
	current: cl-left

    ; for part 02 - not to have to run through all claims again afterwards
    put claims-inches cl-id (to-integer to-string claim/4) * (to-integer to-string claim/5)

	while [cl-top <= cl-bottom] [
		while [current <= cl-right] [
			inch: side-size * (cl-top ) + current	
			either not find occupied inch [
				put occupied inch reduce [cl-id]
				][
				previous: select occupied inch
				put occupied inch (append previous cl-id)
			]
			current: current + 1
		]
		current: cl-left
		cl-top: cl-top + 1
	]
]

; For part 01
count: 0
foreach v values-of occupied [ if (length? v) > 1 [count: count + 1]]

; For part 02 only
singles: #()
foreach v values-of occupied [
    if (length? v) = 1 [
		cl-id: v/1
		either find singles cl-id [
		    put singles cl-id (select singles cl-id) + 1
		][
		    put singles cl-id 1
		]
 	]
]

non-overlapped: 0
foreach [cl-id inches] body-of claims-inches [
    if inches = select singles cl-id [
		non-overlapped: cl-id break
	]
]


print rejoin ["Execution time: " now/time/precise - time-start]
print rejoin ["Solution part 01: " count]
print rejoin ["Solution part 02: " non-overlapped]
