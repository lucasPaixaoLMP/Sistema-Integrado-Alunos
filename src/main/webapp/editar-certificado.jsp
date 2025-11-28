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
    <title>Editar Certificado</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }
        h1 { color: #333; text-align: center; margin-bottom: 30px; }
        .info-box {
            background: #d1ecf1;
            border-left: 4px solid #17a2b8;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 5px;
        }
        .info-box h3 { color: #0c5460; margin-bottom: 15px; }
        .info-item {
            margin: 10px 0;
            padding: 10px;
            background: white;
            border-radius: 5px;
        }
        .info-item strong { color: #17a2b8; }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
        }
        input:focus {
            outline: none;
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
        }
        input:disabled {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            margin-right: 10px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .required { color: #f44; }
        .alert {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #856404;
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
        <h1>✏️ Editar Certificado</h1>
        
        <% 
            Certificado certificado = (Certificado) request.getAttribute("certificado");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
        %>
        
        <div class="info-box">
            <h3>📋 Informações do Certificado</h3>
            <div class="info-item">
                <strong>ID:</strong> <%= certificado.getId() %>
            </div>
            <div class="info-item">
                <strong>Aluno:</strong> <%= certificado.getAluno().getNome() %>
            </div>
            <div class="info-item">
                <strong>Turma:</strong> <%= certificado.getTurma().getNome() %> - <%= certificado.getTurma().getCurso() %>
            </div>
            <div class="info-item">
                <strong>Carga Horária:</strong> <%= certificado.getTurma().getCarga_horaria() %> horas
            </div>
        </div>
        
        <div class="alert">
            <strong>⚠️ Atenção:</strong> Ao alterar a data de emissão, você precisará gerar um novo PDF do certificado.
        </div>
        
        <form action="certificado" method="post">
            <input type="hidden" name="action" value="atualizar">
            <input type="hidden" name="id" value="<%= certificado.getId() %>">
            
            <div class="form-group">
                <label for="cpf">CPF do Aluno <span class="required">*</span></label>
                <input type="text" 
                       id="cpf" 
                       name="cpf" 
                       value="<%= certificado.getCpf_consulta() %>" 
                       placeholder="000.000.000-00"
                       maxlength="14"
                       required>
            </div>
            
            <div class="form-group">
                <label for="dataEmissao">Data de Emissão <span class="required">*</span></label>
                <input type="date" 
                       id="dataEmissao" 
                       name="dataEmissao" 
                       value="<%= sdf.format(certificado.getData_emissao()) %>" 
                       required>
            </div>
            
            <div class="form-group">
                <label>Aluno (não editável)</label>
                <input type="text" 
                       value="<%= certificado.getAluno().getNome() %>" 
                       disabled>
            </div>
            
            <div class="form-group">
                <label>Turma (não editável)</label>
                <input type="text" 
                       value="<%= certificado.getTurma().getNome() %>" 
                       disabled>
            </div>
            
            <button type="submit" class="btn btn-primary">💾 Salvar Alterações</button>
            <a href="certificado?action=list" class="btn btn-secondary">🔙 Cancelar</a>
        </form>
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