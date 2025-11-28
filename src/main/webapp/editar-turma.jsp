<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if(usuarioLogado == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%@ page import="model.Turma" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Turma</title>
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
            margin-top: 10px;
        }
        .required { color: #f44; }
        .info-box {
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
        <h1>✏️ Editar Turma</h1>
        
        <% 
            Turma turma = (Turma) request.getAttribute("turma");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String codigoTurma = String.format("TRM-%04d", turma.getId());
        %>
        
        <div class="info-box">
            <strong>📌 Código da Turma: <%= codigoTurma %></strong>
        </div>
        
        <form action="turma" method="post">
            <input type="hidden" name="action" value="atualizar">
            <input type="hidden" name="id" value="<%= turma.getId() %>">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="nome">Nome da Turma <span class="required">*</span></label>
                    <input type="text" id="nome" name="nome" value="<%= turma.getNome() %>" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="curso">Curso <span class="required">*</span></label>
                    <input type="text" id="curso" name="curso" value="<%= turma.getCurso() %>" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="cargaHoraria">Carga Horária (horas) <span class="required">*</span></label>
                    <input type="number" id="cargaHoraria" name="cargaHoraria" value="<%= turma.getCarga_horaria() %>" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="turno">Turno <span class="required">*</span></label>
                    <select id="turno" name="turno" required>
                        <option value="Matutino" <%= turma.getTurno().equals("Matutino") ? "selected" : "" %>>Matutino</option>
                        <option value="Vespertino" <%= turma.getTurno().equals("Vespertino") ? "selected" : "" %>>Vespertino</option>
                        <option value="Noturno" <%= turma.getTurno().equals("Noturno") ? "selected" : "" %>>Noturno</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="dataInicio">Data de Início <span class="required">*</span></label>
                    <input type="date" id="dataInicio" name="dataInicio" value="<%= sdf.format(turma.getData_inicio()) %>" required>
                </div>
                
                <div class="form-group">
                    <label for="dataFim">Data de Término <span class="required">*</span></label>
                    <input type="date" id="dataFim" name="dataFim" value="<%= sdf.format(turma.getData_fim()) %>" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="status">Status <span class="required">*</span></label>
                    <select id="status" name="status" required>
                        <option value="Ativa" <%= turma.getStatus().equals("Ativa") ? "selected" : "" %>>Ativa</option>
                        <option value="Concluída" <%= turma.getStatus().equals("Concluída") ? "selected" : "" %>>Concluída</option>
                        <option value="Cancelada" <%= turma.getStatus().equals("Cancelada") ? "selected" : "" %>>Cancelada</option>
                    </select>
                </div>
            </div>
            
            <button type="submit" class="btn btn-submit">💾 Salvar Alterações</button>
            <a href="turma?action=list" class="btn btn-voltar">🔙 Cancelar</a>
        </form>
    </div>
</body>
</html>