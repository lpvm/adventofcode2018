Red [ 
    Title:  "Advent of Code 2018 - Day 02 - Part 02" 
    Date:   2018-12-02
    File:   %day02_part02.red
    Author: "Luis Vale Mendes"
    Version: 0.0.1
]	

input-txt: load read %input.txt
common: copy []
input-strings: copy []
foreach id input-txt [append input-strings to-string id]

block-id: copy []

foreach id input-strings [
	append block-id id
	other-ids: exclude input-strings block-id
	id-pos: first id
	count: 0

	foreach other-id other-ids [
		other-pos: first other-id
		until [
			if id-pos <> other-pos [count: count + 1]
			id: next id
			other-id: next other-id
			id-pos: first id
			other-pos: first other-id
			tail? id
		]		
		if count = 2 [append common head id append common head other-id]
		id: head id	
		count: 0
	]
]

first-id: to-string common/1
second-id: to-string common/2
common-chars: copy []
forall first-id [
	if (first first-id) = (first second-id) [append common-chars first first-id]
	second-id: next second-id
]

print rejoin common-chars
