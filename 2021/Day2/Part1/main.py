#! /bin/python3

import sys

horizontal = 0
depth = 0

for line in sys.stdin:
	command = line.split()[0]
	amount = int(line.split()[1])

	if command == "forward":
		horizontal += amount
	elif command == "down":
		depth += amount
	elif command == "up":
		depth -= amount

print(horizontal * depth)
