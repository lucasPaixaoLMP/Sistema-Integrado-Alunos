package service;

import AlunoDAO.AlunoDAO;
import model.Aluno;
import com.itextpdf.text.DocumentException;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import util.PDFGenerator;

public class AlunoService {
    
    private final AlunoDAO alunoDAO;
    
    public AlunoService() {
        this.alunoDAO = new AlunoDAO();
    }
    
    public Aluno cadastrarAlunoComContrato(Aluno aluno, String diretorioPdf) 
            throws SQLException, DocumentException, IOException {
        
        // 1. Inserir aluno no banco de dados
        Aluno alunoSalvo = alunoDAO.inserir(aluno);
        
        // 2. Gerar PDF do contrato
        String caminhoArquivoPdf = PDFGenerator.gerarContrato(alunoSalvo, diretorioPdf);
        
        // 3. Atualizar o caminho do PDF no banco de dados
        alunoDAO.atualizarCaminhoPdf(alunoSalvo.getId(), caminhoArquivoPdf);
        alunoSalvo.setCaminho_pdf(caminhoArquivoPdf);  // p minúsculo
          
        return alunoSalvo;
    }
    
    public Aluno buscarPorId(Integer id) throws SQLException {
        return alunoDAO.buscarPorId(id);
    }
    
    public List<Aluno> listarTodos() throws SQLException {
        return alunoDAO.listarTodos();
    }
}