
!start.

+!start : true 
	<-
	entrarNaPartida;
	.

+suavez : true
	<-
	.wait(1000);
	.print("minha vez");
	?cartaMao(NUM, NAIPE);
	//.wait(2000);
	.print("carta(", NUM, ",", NAIPE, ")");
	-cartaMao(NUM, NAIPE);
	//.wait(2000);
	jogarCarta(NUM, NAIPE);
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
