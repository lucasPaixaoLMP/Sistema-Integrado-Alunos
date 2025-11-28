<%-- 
    Document   : navbar
    Created on : 27 de nov. de 2025
    Author     : Lucas Mathias, Carlos Eduardo
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%
    Usuario usuarioNav = (Usuario) session.getAttribute("usuarioLogado");
    String paginaAtual = request.getRequestURI();
%>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        margin: 0;
        padding: 0;
    }
    
    .navbar {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 12px 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        width: 100%;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
    }
    
    body {
        margin: 0;
        padding: 0;
        padding-top: 58px; /* Espaço para o navbar fixo */
    }
    
    .navbar-content {
        max-width: 100%;
        margin: 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 40px;
    }
    
    .navbar-brand {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .navbar-brand h1 {
        font-size: 18px;
        font-weight: 600;
        margin: 0;
    }
    
    .navbar-brand .logo {
        font-size: 22px;
    }
    
    .navbar-menu {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    
    .navbar-menu a {
        color: white;
        text-decoration: none;
        padding: 6px 14px;
        border-radius: 5px;
        transition: all 0.3s;
        font-weight: 500;
        font-size: 14px;
    }
    
    .navbar-menu a:hover {
        background: rgba(255,255,255,0.2);
    }
    
    .navbar-menu a.active {
        background: rgba(255,255,255,0.3);
    }
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .user-avatar {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        background: rgba(255,255,255,0.3);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 15px;
    }
    
    .user-name {
        font-weight: 500;
        font-size: 14px;
    }
    
    .logout-btn {
        background: rgba(255,255,255,0.2);
        color: white;
        padding: 6px 14px;
        border: 2px solid rgba(255,255,255,0.3);
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s;
        font-weight: 600;
        font-size: 13px;
    }
    
    .logout-btn:hover {
        background: rgba(255,255,255,0.3);
        border-color: rgba(255,255,255,0.5);
        transform: translateY(-2px);
    }
    
    /* Menu Mobile */
    .mobile-menu-btn {
        display: none;
        background: none;
        border: none;
        color: white;
        font-size: 24px;
        cursor: pointer;
    }
    
    @media (max-width: 768px) {
        .navbar-content {
            flex-wrap: wrap;
            padding: 0 20px;
        }
        
        .mobile-menu-btn {
            display: block;
        }
        
        .navbar-menu {
            display: none;
            width: 100%;
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
            margin-top: 20px;
        }
        
        .navbar-menu.active {
            display: flex;
        }
        
        .user-info {
            flex-direction: column;
            align-items: flex-start;
            width: 100%;
        }
    }
</style>

<nav class="navbar">
    <div class="navbar-content">
        <div class="navbar-brand">
            <span class="logo">🔐</span>
            <h1>Sistema Login</h1>
        </div>
        
        <button class="mobile-menu-btn" onclick="toggleMenu()">☰</button>
        
        <% if(usuarioNav != null) { %>
            <div class="user-info">
                <div class="user-avatar">
                    <%= usuarioNav.getNome().substring(0, 1).toUpperCase() %>
                </div>
                <span class="user-name"><%= usuarioNav.getNome() %></span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    Sair 🚪
                </a>
            </div>
        <% } else { %>
            <div class="navbar-menu" id="navbarMenu">
                <a href="${pageContext.request.contextPath}/index.jsp" 
                   class="<%= paginaAtual.endsWith("index.jsp") ? "active" : "" %>">
                    Entrar
                </a>
                <a href="${pageContext.request.contextPath}/cadastro.jsp" 
                   class="<%= paginaAtual.endsWith("cadastro.jsp") ? "active" : "" %>">
                    Cadastrar
                </a>
            </div>
        <% } %>
    </div>
</nav>

<script>
    function toggleMenu() {
        const menu = document.getElementById('navbarMenu');
        menu.classList.toggle('active');
    }
</script>