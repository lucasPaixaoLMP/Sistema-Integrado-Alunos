<%-- 
    Document   : certificado-consulta
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
    <title>Consultar Certificado</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 60px 40px;
            text-align: center;
        }
        .icon {
            font-size: 100px;
            margin-bottom: 20px;
        }
        h1 {
            color: #333;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 40px;
            font-size: 1.1em;
        }
        .form-group {
            margin-bottom: 30px;
            text-align: left;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
            font-size: 1.1em;
        }
        input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1.2em;
            text-align: center;
        }
        input:focus {
            outline: none;
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
        }
        .btn {
            padding: 15px 50px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            margin: 10px;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .btn-secondary {
            background: white;
            color: #4facfe;
            border: 3px solid #4facfe;
        }
        .btn:hover {
            transform: translateY(-3px);
        }
        .opcoes {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e0e0e0;
        }
        .opcao-card {
            flex: 1;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }
        .opcao-card:hover {
            background: #4facfe;
            color: white;
            transform: translateY(-5px);
        }
        .opcao-card .opcao-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
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
        <div class="icon">📜</div>
        <h1>Consultar Certificado</h1>
        <p class="subtitle">Digite o CPF para buscar seu certificado</p>
        
        <% if(request.getAttribute("erro") != null) { %>
            <div class="erro"><strong>Erro:</strong> <%= request.getAttribute("erro") %></div>
        <% } %>
        
        <form action="certificado" method="post">
            <input type="hidden" name="action" value="buscar">
            
            <div class="form-group">
                <label for="cpf">CPF</label>
                <input type="text" 
                       id="cpf" 
                       name="cpf" 
                       placeholder="000.000.000-00" 
                       maxlength="14"
                       required>
            </div>
            
            <button type="submit" class="btn btn-primary">🔍 Buscar Certificado</button>
            <a href="menu.jsp" class="btn btn-secondary">🏠 Voltar</a>
        </form>
        
        <div class="opcoes">
            <a href="certificado?action=form" class="opcao-card">
                <div class="opcao-icon">➕</div>
                <h3>Gerar Novo</h3>
                <p>Criar certificado</p>
            </a>
            
            <a href="certificado?action=list" class="opcao-card">
                <div class="opcao-icon">📋</div>
                <h3>Ver Todos</h3>
                <p>Lista completa</p>
            </a>
        </div>
    </div>
    
    <script>
        document.getElementById('cpf').addEventListener('input', function(e) {
            let v = e.target.value.replace(/\D/g, '');
            if (v.length <= 11) {
                v = v.replace(/(\d{3})(\d)/, '$1.$2');
                v = v.replace(/(\d{3})(\d)/, '$1.$2');
                v = v.replace(/(\d{3})(\d{1,2})$/, '$1-$2');
                e.target.value = v;
            }
        });
    </script>
</body>
</html>