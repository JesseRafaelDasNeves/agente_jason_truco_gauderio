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
jaPediRetruco(nao).
jaPediVale4(nao).
jaPediEnvido(nao).
jaPediFlor(nao).
jaPediContraFlor(nao).
jaPediRealInvido(nao).

outroJogadorPedioTruco(nao).
outroJogadorPedioRetruco(nao).
outroJogadorPedioVale4(nao).
outroJogadorPedioEnvido(nao).
outroJogadorPedioFlor(nao).
outroJogadorPedioRealEnvido(nao).

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

pedirTruco([],R) :- (
	R = false
).
pedirTruco(LISTA_CARTAS,R) :- (
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

pedirRetruco([],R) :- (
	R=false
).
pedirRetruco(LISTA_CARTAS,R) :- (
	codigoVez(V)
	&
	forcaMao(LISTA_CARTAS,FM)
	&
	(
		(V==3 & FM>=11 & R=true)
		|
		(V==2 & FM>=18 & R=true)
		|
		(V==1 & FM>=22 & R=true)
		|
		(R=false)
	)
).

pedirVale4([],R) :- (
	R=false
).
pedirVale4(LISTA_CARTAS,R) :- (
	codigoVez(V)
	&
	forcaMao(LISTA_CARTAS,FM)
	&
	(
		(V==3 & FM>=13 & R=true)
		|
		(V==2 & FM>=20 & R=true)
		|
		(V==1 & FM>=24 & R=true)
		|
		(R=false)
	)
).

pontosEnvido([],PONTO_ATUAL,R) :- (
	R = PONTO_ATUAL
).
pontosEnvido([cartaMao(VALOR,NAIPE)|RESTO_CARTAS],PONTO_ATUAL,R) :- (
	(
		(VALOR<10 & (AUX = (PONTO_ATUAL + VALOR)))
		|
		(AUX = PONTO_ATUAL)
	)
	&
	pontosEnvido(RESTO_CARTAS,AUX,R2)
	&
	R = R2
).
pontosEnvido([],R) :- (
	R = 0
).
pontosEnvido(LISTA_CARTA,R) :- (
	pontosEnvido(LISTA_CARTA,0,R2)
	&
	R = R2
).

pedirEnvido(LISTA_CARTAS,R) :- (
	pontosEnvido(LISTA_CARTAS,QTD_PONTOS)
	&
	(
		(QTD_PONTOS>=20 & R = true)
		|
		(R = false)	
	)
).

pedirRealInvido(LISTA_CARTAS,R) :- (
	pontosEnvido(LISTA_CARTAS,QTD_PONTOS)
	&
	(
		(QTD_PONTOS>=25 & R = true)
		|
		(R = false)	
	)
).

proxima_carta([CARTA|CAUDA], R) :-
	R = CARTA
.

tem_mao_flor([carta(NAIPE_1,NUMERO_2)|CAUDA],R) :-
	proxima_carta(CAUDA,carta(NAIPE_2,NUMERO_2))
	&
	(NAIPE_1 == NAIPE_2)
	&
	R = true
	|
	(NAIPE_1 \== NAIPE_2)
	&
	R = false
.

!inicia.

+!inicia : true <-
	.wait(1000);
	entrarNaPartida;
.

+suavez : true <-
	.wait(1000);
	
	?codigoVez(V);
	.print("#############");
	.print("### Minha vez ###");
	.print("### Vez ",V," ###");
	
	?jaPediTruco(PEDI);
	.print("Ja pedi truco? R:",PEDI);
	
	?outroJogadorPedioTruco(OUTRO_TRUCO);
	.print("Outro pedio truco? R:",OUTRO_TRUCO);
	
	?jaPediRetruco(PEDI_R);
	.print("Ja pedi retruco? R:",PEDI_R);
	
	?jaPediVale4(PEDI_V4);
	.print("Ja pedi vale 4? R:",PEDI_V4);
	
	?todasCartasMao([],TODAS_CARTAS_MAO);
    .print("Cartas Mão -> ",TODAS_CARTAS_MAO);
    
    ?forcaMao(TODAS_CARTAS_MAO,FORCA_MAO);
    .print("Força Mão -> ",FORCA_MAO);
    
    ?jaPediEnvido(P_ENV);
	?pontosEnvido(TODAS_CARTAS_MAO,QTD_PONTOS)
	.print("Ja pedi envido? R:",P_ENV, " Pontos = ", QTD_PONTOS);
    
    ?quantidadeManilha(R,QM);
    .print("Qtd manilha -> ",QM);
	
	!oQueFazerNestaVez(TODAS_CARTAS_MAO);
.

+!oQueFazerNestaVez(LISTA_CARTA) : 
		codigoVez(VEZ)
		&
		VEZ == 1
		& 
		jaPediContraFlor(PEDI_FLOR)
		&
		PEDI_FLOR == nao
		&
		outroJogadorPedioFlor(OUTRO_PEDIO_FLOR)
		&
		OUTRO_PEDIO_FLOR = true
		&
		tem_mao_flor(LISTA_CARTA,PEDE_ENV) 
		&
		PEDE_ENV == true <-
	-+jaPediContraFlor(sim);
	.print("Contra Floooooorrrr!!!!!!!!");
	contraFlor;
.
+!oQueFazerNestaVez(LISTA_CARTA) : 
		codigoVez(VEZ)
		&
		VEZ == 1
		& 
		jaPediFlor(PEDI_FLOR)
		&
		PEDI_FLOR == nao
		&
		outroJogadorPedioFlor(OUTRO_PEDIO_FLOR)
		&
		OUTRO_PEDIO_FLOR = false
		&
		tem_mao_flor(LISTA_CARTA,PEDE_ENV) 
		&
		PEDE_ENV == true <-
	-+jaPediFlor(sim);
	.print("Floooooorrrr!!!!!!!!");
	flor;
.
+!oQueFazerNestaVez(LISTA_CARTA) : 
		codigoVez(VEZ)
		&
		VEZ == 1
		& 
		jaPediRealEnvido(PEDI_REAL_ENV)
		&
		PEDI_REAL_ENV == nao
		&
		pedirRealEnvido(LISTA_CARTA,PEDE_REAL_ENV) 
		&
		PEDE_REAL_ENV == true <-
	-+jaPediEnvido(sim);
	.print("Real Enviiiiiiiiiiiido");
	envido;
.
+!oQueFazerNestaVez(LISTA_CARTA) : 
		codigoVez(VEZ)
		&
		VEZ == 1
		& 
		jaPediEnvido(PEDI_ENV)
		&
		PEDI_ENV == nao
		& 
		jaPediRealEnvido(PEDI_REAL_ENV)
		&
		PEDI_REAL_ENV == nao
		&
		pedirEnvido(LISTA_CARTA,PEDE_ENV) 
		&
		PEDE_ENV == true <-
	-+jaPediRealEnvido(sim);
	.print("Enviiiiiiiiiiiido");
	envido;
.
+!oQueFazerNestaVez(LISTA_CARTA) : 
		jaPediTruco(PEDI)
		&
		PEDI == nao
		&
		pedirTruco(LISTA_CARTA,PEDE_TRUCO)
		&
		PEDE_TRUCO == true
		&
		outroJogadorPedioTruco(OUTRO_PEDIO_TRUCO)
		&
		OUTRO_PEDIO_TRUCO == nao <-
	.print("Truuuuuucoooo");
    
	-+jaPediTruco(sim);
	truco;
.
+!oQueFazerNestaVez(LISTA_CARTA) :
		jaPediRetruco(PEDI_RETRUCO)
		&
		PEDI_RETRUCO==nao
		&
		outroJogadorPedioTruco(OUTRO_PEDIO_TRUCO)
		&
		OUTRO_PEDIO_TRUCO==sim
		&
		outroJogadorPedioRetruco(OUTRO_PEDIO_RETRUCO)
		&
		OUTRO_PEDIO_RETRUCO==nao
		&
		pedirRetruco(LISTA_CARTA,PEDE_RETRUCO)
		&
		PEDE_RETRUCO==true <-
	-+jaPediRetruco(sim);
	.print("Retruuuucoooooo!!!!!!!!");
	retruco;
.
+!oQueFazerNestaVez(LISTA_CARTA) :
		jaPediVale4(PEDI_VALE_4)
		&
		PEDI_VALE_4 == nao
		&
		outroJogadorPedioRetruco(OUTRO_PEDIO_RETRUCO)
		&
		OUTRO_PEDIO_RETRUCO == sim
		&
		outroJogadorPedioVale4(OUTRO_PEDIO_VALE_4)
		&
		OUTRO_PEDIO_VALE_4 == nao
		&
		pedirVale4(LISTA_CARTA,PEDE_VALE_4)
		&
		PEDE_VALE_4 == true <-
	-+jaPediVale4(sim);
	.print("Vale quaaaatrooo!!!!!!!!");
	valeQuatro;
.
+!oQueFazerNestaVez(_) : not cartaVez(_,_) <-
	?maiorCarta(carta(VALOR,NAIPE));
	.print(">>>> Pegar Maior carta");
	
	-cartaMao(VALOR, NAIPE);
	?qtdeCarta(Q);
	-+qtdeCarta(Q-1);
	
	.print("Toma carta(", VALOR, ",", NAIPE, ")");
	jogarCarta(VALOR,NAIPE);
.	
+!oQueFazerNestaVez(_) : cartaVez(VALOR_VEZ,NIPE_VEZ) <-
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
	-+jaPediFlor(nao);
	-+jaPediContraFlor(nao);
	-+jaPediRetruco(nao);
	-+jaPediVale4(nao);
	-+jaPediRealEnvido(nao);
	
	-+outroJogadorPedioTruco(nao);
	-+outroJogadorPedioRetruco(nao);
	-+outroJogadorPedioEnvido(nao);
	-+outroJogadorPedioFlor(nao);
	-+outroJogadorPedioVale4(nao);
	-+outroJogadorPedioRealEnvido(nao);
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
	.print("Aceito truco, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioTruco(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 2 & FORCA_MAO >= 16 <-
	.print("Aceito truco, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioTruco(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 3 & FORCA_MAO >= 9 <-
	.print("Aceito truco, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioTruco(_,_,_) : true <-
	.print("Não aceito truco, O jogo tá muito podre");
	recusar;
.

+envido <-
	?todasCartasMao([],LISTA_CARTA);
	!aceitarEnvido(LISTA_CARTA);
.

+!aceitarEnvido(LISTA_CARTA) : pedirEnvido(LISTA_CARTA,PEDE) & PEDE == true <-
	.print("Aceito envido");
	aceitar;
.
+!aceitarEnvido(LISTA_CARTA) : pedirEnvido(LISTA_CARTA,PEDE) & PEDE == false <-
	.print("Sem envido");
	recusar;
.

+flor <-
	?todasCartasMao([],LISTA_CARTA);
	-+outroJogadorPedioFlor(sim);
	!aceitarFlor(LISTA_CARTA);
.

+!aceitarFlor(LISTA_CARTA) : tem_mao_flor(LISTA_CARTA,TEM_FLOR) & TEM_FLOR == true <-
	.print("Aceito flor");
	aceitar;
.
+!aceitarFlor(LISTA_CARTA) : tem_mao_flor(LISTA_CARTA,TEM_FLOR) & TEM_FLOR == false <-
	.print("Não tenho flor");
	recusar;
.

+contraflor <-
	?todasCartasMao([],LISTA_CARTA);
	!aceitarContraFlor(LISTA_CARTA);
.

+!aceitarContraFlor(LISTA_CARTA) : pontosEnvido(LISTA_CARTA,QTD) & QTD > 23 <-
	.print("Aceito contra flor");
	aceitar;
.
+!aceitarContraFlor(LISTA_CARTA) : pontosEnvido(LISTA_CARTA,QTD) & QTD <= 23 <-
	.print("Não aceito contra flor");
	recusar;
.

+retruco <-
	-+outroJogadorPedioRetruco(sim);
	
	?todasCartasMao([],LISTA_CARTA);
	?codigoVez(CODIGO_VEZ);
	?forcaMao(LISTA_CARTA,FORCA_MAO);
	
	.print("Código Vez -> ",CODIGO_VEZ);
	.print("Força Mao -> ",FORCA_MAO);
	!oQueFazerSeOutroJogadorPedioRetruco(CODIGO_VEZ,LISTA_CARTA,FORCA_MAO);
.

+!oQueFazerSeOutroJogadorPedioRetruco(CODIGO_VEZ,LISTA_CARTA,FORCA_MAO) : CODIGO_VEZ = 1 & FORCA_MAO >= 22 <-
	.print("Aceito retruco, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioRetruco(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 2 & FORCA_MAO >= 18 <-
	.print("Aceito retruco, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioRetruco(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 3 & FORCA_MAO >= 11 <-
	.print("Aceito retruco, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioRetruco(_,_,_) : true <-
	.print("O jogo tá mais ou menos, mas não vou");
	recusar;
.

+vale4 <-
	-+outroJogadorPedioVale4(sim);
	
	?todasCartasMao([],LISTA_CARTA);
	?codigoVez(CODIGO_VEZ);
	?forcaMao(LISTA_CARTA,FORCA_MAO);
	
	.print("Código Vez -> ",CODIGO_VEZ);
	.print("Força Mao -> ",FORCA_MAO);
	!oQueFazerSeOutroJogadorPedioVale4(CODIGO_VEZ,LISTA_CARTA,FORCA_MAO);
.

+!oQueFazerSeOutroJogadorPedioVale4(CODIGO_VEZ,LISTA_CARTA,FORCA_MAO) : CODIGO_VEZ = 1 & FORCA_MAO >= 24 <-
	.print("Aceito vale 4, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioVale4(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 2 & FORCA_MAO >= 20 <-
	.print("Aceito vale 4, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioVale4(CODIGO_VEZ,LISTA_CARTA, FORCA_MAO) : CODIGO_VEZ = 3 & FORCA_MAO >= 13 <-
	.print("Aceito vale 4, Cai essas cartas de merda");
	aceitar;
.

+!oQueFazerSeOutroJogadorPedioVale4(_,_,_) : true <-
	.print("O jogo tá razoável, mas não vou");
	recusar;
.

+realenvido <-
	?todasCartasMao([],LISTA_CARTA);
	!aceitarRealEnvido(LISTA_CARTA);
.

+!aceitarRealEnvido(LISTA_CARTA) : pedirRealEnvido(LISTA_CARTA,PEDE) & PEDE == true <-
	.print("Aceito real envido");
	aceitar;
.
+!aceitarRealEnvido(LISTA_CARTA) : pedirRealEnvido(LISTA_CARTA,PEDE) & PEDE == false <-
	.print("Sem real envido");
	recusar;
.

+faltaenvido <-
	aceitar;
.

+contraflorresto <-
	aceitar;
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
