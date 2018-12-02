manilha(7,ouro).
manilha(7,espada).
manilha(1,paus).
manilha(1,espada).

forcaCarta(7,ouro,11).
forcaCarta(7,espada,12).
forcaCarta(1,paus,13).
forcaCarta(1,espada,14).
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

qtdeCarta(0).

jaPediTruco(nao).
jaPediEnvido(nao).

outroJogadorPedioTruco(nao).

todasCartasMao(AUX,RETORNO) :-  (
	cartaMao(X,Y)
	&
    not .member(cartaMao(X,Y),AUX)
    &
    todasCartasMao([cartaMao(X,Y)|AUX], RETORNO)
).
todasCartasMao(AUX,RETORNO) :- (
	qtdeCarta(Q)
	&
    .length(AUX,Q)
    &
    RETORNO=AUX
).


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
	qtdeCarta(R)
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

cartaManilha(cartaMao(VALOR,NAIPE), R) :- (
	(
		not manilha(VALOR,NAIPE)
		&
		R = false		
	)
	|
	(
		manilha(VALOR,NAIPE)
		&
		R = true
	)
).

quantidadeManilha([],R) :- (
	R = 0
).
quantidadeManilha([],QTD_ATUAL,R) :- (
	R = QTD_ATUAL
).
quantidadeManilha([CARTA|RESTO_CARTAS],QTD_ATUAL,R) :- (
	(
		cartaManilha(CARTA, E_MAN)
		&
		E_MAN == true
		&
		AUX = (QTD_ATUAL + 1)
		&
		quantidadeManilha(RESTO_CARTAS,AUX,R2)
		&
		R = R2
	)
	|
	(
		quantidadeManilha(RESTO_CARTAS,QTD_ATUAL,R3)
		&
		R = R3
	)
).
quantidadeManilha(LISTA_CARTA,R) :- (
	quantidadeManilha(LISTA_CARTA,0,R2)
	&
	R = R2
).

forcaMao([],FORCA_ATUAL,R) :- (
	R = FORCA_ATUAL
).
forcaMao([cartaMao(VALOR,NAIPE)|RESTO_CARTAS],FORCA_ATUAL,R) :- (
	forcaCarta(VALOR,NAIPE,FORCA)
	&
	AUX = (FORCA_ATUAL + FORCA)
	&
	forcaMao(RESTO_CARTAS,AUX,R2)
	&
	R = R2
).
forcaMao([],R) :- (
	R = 0
).
forcaMao(LISTA_CARTA,R) :- (
	forcaMao(LISTA_CARTA,0,R2)
	&
	R = R2
).

daParaPedirTruco([],R) :- (
	R = false
).
daParaPedirTruco(LISTA_CARTAS,R) :- (
	codigoVez(V)
	&
	forcaMao(LISTA_CARTAS,FM)
	&
	(
		(V==3 & FM>=9 & R=true)
		|
		(V==2 & FM>=16 & R=true)
		|
		(V==1 & FM>=20 & R=true)
		|
		(R=false)
	)
).

/*pedirEnvido() :- (*/
	/* A soma dos pontos prescisa ser ao menos 20 */
 /* ).*/
 
teste(R):-(
 	R = false
).

teste2(R):-(
 	R = true
).

!inicia.

+!inicia : true <-
	.wait(1000);
	entrarNaPartida;
.

+suavez : true <-
	.wait(2000);
	
	?codigoVez(V);
	.print("#############");
	.print("### Minha vez ###");
	.print("### Vez ",V," ###");
	
	?jaPediTruco(PEDI);
	.print("Ja pedi truco? R:",PEDI)
	
	?jaPediEnvido(P_ENV);
	.print("Ja pedi envido? R:",P_ENV);
	
	?todasCartasMao([],TODAS_CARTAS_MAO);
    .print("Cartas Mão -> ",TODAS_CARTAS_MAO);
    
    ?quantidadeManilha(R,QM);
    .print("Qtd manilha -> ",QM);
	
	!oQueFazerNestaVez;
