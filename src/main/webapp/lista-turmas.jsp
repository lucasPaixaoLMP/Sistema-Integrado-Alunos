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
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Turmas</title>
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
            border-color: #f5576c;
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
            transition: all 0.2s;
        }
        .btn:hover { transform: translateY(-2px); }
        .btn-primary { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-success { background: #28a745; color: white; padding: 8px 15px; font-size: 0.9em; }
        .btn-edit { background: #ffc107; color: #000; padding: 8px 15px; font-size: 0.85em; }
        .btn-delete { background: #dc3545; color: white; padding: 8px 15px; font-size: 0.85em; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th {
            background: #f5576c;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        tr:hover { background: #f8f9fa; }
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.85em;
            font-weight: 600;
        }
        .badge-ativa { background: #d4edda; color: #155724; }
        .badge-concluida { background: #cce5ff; color: #004085; }
        .codigo-turma {
            font-family: 'Courier New', monospace;
            background: #e3f2fd;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
            color: #1565C0;
        }
        .acoes {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .empty { text-align: center; padding: 40px; color: #666; }
        .info-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .info-box p { margin: 5px 0; color: #856404; }
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
        <h1>📚 Lista de Turmas</h1>
        
        <div class="toolbar">
            <div class="search-box">
                <input type="text" 
                       id="searchInput" 
                       placeholder="🔍 Buscar por Código, Nome ou Curso..." 
                       onkeyup="filtrarTurmas()">
                <span class="search-icon">🔍</span>
            </div>
            <a href="cadastro-turma.jsp" class="btn btn-primary">➕ Nova Turma</a>
            <a href="menu.jsp" class="btn btn-secondary">🏠 Voltar</a>
        </div>
        
        <%
            List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            
            if (turmas != null) {
        %>
            <div class='info-box'>
                <p><strong>✅ Total de turmas: <span id="totalTurmas"><%= turmas.size() %></span></strong></p>
                <p id="resultadoBusca" style="display: none;"></p>
            </div>
        <%
            }
            
            if (turmas != null && !turmas.isEmpty()) {
        %>
        
        <table id="tabelaTurmas">
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Nome</th>
                    <th>Curso</th>
                    <th>Carga Horária</th>
                    <th>Período</th>
                    <th>Turno</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% for (Turma turma : turmas) { 
                    String codigoTurma = String.format("TRM-%04d", turma.getId());
                %>
                <tr class="turma-row"
                    data-codigo="<%= codigoTurma.toLowerCase() %>"
                    data-nome="<%= turma.getNome().toLowerCase() %>"
                    data-curso="<%= turma.getCurso().toLowerCase() %>">
                    <td><span class="codigo-turma"><%= codigoTurma %></span></td>
                    <td><%= turma.getNome() %></td>
                    <td><%= turma.getCurso() %></td>
                    <td><%= turma.getCarga_horaria() %>h</td>
                    <td>
                        <%= sdf.format(turma.getData_inicio()) %> a 
                        <%= sdf.format(turma.getData_fim()) %>
                    </td>
                    <td><%= turma.getTurno() %></td>
                    <td>
                        <span class="badge <%= turma.getStatus().equals("Ativa") ? "badge-ativa" : "badge-concluida" %>">
                            <%= turma.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <div class="acoes">
                            <a href="turma?action=gerenciar&id=<%= turma.getId() %>" 
                               class="btn btn-success"
                               title="Gerenciar Alunos">
                                👥 Alunos
                            </a>
                            <a href="turma?action=editar&id=<%= turma.getId() %>" 
                               class="btn btn-edit"
                               title="Editar Turma">
                                ✏️ Editar
                            </a>
                            <a href="#" 
                               onclick="confirmarExclusao(<%= turma.getId() %>, '<%= turma.getNome() %>')"
                               class="btn btn-delete"
                               title="Excluir Turma">
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
                <h2>📭 Nenhuma turma cadastrada</h2>
                <p>Clique em "Nova Turma" para cadastrar a primeira turma.</p>
            </div>
        <% } %>
    </div>
    
    <script>
        function filtrarTurmas() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const rows = document.querySelectorAll('.turma-row');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const codigo = row.getAttribute('data-codigo');
                const nome = row.getAttribute('data-nome');
                const curso = row.getAttribute('data-curso');
                
                if (codigo.includes(filter) || nome.includes(filter) || curso.includes(filter)) {
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
            if (confirm('⚠️ ATENÇÃO!\n\nTem certeza que deseja excluir a turma:\n\n' + nome + '\n\n⚠️ TODOS OS ALUNOS DESTA TURMA SERÃO REMOVIDOS!\n\nEsta ação NÃO pode ser desfeita!')) {
                window.location.href = 'turma?action=deletar&id=' + id;
            }
        }
    </script>
</body>
</html>