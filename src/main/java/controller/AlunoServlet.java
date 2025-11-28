package controller;

import model.Aluno;
import service.AlunoService;
import AlunoDAO.AlunoDAO;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/aluno")
public class AlunoServlet extends HttpServlet {
    
    private AlunoService alunoService;
    private AlunoDAO alunoDAO;
    private String diretorioPdf;
    
    @Override
    public void init() throws ServletException {
        super.init();
        alunoService = new AlunoService();
        alunoDAO = new AlunoDAO();
        
        diretorioPdf = getServletContext().getRealPath("/") + "contratos";
        
        java.io.File dir = new java.io.File(diretorioPdf);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        
        System.out.println("========================================");
        System.out.println("AlunoServlet inicializado!");
        System.out.println("Diretório PDF: " + diretorioPdf);
        System.out.println("========================================");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        System.out.println("doGet chamado! Action: " + action);
        
        try {
            if (action == null || action.equals("list")) {
                listarAlunos(request, response);
            } else if (action.equals("view")) {
                visualizarAluno(request, response);
            } else if (action.equals("download")) {
                downloadPdf(request, response);
            } else if (action.equals("editar")) {
                exibirFormularioEdicao(request, response);
            } else if (action.equals("deletar")) {
                deletarAluno(request, response);
            }
        } catch (Exception e) {
            System.err.println("ERRO no doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao processar requisição: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        System.out.println("doPost chamado - Action: " + action);
        
        try {
            if ("atualizar".equals(action)) {
                atualizarAluno(request, response);
            } else {
                cadastrarAluno(request, response);
            }
        } catch (Exception e) {
            System.err.println("❌ ERRO ao processar: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("erro", "Erro: " + e.getMessage());
            request.getRequestDispatcher("/cadastro.jsp").forward(request, response);
        }
    }
    
    private void cadastrarAluno(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        String rg = request.getParameter("rg");
        String telefone = request.getParameter("telefone");
        String nascStr = request.getParameter("nasc");
        String email = request.getParameter("email");
        String emailRes = request.getParameter("emailRes");
        String nomeRes = request.getParameter("nomeRes");
        String cpfRes = request.getParameter("cpfRes");
        String telefoneRes = request.getParameter("telefoneRes");
        String parentesco = request.getParameter("parentesco");
        
        System.out.println("Recebendo cadastro de: " + nome);
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date nasc = sdf.parse(nascStr);
        
        Aluno aluno = new Aluno(nome, cpf, rg, telefone, nasc, email, 
                                emailRes, nomeRes, cpfRes, telefoneRes, parentesco);
        
        Aluno alunoSalvo = alunoService.cadastrarAlunoComContrato(aluno, diretorioPdf);
        
        System.out.println("✅ Aluno cadastrado! ID: " + alunoSalvo.getId());
        
        request.setAttribute("mensagem", "Aluno cadastrado com sucesso!");
        request.setAttribute("aluno", alunoSalvo);
        request.getRequestDispatcher("/sucesso.jsp").forward(request, response);
    }
    
    private void listarAlunos(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("Listando alunos...");
        
        List<Aluno> alunos = alunoService.listarTodos();
        
        System.out.println("Total de alunos: " + (alunos != null ? alunos.size() : 0));
        
        request.setAttribute("alunos", alunos);
        request.getRequestDispatcher("/lista.jsp").forward(request, response);
    }
    
    private void visualizarAluno(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Aluno aluno = alunoService.buscarPorId(id);
        request.setAttribute("aluno", aluno);
        request.getRequestDispatcher("/visualizar.jsp").forward(request, response);
    }
    
    private void exibirFormularioEdicao(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Aluno aluno = alunoDAO.buscarPorId(id);
        
        if (aluno == null) {
            request.setAttribute("erro", "Aluno não encontrado!");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("aluno", aluno);
        request.getRequestDispatcher("/editar-aluno.jsp").forward(request, response);
    }
    
    private void atualizarAluno(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Buscar aluno existente
        Aluno aluno = alunoDAO.buscarPorId(id);
        
        if (aluno == null) {
            request.setAttribute("erro", "Aluno não encontrado!");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
            return;
        }
        
        // Atualizar dados
        aluno.setNome(request.getParameter("nome"));
        aluno.setCpf(request.getParameter("cpf"));
        aluno.setRg(request.getParameter("rg"));
        aluno.setTelefone(request.getParameter("telefone"));
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        aluno.setNasc(sdf.parse(request.getParameter("nasc")));
        
        aluno.setEmail(request.getParameter("email"));
        aluno.setEmail_res(request.getParameter("emailRes"));
        aluno.setNome_res(request.getParameter("nomeRes"));
        aluno.setCpf_res(request.getParameter("cpfRes"));
        aluno.setTelefone_res(request.getParameter("telefoneRes"));
        aluno.setParentesco(request.getParameter("parentesco"));
        
        alunoDAO.atualizar(aluno);
        
        System.out.println("✅ Aluno atualizado! ID: " + aluno.getId());
        
        response.sendRedirect("aluno?action=list");
    }
    
    private void deletarAluno(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        System.out.println("Deletando aluno ID: " + id);
        
        // Buscar aluno para pegar o caminho do PDF
        Aluno aluno = alunoDAO.buscarPorId(id);
        
        if (aluno != null) {
            // Deletar arquivo PDF se existir
            if (aluno.getCaminho_pdf() != null && !aluno.getCaminho_pdf().isEmpty()) {
                File pdfFile = new File(aluno.getCaminho_pdf());
                if (pdfFile.exists()) {
                    pdfFile.delete();
                    System.out.println("PDF deletado: " + aluno.getCaminho_pdf());
                }
            }
            
            // Deletar do banco
            alunoDAO.deletar(id);
            System.out.println("✅ Aluno deletado com sucesso!");
        }
        
        response.sendRedirect("aluno?action=list");
    }
    
    private void downloadPdf(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("========================================");
        System.out.println("Download PDF solicitado");
        System.out.println("========================================");
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            System.out.println("ID do aluno: " + id);
            
            Aluno aluno = alunoService.buscarPorId(id);
            
            if (aluno == null) {
                System.err.println("❌ Aluno não encontrado!");
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Aluno não encontrado");
                return;
            }
            
            System.out.println("Aluno encontrado: " + aluno.getNome());
            System.out.println("Caminho PDF: " + aluno.getCaminho_pdf());
            
            String caminhoPdf = aluno.getCaminho_pdf();
            
            if (caminhoPdf == null || caminhoPdf.isEmpty()) {
                System.err.println("❌ Caminho do PDF não está registrado!");
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "PDF não encontrado");
                return;
            }
            
            File arquivo = new File(caminhoPdf);
            
            if (!arquivo.exists()) {
                System.err.println("❌ Arquivo não existe: " + caminhoPdf);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Arquivo PDF não existe");
                return;
            }
            
            System.out.println("✅ Arquivo encontrado! Tamanho: " + arquivo.length() + " bytes");
            
            response.setContentType("application/pdf");
            response.setContentLength((int) arquivo.length());
            
            String nomeArquivo = "contrato_" + aluno.getNome().replaceAll(" ", "_") + ".pdf";
            response.setHeader("Content-Disposition", "inline; filename=\"" + nomeArquivo + "\"");
            
            FileInputStream inputStream = new FileInputStream(arquivo);
            ServletOutputStream outputStream = response.getOutputStream();
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            
            inputStream.close();
            outputStream.flush();
            outputStream.close();
            
            System.out.println("✅ PDF enviado com sucesso!");
            
        } catch (Exception e) {
            System.err.println("❌ Erro ao fazer download: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao processar PDF");
        }
    }
}