#include<reg52.h>
void delay(int);
void main()
{
	int i;
	P2=0x03;
	delay(500);
	while(1)
	{
		for(i=0;i<3;i++)
			{
				P2<<=2;
				delay(500);
			}
		P2=0x03;
		delay(500);
	}
}
void delay(int x)
{
	int i,j;
	for(i=x;i>0l;i--)
		for(j=110;j>0;j--);
}