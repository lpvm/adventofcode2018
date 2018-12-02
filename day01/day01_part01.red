Red [ 
	Title:  "Advent of Code 2018 - Day 01 - Part 01" 
	Date:   2018-12-02
	File:   %day01_part01.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]	

input-txt: load read %input.txt

sum: 0
foreach i input-txt [ sum: sum + i]
print sum
