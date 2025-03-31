#include <stdio.h>
#include <math.h>
int main()
{
	// 0~1000 모든 수 소수 판단
	int bPrime[1001] = { 0,0, };
	// 0, 1 제외 모든 값을 일단 소수라고 저장한다
	for (int i = 2; i < 1001; i++) bPrime[i] = 1;
	// 루트 1000 이하 소수들의 배수 지우기
	int root = sqrt(1000);
	for (int i = 2; i <= root; i++)
	{
		// 합성수의 배수는 판단할 필요 없음
		if (bPrime[i] == 0) continue;
		int index = i;
		while ((index += i) < 1001) bPrime[index] = 0;
	}
	int cNum = 0, count = 0;
	scanf("%d", &cNum);
	for (int i = 0; i < cNum; i++)
	{
		int n = 0;
		scanf("%d", &n);
		if (bPrime[n]) count++;
	}
	printf("%d", count);
}