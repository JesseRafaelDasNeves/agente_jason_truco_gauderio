package artefato;

import java.util.ArrayList;
import java.util.List;

import cartago.AgentId;

public final class Jogador {

    private final AgentId id;
    private final String nome;
    private final String avatar;
    private List<String> mao;

    public Jogador(String nome, String avatar, AgentId id) {
        this.nome = nome;
        this.avatar = avatar;
        this.id = id;
        this.mao = new ArrayList<String>(3);
    }

    public final String getNome() {
        return this.nome;
    }

    public final String getAvatar() {
        return this.avatar;
    }

    public final AgentId getId() {
        return this.id;
    }

    public final void addCarta(String card) {
        this.mao.add(card);
    }

    public final void drawCarta(String cardRemove) {
        this.mao.remove(cardRemove);
    }
    
    public final void drawAllCarta() {
        this.mao.clear();
    }

    public List<String> getMao() {
        return mao;
    }

    public void setMao(List<String> mao) {
        this.mao = mao;
    }

    @Override
    public String toString() {
        return "{Player nome: " + nome + "}";
    }

}
