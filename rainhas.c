#include <stdio.h>
#include <stdlib.h>
int tabuleiro[25], n, cont;

int main ()
{
	
	void rainha(int linha, int n);
	
	printf("Insira o valor de n:");
	scanf("%d",&n);
	
	rainha(1,n);			
	
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
		// Diferença entra Coluna de uma rainha anterior e a Coluna a ser testada
		int x = tabuleiro[i] - coluna;
		// Diferença entra Linha de uma rainha anterior e a Linha a ser testada
		int y = i - linha;
		
		// Módulo de y e x
		if(y <= 0) {
			y = y * -1;
		}
		if (x <= 0) {
			x = x * -1;
		}
		
		if(tabuleiro[i] == coluna) {		// Teste se existe coluna anterior conflitante
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
	int coluna;
	for(coluna = 1; coluna <= n; coluna++) {
		if(coloca(linha, coluna)) {			
			tabuleiro[linha] = coluna; 	 
			if(linha == n){
				print(n); 					// Se chego na ultima linha imprime o resultado
			}else{ 
				rainha(linha + 1, n);}		// Se não passa para próxima linha
		}
	}

}


