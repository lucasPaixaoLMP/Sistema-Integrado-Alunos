package AlunoDAO;

import config.ConectaDB;
import model.Turma;
import model.Aluno;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TurmaDAO {

    public Turma inserir(Turma turma) throws SQLException {
        String sql = "INSERT INTO turmas (nome, curso, carga_horaria, data_inicio, data_fim, turno, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, turma.getNome());
            stmt.setString(2, turma.getCurso());
            stmt.setInt(3, turma.getCarga_horaria());
            stmt.setDate(4, new java.sql.Date(turma.getData_inicio().getTime()));
            stmt.setDate(5, new java.sql.Date(turma.getData_fim().getTime()));
            stmt.setString(6, turma.getTurno());
            stmt.setString(7, turma.getStatus());
            
            System.out.println("Executando INSERT turma no banco...");
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao inserir turma.");
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                turma.setId(rs.getInt(1));
                System.out.println("Turma inserida com ID: " + turma.getId());
            }
            
            return turma;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public List<Turma> listarTodas() throws SQLException {
        String sql = "SELECT * FROM turmas ORDER BY data_criacao DESC";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Turma> turmas = new ArrayList<>();

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                turmas.add(mapearTurma(rs));
            }
            
            return turmas;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public Turma buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM turmas WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearTurma(rs);
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void adicionarAluno(int turmaId, int alunoId) throws SQLException {
        String sql = "INSERT INTO alunos_turmas (aluno_id, turma_id, status) VALUES (?, ?, 'Ativo')";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, alunoId);
            stmt.setInt(2, turmaId);
            
            stmt.executeUpdate();
            System.out.println("Aluno " + alunoId + " adicionado à turma " + turmaId);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void removerAluno(int turmaId, int alunoId) throws SQLException {
        String sql = "DELETE FROM alunos_turmas WHERE turma_id = ? AND aluno_id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, turmaId);
            stmt.setInt(2, alunoId);
            
            stmt.executeUpdate();
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void atualizar(Turma turma) throws SQLException {
        String sql = "UPDATE turmas SET nome=?, curso=?, carga_horaria=?, data_inicio=?, " +
                     "data_fim=?, turno=?, status=? WHERE id=?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, turma.getNome());
            stmt.setString(2, turma.getCurso());
            stmt.setInt(3, turma.getCarga_horaria());
            stmt.setDate(4, new java.sql.Date(turma.getData_inicio().getTime()));
            stmt.setDate(5, new java.sql.Date(turma.getData_fim().getTime()));
            stmt.setString(6, turma.getTurno());
            stmt.setString(7, turma.getStatus());
            stmt.setInt(8, turma.getId());
            
            int rows = stmt.executeUpdate();
            System.out.println("Turma atualizada. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public void deletar(int id) throws SQLException {
        String sql = "DELETE FROM turmas WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rows = stmt.executeUpdate();
            System.out.println("Turma deletada. Linhas afetadas: " + rows);
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public List<Aluno> listarAlunosDaTurma(int turmaId) throws SQLException {
        String sql = "SELECT a.* FROM alunos a " +
                     "INNER JOIN alunos_turmas at ON a.id = at.aluno_id " +
                     "WHERE at.turma_id = ? ORDER BY a.nome";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Aluno> alunos = new ArrayList<>();
        AlunoDAO alunoDAO = new AlunoDAO();

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, turmaId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                alunos.add(mapearAluno(rs));
            }
            
            return alunos;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public List<Aluno> listarAlunosForaDaTurma(int turmaId) throws SQLException {
        String sql = "SELECT * FROM alunos WHERE id NOT IN " +
                     "(SELECT aluno_id FROM alunos_turmas WHERE turma_id = ?) " +
                     "ORDER BY nome";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Aluno> alunos = new ArrayList<>();

        try {
            conn = ConectaDB.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, turmaId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                alunos.add(mapearAluno(rs));
            }
            
            return alunos;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private Turma mapearTurma(ResultSet rs) throws SQLException {
        Turma turma = new Turma();
        turma.setId(rs.getInt("id"));
        turma.setNome(rs.getString("nome"));
        turma.setCurso(rs.getString("curso"));
        turma.setCarga_horaria(rs.getInt("carga_horaria"));
        
        java.sql.Date dataInicio = rs.getDate("data_inicio");
        if (dataInicio != null) {
            turma.setData_inicio(new Date(dataInicio.getTime()));
        }
        
        java.sql.Date dataFim = rs.getDate("data_fim");
        if (dataFim != null) {
            turma.setData_fim(new Date(dataFim.getTime()));
        }
        
        turma.setTurno(rs.getString("turno"));
        turma.setStatus(rs.getString("status"));
        
        Timestamp dataCriacao = rs.getTimestamp("data_criacao");
        if (dataCriacao != null) {
            turma.setData_criacao(new Date(dataCriacao.getTime()));
        }
        
        return turma;
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
        
        return aluno;
    }
}