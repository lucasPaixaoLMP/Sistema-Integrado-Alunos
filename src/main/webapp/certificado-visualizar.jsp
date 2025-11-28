<%-- 
    Document   : certificado-visualizar
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
<%@ page import="model.Certificado" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificado</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            min-height: 100vh;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 700px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 50px 40px;
            text-align: center;
        }
        .icon {
            font-size: 100px;
            margin-bottom: 20px;
        }
        .icon.success { color: #4caf50; }
        .icon.error { color: #f44336; }
        h1 { color: #333; margin-bottom: 20px; font-size: 2.5em; }
        .certificado-info {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            text-align: left;
        }
        .info-item {
            margin: 15px 0;
            padding: 15px;
            background: white;
            border-radius: 8px;
        }
        .info-item strong {
            color: #4facfe;
            display: block;
            margin-bottom: 5px;
        }
        .btn {
            padding: 15px 40px;
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
        .btn:hover { transform: translateY(-3px); }
        .not-found {
            color: #f44336;
            padding: 30px;
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
        <% 
            Certificado certificado = (Certificado) request.getAttribute("certificado");
            String cpfBuscado = (String) request.getAttribute("cpfBuscado");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            
            if (certificado != null) {
        %>
            <div class="icon success">✅</div>
            <h1>Certificado Encontrado!</h1>
            
            <div class="certificado-info">
                <div class="info-item">
                    <strong>🎓 Aluno</strong>
                    <%= certificado.getAluno().getNome() %>
                </div>
                
                <div class="info-item">
                    <strong>📄 CPF</strong>
                    <%= certificado.getAluno().getCpf() %>
                </div>
                
                <div class="info-item">
                    <strong>📚 Curso</strong>
                    <%= certificado.getTurma().getCurso() %>
                </div>
                
                <div class="info-item">
                    <strong>👥 Turma</strong>
                    <%= certificado.getTurma().getNome() %>
                </div>
                
                <div class="info-item">
                    <strong>⏱️ Carga Horária</strong>
                    <%= certificado.getTurma().getCarga_horaria() %> horas
                </div>
                
                <div class="info-item">
                    <strong>📅 Data de Emissão</strong>
                    <%= sdf.format(certificado.getData_emissao()) %>
                </div>
            </div>
            
            <a href="certificado?action=download&cpf=<%= certificado.getCpf_consulta() %>" 
               class="btn btn-primary" 
               target="_blank">
                📄 Visualizar Certificado PDF
            </a>
            
            <a href="certificado-consulta.jsp" class="btn btn-secondary">
                🔍 Nova Busca
            </a>
            
        <% } else { %>
            <div class="icon error">❌</div>
            <h1>Certificado Não Encontrado</h1>
            
            <div class="not-found">
                <p>Não foi encontrado nenhum certificado para o CPF:</p>
                <h2><%= cpfBuscado %></h2>
                <br>
                <p>Verifique se:</p>
                <ul style="text-align: left; margin: 20px auto; max-width: 400px;">
                    <li>O CPF está correto</li>
                    <li>O aluno já concluiu algum curso</li>
                    <li>O certificado já foi gerado</li>
                </ul>
            </div>
            
            <a href="certificado-consulta.jsp" class="btn btn-secondary">
                🔙 Voltar
            </a>
            
            <a href="certificado?action=form" class="btn btn-primary">
                ➕ Gerar Novo Certificado
            </a>
        <% } %>
    </div>
</body>
</html>