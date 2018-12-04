Red [ 
Title:  "Advent of Code 2018 - Day 03 - Part 01" 
Date:   2018-12-04
File:   %day03_part01.red
Author: "Luis Vale Mendes"
Version: 0.0.1
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

foreach claim claim-block [
	cl-id: to-integer to-string claim/1
	cl-left: to-integer to-string claim/2
	cl-top: to-integer to-string claim/3
	cl-right: cl-left - 1 + to-integer to-string claim/4 
	cl-bottom: cl-top - 1 + to-integer to-string claim/5
	current: cl-left

	while [cl-top <= cl-bottom] [
		while [current <= cl-right] [
			inch: side-size * (cl-top ) + current	
			unless find occupied inch [put occupied inch 0]
			put occupied inch (select occupied inch) + 1
			current: current + 1
		]
		current: cl-left
		cl-top: cl-top + 1
	]
]


count: 0
; probe rejoin ["length of occupied: " length? occupied]
; probe rejoin ["body-of occupied: " body-of occupied]
foreach v values-of occupied [ if v > 1 [count: count + 1]]

print rejoin ["Execution time: " now/time/precise - time-start]
print count
