package controller;

import model.Certificado;
import model.Aluno;
import model.Turma;
import AlunoDAO.CertificadoDAO;
import AlunoDAO.AlunoDAO;
import AlunoDAO.TurmaDAO;
import util.CertificadoGenerator;

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

@WebServlet("/certificado")
public class CertificadoServlet extends HttpServlet {
    
    private CertificadoDAO certificadoDAO;
    private AlunoDAO alunoDAO;
    private TurmaDAO turmaDAO;
    private String diretorioPdf;
    
    @Override
    public void init() throws ServletException {
        super.init();
        certificadoDAO = new CertificadoDAO();
        alunoDAO = new AlunoDAO();
        turmaDAO = new TurmaDAO();
        
        diretorioPdf = getServletContext().getRealPath("/") + "certificados";
        
        java.io.File dir = new java.io.File(diretorioPdf);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        
        System.out.println("CertificadoServlet inicializado!");
        System.out.println("Diretório PDF: " + diretorioPdf);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.equals("form")) {
                exibirFormulario(request, response);
            } else if (action.equals("consultar")) {
                consultarPorCpf(request, response);
            } else if (action.equals("download")) {
                downloadCertificado(request, response);
            } else if (action.equals("list")) {
                listarCertificados(request, response);
            } else if (action.equals("editar")) {
                exibirFormularioEdicao(request, response);
            } else if (action.equals("deletar")) {
                deletarCertificado(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro: " + e.getMessage());
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("gerar".equals(action)) {
                gerarCertificado(request, response);
            } else if ("buscar".equals(action)) {
                buscarPorCpf(request, response);
            } else if ("atualizar".equals(action)) {
                atualizarCertificado(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao processar: " + e.getMessage());
            request.getRequestDispatcher("/certificado-consulta.jsp").forward(request, response);
        }
    }
    
    private void exibirFormulario(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        List<Aluno> alunos = alunoDAO.listarTodos();
        List<Turma> turmas = turmaDAO.listarTodas();
        
        request.setAttribute("alunos", alunos);
        request.setAttribute("turmas", turmas);
        request.getRequestDispatcher("/certificado-gerar.jsp").forward(request, response);
    }
    
    private void gerarCertificado(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int alunoId = Integer.parseInt(request.getParameter("alunoId"));
        int turmaId = Integer.parseInt(request.getParameter("turmaId"));
        String cpfConsulta = request.getParameter("cpf");
        
        System.out.println("Gerando certificado: Aluno=" + alunoId + " Turma=" + turmaId);
        
        Aluno aluno = alunoDAO.buscarPorId(alunoId);
        Turma turma = turmaDAO.buscarPorId(turmaId);
        
        if (aluno == null || turma == null) {
            request.setAttribute("erro", "Aluno ou turma não encontrados!");
            request.getRequestDispatcher("/certificado-gerar.jsp").forward(request, response);
            return;
        }
        
        String cpfLimpo = cpfConsulta.replaceAll("[^0-9]", "");
        String cpfAlunoLimpo = aluno.getCpf().replaceAll("[^0-9]", "");
        
        if (!cpfLimpo.equals(cpfAlunoLimpo)) {
            request.setAttribute("erro", "CPF não confere com o aluno selecionado!");
            request.getRequestDispatcher("/certificado-gerar.jsp").forward(request, response);
            return;
        }
        
        if (certificadoDAO.certificadoExiste(alunoId, turmaId)) {
            request.setAttribute("erro", "Certificado já existe para este aluno nesta turma!");
            request.getRequestDispatcher("/certificado-gerar.jsp").forward(request, response);
            return;
        }
        
        Date dataEmissao = new Date();
        Certificado certificado = new Certificado(alunoId, turmaId, cpfConsulta, dataEmissao);
        
        String caminhoPdf = CertificadoGenerator.gerarCertificado(certificado, aluno, turma, diretorioPdf);
        certificado.setCaminho_pdf(caminhoPdf);
        
        certificadoDAO.inserir(certificado);
        
        System.out.println("✅ Certificado gerado! ID: " + certificado.getId());
        
        response.sendRedirect("certificado?action=consultar&cpf=" + cpfConsulta);
    }
    
    private void buscarPorCpf(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        String cpf = request.getParameter("cpf");
        response.sendRedirect("certificado?action=consultar&cpf=" + cpf);
    }
    
    private void consultarPorCpf(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        String cpf = request.getParameter("cpf");
        
        if (cpf == null || cpf.isEmpty()) {
            request.getRequestDispatcher("/certificado-consulta.jsp").forward(request, response);
            return;
        }
        
        Certificado certificado = certificadoDAO.buscarPorCpf(cpf);
        
        request.setAttribute("cpfBuscado", cpf);
        request.setAttribute("certificado", certificado);
        request.getRequestDispatcher("/certificado-visualizar.jsp").forward(request, response);
    }
    
    private void listarCertificados(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        List<Certificado> certificados = certificadoDAO.listarTodos();
        request.setAttribute("certificados", certificados);
        request.getRequestDispatcher("/lista-certificados.jsp").forward(request, response);
    }
    
    private void exibirFormularioEdicao(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Certificado certificado = certificadoDAO.buscarPorId(id);
        
        if (certificado == null) {
            request.setAttribute("erro", "Certificado não encontrado!");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
            return;
        }
        
        Aluno aluno = alunoDAO.buscarPorId(certificado.getAluno_id());
        Turma turma = turmaDAO.buscarPorId(certificado.getTurma_id());
        
        certificado.setAluno(aluno);
        certificado.setTurma(turma);
        
        request.setAttribute("certificado", certificado);
        request.getRequestDispatcher("/editar-certificado.jsp").forward(request, response);
    }
    
    private void atualizarCertificado(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        Certificado certificado = certificadoDAO.buscarPorId(id);
        
        if (certificado == null) {
            request.setAttribute("erro", "Certificado não encontrado!");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
            return;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        certificado.setData_emissao(sdf.parse(request.getParameter("dataEmissao")));
        certificado.setCpf_consulta(request.getParameter("cpf"));
        
        certificadoDAO.atualizar(certificado);
        
        System.out.println("✅ Certificado atualizado! ID: " + certificado.getId());
        
        response.sendRedirect("certificado?action=list");
    }
    
    private void deletarCertificado(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        System.out.println("Deletando certificado ID: " + id);
        
        Certificado certificado = certificadoDAO.buscarPorId(id);
        
        if (certificado != null) {
            // Deletar arquivo PDF se existir
            if (certificado.getCaminho_pdf() != null && !certificado.getCaminho_pdf().isEmpty()) {
                File pdfFile = new File(certificado.getCaminho_pdf());
                if (pdfFile.exists()) {
                    pdfFile.delete();
                    System.out.println("PDF deletado: " + certificado.getCaminho_pdf());
                }
            }
            
            certificadoDAO.deletar(id);
            System.out.println("✅ Certificado deletado com sucesso!");
        }
        
        response.sendRedirect("certificado?action=list");
    }
    
    private void downloadCertificado(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String cpf = request.getParameter("cpf");
        Certificado certificado = certificadoDAO.buscarPorCpf(cpf);
        
        if (certificado == null || certificado.getCaminho_pdf() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Certificado não encontrado");
            return;
        }
        
        File arquivo = new File(certificado.getCaminho_pdf());
        
        if (!arquivo.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Arquivo não existe");
            return;
        }
        
        response.setContentType("application/pdf");
        response.setContentLength((int) arquivo.length());
        response.setHeader("Content-Disposition", "inline; filename=\"certificado_" + 
                          certificado.getAluno().getNome().replaceAll(" ", "_") + ".pdf\"");
        
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
    }
}