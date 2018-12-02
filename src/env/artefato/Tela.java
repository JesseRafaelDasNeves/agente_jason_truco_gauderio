/*
 * The MIT License
 *
 * Copyright 2018 Jessé Rafael das Neves, Marcos Rufino de Camargo and Samuel Felício Adriano.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package artefato;

import java.awt.Color;
import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;

public class Tela extends JFrame {

   private javax.swing.JLabel jogador1;
    private javax.swing.JLabel carta1Jogador2;
    private javax.swing.JLabel carta2Jogador2;
    private javax.swing.JLabel carta3Jogador2;
    private javax.swing.JLabel jogador2;
    private javax.swing.JLabel pontosPartidaJogador1;
    private javax.swing.JLabel cartaVez;
    private javax.swing.JLabel baralhoImg;
    private javax.swing.JLabel pontosPartidaJogador2;
    private javax.swing.JLabel carta1Jogador1;
    private javax.swing.JLabel carta2Jogador1;
    private javax.swing.JLabel carta3Jogador1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
//    private javax.swing.JPanel jPanel3;
//    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTabbedPane jTabbedPane1;
//    private javax.swing.JTable jTable1;
    private javax.swing.JTextField textPontosPartidaJogador1;
    private javax.swing.JTextField textPontosPartidaJogador2;

    private String EXTENSAO_IMG = ".png";

    public Tela(int width, int height) {
        init(width, height);
        this.setVisible(true);
    }

    public Tela() {
        init(900, 800);
        this.setVisible(true);
    }

    public void atualizaPontosPartida(int pontosJogador1,int pontosJogador2) {
    this.textPontosPartidaJogador1.setText(pontosJogador1+"");
    this.textPontosPartidaJogador2.setText(pontosJogador2+"");
    this.atualizaTela();
    }
    
    public void addImagemCarta(Jogador jogador, String carta, int pos) {
     	System.out.println(carta);
        if (jogador.getAvatar().equalsIgnoreCase("jogador1")) {
            switch (pos) {
                case 0:
                    this.carta1Jogador1.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
                    break;
                case 1:
                    this.carta2Jogador1.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
                    break;
                case 2:
                    this.carta3Jogador1.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
                    break;
            }
        } else {
            switch (pos) {
                case 0:
                    this.carta1Jogador2.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
                    break;
                case 1:
                    this.carta2Jogador2.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
                    break;
                case 2:
                    this.carta3Jogador2.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
                    break;
            }
        }
        this.atualizaTela();
    }
    
    public void removeImagemCarta(Jogador jogador, int pos) {
        if (jogador.getAvatar().equalsIgnoreCase("jogador1")) {
            switch (pos) {
                case 0:
                    this.carta1Jogador1.setIcon(null);
                    break;
                case 1:
                    this.carta2Jogador1.setIcon(null);
                    break;
                case 2:
                    this.carta3Jogador1.setIcon(null);
                    break;
            }
        } else {
            switch (pos) {
                case 0:
                    this.carta1Jogador2.setIcon(null);
                    break;
                case 1:
                    this.carta2Jogador2.setIcon(null);
                    break;
                case 2:
                    this.carta3Jogador2.setIcon(null);
                    break;
            }
        }
        this.atualizaTela();
    }

    private void atualizaTela() {
        this.repaint();
    }

    public void addImagemCartaVez(String carta) {
        this.cartaVez.setIcon(this.carregaIcone(91, 128, "img/carta/" + carta, "" + carta));
        this.atualizaTela();
    }
    
    public void removeImagemCartaVez() {
        this.cartaVez.setIcon(null);
        this.atualizaTela();
    }
    
   private void addBaralho() {
        this.baralhoImg.setIcon(this.carregaIcone(91, 128, "img/carta/baralho", "Baralho"));
        this.atualizaTela();
    }

    private Image carregaImagem(String caminho) {
        Image img = null;
        try {
            img = ImageIO.read(new File(caminho));
        } catch (IOException ex) {
            Logger.getLogger(Tela.class.getName()).log(Level.SEVERE, null, ex);
        }
        return img;
    }

    private ImageIcon carregaIcone(int width, int height, String caminho, String caption) {
        return new ImageIcon(new ImageIcon(this.carregaImagem(caminho + EXTENSAO_IMG)).getImage()
                .getScaledInstance(width, height, Image.SCALE_DEFAULT), caption);
    }

    public void addImagemJogador(Jogador jogador) {
   
        if (this.jogador1.getIcon() == null) {
            this.jogador1.setIcon(this.carregaIcone(64, 64, "img/avatar/jogador1", "Jogador1"));
        } else {
            this.jogador2.setIcon(this.carregaIcone(64, 64, "img/avatar/jogador2", "Jogador2"));
        }
        this.atualizaTela();
    }

    public void montaTela(List<Jogador> jogadores) {
        for (Jogador jogador : jogadores) {
            this.addImagemJogador(jogador);
            for (int i = 0; i < jogador.getMao().size(); i++) {
                this.addImagemCarta(jogador, jogador.getMao().get(i), i);
            }
        }
        this.addBaralho();
    }

    private void init(int width, int height) {

        setTitle("TRUCO GAUDERIO");

        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel1 = new javax.swing.JPanel();

        jogador1 = new javax.swing.JLabel();
        jogador2 = new javax.swing.JLabel();
        cartaVez = new javax.swing.JLabel();

        baralhoImg = new javax.swing.JLabel();
        carta1Jogador1 = new javax.swing.JLabel();
        carta2Jogador1 = new javax.swing.JLabel();
        carta3Jogador1 = new javax.swing.JLabel();
        carta1Jogador2 = new javax.swing.JLabel();
        carta2Jogador2 = new javax.swing.JLabel();
        carta3Jogador2 = new javax.swing.JLabel();

        jPanel2 = new javax.swing.JPanel();
        textPontosPartidaJogador1 = new javax.swing.JTextField();
        pontosPartidaJogador1 = new javax.swing.JLabel();
        pontosPartidaJogador2 = new javax.swing.JLabel();
        textPontosPartidaJogador2 = new javax.swing.JTextField();
//        jPanel3 = new javax.swing.JPanel();
//        jScrollPane1 = new javax.swing.JScrollPane();
//        jTable1 = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setAlwaysOnTop(true);

        jogador1.setText("Jogador 1");
        jogador1.setForeground(new Color(255, 255, 255));

        jogador2.setText("Jogador 2");
        jogador2.setForeground(new Color(255, 255, 255));

        cartaVez.setText("");
        
        baralhoImg.setForeground(new Color(255, 255, 255));

        carta1Jogador1.setText("");

        carta2Jogador1.setText("");

        carta3Jogador1.setText("");

        carta1Jogador2.setText("");

        carta2Jogador2.setText("");

        carta3Jogador2.setText("");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup().addGap(76, 76, 76)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jogador2).addComponent(carta1Jogador1))
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addGroup(jPanel1Layout.createSequentialGroup().addGap(107, 107, 107)
                                        .addComponent(carta1Jogador2).addGap(145, 145, 145))
                                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING,
                                        jPanel1Layout.createSequentialGroup()
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED,
                                                        javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                .addComponent(carta2Jogador1).addGap(108, 108, 108)))
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel1Layout.createSequentialGroup().addComponent(carta2Jogador2).addGap(45, 301,
                                        Short.MAX_VALUE))
                                .addGroup(jPanel1Layout.createSequentialGroup().addGap(34, 34, 34).addComponent(carta3Jogador1)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED,
                                                javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jogador1).addGap(56, 56, 56))))
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING,
                        jPanel1Layout.createSequentialGroup().addGap(243, 243, 243).addComponent(cartaVez)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED,
                                        javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(carta3Jogador2).addComponent(baralhoImg))
                                .addGap(87, 87, 87)));
        jPanel1Layout.setVerticalGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel1Layout.createSequentialGroup().addContainerGap()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jogador1).addComponent(carta1Jogador1).addComponent(carta2Jogador1)
                                .addComponent(carta3Jogador1))
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel1Layout.createSequentialGroup().addGap(145, 145, 145)
                                        .addComponent(baralhoImg))
                                .addGroup(jPanel1Layout.createSequentialGroup().addGap(159, 159, 159)
                                        .addComponent(cartaVez)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 234, Short.MAX_VALUE)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jogador2).addComponent(carta1Jogador2).addComponent(carta2Jogador2)
                                .addComponent(carta3Jogador2))
                        .addGap(21, 21, 21)));
        jPanel1.setBackground(new Color(63, 122, 77));
        jTabbedPane1.addTab("Jogadores", jPanel1);

        pontosPartidaJogador1.setText("Partidas Vencidas -> JOGADOR1: ");

        pontosPartidaJogador2.setText("Partidas Vencidas -> JOGADOR2: ");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup().addContainerGap()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel2Layout.createSequentialGroup().addComponent(pontosPartidaJogador1)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(textPontosPartidaJogador1))
                                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING,
                                        jPanel2Layout.createSequentialGroup().addComponent(pontosPartidaJogador2)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(textPontosPartidaJogador2, javax.swing.GroupLayout.DEFAULT_SIZE, 645,
                                                        Short.MAX_VALUE)))
                        .addContainerGap()));
        jPanel2Layout.setVerticalGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup().addGap(23, 23, 23)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(textPontosPartidaJogador1, javax.swing.GroupLayout.PREFERRED_SIZE,
                                        javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(pontosPartidaJogador1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(textPontosPartidaJogador2, javax.swing.GroupLayout.PREFERRED_SIZE,
                                        javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(pontosPartidaJogador2))
                        .addContainerGap(391, Short.MAX_VALUE)));
        
        jPanel2Layout.setVerticalGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup().addGap(23, 23, 23)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(textPontosPartidaJogador1, javax.swing.GroupLayout.PREFERRED_SIZE,
                                        javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(pontosPartidaJogador1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(textPontosPartidaJogador2, javax.swing.GroupLayout.PREFERRED_SIZE,
                                        javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(pontosPartidaJogador2))
                        .addContainerGap(391, Short.MAX_VALUE)));

        jTabbedPane1.addTab("Geral Jogo", jPanel2);

//        jTable1.setModel(
//                new javax.swing.table.DefaultTableModel(
//                        new Object[][]{{null, null, null, null}, {null, null, null, null},
//                        {null, null, null, null}, {null, null, null, null}},
//                        new String[]{"Title 1", "Title 2", "Title 3", "Title 4"}));
//        jScrollPane1.setViewportView(jTable1);
//
//        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
//        jPanel3.setLayout(jPanel3Layout);
//        jPanel3Layout.setHorizontalGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
//                .addGroup(jPanel3Layout.createSequentialGroup().addContainerGap()
//                        .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 759, Short.MAX_VALUE)
//                        .addContainerGap()));
//        jPanel3Layout.setVerticalGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
//                .addGroup(jPanel3Layout
//                        .createSequentialGroup().addContainerGap().addComponent(jScrollPane1,
//                                javax.swing.GroupLayout.PREFERRED_SIZE, 395, javax.swing.GroupLayout.PREFERRED_SIZE)
//                        .addContainerGap(67, Short.MAX_VALUE)));
//
//        jTabbedPane1.addTab("Partida", jPanel3);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.Alignment.TRAILING));
        layout.setVerticalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING).addComponent(jTabbedPane1));

        pack();
        setLocationRelativeTo(null);
        this.setResizable(false);
        this.setSize(width, height);
    }

    public JLabel getJogador1() {
        return this.jogador1;
    }

}
