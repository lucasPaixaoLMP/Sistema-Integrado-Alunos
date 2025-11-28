package AlunoDAO;

import config.ConectaDB;
import model.Certificado;
import model.Aluno;
import model.Turma;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CertificadoDAO {

    public Certificado inserir(Certificado certificado) throws SQLException {
        String sql = "INSERT INTO certificados (aluno_id, turma_id, cpf_consulta, data_emissao, caminho_pdf) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, certificado.getAluno_id());
            stmt.setInt(2, certificado.getTurma_id());
            stmt.setString(3, certificado.getCpf_consulta());
            stmt.setDate(4, new java.sql.Date(certificado.getData_emissao().getTime()));
            stmt.setString(5, certificado.getCaminho_pdf());
            
            System.out.println("Executando INSERT certificado no banco...");
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao inserir certificado.");
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                certificado.setId(rs.getInt(1));
                System.out.println("Certificado inserido com ID: " + certificado.getId());
            }
            
            return certificado;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public Certificado buscarPorCpf(String cpf) throws SQLException {
        String sql = "SELECT c.*, a.nome as aluno_nome, a.cpf as aluno_cpf, " +
                     "t.nome as turma_nome, t.curso, t.carga_horaria " +
                     "FROM certificados c " +
                     "INNER JOIN alunos a ON c.aluno_id = a.id " +
                     "INNER JOIN turmas t ON c.turma_id = t.id " +
                     "WHERE c.cpf_consulta = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, cpf);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearCertificadoCompleto(rs);
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public List<Certificado> listarTodos() throws SQLException {
        String sql = "SELECT c.*, a.nome as aluno_nome, t.nome as turma_nome " +
                     "FROM certificados c " +
                     "INNER JOIN alunos a ON c.aluno_id = a.id " +
                     "INNER JOIN turmas t ON c.turma_id = t.id " +
                     "ORDER BY c.data_geracao DESC";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Certificado> certificados = new ArrayList<>();

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                certificados.add(mapearCertificadoSimples(rs));
            }
            
            return certificados;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public boolean certificadoExiste(int alunoId, int turmaId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM certificados WHERE aluno_id = ? AND turma_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, alunoId);
            stmt.setInt(2, turmaId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
            
            return false;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public Certificado buscarPorId(int id) throws SQLException {
        String sql = "SELECT c.*, a.nome as aluno_nome, a.cpf as aluno_cpf, " +
                     "t.nome as turma_nome, t.curso, t.carga_horaria " +
                     "FROM certificados c " +
                     "INNER JOIN alunos a ON c.aluno_id = a.id " +
                     "INNER JOIN turmas t ON c.turma_id = t.id " +
                     "WHERE c.id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearCertificadoCompleto(rs);
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void atualizar(Certificado certificado) throws SQLException {
        String sql = "UPDATE certificados SET cpf_consulta=?, data_emissao=? WHERE id=?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, certificado.getCpf_consulta());
            stmt.setDate(2, new java.sql.Date(certificado.getData_emissao().getTime()));
            stmt.setInt(3, certificado.getId());
            
            int rows = stmt.executeUpdate();
            System.out.println("Certificado atualizado. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void deletar(int id) throws SQLException {
        String sql = "DELETE FROM certificados WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rows = stmt.executeUpdate();
            System.out.println("Certificado deletado. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private Certificado mapearCertificadoCompleto(ResultSet rs) throws SQLException {
        Certificado cert = new Certificado();
        cert.setId(rs.getInt("id"));
        cert.setAluno_id(rs.getInt("aluno_id"));
        cert.setTurma_id(rs.getInt("turma_id"));
        cert.setCpf_consulta(rs.getString("cpf_consulta"));
        
        java.sql.Date dataEmissao = rs.getDate("data_emissao");
        if (dataEmissao != null) {
            cert.setData_emissao(new Date(dataEmissao.getTime()));
        }
        
        cert.setCaminho_pdf(rs.getString("caminho_pdf"));
        
        Timestamp dataGeracao = rs.getTimestamp("data_geracao");
        if (dataGeracao != null) {
            cert.setData_geracao(new Date(dataGeracao.getTime()));
        }
        
        // Mapear aluno
        Aluno aluno = new Aluno();
        aluno.setId(rs.getInt("aluno_id"));
        aluno.setNome(rs.getString("aluno_nome"));
        aluno.setCpf(rs.getString("aluno_cpf"));
        cert.setAluno(aluno);
        
        // Mapear turma
        Turma turma = new Turma();
        turma.setId(rs.getInt("turma_id"));
        turma.setNome(rs.getString("turma_nome"));
        turma.setCurso(rs.getString("curso"));
        turma.setCarga_horaria(rs.getInt("carga_horaria"));
        cert.setTurma(turma);
        
        return cert;
    }

    private Certificado mapearCertificadoSimples(ResultSet rs) throws SQLException {
        Certificado cert = new Certificado();
        cert.setId(rs.getInt("id"));
        cert.setAluno_id(rs.getInt("aluno_id"));
        cert.setTurma_id(rs.getInt("turma_id"));
        cert.setCpf_consulta(rs.getString("cpf_consulta"));
        
        java.sql.Date dataEmissao = rs.getDate("data_emissao");
        if (dataEmissao != null) {
            cert.setData_emissao(new Date(dataEmissao.getTime()));
        }
        
        cert.setCaminho_pdf(rs.getString("caminho_pdf"));
        
        // Criar objetos simplificados
        Aluno aluno = new Aluno();
        aluno.setId(rs.getInt("aluno_id"));
        aluno.setNome(rs.getString("aluno_nome"));
        cert.setAluno(aluno);
        
        Turma turma = new Turma();
        turma.setId(rs.getInt("turma_id"));
        turma.setNome(rs.getString("turma_nome"));
        cert.setTurma(turma);
        
        return cert;
    }
}