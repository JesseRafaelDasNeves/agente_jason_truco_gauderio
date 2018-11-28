manilha(7,ouro, 11).
manilha(7,espada, 12).
manilha(1,paus, 13).
manilha(1,espada, 14).

forcaCarta(4,_,1).
forcaCarta(5,_,2).
forcaCarta(6,_,3).
forcaCarta(7,_,4).
forcaCarta(10,_,5).
forcaCarta(11,_,6).
forcaCarta(12,_,7).
forcaCarta(1,_,8).
forcaCarta(2,_,9).
forcaCarta(3,_,10).
forcaCarta(7,ouro,11).
forcaCarta(7,espada,12).
forcaCarta(7,paus,13).
forcaCarta(7,espada,14).

melhorCartaParaJogar(carta(VALOR,NAIPE),MINHA_JOGADA) :- (
	forcaCarta(VALOR,NAIPE,FORCA_CARTA_VEZ)
	&
	/* Pega a primeira maior carta se tiver */
	(
		cartaMao(MAIOR_VALOR,MAIOR_NAIPE)
		&
		forcaCarta(MAIOR_VALOR,MAIOR_NAIPE,MAIOR_FORCA)
		&
		MAIOR_FORCA > FORCA_CARTA_VEZ
		&
		MINHA_JOGADA = carta(MAIOR_VALOR,MAIOR_NAIPE)
		&
		not(
			cartaMao(ValorTemp,NaipeTemp)
			&
			forcaCarta(ValorTemp,NaipeTemp,ForcaTemp)
			&
			FORCA_CARTA_VEZ < ForcaTemp
			&
			ForcaTemp < MAIOR_FORCA
		)
	)
	|
	/* Ou se não tiver pega a menor carta */
	(
		menorCarta(RETORNO)
		&
		MINHA_JOGADA = RETORNO	
	) 
).

menorCarta(RETORNO) :- (
	cartaMao(MENOR_VALOR,MENOR_NAIPE)
	&
	forcaCarta(MENOR_VALOR,MENOR_NAIPE,MENOR_FORCA)
	&
	cartaMao(VALOR_2,NAIPE_2)
	&
	forcaCarta(VALOR_2,NAIPE_2,FORCA_2)
	&
	MENOR_FORCA <= FORCA_2
	&
	RETORNO = carta(MENOR_VALOR,MENOR_NAIPE)
	&
	not(
		cartaMao(VALOR_TEMP,NAIPE_TEMP)
		&
		forcaCarta(VALOR_TEMP,NAIPE_TEMP,FORCA_TEMP)
		&
		MENOR_FORCA > FORCA_TEMP
	)
).

maiorCarta(RETORNO) :- (
	cartaMao(MAIOR_VALOR,MAIOR_NAIPE)
	&
	forcaCarta(MAIOR_VALOR,MAIOR_NAIPE,MAIOR_FORCA)
	&
	cartaMao(VALOR_2,NAIPE_2)
	&
	forcaCarta(VALOR_2,NAIPE_2,FORCA_2)
	&
	MAIOR_FORCA >= FORCA_2
	&
	RETORNO = carta(MAIOR_VALOR,MAIOR_NAIPE)
	&
	not(
		cartaMao(VALOR_TEMP,NAIPE_TEMP)
		&
		forcaCarta(VALOR_TEMP,NAIPE_TEMP,FORCA_TEMP)
		&
		MAIOR_FORCA < FORCA_TEMP
	)	
).

codigoVezMao(RETORNO) :- (
	I = 0
	&
	COUNT = 0
	&
	.print(RETORNO)
	&
	cartaMao(VALOR,NAIPE)
	&
	.print(VALOR, " --------------- ", NAIPE)
	&
	.print("Index = ", I, " - count", COUNT)
	&
	RETORNO = (COUNT + 1)
	&
	I = (I + 1)
	&
	I < 3
).

qtdeCartas(carta(_,_),RETORNO) :- (
	RETORNO = 1
	&
	.print("Mais uma",RETORNO)
).

qtdeCartas(_,RETORNO) :- (
	RETORNO = 0
	&
	.print("Acabou ",RETORNO)
).

qtdeCartas(RETORNO) :- (
	RETORNO = 0
	&
	qtdeCartas(cartaMao(_,_),R2)
	&
	RETORNO = RETORNO + R2
	&
	false
	&
	.print("Somatório ",RETORNO)
).

/*
horaDePedirTruco() :- (*/
	/* Regra pera pedir truco
	 * -> Uma manilha
	 * -> Uma carta maior que 12
	 */
/*).*/

/*pedirEnvido() :- (*/
	/* A soma dos pontos prescisa ser ao menos 20 */
/* ).*/

!start.

+!start : true 
	<-
	entrarNaPartida;
	.wait(1000);
	.

+suavez : not cartaVez(_,_)
	<-
	.wait(1000);
	?qtdeCartas(R);
	.print("Qtde cartas = ", R);
	.print("minha vez");
	?maiorCarta(carta(VALOR,NAIPE));
	.print("carta(", VALOR, ",", NAIPE, ")");
	-cartaMao(VALOR, NAIPE);
	jogarCarta(VALOR, NAIPE);
.

+suavez : cartaVez(VALOR_VEZ,NIPE_VEZ)
	<-
	.wait(1000);
	.print("minha vez ===== Carta Vez é ", VALOR_VEZ, " de ", NIPE_VEZ);
	?melhorCartaParaJogar(carta(VALOR_VEZ,NIPE_VEZ), carta(MELHOR_VALOR,MELHOR_NAIPE));
	.print(">>>> Melhor carta é ", MELHOR_VALOR, " de ", MELHOR_NAIPE);
	-cartaMao(MELHOR_VALOR, MELHOR_NAIPE);
	jogarCarta(MELHOR_VALOR,MELHOR_NAIPE);
.
	
+receberCarta(NUM, NAIPE) : true
	<-
	.print("Recebida a carta(", NUM, ",", NAIPE, ")");
	+cartaMao(NUM , NAIPE);
.

+truco : true
	<-
	.print("teste");
	.
	
+dropAll:true
	<-
 	.abolish(cartaVez(_,_));
 	.abolish(cartaMao(_,_));
 	//.wait(500);
 .


+cartaVez(NUM, NAIPE) : true
	<-
	.print("cartaVez(", NUM, ",", NAIPE, ")");
	.

-cartaVez(NUM, NAIPE): true
	<-
	.print("removeu carta Vez");
	.

+dropCartaVez: true
	<-
	.print("removendo carta vez");
 	.abolish(cartaVez(_,_));
 .

	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
