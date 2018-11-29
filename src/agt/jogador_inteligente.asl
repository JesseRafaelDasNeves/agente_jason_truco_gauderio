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


qtdeCarta(0).


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

codigoVez(RETORNO) :- (
	(
		qtdeCarta(R)
		&
		.print("qtd - codigo vez = ",R)
		
	)
	&
	(
		(
			R == 1
			&
			RETORNO = 3
		)
		|
		(
			R == 2
			&
			RETORNO = 2
		)
		|
		(
			R == 3
			&
			RETORNO = 1
		)
	)
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

!inicia.

+!inicia : true 
	<-
	entrarNaPartida;
//	+qtdeCarta(0);
	.wait(1000);
.

+suavez : not cartaVez(_,_)
	<-
	.wait(1000);
	?codigoVez(V);
	.print("### Vez",V," ### Minha vez ###");
	?maiorCarta(carta(VALOR,NAIPE));
	.print(">>>> Maior carta é carta(", VALOR, ",", NAIPE, ")");
	?qtdeCarta(Q);
	-+qtdeCarta(Q-1);
	jogarCarta(VALOR, NAIPE);
.

+suavez : cartaVez(VALOR_VEZ,NIPE_VEZ)
	<-
	.wait(1000);
	?codigoVez(V);
	.print("### Vez",V," ### Minha vez ### Carta Vez é ", VALOR_VEZ, " de ", NIPE_VEZ,"###");
	?melhorCartaParaJogar(carta(VALOR_VEZ,NIPE_VEZ), carta(MELHOR_VALOR,MELHOR_NAIPE));
	.print(">>>> Melhor carta é ", MELHOR_VALOR, " de ", MELHOR_NAIPE);
	-cartaMao(MELHOR_VALOR, MELHOR_NAIPE);
	?qtdeCarta(Q);
	-+qtdeCarta(Q-1);
	jogarCarta(MELHOR_VALOR,MELHOR_NAIPE);
.
	
+receberCarta(NUM, NAIPE) : true
	<-
	-+qtdeCarta(3);
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
