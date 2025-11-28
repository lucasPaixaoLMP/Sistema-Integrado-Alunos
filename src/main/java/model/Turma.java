package model;

import java.util.Date;

/**
 * Classe que representa uma Turma
 */
public class Turma {
    
    // Atributos
    private int id;
    private String nome;
    private String curso;
    private int carga_horaria;
    private Date data_inicio;
    private Date data_fim;
    private String turno;
    private String status;
    private Date data_criacao;
    
    // Construtores
    public Turma() {
        this.data_criacao = new Date();
        this.status = "Ativa";
    }
    
    public Turma(String p_nome, String p_curso, int p_carga_horaria, 
                 Date p_data_inicio, Date p_data_fim, String p_turno) {
        this.nome = p_nome;
        this.curso = p_curso;
        this.carga_horaria = p_carga_horaria;
        this.data_inicio = p_data_inicio;
        this.data_fim = p_data_fim;
        this.turno = p_turno;
        this.status = "Ativa";
        this.data_criacao = new Date();
    }
    
    // Métodos Setters
    public void setId(int p_id) {
        this.id = p_id;
    }
    
    public void setNome(String p_nome) {
        this.nome = p_nome;
    }
    
    public void setCurso(String p_curso) {
        this.curso = p_curso;
    }
    
    public void setCarga_horaria(int p_carga_horaria) {
        this.carga_horaria = p_carga_horaria;
    }
    
    public void setData_inicio(Date p_data_inicio) {
        this.data_inicio = p_data_inicio;
    }
    
    public void setData_fim(Date p_data_fim) {
        this.data_fim = p_data_fim;
    }
    
    public void setTurno(String p_turno) {
        this.turno = p_turno;
    }
    
    public void setStatus(String p_status) {
        this.status = p_status;
    }
    
    public void setData_criacao(Date p_data_criacao) {
        this.data_criacao = p_data_criacao;
    }
    
    // Métodos Getters
    public int getId() {
        return this.id;
    }
    
    public String getNome() {
        return this.nome;
    }
    
    public String getCurso() {
        return this.curso;
    }
    
    public int getCarga_horaria() {
        return this.carga_horaria;
    }
    
    public Date getData_inicio() {
        return this.data_inicio;
    }
    
    public Date getData_fim() {
        return this.data_fim;
    }
    
    public String getTurno() {
        return this.turno;
    }
    
    public String getStatus() {
        return this.status;
    }
    
    public Date getData_criacao() {
        return this.data_criacao;
    }
    
    @Override
    public String toString() {
        return "Turma{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", curso='" + curso + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}