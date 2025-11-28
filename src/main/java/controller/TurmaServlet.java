package controller;

import model.Turma;
import model.Aluno;
import AlunoDAO.TurmaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/turma")
public class TurmaServlet extends HttpServlet {
    
    private TurmaDAO turmaDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        turmaDAO = new TurmaDAO();
        System.out.println("TurmaServlet inicializado!");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.equals("list")) {
                listarTurmas(request, response);
            } else if (action.equals("gerenciar")) {
                gerenciarAlunos(request, response);
            } else if (action.equals("adicionar")) {
                int turmaId = Integer.parseInt(request.getParameter("turmaId"));
                int alunoId = Integer.parseInt(request.getParameter("alunoId"));
                turmaDAO.adicionarAluno(turmaId, alunoId);
                response.sendRedirect("turma?action=gerenciar&id=" + turmaId);
            } else if (action.equals("remover")) {
                int turmaId = Integer.parseInt(request.getParameter("turmaId"));
                int alunoId = Integer.parseInt(request.getParameter("alunoId"));
                turmaDAO.removerAluno(turmaId, alunoId);
                response.sendRedirect("turma?action=gerenciar&id=" + turmaId);
            } else if (action.equals("editar")) {
                exibirFormularioEdicao(request, response);
            } else if (action.equals("deletar")) {
                deletarTurma(request, response);
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
            if ("atualizar".equals(action)) {
                atualizarTurma(request, response);
            } else {
                cadastrarTurma(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao processar: " + e.getMessage());
            request.getRequestDispatcher("/cadastro-turma.jsp").forward(request, response);
        }
    }
    
    private void cadastrarTurma(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String nome = request.getParameter("nome");
        String curso = request.getParameter("curso");
        int cargaHoraria = Integer.parseInt(request.getParameter("cargaHoraria"));
        String turno = request.getParameter("turno");
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dataInicio = sdf.parse(request.getParameter("dataInicio"));
        Date dataFim = sdf.parse(request.getParameter("dataFim"));
        
        Turma turma = new Turma(nome, curso, cargaHoraria, dataInicio, dataFim, turno);
        
        turmaDAO.inserir(turma);
        
        System.out.println("✅ Turma cadastrada! ID: " + turma.getId());
        
        request.setAttribute("mensagem", "Turma cadastrada com sucesso!");
        request.setAttribute("turma", turma);
        request.getRequestDispatcher("/turma-sucesso.jsp").forward(request, response);
    }
    
    private void listarTurmas(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        List<Turma> turmas = turmaDAO.listarTodas();
        request.setAttribute("turmas", turmas);
        request.getRequestDispatcher("/lista-turmas.jsp").forward(request, response);
    }
    
    private void gerenciarAlunos(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int turmaId = Integer.parseInt(request.getParameter("id"));
        
        Turma turma = turmaDAO.buscarPorId(turmaId);
        List<Aluno> alunosDaTurma = turmaDAO.listarAlunosDaTurma(turmaId);
        List<Aluno> alunosDisponiveis = turmaDAO.listarAlunosForaDaTurma(turmaId);
        
        request.setAttribute("turma", turma);
        request.setAttribute("alunosDaTurma", alunosDaTurma);
        request.setAttribute("alunosDisponiveis", alunosDisponiveis);
        request.getRequestDispatcher("/gerenciar-turma.jsp").forward(request, response);
    }
    
    private void exibirFormularioEdicao(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Turma turma = turmaDAO.buscarPorId(id);
        
        if (turma == null) {
            request.setAttribute("erro", "Turma não encontrada!");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("turma", turma);
        request.getRequestDispatcher("/editar-turma.jsp").forward(request, response);
    }
    
    private void atualizarTurma(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        Turma turma = turmaDAO.buscarPorId(id);
        
        if (turma == null) {
            request.setAttribute("erro", "Turma não encontrada!");
            request.getRequestDispatcher("/erro.jsp").forward(request, response);
            return;
        }
        
        turma.setNome(request.getParameter("nome"));
        turma.setCurso(request.getParameter("curso"));
        turma.setCarga_horaria(Integer.parseInt(request.getParameter("cargaHoraria")));
        turma.setTurno(request.getParameter("turno"));
        turma.setStatus(request.getParameter("status"));
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        turma.setData_inicio(sdf.parse(request.getParameter("dataInicio")));
        turma.setData_fim(sdf.parse(request.getParameter("dataFim")));
        
        turmaDAO.atualizar(turma);
        
        System.out.println("✅ Turma atualizada! ID: " + turma.getId());
        
        response.sendRedirect("turma?action=list");
    }
    
    private void deletarTurma(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        System.out.println("Deletando turma ID: " + id);
        
        turmaDAO.deletar(id);
        
        System.out.println("✅ Turma deletada com sucesso!");
        
        response.sendRedirect("turma?action=list");
    }
}