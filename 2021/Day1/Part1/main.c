#include <limits.h>
#include <stdio.h>

int
main(int argc, char** argv)
{
	int previousDepth;
	int currentDepth;
	int bigCount;

	previousDepth = INT_MAX;
	bigCount = 0;

	while (scanf("%d", &currentDepth) != EOF) {
		if (previousDepth < currentDepth) {
			bigCount++;
		}

		previousDepth = currentDepth;
	}

	printf("%d\n", bigCount);

	return 0;
}
