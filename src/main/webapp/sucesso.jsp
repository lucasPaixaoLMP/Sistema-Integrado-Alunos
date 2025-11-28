<%-- 
    Document   : sucesso
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
<%@ page import="model.Aluno" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro Realizado</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 600px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
            text-align: center;
        }
        .sucesso-icon {
            font-size: 80px;
            color: #4caf50;
            margin-bottom: 20px;
            animation: scaleIn 0.5s ease;
        }
        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }
        h1 { color: #333; margin-bottom: 15px; font-size: 2em; }
        .mensagem { color: #666; font-size: 1.1em; margin-bottom: 30px; }
        .info-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin: 20px 0;
            border-left: 4px solid #4caf50;
            text-align: left;
        }
        .info-box h3 { color: #333; margin-bottom: 15px; }
        .info-item { margin: 10px 0; color: #555; }
        .info-item strong { color: #333; }
        .pdf-info {
            background: #e8f5e9;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }
        .pdf-info p { color: #2e7d32; font-weight: 600; }
        .botoes { display: flex; gap: 15px; margin-top: 30px; }
        .btn {
            flex: 1;
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s ease;
        }
        .btn:hover { transform: translateY(-2px); }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
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
        <div class="sucesso-icon">✅</div>
        <h1>Cadastro Realizado com Sucesso!</h1>
        <p class="mensagem"><%= request.getAttribute("mensagem") %></p>
        
        <% Aluno aluno = (Aluno) request.getAttribute("aluno"); %>
        
        <div class="info-box">
            <h3>📋 Dados Cadastrados</h3>
            <div class="info-item"><strong>ID:</strong> <%= aluno.getId() %></div>
            <div class="info-item"><strong>Nome:</strong> <%= aluno.getNome() %></div>
            <div class="info-item"><strong>CPF:</strong> <%= aluno.getCpf() %></div>
            <div class="info-item"><strong>E-mail:</strong> <%= aluno.getEmail() %></div>
            <div class="info-item"><strong>Responsável:</strong> <%= aluno.getNome_res() %></div>
        </div>
        
        <div class="pdf-info">
            <p>📄 Contrato em PDF gerado com sucesso!</p>
        </div>
        
        <div class="botoes">
            <a href="cadastro.jsp" class="btn btn-secondary">➕ Novo Cadastro</a>
            <a href="aluno?action=list" class="btn btn-primary">📑 Ver Todos os Alunos</a>
        </div>
    </div>
</body>
</html>