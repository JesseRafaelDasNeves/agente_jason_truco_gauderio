package artefato;

import java.util.Random;

import cartago.*;
import artefato.Jogador;
import artefato.Tela;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.parser.ParseException;
import jason.stdlib.foreach;

import java.util.ArrayList;
import java.util.List;

public class MesaTeste extends Artifact {
	
private int[][] controlePartida = new int[4][2];
	
	private int jogadorVez = 0;
	private AgentId[] jogadores = new AgentId[2];
	private String[][] baralho = new String[40][2];
	private String[][] cartasMaos = new String[6][3]; 
	private int pe;
	private int vencedorPrimeiraRodada;
	private int rodada;
	private int jogadorMao = 1;
	private int aposta = 0;
	private int valorPartida = 6;
	private int jogadorAposta = -1;
	private ObsProperty cartaVez = null;
        
        //atributos da interface gráfica
        private Tela tela;
        private final int width = 900;
        private final int height = 800;
        private List<Jogador> jogadoresTela;
	
	
	void init()  {

	       this.tela = new Tela(this.width, this.height);
            this.jogadoresTela = new ArrayList<Jogador>();
		
	}

	@OPERATION
	void entrarNaPartida() throws ParseException {
		rodada = 1;
		jogadores[jogadorVez] = getCurrentOpAgentId();
        Jogador jogadorTela = new Jogador("Jogador"+(jogadorVez+1), "jogador"+(jogadorVez+1), jogadores[jogadorVez]);
        this.jogadoresTela.add(jogadorTela);
                
		if(jogadorVez == 1) {
			this.tela.jogador1.setText(jogadores[0].getGlobalId());
			this.tela.jogador2.setText(jogadores[1].getGlobalId());
			carregaBaralho();
			distribuirCartas();
                        
			signal(jogadores[jogadorVez], "suavez");
		} else {
			jogadorVez++;
		}
	}
	
	@OPERATION
	void jogarCarta(int num, String naipe) throws ParseException {
		boolean finalizouMao = false;
		if(this.cartaVez == null) {
			if(rodada == 1) {
				pe = jogadorVez;
			}
		//	System.out.println("chamando inserir carta vez");
			execInternalOp("inserirCartaVez", num, naipe);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
		} else {
			int num1 = Integer.parseInt(cartaVez.stringValue(0));
			String naipe1 = cartaVez.stringValue(1);
			int jogador = retornaJogadorMelhorCarta(num, (String) naipe, num1, naipe1);
			
			/* Se n�o empatar */
			if(jogador != 2)
				controlePartida[1][jogador]++;
			if(rodada > 1) {
				if(controlePartida[1][0] > controlePartida[1][1]) {
					finalizouMao = true;
					finalizaMao();
				}		
				else if(controlePartida[1][0] < controlePartida[1][1]) {
					finalizouMao = true;
					finalizaMao();
				}
				else 
					if(rodada == 3) {
						if(jogador == 2 && vencedorPrimeiraRodada == 2)
							controlePartida[1][pe]++; 
						else
							controlePartida[1][vencedorPrimeiraRodada]++;
						finalizouMao = true;
						finalizaMao();
					}
			} else { 
				vencedorPrimeiraRodada = jogador;
			}
			if(!finalizouMao) {
				System.out.println("N�o finalizou m�o");
				rodada++;
				try {
				//	System.out.println("Chamando remover carta vez");
					execInternalOp("removerCartaVez");
				}catch(Exception e) {
					System.out.println("________________Teste Nao tem carta vez");
				}
				
				if(jogador == 2) {
					signal(jogadores[pe], "suavez");
					jogadorVez = pe;
				} else {
					signal(jogadores[jogador], "suavez");
					jogadorVez = jogador;
				}
			}
			imprimirPlacar();
			
			System.out.println("Rodada finalizada \n");
			
		}
		int jogadorVezAux = 0;
		if(jogadorVez == 0)
			jogadorVezAux = 1;
		else 
			jogadorVezAux = 0;
		this.tela.removeImagemCarta(this.jogadoresTela.get(jogadorVezAux), this.getPos(num,naipe));
	}
	
