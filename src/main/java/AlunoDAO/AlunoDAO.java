package AlunoDAO;

import config.ConectaDB;
import model.Aluno;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AlunoDAO {

    public Aluno inserir(Aluno aluno) throws SQLException {
        String sql = "INSERT INTO alunos (nome, cpf, rg, telefone, nasc, email, " +
                     "email_res, nome_res, cpf_res, telefone_res, parentesco, caminho_pdf) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, aluno.getNome());
            stmt.setString(2, aluno.getCpf());
            stmt.setString(3, aluno.getRg());
            stmt.setString(4, aluno.getTelefone());
            stmt.setDate(5, new java.sql.Date(aluno.getNasc().getTime()));
            stmt.setString(6, aluno.getEmail());
            stmt.setString(7, aluno.getEmail_res());
            stmt.setString(8, aluno.getNome_res());
            stmt.setString(9, aluno.getCpf_res());
            stmt.setString(10, aluno.getTelefone_res());
            stmt.setString(11, aluno.getParentesco());
            stmt.setString(12, aluno.getCaminho_pdf());
            
            System.out.println("Executando INSERT no banco...");
            int affectedRows = stmt.executeUpdate();
            System.out.println("Linhas afetadas: " + affectedRows);
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao inserir aluno, nenhuma linha afetada.");
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                aluno.setId(rs.getInt(1));
                System.out.println("Aluno inserido com ID: " + aluno.getId());
            }
            
            return aluno;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void atualizar(Aluno aluno) throws SQLException {
        String sql = "UPDATE alunos SET nome=?, cpf=?, rg=?, telefone=?, nasc=?, email=?, " +
                     "email_res=?, nome_res=?, cpf_res=?, telefone_res=?, parentesco=? WHERE id=?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, aluno.getNome());
            stmt.setString(2, aluno.getCpf());
            stmt.setString(3, aluno.getRg());
            stmt.setString(4, aluno.getTelefone());
            stmt.setDate(5, new java.sql.Date(aluno.getNasc().getTime()));
            stmt.setString(6, aluno.getEmail());
            stmt.setString(7, aluno.getEmail_res());
            stmt.setString(8, aluno.getNome_res());
            stmt.setString(9, aluno.getCpf_res());
            stmt.setString(10, aluno.getTelefone_res());
            stmt.setString(11, aluno.getParentesco());
            stmt.setInt(12, aluno.getId());
            
            int rows = stmt.executeUpdate();
            System.out.println("Aluno atualizado. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void deletar(int id) throws SQLException {
        String sql = "DELETE FROM alunos WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rows = stmt.executeUpdate();
            System.out.println("Aluno deletado. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void atualizarCaminhoPdf(int id, String caminhoPdf) throws SQLException {
        String sql = "UPDATE alunos SET caminho_pdf = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, caminhoPdf);
            stmt.setInt(2, id);
            
            int rows = stmt.executeUpdate();
            System.out.println("Caminho PDF atualizado. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public Aluno buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM alunos WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearAluno(rs);
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public List<Aluno> listarTodos() throws SQLException {
        String sql = "SELECT * FROM alunos ORDER BY data_matricula DESC";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Aluno> alunos = new ArrayList<>();

        try {
            System.out.println("Buscando todos os alunos no banco...");
            conn = ConectaDB.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            int count = 0;
            while (rs.next()) {
                Aluno aluno = mapearAluno(rs);
                alunos.add(aluno);
                count++;
            }
            
            System.out.println("Total de alunos encontrados: " + count);
            return alunos;
        } catch (SQLException e) {
            System.err.println("ERRO ao listar alunos: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private Aluno mapearAluno(ResultSet rs) throws SQLException {
        Aluno aluno = new Aluno();
        aluno.setId(rs.getInt("id"));
        aluno.setNome(rs.getString("nome"));
        aluno.setCpf(rs.getString("cpf"));
        aluno.setRg(rs.getString("rg"));
        aluno.setTelefone(rs.getString("telefone"));
        
        java.sql.Date nasc = rs.getDate("nasc");
        if (nasc != null) {
            aluno.setNasc(new Date(nasc.getTime()));
        }
        
        aluno.setEmail(rs.getString("email"));
        aluno.setEmail_res(rs.getString("email_res"));
        aluno.setNome_res(rs.getString("nome_res"));
        aluno.setCpf_res(rs.getString("cpf_res"));
        aluno.setTelefone_res(rs.getString("telefone_res"));
        aluno.setParentesco(rs.getString("parentesco"));
        
        Timestamp dataMatricula = rs.getTimestamp("data_matricula");
        if (dataMatricula != null) {
            aluno.setData_matricula(new Date(dataMatricula.getTime()));
        }
        
        aluno.setCaminho_pdf(rs.getString("caminho_pdf"));
        
        return aluno;
    }
}