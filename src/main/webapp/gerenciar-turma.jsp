<%-- 
    Document   : gerenciar-turma
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
<%@ page import="java.util.List" %>
<%@ page import="model.Turma" %>
<%@ page import="model.Aluno" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Alunos da Turma</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }
        h1 { color: #333; margin-bottom: 10px; text-align: center; }
        .info-turma {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #f5576c;
        }
        .info-turma h2 { color: #f5576c; margin-bottom: 10px; }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 30px;
        }
        .secao {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }
        .secao h3 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f5576c;
        }
        .aluno-item {
            background: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .aluno-info h4 { color: #333; margin-bottom: 5px; }
        .aluno-info p { color: #666; font-size: 0.9em; }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-add { background: #28a745; color: white; }
        .btn-remove { background: #dc3545; color: white; }
        .btn-voltar { background: #6c757d; color: white; padding: 12px 25px; }
        .btn:hover { opacity: 0.9; }
        .empty { text-align: center; padding: 20px; color: #999; }
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
        <% 
            Turma turma = (Turma) request.getAttribute("turma");
            List<Aluno> alunosDaTurma = (List<Aluno>) request.getAttribute("alunosDaTurma");
            List<Aluno> alunosDisponiveis = (List<Aluno>) request.getAttribute("alunosDisponiveis");
        %>
        
        <h1>👥 Gerenciar Alunos da Turma</h1>
        
        <div class="info-turma">
            <h2><%= turma.getNome() %></h2>
            <p><strong>Curso:</strong> <%= turma.getCurso() %></p>
            <p><strong>Turno:</strong> <%= turma.getTurno() %> | <strong>Carga Horária:</strong> <%= turma.getCarga_horaria() %>h</p>
        </div>
        
        <a href="turma?action=list" class="btn btn-voltar">🔙 Voltar para Lista</a>
        
        <div class="grid">
            <!-- ALUNOS NA TURMA -->
            <div class="secao">
                <h3>✅ Alunos na Turma (<%= alunosDaTurma != null ? alunosDaTurma.size() : 0 %>)</h3>
                
                <% if (alunosDaTurma != null && !alunosDaTurma.isEmpty()) { 
                    for (Aluno aluno : alunosDaTurma) { %>
                    <div class="aluno-item">
                        <div class="aluno-info">
                            <h4><%= aluno.getNome() %></h4>
                            <p>CPF: <%= aluno.getCpf() %> | E-mail: <%= aluno.getEmail() %></p>
                        </div>
                        <a href="turma?action=remover&turmaId=<%= turma.getId() %>&alunoId=<%= aluno.getId() %>" 
                           class="btn btn-remove"
                           onclick="return confirm('Remover <%= aluno.getNome() %> da turma?')">
                            ✖ Remover
                        </a>
                    </div>
                <% } 
                } else { %>
                    <div class="empty">Nenhum aluno na turma</div>
                <% } %>
            </div>
            
            <!-- ALUNOS DISPONÍVEIS -->
            <div class="secao">
                <h3>➕ Alunos Disponíveis (<%= alunosDisponiveis != null ? alunosDisponiveis.size() : 0 %>)</h3>
                
                <% if (alunosDisponiveis != null && !alunosDisponiveis.isEmpty()) { 
                    for (Aluno aluno : alunosDisponiveis) { %>
                    <div class="aluno-item">
                        <div class="aluno-info">
                            <h4><%= aluno.getNome() %></h4>
                            <p>CPF: <%= aluno.getCpf() %> | E-mail: <%= aluno.getEmail() %></p>
                        </div>
                        <a href="turma?action=adicionar&turmaId=<%= turma.getId() %>&alunoId=<%= aluno.getId() %>" 
                           class="btn btn-add">
                            ➕ Adicionar
                        </a>
                    </div>
                <% } 
                } else { %>
                    <div class="empty">Nenhum aluno disponível</div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>