.

/*+!oQueFazerNestaVez : 
		jaPediEnvido(PEDI_ENV)
		&
		PEDI_ENV == nao
		&
		todasCartasMao([],LISTA_CARTA)
		&
		daParaPedirEnvido(LISTA_CARTA,PEDE_ENV) 
		&
		PEDE_ENV == true <-
	teste
.
*/

+!oQueFazerNestaVez : 
		jaPediTruco(PEDI)
		&
		PEDI == nao
		&
		todasCartasMao([],LISTA_CARTA)
		&
		daParaPedirTruco(LISTA_CARTA,PEDE_TRUCO)
		&
		PEDE_TRUCO == true <-
	
	.print("Truuuuuucoooo");
    
	-+jaPediTruco(sim);
	truco;
.
+!oQueFazerNestaVez : not cartaVez(_,_) <-
	?maiorCarta(carta(VALOR,NAIPE));
	.print(">>>> Pegar Maior carta");
	
	-cartaMao(VALOR, NAIPE);
	?qtdeCarta(Q);
	-+qtdeCarta(Q-1);
	
	.print("Toma carta(", VALOR, ",", NAIPE, ")");
	jogarCarta(VALOR,NAIPE);
.	
+!oQueFazerNestaVez : cartaVez(VALOR_VEZ,NIPE_VEZ) <-
	.print("### Tem Carta Vez. é ", VALOR_VEZ, " de ", NIPE_VEZ,"###");
	
	?melhorCartaParaJogar(carta(VALOR_VEZ,NIPE_VEZ), carta(MELHOR_VALOR,MELHOR_NAIPE));
	.print(">>>> Então a melhor carta é ", MELHOR_VALOR, " de ", MELHOR_NAIPE);
	
	-cartaMao(MELHOR_VALOR, MELHOR_NAIPE);
	?qtdeCarta(Q);
	-+qtdeCarta(Q-1);
	
	.print("Toma carta(", MELHOR_VALOR, ",", MELHOR_NAIPE, ")");
	jogarCarta(MELHOR_VALOR,MELHOR_NAIPE);
.
	
+receberCarta(NUM, NAIPE) : true <-
	-+qtdeCarta(3);
	.print("Recebida a carta(", NUM, ",", NAIPE, ")");
	+cartaMao(NUM , NAIPE);
	-+jaPediTruco(nao);
	-+jaPediEnvido(nao);
.

+truco : true <-
	.print("......");
	.wait(2000);
	-+outroJogadorPedioTruco(sim);
	?todasCartasMao([],LISTA_CARTA);
	?codigoVez(CODIGO_VEZ);
	?forcaMao(LISTA_CARTA,FORCA_MAO);
	
	.print("Código Vez -> ",CODIGO_VEZ);
	.print("Força Mao -> ",FORCA_MAO);
	!oQueFazerSeOutroJogadorPedioTruco(CODIGO_VEZ,LISTA_CARTA,FORCA_MAO);
.

+!oQueFazerSeOutroJogadorPedioTruco(CODIGO_VEZ,LISTA_CARTA,FORCA_MAO) : CODIGO_VEZ = 1 & FORCA_MAO >= 20 <-
	.print("Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioTruco(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 2 & FORCA_MAO >= 16 <-
	.print("Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioTruco(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 3 & FORCA_MAO >= 9 <-
	.print("Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioTruco(_,_,_) : true <-
	.print("O jogo tá muito podre");
	recusar;
.
	
+dropAll:true <-
 	.abolish(cartaMao(_,_));
.


+cartaVez(NUM, NAIPE) : true <-
	.print("cartaVez(", NUM, ",", NAIPE, ")");
.

-cartaVez(NUM, NAIPE): true <-
	.print("removeu carta Vez");
.

+dropCartaVez: true <-
	.print("removendo carta vez");
 	.abolish(cartaVez(_,_));
 .

	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
