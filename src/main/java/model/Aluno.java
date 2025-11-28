package model;

import java.util.Date;

/**
 * Classe que representa um Aluno
 * @author Sistema de Cadastro
 */
public class Aluno {
    
    // Atributos
    private int id;
    private String nome;
    private String cpf;
    private String rg;
    private String telefone;
    private Date nasc;
    private String email;
    private String email_res;
    private String nome_res;
    private String cpf_res;
    private String telefone_res;
    private String parentesco;
    private Date data_matricula;
    private String caminho_pdf;
    
    // Construtores
    public Aluno() {
        this.data_matricula = new Date();
    }
    
    public Aluno(String p_nome, String p_cpf, String p_rg, String p_telefone, 
                 Date p_nasc, String p_email, String p_email_res, String p_nome_res, 
                 String p_cpf_res, String p_telefone_res, String p_parentesco) {
        this.nome = p_nome;
        this.cpf = p_cpf;
        this.rg = p_rg;
        this.telefone = p_telefone;
        this.nasc = p_nasc;
        this.email = p_email;
        this.email_res = p_email_res;
        this.nome_res = p_nome_res;
        this.cpf_res = p_cpf_res;
        this.telefone_res = p_telefone_res;
        this.parentesco = p_parentesco;
        this.data_matricula = new Date();
    }
    
    // Métodos Setters
    public void setId(int p_id) {
        this.id = p_id;
    }
    
    public void setNome(String p_nome) {
        this.nome = p_nome;
    }
    
    public void setCpf(String p_cpf) {
        this.cpf = p_cpf;
    }
    
    public void setRg(String p_rg) {
        this.rg = p_rg;
    }
    
    public void setTelefone(String p_telefone) {
        this.telefone = p_telefone;
    }
    
    public void setNasc(Date p_nasc) {
        this.nasc = p_nasc;
    }
    
    public void setEmail(String p_email) {
        this.email = p_email;
    }
    
    public void setEmail_res(String p_email_res) {
        this.email_res = p_email_res;
    }
    
    public void setNome_res(String p_nome_res) {
        this.nome_res = p_nome_res;
    }
    
    public void setCpf_res(String p_cpf_res) {
        this.cpf_res = p_cpf_res;
    }
    
    public void setTelefone_res(String p_telefone_res) {
        this.telefone_res = p_telefone_res;
    }
    
    public void setParentesco(String p_parentesco) {
        this.parentesco = p_parentesco;
    }
    
    public void setData_matricula(Date p_data_matricula) {
        this.data_matricula = p_data_matricula;
    }
    
    public void setCaminho_pdf(String p_caminho_pdf) {
        this.caminho_pdf = p_caminho_pdf;
    }
    
    // Métodos Getters
    public int getId() {
        return this.id;
    }
    
    public String getNome() {
        return this.nome;
    }
    
    public String getCpf() {
        return this.cpf;
    }
    
    public String getRg() {
        return this.rg;
    }
    
    public String getTelefone() {
        return this.telefone;
    }
    
    public Date getNasc() {
        return this.nasc;
    }
    
    public String getEmail() {
        return this.email;
    }
    
    public String getEmail_res() {
        return this.email_res;
    }
    
    public String getNome_res() {
        return this.nome_res;
    }
    
    public String getCpf_res() {
        return this.cpf_res;
    }
    
    public String getTelefone_res() {
        return this.telefone_res;
    }
    
    public String getParentesco() {
        return this.parentesco;
    }
    
    public Date getData_matricula() {
        if (this.data_matricula == null) {
            this.data_matricula = new Date();
        }
        return this.data_matricula;
    }
    
    public String getCaminho_pdf() {
        return this.caminho_pdf;
    }
    
    @Override
    public String toString() {
        return "Aluno{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", cpf='" + cpf + '\'' +
                ", nome_res='" + nome_res + '\'' +
                '}';
    }
}