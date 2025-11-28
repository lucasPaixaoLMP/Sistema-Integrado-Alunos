<%-- 
    Document   : cadastro-turma
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
    <title>Cadastrar Turma</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }
        h1 { color: #333; text-align: center; margin-bottom: 30px; }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group { display: flex; flex-direction: column; }
        label { font-weight: 600; margin-bottom: 8px; color: #333; }
        input, select {
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #f5576c;
            box-shadow: 0 0 0 3px rgba(245, 87, 108, 0.1);
        }
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: transform 0.2s;
        }
        .btn-submit {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            width: 100%;
        }
        .btn-submit:hover { transform: translateY(-2px); }
        .btn-voltar {
            background: #6c757d;
            color: white;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .required { color: #f44; }
        .erro {
            background: #fee;
            border-left: 4px solid #f44;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #c33;
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
        <h1>📚 Cadastrar Nova Turma</h1>
        
        <% if(request.getAttribute("erro") != null) { %>
            <div class="erro"><strong>Erro:</strong> <%= request.getAttribute("erro") %></div>
        <% } %>
        
        <form action="turma" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="nome">Nome da Turma <span class="required">*</span></label>
                    <input type="text" id="nome" name="nome" placeholder="Ex: Turma A - 2024" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="curso">Curso <span class="required">*</span></label>
                    <input type="text" id="curso" name="curso" placeholder="Ex: Desenvolvimento Web" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="cargaHoraria">Carga Horária (horas) <span class="required">*</span></label>
                    <input type="number" id="cargaHoraria" name="cargaHoraria" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="turno">Turno <span class="required">*</span></label>
                    <select id="turno" name="turno" required>
                        <option value="">Selecione...</option>
                        <option value="Matutino">Matutino</option>
                        <option value="Vespertino">Vespertino</option>
                        <option value="Noturno">Noturno</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="dataInicio">Data de Início <span class="required">*</span></label>
                    <input type="date" id="dataInicio" name="dataInicio" required>
                </div>
                
                <div class="form-group">
                    <label for="dataFim">Data de Término <span class="required">*</span></label>
                    <input type="date" id="dataFim" name="dataFim" required>
                </div>
            </div>
            
            <button type="submit" class="btn btn-submit">✅ Cadastrar Turma</button>
            <a href="menu.jsp" class="btn btn-voltar">🔙 Voltar</a>
        </form>
    </div>
</body>
</html>