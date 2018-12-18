Red [ 
	Title:  "Advent of Code 2018 - Day 07 - Part 01" 
	Date:   2018-12-15
	File:   %day07_part01.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]

time-start: now/time/precise

; -- LOAD INPUT
input-txt: read %input.txt
; input-txt: [ "Step C must be finished before step A can begin." "Step C must be finished before step F can begin." "Step A must be finished before step B can begin." "Step A must be finished before step D can begin." "Step B must be finished before step E can begin." "Step D must be finished before step E can begin." "Step F must be finished before step E can begin."]

steps: copy []
parse input-txt [some [thru "Step " set step-1 to space thru "before step " set step-2 to space (append/only steps reduce [to-string step-1 to-string step-2])thru "begin." thru "^/" ]]
; [[#"C" #"A"] [#"C" #"F"] [#"A" #"B"] [#"A" #"D"] [#"B" #"E"] [#"D" #"E"] [#"F" #"E"]]
sort steps

; as forskip is not yet available
; get the list of predecessors, and successors and then determine first step
predecessors: copy []
successors: copy []
forall steps [append predecessors first steps/1]
forall steps [append successors second steps/1]

available: exclude predecessors successors
step-last: exclude successors predecessors
; The steps should begin by the first letter of available in
; alphabetical order, so in this case #"A"
; "available: L B A"
; "step-last: G"

; as an example (not comming from the input)
; Step Y must be finished before step N can begin.
; Step P must be finished before step N can begin.
; #(N [Y P])
; N requires that Y and P are already done
required: #()
forall steps [
	either find required steps/1/2 [
		put required steps/1/2 append select required steps/1/2 copy steps/1/1
	][
		put required steps/1/2 reduce [copy steps/1/1]
	]
]
; start with the first available
step-order: first sort available
remove available 

removed: false
while [(length? steps) > 0] [
	prior-step: last step-order

	; -- After adding another step to step-order
	; -- run through all of steps to check if its dependents 
	; -- can be added to available
	steps: head steps
	available: sort head available
	while [not tail? steps] [
		removed: false
		if (steps/1/1) = (to-string prior-step) [
			step-order: head step-order
			available: head available
			in-step-order: (find step-order to-string steps/1/2) <> none
			in-available: (find available to-string steps/1/2) <> none
			if (not in-step-order) and (not in-available) [
				append available steps/1/2
			]
			remove steps
			removed: true
		]
		unless removed [steps: next steps]
	]

	; -- remove that prior-step entry from required
	if find required to-string prior-step [put required to-string prior-step none]

	; -- Find out the next step to be done
	; -- The next step will be considered from the available pool, considering:
	; --     take the first available (already sorted alphabetically)
	; --     if all of its required predecessors are already done, it can be chosen

	available: sort head available

	while [not tail? available] [
		; -- 1st case: step in availabe has no prior required steps
		either not find required to-string first available [
			append step-order first available
			remove available
			break
		][
	
			all-in-step-order: true
			foreach req select required first available [
				all-in-step-order: all-in-step-order and ((find step-order to-string req) <> none)	
			]	
			if all-in-step-order [
				append step-order first available
				remove available
				break
			]
			available: next available	
		]

	]

	steps: head steps
]

print rejoin ["Execution time: " now/time/precise - time-start]
probe step-order
