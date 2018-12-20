Red [ 
	Title:  "Advent of Code 2018 - Day 07 - Part 02" 
	Date:   2018-12-20
	File:   %day07_part02.red
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

; -- how many seconds each step take to finish
n: 1
sec-step: copy []
; while [n <= 26] [append/only sec-step reduce [to-char 64 + n n + 60] n: n + 1]
; [[#"A" 61] [#"B" 62] [#"C" 63] [#"D" 64] [#"E" 65] [#"F" 66] [#"G" 67] [#"H" 68] [#"I" 69] [#"J" 70] [...
while [n <= 26] [
	append sec-step to-string to-char 64 + n
 	append sec-step (60 + n)			; -- for input.txt
; 	append sec-step n					; -- for input.test07 only
	n: n + 1
]
sec-step: make map! sec-step
; probe rejoin ["sec-step: " sec-step]
; #(
;     "A" 1
;     "B" 2
;     "C" 3
  
length-working: func [m /local c] [
	c: 0
	sts: values-of m
	forall sts [
		c: c + length? sts/1
	]
	c
]

second-count: 0

step-working: copy #()
available: sort head available
nr-workers: 5

while [(not tail? available) and ((length-working step-working) <= nr-workers)] [
	st: first available
 	put step-working second-count + (select sec-step st) reduce [st]
	remove available
]
; probe rejoin ["step-working: " step-working]
; #(
;     1 ["A"]
;     2 ["B"]
;     12 ["L"]
; )

step-order: copy ""

removed: false
while [(length? step-working) > 0] [
	second-count: second-count + 1

	; -- if no step is finishing at this second-count, just get forward
	if find step-working second-count [

		steps-finished: sort select step-working second-count
		forall steps-finished [
			append step-order steps-finished/1

			prior-step: steps-finished/1
		
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

		]

		; remove the just finished steps from steps-working
		put step-working second-count none
	]
	
	; -- Find out the next step to be done
	; -- The next step will be considered from the available pool, considering:
	; --     take the first available (already sorted alphabetically)
	; --     if all of its required predecessors are already done, it can be chosen
	available: sort head available

	while [(not tail? available) and ((length-working step-working) < nr-workers)] [
		st: first available
		either not find required to-string st [
				put step-working second-count + (select sec-step st) reduce [st]
			remove available
		][
			all-in-step-order: true
			foreach req select required first available [
				all-in-step-order: all-in-step-order and ((find step-order to-string req) <> none)	
			]	
			if all-in-step-order [
					put step-working second-count + (select sec-step st) reduce [st]
				remove available
			]
			unless all-in-step-order [available: next available]

		]
	]
	steps: head steps
]

print rejoin ["Execution time: " now/time/precise - time-start]
probe step-order
probe second-count
