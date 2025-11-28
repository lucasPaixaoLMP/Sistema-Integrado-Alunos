package controller;

import AlunoDAO.UsuarioDAO;
import model.Usuario;
import config.ConectaDB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        try (Connection conn = ConectaDB.getConnection()) {
            UsuarioDAO dao = new UsuarioDAO(conn);
            Usuario usuario = dao.autenticar(email, senha);
            
            if (usuario != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                response.sendRedirect(request.getContextPath() + "/menu.jsp");
            } else {
                request.setAttribute("erro", "Email ou senha inválidos!");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao processar login!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}