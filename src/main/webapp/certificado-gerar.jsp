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
<%@ page import="model.Aluno" %>
<%@ page import="model.Turma" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerar Certificado</title>
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
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }
        select, input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
        }
        select:focus, input:focus {
            outline: none;
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
        }
        .info-box {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 4px solid #4facfe;
        }
        .info-box p {
            color: #1565C0;
            margin: 5px 0;
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
        <h1>📜 Gerar Certificado</h1>
        
        <% if(request.getAttribute("erro") != null) { %>
            <div class="erro"><strong>Erro:</strong> <%= request.getAttribute("erro") %></div>
        <% } %>
        
        <div class="info-box">
            <p><strong>ℹ️ Instruções:</strong></p>
            <p>1. Selecione o aluno</p>
            <p>2. Selecione a turma que o aluno concluiu</p>
            <p>3. Confirme o CPF do aluno</p>
        </div>
        
        <form action="certificado" method="post" id="formCertificado">
            <input type="hidden" name="action" value="gerar">
            
            <div class="form-group">
                <label for="alunoId">Selecione o Aluno <span class="required">*</span></label>
                <select id="alunoId" name="alunoId" required onchange="preencherCpf()">
                    <option value="">-- Selecione --</option>
                    <% 
                        List<Aluno> alunos = (List<Aluno>) request.getAttribute("alunos");
                        if (alunos != null) {
                            for (Aluno aluno : alunos) { 
                    %>
                        <option value="<%= aluno.getId() %>" data-cpf="<%= aluno.getCpf() %>">
                            <%= aluno.getNome() %> - <%= aluno.getCpf() %>
                        </option>
                    <% 
                            }
                        } 
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="turmaId">Selecione a Turma <span class="required">*</span></label>
                <select id="turmaId" name="turmaId" required>
                    <option value="">-- Selecione --</option>
                    <% 
                        List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
                        if (turmas != null) {
                            for (Turma turma : turmas) { 
                    %>
                        <option value="<%= turma.getId() %>">
                            <%= turma.getNome() %> - <%= turma.getCurso() %>
                        </option>
                    <% 
                            }
                        } 
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="cpf">Confirme o CPF do Aluno <span class="required">*</span></label>
                <input type="text" 
                       id="cpf" 
                       name="cpf" 
                       placeholder="000.000.000-00" 
                       maxlength="14"
                       required
                       readonly>
            </div>
            
            <button type="submit" class="btn btn-primary">✅ Gerar Certificado</button>
            <a href="certificado-consulta.jsp" class="btn btn-secondary">🔙 Voltar</a>
        </form>
    </div>
    
    <script>
        function preencherCpf() {
            var select = document.getElementById('alunoId');
            var cpfInput = document.getElementById('cpf');
            var selectedOption = select.options[select.selectedIndex];
            
            if (selectedOption.value) {
                cpfInput.value = selectedOption.getAttribute('data-cpf');
            } else {
                cpfInput.value = '';
            }
        }
        
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