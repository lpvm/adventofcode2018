Red [ 
    Title:  "Advent of Code 2018 - Day 02 - Part 01" 
    Date:   2018-12-02
    File:   %day02_part01.red
    Author: "Luis Vale Mendes"
    Version: 0.0.1
]	

twos: 0
threes: 0
input-txt: load read %input.txt
input-sorted: make block! length? input-txt

foreach s input-txt [append input-sorted sort to-string s]

; probe input-sorted
; ["abcdef" "aabbbc" "abbcde" "abcccd" "aabcdd" "abcdee" "aaabbb"]

; only one pair and one triplet in each ID, hence twos-possible and threes-possible
foreach s input-sorted [
    ; print rejoin [newline "for string: " s]
    anchor-char: first s
	count: 1
	twos-possible: true
	threes-possible: true

    until [
		s: next s
		curr-char: first s
		if curr-char = anchor-char [
		    count: count + 1
		]
		if (curr-char <> anchor-char) or (tail? s) [
		    case [
				count = 2 and twos-possible [twos: twos + 1 twos-possible: false]
				count = 3 and threes-possible [threes: threes + 1 threes-possible: false]
			]
			count: 1
			anchor-char: curr-char
		]

		tail? s
	]
]

print twos * threes
