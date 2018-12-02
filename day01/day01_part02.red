Red [ 
	Title:  "Advent of Code 2018 - Day 01 - Part 02" 
	Date:   2018-12-02
	File:   %day01_part02.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]	

input-txt: load read %input.txt

; takes more than five minutes using a normal block
; but only one second when stored in a hash!
frequencies-seen: make hash! []
number-inputs: length? input-txt 
sum: 0
found: false
loops: 0
time-start: now/time

while [not found] [
	i: first input-txt
	sum: sum + i
	if find frequencies-seen sum [found: true]
	append frequencies-seen sum
	input-txt: next input-txt
	if tail? input-txt [input-txt: head input-txt loops: loops + 1]
]
print rejoin ["found frequency: " sum newline "number of inputs: " number-inputs newline "number of loops: " loops]
print rejoin ["spent: " now/time - time-start]
