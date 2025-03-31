#include <stdio.h>
#include <math.h>
int main()
{
	// 0~1000 ��� �� �Ҽ� �Ǵ�
	int bPrime[1001] = { 0,0, };
	// 0, 1 ���� ��� ���� �ϴ� �Ҽ���� �����Ѵ�
	for (int i = 2; i < 1001; i++) bPrime[i] = 1;
	// ��Ʈ 1000 ���� �Ҽ����� ��� �����
	int root = sqrt(1000);
	for (int i = 2; i <= root; i++)
	{
		// �ռ����� ����� �Ǵ��� �ʿ� ����
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