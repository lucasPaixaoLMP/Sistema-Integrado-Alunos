package model;

import java.util.Date;

/**
 * Classe que representa um Certificado
 */
public class Certificado {
    
    // Atributos
    private int id;
    private int aluno_id;
    private int turma_id;
    private String cpf_consulta;
    private Date data_emissao;
    private String caminho_pdf;
    private Date data_geracao;
    
    // Objetos relacionados
    private Aluno aluno;
    private Turma turma;
    
    // Construtores
    public Certificado() {
        this.data_geracao = new Date();
    }
    
    public Certificado(int p_aluno_id, int p_turma_id, String p_cpf_consulta, Date p_data_emissao) {
        this.aluno_id = p_aluno_id;
        this.turma_id = p_turma_id;
        this.cpf_consulta = p_cpf_consulta;
        this.data_emissao = p_data_emissao;
        this.data_geracao = new Date();
    }
    
    // Métodos Setters
    public void setId(int p_id) {
        this.id = p_id;
    }
    
    public void setAluno_id(int p_aluno_id) {
        this.aluno_id = p_aluno_id;
    }
    
    public void setTurma_id(int p_turma_id) {
        this.turma_id = p_turma_id;
    }
    
    public void setCpf_consulta(String p_cpf_consulta) {
        this.cpf_consulta = p_cpf_consulta;
    }
    
    public void setData_emissao(Date p_data_emissao) {
        this.data_emissao = p_data_emissao;
    }
    
    public void setCaminho_pdf(String p_caminho_pdf) {
        this.caminho_pdf = p_caminho_pdf;
    }
    
    public void setData_geracao(Date p_data_geracao) {
        this.data_geracao = p_data_geracao;
    }
    
    public void setAluno(Aluno p_aluno) {
        this.aluno = p_aluno;
    }
    
    public void setTurma(Turma p_turma) {
        this.turma = p_turma;
    }
    
    // Métodos Getters
    public int getId() {
        return this.id;
    }
    
    public int getAluno_id() {
        return this.aluno_id;
    }
    
    public int getTurma_id() {
        return this.turma_id;
    }
    
    public String getCpf_consulta() {
        return this.cpf_consulta;
    }
    
    public Date getData_emissao() {
        return this.data_emissao;
    }
    
    public String getCaminho_pdf() {
        return this.caminho_pdf;
    }
    
    public Date getData_geracao() {
        return this.data_geracao;
    }
    
    public Aluno getAluno() {
        return this.aluno;
    }
    
    public Turma getTurma() {
        return this.turma;
    }
    
    @Override
    public String toString() {
        return "Certificado{" +
                "id=" + id +
                ", aluno_id=" + aluno_id +
                ", turma_id=" + turma_id +
                ", cpf='" + cpf_consulta + '\'' +
                '}';
    }
}