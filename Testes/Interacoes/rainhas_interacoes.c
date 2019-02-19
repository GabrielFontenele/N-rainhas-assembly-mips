#include <stdio.h>
#include <stdlib.h>
int tabuleiro[25], cont;
double cont_interacoes;
int x;
int main ()
{
	cont_interacoes = 0;
	x = 0;
	void rainha(int linha, int n);
	rainha(1,15);
	printf("\n numero de interacoes %f\n", cont_interacoes);
	return 0;
}

void print(int n)
{
	int i, x;
	printf("\n resultado %d:\n", ++cont);

	for(i = 1; i <= n; i++) {
		printf("\t%d", i);
	}

	for(i = 1; i <= n; i++) {
		printf("\n\n%d", i);
		for(x = 1; x <= n; x++) {
			if(tabuleiro[i] == x) {
				printf("\tQ");
			} else {
				printf("\t-");
			}
		}

	}


}


int coloca(int linha, int coluna)
{
	int i;
	for(i = 1; i < linha; ++i) {
		int x = tabuleiro[i] - coluna;
		int y = i - linha;
		if(y <= 0) {
			y = y * -1;
		}
		if (x <= 0) {
			x = x * -1;
		}
		if(tabuleiro[i] == coluna) {
			return 0;
		} else {
			if(x == y)
				return 0;
		}
	}


return 1;
}

void rainha(int linha, int n)
{
	cont_interacoes++;
	int coluna;
	for(coluna = 1; coluna <= n; coluna++) {
		if(coloca(linha, coluna)) {
			tabuleiro[linha] = coluna; 	 
			if(linha == n){
				//print(n); 
				x = 1;
				return 0;
				
			}else{ 
				rainha(linha + 1, n);
				if (x==1){
					return 0; 
				}
				}
		}
	}

}


