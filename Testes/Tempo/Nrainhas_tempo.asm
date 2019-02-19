		.data
tabuleiro:	.space 100
cont:		.space 4
str1:		.asciiz "\n resultado "
str2:		.asciiz "\t"
str3:		.asciiz ":\n"
str4:		.asciiz "\n\n"
strQ:		.asciiz "\tQ"
strT:		.asciiz "\t-"

		.text
.globl main
main:
	li	$v0, 30
	syscall		
	move	$a3, $a0	
	
	
	la 	$t9, cont		# Carrega endereco do contador 
	li 	$t8, 0			# Inicia $t8 = 0
	sw 	$t8, ($t9)		# Salva o valor 0 no contador
	
	
	li 	$a0, 18			# n = 15
	li 	$a1, 1			# Inicia Linha = 1	
	jal	rainha			# Chama função rainha
	
	li	$v0, 30
	syscall
		
	
	sub	$a0, $a0, $a3
	
	li	$v0, 1
	syscall
	
	
	li 	$v0, 10     		# Termina programa
	syscall

####	Print	####
print:	
	addi	$sp, $sp, -4		# Move $sp em -4 Bytes
	sw	$a0, 0($sp)		# Salva $a0 (n)
	
	move	$t4, $a0		# Move n para $t4	 
	
	la	$a0, str1   		# Imprime "\n resultado "
	li	$v0, 4
	syscall				
	
	la	$t9, cont		# Carrega endereço do contador  
	lw	$t7, ($t9)		# Salva o valor do contador em $t0
	addi	$t7, $t7, 1		# Contador++
	sw 	$t7, ($t9)		# Salva Contador++
	
	move	$a0, $t7   		# Imprime valor do contador  
	li	$v0, 1			
	syscall				
	
	la	$a0, str3   		# Imprime ":\n"
	li	$v0, 4
	syscall				
	
	li	$t0, 1			# Inicia $t0 = 1	
for1:	
	la	$a0, str2   		# Imprime \t
	li	$v0, 4
	syscall				
	
	li	$v0, 1			# Imprime valor de $t0 (Coluna)
	move	$a0, $t0
	syscall				
	
	addi	$t0, $t0, 1		# $t0++
	ble	$t0, $t4, for1		# $t0 <= N	
	
	li	$t0, 1			# Inicia $t0 = 1 (Linha)
for2:
	la	$a0, str4   		# Imprime \n\n
	li	$v0, 4
	syscall				
	
	move	$a0, $t0		# Imprime $t0 (Linha)
	li	$v0, 1			
	syscall				
		
	li	$t1, 1			# Inicia $t1 = 1 (Coluna)
for3:	
	mul	$t5, $t0, 4		# Multiplica $t0 por 4 
	la	$t3, tabuleiro		# Chama tabuleiro
	add	$t3, $t3,$t5		# Move endereço do tabuleiro ate linha $t0
	lw	$t9, ($t3)		# Carrega do valor de tabuleiro[$t0] 	

	bne	$t9, $t1, printT	# Se tabuleiro[$t0] diferente de coluna Imprime -
	
	la	$a0, strQ 		# Printa Q
	li	$v0, 4
	syscall
	j	fimfor3
printT:
	la	$a0, strT 		# Printa -
	li	$v0, 4
	syscall
fimfor3:
	addi	$t1, $t1, 1		# $t1++
	ble	$t1, $t4, for3		# $t1 <= N	
	
	addi	$t0, $t0, 1		# $t0++
	ble	$t0, $t4, for2		# $t0 <= N
	
	lw	$a0, 0($sp)		# Carrega $a0 (n)
	addi	$sp, $sp, 4		# Move $sp em 4 Bytes
	jr	$ra			# Volta para o endereco de $ra

####	Coloca	####
coloca:
	li	$t0, 1			# Inicia $t0 = 1 para testar se alguma linha anterior gera conflito
for5:	
	bge	$t0, $a1, retorna1	# Se $t0 >= linha Retorna 1	
	
	mul	$t8, $t0, 4		# Multiplica $t0 por 4
	la	$t9, tabuleiro		# Carrega endereço de tabuleiro
	add	$t9, $t9, $t8		# Move endereco do tabuleiro ate linha $t0 * 4bytes
	lw	$t8, ($t9)		# Carrega tabuleiro[$t0]
	move	$t6, $t8		# Move tabuleiro[$t0] para $t6	
	
	sub	$t8, $t8, $a2		# t8 = tabuleiro[$t0] - coluna	
	sub	$t7, $t0, $a1		# t7 = t0 - linha	
	
	li	$t9,-1			# Carrega -1 para fazer o modulo t8 e t7 se necessario
	
	bgtz	$t8, saiC1		# se t8 > 0 sai	
	mul	$t8, $t8, $t9		# t8 * -1
saiC1:	
	bgtz	$t7, saiC2		# t7 > 0 sai
	mul	$t7, $t7, $t9		# t7 * -1	
saiC2:
	beq	$t6, $a2, retorna0	# se tabuleiro[$t0] = coluna retorna 0
	beq	$t8, $t7, retorna0	# se |(tabuleiro[$t0] - coluna)| == |($t0 - linha)| retorna 0
		
	addi	$t0, $t0, 1		# $t0++
	j	for5			# Testa proxima linha
retorna1:
	li	$v1, 1			# Retorna 1		
	jr	$ra			# Volta para o endereco de $ra
retorna0:
	li	$v1, 0			# Retorna 0	
	jr	$ra			# Volta para o endereco de $ra

####	Rainha	####
rainha:
	addi	$sp, $sp, -8		# Move sp em -8 Bytes
	sw	$a2, 4($sp)		# Salva Coluna
	sw	$ra, 0($sp)		# Salva endereco de retorno
	
	bnez	$t2, saifor6		# Teste se ja encontro um resutado 
	li	$a2, 1			# Inicia coluna	= 1
for6:	
	bgt	$a2, $a0, saifor6	# Teste de Coluna <= n
	
	jal	coloca			# Chama Colocar (linha, coluna)
	beqz	$v1, saiprint1		# Teste se retorno = 0 
	
	li	$t1, 4			# Inicia $t1 = 4
	la	$t9, tabuleiro		# Carrega array tabuleiro	
	mul	$t1, $t1, $a1		# Mutiplica linha por 4 e salva em $t1
	add	$t9, $t9, $t1		# Move endereco em 4 bytes * linha
	sw 	$a2, ($t9)		# Salva tabuleiro[linha] = coluna

	bne	$a0, $a1, saiprint2	# Se linha = n
	#jal	print			# Printa tabela 
	li	$t2, 1			# valor de retorno para o backtrack
	j	saifor6
saiprint2:
	addi	$sp, $sp, -4		# Move sp em -4 Bytes
	sw	$a1, 0($sp)		# Salva linha

	addi	$a1, $a1, 1		# Linha++
	jal	rainha			# Chama rainha(linha + 1, n)

	lw	$a1, 0($sp)		# Carrega Linha 
	addi	$sp, $sp, 4		# Move sp em 4 Bytes
saiprint1:
	addi	$a2, $a2, 1		# Coluna++
	j	for6
saifor6:			
	lw	$a2, 4($sp)		# Carrega Coluna
	lw	$ra, 0($sp)		# Carrega endereco de retorno
	addi	$sp, $sp, 8		# Move sp em 8 Bytes
	jr	$ra			# Volta para o endereco de $ra
