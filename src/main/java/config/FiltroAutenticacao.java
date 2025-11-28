package config;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter("/*")
public class FiltroAutenticacao implements Filter {
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        
        String uri = request.getRequestURI();
        
        // Páginas públicas que não precisam de autenticação
        boolean paginaPublica = uri.endsWith("index.jsp") || 
                                uri.endsWith("cadastro.jsp") ||
                                uri.endsWith("/login") ||
                                uri.endsWith("/cadastro") ||
                                uri.contains("/css/") ||
                                uri.contains("/js/") ||
                                uri.contains("/images/") ||
                                uri.contains("/fonts/") ||
                                uri.equals(request.getContextPath() + "/") ||
                                uri.equals(request.getContextPath()) ||
                                uri.contains("cadastro");
        
        boolean usuarioLogado = (session != null && session.getAttribute("usuarioLogado") != null);
        
        if (paginaPublica || usuarioLogado) {
            chain.doFilter(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
    
    @Override
    public void init(FilterConfig config) throws ServletException {}
    
    @Override
    public void destroy() {}
}