	private int getPos(int num, String naipe) {
		int jogadorVezAux = 0;
		if(jogadorVez == 0)
			jogadorVezAux = 1;
		else 
			jogadorVezAux = 0;
		for (int i = 0; i <  this.jogadoresTela.get(jogadorVezAux).getMao().size(); i++) {
			if(this.jogadoresTela.get(jogadorVezAux).getMao().get(i).equalsIgnoreCase(num+naipe)) {
				return i;
			}
	}
		return -1;
	}

	@INTERNAL_OPERATION void inserirCartaVez(int num, String naipe) throws ParseException {
		//System.out.println("Inserindo carta vez: " + num + "," + naipe);
		if(this.cartaVez==null) {
			this.tela.addImagemCartaVez(num+naipe);
			this.cartaVez=defineObsProperty("cartaVez", num, ASSyntax.parseLiteral(naipe));
		}
	}
	
	@INTERNAL_OPERATION void removerCartaVez() {
		//System.out.println("Removendo carta Vez");
		this.tela.removeImagemCartaVez();
		try {
			removeObsPropertyByTemplate(this.cartaVez.getName(),this.cartaVez.getValues());
		} catch (Exception e) {
			System.out.println("____________Nao tem carta da vez na mesa");
		}
	
		this.cartaVez = null;
	}
	
