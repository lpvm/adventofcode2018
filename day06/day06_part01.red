Red [ 
	Title:  "Advent of Code 2018 - Day 06 - Part 01" 
	Date:   2018-12-14
	File:   %day06_part01.red
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
 
; -- FILL GRID
foreach [k v] body-of grid [
	coord: find keys-of coords k
	either coord <> none [
		; -- grid point is a given coordinate
		put grid k to-block coord/1
	][
		; -- grid point value will have nearest coordinates
		; -- manhattan distance
		nearest: copy []
		min-distance: 99999999
		foreach c keys-of coords [
		    distance: k - c
			distance: (absolute distance/1) + (absolute distance/2)
			; -- test equality first
			if distance = min-distance [append nearest c]
			if distance < min-distance [
				min-distance: distance
				nearest: to-block c
			]
		]
		put grid k copy nearest
	]
]
;     3x5 [3x4]
;     3x6 [1x6 3x4]
;     3x7 [1x6 3x4]
;     3x8 [1x6 3x4]
;     3x9 [1x6 3x4 8x9]
;     4x1 [1x1]
 
; -- EXCLUDE ALL COORDINATES AT BORDERS
; coord-deletion: make vector! max-width + max-height

foreach [k v] body-of grid [
;     probe rejoin ["Trying: k,v: " k " " v]
	either (k/1 = min-width) or (k/1 = max-width)
		or
		(k/2 = min-height) or (k/2 = max-height) [
		; -- at borders, infinite, not accountable
		; -- tied grid points don't count
		unless (length? v) > 1 [put coords v/1 none]
	][
		; -- finite ones, the ones interesting
		if (find coords v/1) <> none [put coords v/1 (select coords v/1) + 1]
	]
]

coord: 0x0
size-largest: 0
foreach [k v] body-of coords [
    if v > size-largest [
		size-largest: v
		coord: k
	]
]

print rejoin ["Execution time: " now/time/precise - time-start]
print rejoin ["Coords point: " coord "    has largest size: " size-largest]
