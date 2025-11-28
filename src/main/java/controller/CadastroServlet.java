package controller;

import AlunoDAO.UsuarioDAO;
import model.Usuario;
import config.ConectaDB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("cadastro.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        
        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não conferem!");
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
            return;
        }
        
        try (Connection conn = ConectaDB.getConnection()) {
            UsuarioDAO dao = new UsuarioDAO(conn);
            
            if (dao.emailExiste(email)) {
                request.setAttribute("erro", "Email já cadastrado!");
                request.getRequestDispatcher("cadastro.jsp").forward(request, response);
                return;
            }
            
            Usuario usuario = new Usuario(nome, email, senha);
            
            if (dao.cadastrar(usuario)) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?cadastroSucesso=true");
            } else {
                request.setAttribute("erro", "Erro ao cadastrar usuário!");
                request.getRequestDispatcher("cadastro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao processar cadastro!");
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
        }
    }
}
