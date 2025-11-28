<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Turma" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Turma Cadastrada</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            text-align: center;
        }
        .btn:hover { transform: translateY(-2px); }
        .btn-primary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .btn-secondary {
            background: white;
            color: #f5576c;
            border: 2px solid #f5576c;
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
        <h1>Turma Cadastrada com Sucesso!</h1>
        <p class="mensagem"><%= request.getAttribute("mensagem") %></p>
        
        <% 
            Turma turma = (Turma) request.getAttribute("turma");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        %>
        
        <div class="info-box">
            <h3>📋 Dados da Turma</h3>
            <div class="info-item"><strong>ID:</strong> <%= turma.getId() %></div>
            <div class="info-item"><strong>Nome:</strong> <%= turma.getNome() %></div>
            <div class="info-item"><strong>Curso:</strong> <%= turma.getCurso() %></div>
            <div class="info-item"><strong>Carga Horária:</strong> <%= turma.getCarga_horaria() %> horas</div>
            <div class="info-item"><strong>Turno:</strong> <%= turma.getTurno() %></div>
            <div class="info-item">
                <strong>Período:</strong> 
                <%= sdf.format(turma.getData_inicio()) %> a 
                <%= sdf.format(turma.getData_fim()) %>
            </div>
            <div class="info-item"><strong>Status:</strong> <%= turma.getStatus() %></div>
        </div>
        
        <div class="botoes">
            <a href="turma?action=gerenciar&id=<%= turma.getId() %>" class="btn btn-primary">
                👥 Adicionar Alunos
            </a>
            <a href="turma?action=list" class="btn btn-secondary">
                📚 Ver Todas as Turmas
            </a>
        </div>
        
        <div style="margin-top: 15px;">
            <a href="cadastro-turma.jsp" class="btn btn-secondary">
                ➕ Cadastrar Nova Turma
            </a>
        </div>
    </div>
</body>
</html>