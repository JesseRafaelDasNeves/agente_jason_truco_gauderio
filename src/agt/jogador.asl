jaPediTruco(nao).
outroJogadorPedioTruco(nao).

!start.

+!start : true 
	<-
	entrarNaPartida;
	.

+suavez : true <-
	.wait(1000);
	.print("minha vez");
	!oQueFazerNaMinhaVez;
.

/*
+!oQueFazerNaMinhaVez : jaPediTruco(PEDI) & PEDI == nao & outroJogadorPedioTruco(PEDIU) & PEDIU == nao <-
	.print("Truco");
    
	-+jaPediTruco(sim);
	truco;
.
*/

+!oQueFazerNaMinhaVez : true <-
	.print("Truco");
    
	?cartaMao(NUM, NAIPE);
	.print("carta(", NUM, ",", NAIPE, ")");
	-cartaMao(NUM, NAIPE);
	jogarCarta(NUM, NAIPE);
.
	
+receberCarta(NUM, NAIPE) : true <-
	.print("Recebida a carta(", NUM, ",", NAIPE, ")");
	
	-+outroJogadorPedioTruco(nao);
	-+jaPediTruco(nao);
	+cartaMao(NUM , NAIPE);
.

+truco : true
	<-
	.print("Cai carta seu merda");
	-+outroJogadorPedioTruco(sim);
	aceitar;
	.
	
+dropAll:true <-
 	.abolish(cartaMao(_,_));
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
	.print("Nada implementado");
 .

	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