	@OPERATION
	void truco() {
		jogadorAposta = jogadorVez;
		aposta = 1;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "truco");
	}
	
	@OPERATION
	void retruco() {
		jogadorAposta = jogadorVez;
		aposta = 2;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "retruco");
	}
	
	@OPERATION
	void valeQuatro() {
		jogadorAposta = jogadorVez;
		aposta = 3;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "vale4");
	}
	
	@OPERATION
	void envido() {
		aposta = 4;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "envido");
	}
	
	@OPERATION
	void realEnvido() {
		if(aposta == 4)
			aposta = 6;
		else
			aposta = 5;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "realenvido");
	}
	
	@OPERATION
	void faltaEnvido() {
		if(aposta == 5 || aposta == 6)
			aposta = 8;
		else
			aposta = 7;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "faltaenvido");
	}
	
	@OPERATION
	void flor() {
		aposta = 7;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "flor");
	}
	
	@OPERATION
	void contraFlor() {
		aposta = 8;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "contraflor");
	}
	
	@OPERATION
	void florResto() {
		aposta = 9;
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "contraflorresto");
	}
		
	@OPERATION
	void aceitar() {
		jogadorAposta = -1;
		System.out.println("aposta: " + aposta);
		switch (aposta) {
		case 1:
			/* Truco */
			incrementarPontosExtras(2);
			break;
		case 2:
			/* Re-Truco */
			incrementarPontosExtras(3);
			break;
		case 3:
			/* Vale 4 */
			incrementarPontosExtras(4);
			break;
		case 4:
			/* Envido */
			incrementarPontosExtras(2);
			break;
		case 5:
			/* Real Envido */
			incrementarPontosExtras(5);
			break;
		case 6:
			/* Real Envido ap�s Envido*/
			incrementarPontosExtras(5);
			break;
		case 7:
			/* Falta Envido */
			incrementarPontosExtras(retornaPontuacaoFaltante());
			break;
		case 8:
			/* Falta Envido ap�s Real Envido */
			incrementarPontosExtras(retornaPontuacaoFaltante());
			break;
		case 9:
			/* Flor */
			incrementarPontosExtras(3);
			break;		
		case 10:
			/* Contra-Flor */
			incrementarPontosExtras(6);
			break;	
		case 11:
			/* Contra-Flor e o resto */
			incrementarPontosExtras(retornaPontuacaoFaltante());
			break;	
		}
		if(aposta > 8)
			calculaPontuacaoAposta(2);
		else if(aposta > 3)
			calculaPontuacaoAposta(1);
		
		atualizaJogadorVez();
		signal(jogadores[jogadorVez], "suavez");
	}
	
	@OPERATION
	void recusar() {
		System.out.println("aposta: " + aposta);
		switch (aposta) {
		case 1:
			/* Truco */
			incrementarPontosExtras(1);
			finalizaMao();
			break;
		case 2:
			/* Re-Truco */
			incrementarPontosExtras(2);
			finalizaMao();
			break;
		case 3:
			/* Vale 4 */
			incrementarPontosExtras(3);
			finalizaMao();
			break;
		case 4:
			/* Envido */
			incrementarPontosExtras(1);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
			break;
		case 5:
			/* Real Envido */
			incrementarPontosExtras(1);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
			break;
		case 6:
			/* Real Envido ap�s Envido*/
			incrementarPontosExtras(2);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
			break;
		case 7:
			/* Falta Envido */
			incrementarPontosExtras(1);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
			break;
		case 8:
			/* Falta Envido ap�s Real Envido */
			incrementarPontosExtras(5);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
			break;
		case 9:
			/* Flor */
			incrementarPontosExtras(4);
			atualizaJogadorVez();
			signal(jogadores[jogadorVez], "suavez");
			break;		
		}
	}
	
	public void calculaPontuacaoAposta(int opcao) {
		for(int y = 0; y < jogadores.length; y ++) {
			int[] naipes = new int[4];
			int[] somaNaipes = new int[4];
			for(int i  = 0; i < cartasMaos.length; i++) {
				if(cartasMaos[i][2].equals("copas") && (cartasMaos[i][0].equals(String.valueOf(y)))) {
					naipes[0]++;
					somaNaipes[0] += Integer.parseInt(cartasMaos[i][1]);
				} else if(cartasMaos[i][2].equals("espada") && (cartasMaos[i][0].equals(String.valueOf(y)))) {
					naipes[1]++;
					somaNaipes[1] += Integer.parseInt(cartasMaos[i][1]);
				} else if(cartasMaos[i][2].equals("ouro") && (cartasMaos[i][0].equals(String.valueOf(y)))) {
					naipes[2]++;
					somaNaipes[2] += Integer.parseInt(cartasMaos[i][1]);
				} else if(cartasMaos[i][2].equals("paus") && (cartasMaos[i][0].equals(String.valueOf(y)))){
					naipes[3]++;
					somaNaipes[3] += Integer.parseInt(cartasMaos[i][1]);
				}
			}
			int maior = 0;
			for(int x = 0; x < 4; x++) 
				if(naipes[x] > opcao)
					maior = x;
			if (maior > 0) 
				controlePartida[3][y] = somaNaipes[maior] + 20;
		}
	}

	public int retornaPontuacaoFaltante() {
		int resto = valorPartida - controlePartida[0][0];
		for(int i = 0; i < jogadores.length; i++)
			if(valorPartida - controlePartida[0][i] < resto)
				resto = valorPartida - controlePartida[0][i];
		return resto;
	}
	
	public void incrementarPontosExtras(int pontuacao) {
		for(int i = 0; i < 2; i++)
			controlePartida[2][i] = pontuacao;
	}
	
	public void imprimirPlacar() {
		System.out.println("Extra:" + jogadores[0].getAgentName() + ": " + controlePartida[3][0]);
		System.out.println("Extra:" + jogadores[1].getAgentName() + ": " + controlePartida[3][1]);
		System.out.println("M�o:" + jogadores[0].getAgentName() + ": " + controlePartida[1][0]);
		System.out.println("M�o:" + jogadores[1].getAgentName() + ": " + controlePartida[1][1]);
		System.out.println("Partida:" + jogadores[0].getAgentName() + ": " + controlePartida[0][0]);
		System.out.println("Partida:" + jogadores[1].getAgentName() + ": " + controlePartida[0][1]);
		this.tela.atualizaPontosPartida(controlePartida[0][0], controlePartida[0][1]);
		
	}
	
	public void distribuirCartas() {
		 this.jogadoresTela.get(0).drawAllCarta();
		 this.jogadoresTela.get(1).drawAllCarta();
		int[] cartas = this.sorteiaCartas();
		for(int i = 0; i < cartas.length; i++) 
			try {
				if(i < 3) {
					signal(jogadores[0], "receberCarta", ASSyntax.parseNumber(baralho[cartas[i]][0]), ASSyntax.parseLiteral(baralho[cartas[i]][1]));
					cartasMaos[i][0] = "0";
					cartasMaos[i][1] = baralho[cartas[i]][0];
					cartasMaos[i][2] = baralho[cartas[i]][1];
                    this.jogadoresTela.get(0).addCarta(cartasMaos[i][1]+cartasMaos[i][2]);
				} else {
					signal(jogadores[1], "receberCarta", ASSyntax.parseNumber(baralho[cartas[i]][0]), ASSyntax.parseLiteral(baralho[cartas[i]][1]));
					cartasMaos[i][0] = "1";
					cartasMaos[i][1] = baralho[cartas[i]][0];
					cartasMaos[i][2] = baralho[cartas[i]][1];
                    this.jogadoresTela.get(1).addCarta(cartasMaos[i][1]+cartasMaos[i][2]);
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		montaTela();
	}
	
	private void finalizaMao() {
		rodada = 1;
		try {
			execInternalOp("removerCartaVez");
			signal(jogadores[0], "dropAll");
			signal(jogadores[1], "dropAll");
		}catch(Exception e) {
			System.out.println("N�o h� carta da vez para remover");
		}
		boolean partidaFinalizada = false;
		
		if((controlePartida[1][0] > controlePartida[1][1] && aposta < 4)||(controlePartida[3][0] > controlePartida[3][1] && aposta > 3) && jogadorAposta == -1) {
			if(aposta > 0)
				controlePartida[0][0] = controlePartida[0][0] + controlePartida[2][0];
			else
				controlePartida[0][0]++;
			if(controlePartida[0][0] >= valorPartida) {
				System.out.println("O jogador " + jogadores[0].getAgentName() + " ganhou a partida.");
				partidaFinalizada = true;
			}
		} else if(jogadorAposta == -1){
			if(aposta > 0)
				controlePartida[0][1] = controlePartida[0][0] + controlePartida[2][0];
			else
				controlePartida[0][1]++;
			if(controlePartida[0][1] >= valorPartida) {
				partidaFinalizada = true;
			}
		}
		if(jogadorAposta != -1) {
			controlePartida[0][jogadorAposta] = controlePartida[0][jogadorAposta] + controlePartida[2][jogadorAposta];
			if(controlePartida[0][1] >= valorPartida) 
				partidaFinalizada = true;
		}
			
		
		if(jogadorMao == 0)
			jogadorMao = 1;
		else
			jogadorMao = 0;	
		
		imprimirPlacar();
		resetarValoresMao();
		
		
		if(!partidaFinalizada) { 
			distribuirCartas();
			atualizaJogadorVez();
			if(jogadorMao == 1) 
				jogadorMao = 0;
			else
				jogadorMao = 1;
			signal(jogadores[jogadorVez], "suavez");
			System.out.println("M�o finalizada \n");
		} else {
			System.out.println("Partida Finalizada");
		}
	}
	
	private void resetarValoresMao() {
		for(int i = 0; i < 2; i++) {
			controlePartida[1][i] = 0;
			controlePartida[2][i] = 0;
		}
		aposta = 0;
		jogadorAposta = -1;
	}
	
	private void atualizaJogadorVez() {
		if(jogadorVez == 0)
			jogadorVez = 1;
		else 
			jogadorVez = 0;
	}
	
	private int retornaJogadorMelhorCarta(int num1, String naipe1, int num2, String naipe2) {
		int indice1 = 0;
		int indice2 = 0;
		for(int i = 0; i < baralho.length; i++) {
			if(Integer.parseInt(baralho[i][0]) == num1 && baralho[i][1].equalsIgnoreCase(naipe1)) 
				indice1 = i;
			if(Integer.parseInt(baralho[i][0]) == num2 && baralho[i][1].equalsIgnoreCase(naipe2)) 
				indice2 = i;
		}
		
		if((num1 == num2) && (indice1 >= 4 && indice2 >= 4))
			return 2;
		else
			if(indice1 < indice2)
				return jogadorVez;
			else
				if(jogadorVez == 0)
					return 1;
				else 
					return 0;
		
	}
	
	private int[] sorteiaCartas() {
		int[] cartas = new int[6];
        
		for (int i = 0; i < cartas.length; i++) {
            cartas[i] = -1;
        }
        
        Random random = new Random();
        
        for (int i = 0; i < cartas.length; i++) {
            boolean naoExiste = false;
            int temp;
            if(i == 0){
                temp = random.nextInt(40);
                cartas[i] = temp;
            }else{
                while(!naoExiste){
                    naoExiste = true;
                    temp = random.nextInt(40);
                    for(int j = i; j >= 0; j--){
                        if(temp == cartas[j]){
                            naoExiste = false;
                        }
                    }
                    if(naoExiste){
                        cartas[i] = temp;
                    }
                }
            }
        }
		return cartas;
	}
	
	private void carregaBaralho() {
		baralho[0][0] = "1"; 
		baralho[0][1] = "espada";
		baralho[1][0] = "1"; 
		baralho[1][1] = "paus"; 
		baralho[2][0] = "7"; 
		baralho[2][1] = "espada"; 
		baralho[3][0] = "7"; 
		baralho[3][1] = "ouro"; 		
		baralho[4][0] = "3"; 
		baralho[4][1] = "paus"; 
		baralho[5][0] = "3"; 
		baralho[5][1] = "copas"; 
		baralho[6][0] = "3"; 
		baralho[6][1] = "espada"; 
		baralho[7][0] = "3"; 
		baralho[7][1] = "ouro"; 
		baralho[8][0]  = "2"; 
		baralho[8][1]  = "paus"; 
		baralho[9][0]  = "2"; 
		baralho[9][1]  = "copas"; 
		baralho[10][0] = "2"; 
		baralho[10][1] = "espada"; 
		baralho[11][0] = "2"; 
		baralho[11][1] = "ouro"; 
		baralho[12][0] = "1"; 
		baralho[12][1] = "copas";  
		baralho[13][0] = "1"; 
		baralho[13][1] = "ouro"; 
		baralho[14][0] = "12"; 
		baralho[14][1] = "paus"; 
		baralho[15][0] = "12"; 
		baralho[15][1] = "copas"; 
		baralho[16][0] = "12"; 
		baralho[16][1] = "espada"; 
		baralho[17][0] = "12"; 
		baralho[17][1] = "ouro"; 
		baralho[18][0] = "11"; 
		baralho[18][1] = "paus"; 
		baralho[19][0] = "11"; 
		baralho[19][1] = "copas"; 
		baralho[20][0] = "11"; 
		baralho[20][1] = "espada"; 
		baralho[21][0] = "11"; 
		baralho[21][1] = "ouro"; 
		baralho[22][0] = "10"; 
		baralho[22][1] = "paus"; 
		baralho[23][0] = "10"; 
		baralho[23][1] = "copas"; 
		baralho[24][0] = "10"; 
		baralho[24][1] = "espada"; 
		baralho[25][0] = "10"; 
		baralho[25][1] = "ouro"; 
		baralho[26][0] = "7"; 
		baralho[26][1] = "paus"; 
		baralho[27][0] = "7"; 
		baralho[27][1] = "copas"; 
		baralho[28][0] = "6"; 
		baralho[28][1] = "paus"; 
		baralho[29][0] = "6"; 
		baralho[29][1] = "copas"; 
		baralho[30][0] = "6"; 
		baralho[30][1] = "espada"; 
		baralho[31][0] = "6"; 
		baralho[31][1] = "ouro"; 
		baralho[32][0] = "5"; 
		baralho[32][1] = "paus"; 
		baralho[33][0] = "5"; 
		baralho[33][1] = "copas"; 
		baralho[34][0] = "5"; 
		baralho[34][1] = "espada"; 
		baralho[35][0] = "5"; 
		baralho[35][1] = "ouro";
		baralho[36][0] = "4"; 
		baralho[36][1] = "paus"; 
		baralho[37][0] = "4"; 
		baralho[37][1] = "copas"; 
		baralho[38][0] = "4"; 
		baralho[38][1] = "espada"; 
		baralho[39][0] = "4"; 
		baralho[39][1] = "ouro";		
	}

    private void montaTela() {
        this.tela.montaTela(this.jogadoresTela);
    }

	
}

