<%-- 
    Document   : lista
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
<%@ page import="model.Aluno" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Alunos</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        h1 { color: #333; margin-bottom: 30px; text-align: center; }
        .toolbar {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }
        .search-box {
            flex: 1;
            min-width: 300px;
            position: relative;
        }
        .search-box input {
            width: 100%;
            padding: 12px 45px 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
        }
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
        }
        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2em;
            color: #999;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-size: 0.95em;
            transition: all 0.2s;
        }
        .btn:hover { transform: translateY(-2px); opacity: 0.9; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-edit { background: #ffc107; color: #000; padding: 8px 15px; font-size: 0.85em; }
        .btn-delete { background: #dc3545; color: white; padding: 8px 15px; font-size: 0.85em; }
        .btn-pdf { background: #dc3545; color: white; padding: 8px 15px; font-size: 0.85em; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 0.95em; }
        th {
            background: #667eea;
            color: white;
            padding: 15px 10px;
            text-align: left;
            font-weight: 600;
            font-size: 0.9em;
            position: sticky;
            top: 0;
        }
        td {
            padding: 12px 10px;
            border-bottom: 1px solid #e0e0e0;
        }
        tr:hover { background: #f8f9fa; }
        .acoes {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .empty { text-align: center; padding: 40px; color: #666; }
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .info-box p { margin: 5px 0; color: #1565C0; }
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
        <h1>📚 Lista de Alunos Cadastrados</h1>
        
        <div class="toolbar">
            <div class="search-box">
                <input type="text" 
                       id="searchInput" 
                       placeholder="🔍 Buscar por CPF, Nome ou E-mail..." 
                       onkeyup="filtrarAlunos()">
                <span class="search-icon">🔍</span>
            </div>
            <a href="cadastro-aluno.jsp" class="btn btn-primary">➕ Novo Cadastro</a>
            <a href="menu.jsp" class="btn btn-secondary">🏠 Voltar</a>
        </div>
        
        <%
            List<Aluno> alunos = (List<Aluno>) request.getAttribute("alunos");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            if (alunos != null) {
        %>
            <div class='info-box'>
                <p><strong>✅ Total de alunos: <span id="totalAlunos"><%= alunos.size() %></span></strong></p>
                <p id="resultadoBusca" style="display: none;"></p>
            </div>
        <%
            }
            
            if (alunos != null && !alunos.isEmpty()) {
        %>
        
        <table id="tabelaAlunos">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>CPF</th>
                    <th>E-mail</th>
                    <th>Responsável</th>
                    <th>Data Matrícula</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    for (Aluno aluno : alunos) { 
                %>
                <tr class="aluno-row" 
                    data-cpf="<%= aluno.getCpf() %>"
                    data-nome="<%= aluno.getNome().toLowerCase() %>"
                    data-email="<%= aluno.getEmail().toLowerCase() %>">
                    <td><%= aluno.getId() %></td>
                    <td><%= aluno.getNome() %></td>
                    <td><%= aluno.getCpf() %></td>
                    <td><%= aluno.getEmail() %></td>
                    <td><%= aluno.getNome_res() %></td>
                    <td>
                        <%= aluno.getData_matricula() != null ? sdf.format(aluno.getData_matricula()) : "N/A" %>
                    </td>
                    <td>
                        <div class="acoes">
                            <% if (aluno.getCaminho_pdf() != null && !aluno.getCaminho_pdf().isEmpty()) { %>
                                <a href="aluno?action=download&id=<%= aluno.getId() %>" 
                                   class="btn btn-pdf" 
                                   target="_blank"
                                   title="Ver Contrato PDF">
                                    📄 PDF
                                </a>
                            <% } %>
                            <a href="aluno?action=editar&id=<%= aluno.getId() %>" 
                               class="btn btn-edit"
                               title="Editar Aluno">
                                ✏️ Editar
                            </a>
                            <a href="#" 
                               onclick="confirmarExclusao(<%= aluno.getId() %>, '<%= aluno.getNome() %>')"
                               class="btn btn-delete"
                               title="Excluir Aluno">
                                🗑️ Apagar
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <% } else { %>
            <div class="empty">
                <h2>📭 Nenhum aluno cadastrado</h2>
                <p>Clique em "Novo Cadastro" para adicionar o primeiro aluno.</p>
            </div>
        <% } %>
    </div>
    
    <script>
        function filtrarAlunos() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase().replace(/[^0-9a-z@.]/g, '');
            const rows = document.querySelectorAll('.aluno-row');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const cpf = row.getAttribute('data-cpf').replace(/[^0-9]/g, '');
                const nome = row.getAttribute('data-nome');
                const email = row.getAttribute('data-email');
                
                if (cpf.includes(filter) || nome.includes(filter) || email.includes(filter)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            const resultadoBusca = document.getElementById('resultadoBusca');
            if (filter) {
                resultadoBusca.style.display = 'block';
                resultadoBusca.innerHTML = '<strong>🔍 Mostrando ' + visibleCount + ' resultado(s) da busca</strong>';
            } else {
                resultadoBusca.style.display = 'none';
            }
        }
        
        function confirmarExclusao(id, nome) {
            if (confirm('⚠️ ATENÇÃO!\n\nTem certeza que deseja excluir o aluno:\n\n' + nome + '\n\nEsta ação NÃO pode ser desfeita!')) {
                window.location.href = 'aluno?action=deletar&id=' + id;
            }
        }
    </script>
</body>
</html>