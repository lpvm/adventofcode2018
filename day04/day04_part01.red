Red [ 
	Title:  "Advent of Code 2018 - Day 04 - Part 01" 
	Date:   2018-12-10
	File:   %day04_part01.red
	Author: "Luis Vale Mendes"
	Version: 0.0.1
]

time-start: now/time/precise
input-txt: sort read/lines %input.txt
; ["[1518-11-01 00:00] Guard #10 begins shift" "[1518-11-01 00:05] falls asleep" 

; not necessary to apply `new-line/all input-txt on`
			 
input-txt: form input-txt
; {[1518-11-01 00:00] Guard #10 begins shift [1518-11-01 00:05] falls asleep [

; not necessary to apply: `replace input-formed {"} {}`,
; as there are no quotes anymore

input-txt: load input-txt
; [[1-Nov-1518 0:00:00] Guard #10 begins shift [1-Nov-1518 0:05:00] falls asleep 

actions: [begins falls wakes]

shifts: parse input-txt [
    collect some collect [
        into [keep pick to end]
        opt [skip set ID issue!] keep (load form ID)
        set action skip keep (index? find actions action) skip
    ]
]

; probe shifts
; [[1-Nov-1518 0:00:00 10 1] [1-Nov-1518 0:05:00 10 2] 

shifts: new-line/all shifts on
; [
;     [1-Nov-1518 0:00:00 10 1]
;     [1-Nov-1518 0:05:00 10 2]
;     [1-Nov-1518 0:25:00 10 3]
; ... ] 

range: func [mi [integer!]
			ma [integer!]
			/local bl [block!]
		][
	bl: copy []
	while [mi < ma] [
		append bl mi
		mi: mi + 1
	]	
	bl
]

day: guard: 0
sleep-start: 00:00

; for each guard, number of times that was asleep at each minute
guards-sleeping-profile: #()

foreach shift shifts [
	if shift/4 = 1 [
		guard: shift/3
		unless find guards-sleeping-profile guard [
			; create minute profile for that guard
			minute-profile: copy #()
			repeat mi 60 [put minute-profile mi - 1 0]
			put guards-sleeping-profile guard minute-profile
		]
	]
	if shift/4 = 2 [sleep-start: shift/2 sleep-start: sleep-start/minute]
	if shift/4 = 3 [
		sleep-end: shift/2
		sleep-end: sleep-end/minute
		minute-profile: select guards-sleeping-profile guard	

		while [sleep-start < sleep-end] [

			put minute-profile sleep-start (select minute-profile sleep-start) + 1
			sleep-start: sleep-start + 1
		]
		put guards-sleeping-profile guard minute-profile
	]
]

guard-sleeps-most: 0
max-minutes-slept: 0
foreach [guard minute-profile] body-of guards-sleeping-profile [
	guard-slept: 0
	foreach [minute slept] body-of minute-profile [
		guard-slept: guard-slept + slept	
	]	
	if guard-slept > max-minutes-slept [
		guard-sleeps-most: guard
		max-minutes-slept: guard-slept
	]
]


guard-profile: select guards-sleeping-profile guard-sleeps-most
minute-most-slept: 0
max-minutes: 0
foreach [minute slept] body-of guard-profile [
	if slept > max-minutes [	
		max-minutes: slept
		minute-most-slept: minute
	]
]

; guard 727 at minute 29 (15 minutes): 21083
print rejoin ["Execution time: " now/time/precise - time-start]
probe rejoin ["guard sleeps most: " guard-sleeps-most "    sleeps most at minute: " minute-most-slept "    for " max-minutes " times"]
print guard-sleeps-most * minute-most-slept

