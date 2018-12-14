Red [ 
	Title:  "Advent of Code 2018 - Day 06 - Part 02" 
	Date:   2018-12-14
	File:   %day06_part02.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]

time-start: now/time/precise

; -- LOAD INPUT
input-txt: read/lines %input.txt
; input-txt: ["1, 1" "1, 6" "8, 3" "3, 4" "5, 5" "8, 9"]

; -- CREATE COORDINATES MAP
coords: #()
forall input-txt [put coords load replace input-txt/1 ", " 'x 0]
; probe coords
; #( 1x1 0     1x6 0     8x3 0 ...)


; -- FIND MIN AND MAX COORDINATES OF GRID
min-width: 9999999999
max-width: 0
min-height: 9999999999
max-height: 0
foreach coord keys-of coords [
	if coord/1 < min-width [min-width: coord/1]
	if coord/1 > max-width [max-width: coord/1]
	if coord/2 < min-height [min-height: coord/2]
	if coord/2 > max-height [max-height: coord/2]
]

; probe rejoin [min-width " -> " max-width "  and  " min-height " | " max-height]
; "1 -> 8  and  1 | 9"

; -- CREATE GRID OF ALL LOCATIONS
grid: #()
mi-w: min-width
mi-h: min-height
while [mi-w <= max-width] [
    while [mi-h <= max-height] [
		put grid as-pair mi-w mi-h 0
		mi-h: mi-h + 1
	]
	mi-w: mi-w + 1
	mi-h: min-height
]
; probe grid
; 4x5 0 4x6 0 4x7 0 4x8 0
 
; -- FILL GRID WITH SUM OF DISTANCES TO ALL COORDS
foreach key keys-of grid [
    sum-distances: 0
    foreach coord keys-of coords [
		distance: key - coord
		distance: (absolute distance/1) + (absolute distance/2)
	    sum-distances: sum-distances + distance
		put grid key sum-distances
	]
]
 
max-distance: 10000

nr-locations: 0
foreach sum-distances values-of grid [
    if sum-distances < max-distance [nr-locations: nr-locations + 1]
]

print rejoin ["Execution time: " now/time/precise - time-start]
print rejoin ["Number of locations: " nr-locations "    with sum of distances less than: " max-distance]
