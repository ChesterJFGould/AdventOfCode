#include <limits.h>
#include <stdio.h>

#define windowSize 3

int
nextSum()
{
	static int initialized = 0;
	static int window[windowSize];

	if (!initialized) {
		for (int i = 0; i < windowSize; i++) {
			if (scanf("%d", &window[i]) == EOF) return -1;
		}

		initialized = 1;
	} else {
		for (int i = 1; i < windowSize; i++) {
			window[i - 1] = window[i];
		}

		if (scanf("%d", &window[windowSize - 1]) == EOF) return -1;
	}

	int sum;

	sum = 0;

	for (int i = 0; i < windowSize; i++) {
		sum += window[i];
	}

	return sum;
}

int
main(int argc, char** argv)
{
	int previousDepth;
	int currentDepth;
	int bigCount;

	previousDepth = INT_MAX;
	bigCount = 0;

	for (currentDepth = nextSum(); currentDepth != -1; currentDepth = nextSum()) {
		printf("Current depth sum is %d\n", currentDepth);
		if (previousDepth < currentDepth) {
			bigCount++;
		}

		previousDepth = currentDepth;
	}

	printf("%d\n", bigCount);

	return 0;
}
