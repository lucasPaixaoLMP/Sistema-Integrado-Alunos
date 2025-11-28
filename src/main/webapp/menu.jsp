<%-- 
    Document   : menu
    Created on : 27 de nov. de 2025
    Author     : Lucas Mathias, Carlos Eduardo
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if(usuarioLogado == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Gestão Acadêmica</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 60px 40px;
        }
        h1 {
            color: #333;
            font-size: 2.5em;
            text-align: center;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #666;
            font-size: 1.2em;
            margin-bottom: 50px;
        }
        .icon {
            font-size: 80px;
            text-align: center;
            margin-bottom: 20px;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }
        .menu-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            color: white;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .menu-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }
        .menu-card .card-icon {
            font-size: 60px;
            margin-bottom: 15px;
        }
        .menu-card h2 {
            font-size: 1.5em;
            margin-bottom: 10px;
        }
        .menu-card p {
            font-size: 0.95em;
            opacity: 0.9;
        }
        .menu-card.alunos { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .menu-card.turmas { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .menu-card.certificados { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .menu-card.relatorios { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .navbar-user {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 15px 20px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 1000;
    }
    
    .navbar-user-content {
        max-width: 1400px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .navbar-user-title {
        font-size: 20px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .navbar-user-info {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    
    .navbar-user-name {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
    }
    
    .navbar-user-name::before {
        content: "👤";
        font-size: 18px;
    }
    
    .navbar-logout-btn {
        background: rgba(255,255,255,0.2);
        color: white;
        padding: 8px 20px;
        border: 2px solid rgba(255,255,255,0.3);
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s;
        font-weight: 500;
        font-size: 14px;
    }
    
    .navbar-logout-btn:hover {
        background: rgba(255,255,255,0.3);
        border-color: rgba(255,255,255,0.5);
        transform: translateY(-2px);
    }
    
    .navbar-logout-btn::before {
        content: "🚪";
    }
    
    @media (max-width: 768px) {
        .navbar-user-content {
            flex-direction: column;
            gap: 15px;
            text-align: center;
        }
        
        .navbar-user-info {
            flex-direction: column;
            gap: 10px;
        }
    }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container">
        <div class="icon">🎓</div>
        <h1>Sistema de Gestão Acadêmica</h1>
        <p class="subtitle">Escolha uma opção para começar</p>
        
        <div class="menu-grid">
            <a href="cadastro-aluno.jsp" class="menu-card alunos">
                <div class="card-icon">👤</div>
                <h2>Alunos</h2>
                <p>Cadastrar novos alunos e gerenciar contratos</p>
            </a>
            
            <a href="turma?action=list" class="menu-card turmas">
                <div class="card-icon">📚</div>
                <h2>Turmas</h2>
                <p>Criar turmas e adicionar alunos</p>
            </a>
            
            <a href="certificado-consulta.jsp" class="menu-card certificados">
                <div class="card-icon">📜</div>
                <h2>Certificados</h2>
                <p>Gerar e consultar certificados</p>
            </a>
            
            <a href="aluno?action=list" class="menu-card relatorios">
                <div class="card-icon">📄</div>
                <h2>Relatórios</h2>
                <p>Visualizar lista de alunos e contratos</p>
            </a>
        </div>
    </div>
</body>
</html>