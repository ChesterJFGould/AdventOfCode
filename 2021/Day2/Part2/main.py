#! /bin/python3

import sys

horizontal = 0
depth = 0
aim = 0

for line in sys.stdin:
	command = line.split()[0]
	amount = int(line.split()[1])

	if command == "forward":
		horizontal += amount
		depth += amount * aim
	elif command == "down":
		aim += amount
	elif command == "up":
		aim -= amount

print(horizontal * depth)
