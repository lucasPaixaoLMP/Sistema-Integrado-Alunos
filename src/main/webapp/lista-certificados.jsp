<%-- 
    Document   : lista-certificados
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
<%@ page import="model.Certificado" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Certificados</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            border-color: #4facfe;
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
        .btn-primary { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-pdf { background: #dc3545; color: white; padding: 8px 15px; font-size: 0.9em; }
        .btn-edit { background: #ffc107; color: #000; padding: 8px 15px; font-size: 0.85em; }
        .btn-delete { background: #dc3545; color: white; padding: 8px 15px; font-size: 0.85em; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th {
            background: #4facfe;
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
        .acoes {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .empty { text-align: center; padding: 40px; color: #666; }
        .info-box {
            background: #d1ecf1;
            border-left: 4px solid #17a2b8;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .info-box p { margin: 5px 0; color: #0c5460; }
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
        <h1>📜 Lista de Certificados Emitidos</h1>
        
        <div class="toolbar">
            <div class="search-box">
                <input type="text" 
                       id="searchInput" 
                       placeholder="🔍 Buscar por CPF, Nome ou Turma..." 
                       onkeyup="filtrarCertificados()">
                <span class="search-icon">🔍</span>
            </div>
            <a href="certificado?action=form" class="btn btn-primary">➕ Gerar Novo</a>
            <a href="certificado-consulta.jsp" class="btn btn-secondary">🔍 Consultar</a>
            <a href="menu.jsp" class="btn btn-secondary">🏠 Voltar</a>
        </div>
        
        <%
            List<Certificado> certificados = (List<Certificado>) request.getAttribute("certificados");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            
            if (certificados != null) {
        %>
            <div class='info-box'>
                <p><strong>✅ Total de certificados: <span id="totalCertificados"><%= certificados.size() %></span></strong></p>
                <p id="resultadoBusca" style="display: none;"></p>
            </div>
        <%
            }
            
            if (certificados != null && !certificados.isEmpty()) {
        %>
        
        <table id="tabelaCertificados">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Aluno</th>
                    <th>CPF</th>
                    <th>Turma</th>
                    <th>Data Emissão</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% for (Certificado cert : certificados) { %>
                <tr class="certificado-row"
                    data-cpf="<%= cert.getCpf_consulta() %>"
                    data-nome="<%= cert.getAluno().getNome().toLowerCase() %>"
                    data-turma="<%= cert.getTurma().getNome().toLowerCase() %>">
                    <td><%= cert.getId() %></td>
                    <td><%= cert.getAluno().getNome() %></td>
                    <td><%= cert.getCpf_consulta() %></td>
                    <td><%= cert.getTurma().getNome() %></td>
                    <td><%= sdf.format(cert.getData_emissao()) %></td>
                    <td>
                        <div class="acoes">
                            <a href="certificado?action=download&cpf=<%= cert.getCpf_consulta() %>" 
                               class="btn btn-pdf" 
                               target="_blank"
                               title="Ver PDF">
                                📄 PDF
                            </a>
                            <a href="#" 
                               onclick="confirmarExclusao(<%= cert.getId() %>, '<%= cert.getAluno().getNome() %>')"
                               class="btn btn-delete"
                               title="Excluir Certificado">
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
                <h2>📭 Nenhum certificado emitido</h2>
                <p>Clique em "Gerar Novo" para criar o primeiro certificado.</p>
            </div>
        <% } %>
    </div>
    
    <script>
        function filtrarCertificados() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase().replace(/[^0-9a-z]/g, '');
            const rows = document.querySelectorAll('.certificado-row');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const cpf = row.getAttribute('data-cpf').replace(/[^0-9]/g, '');
                const nome = row.getAttribute('data-nome');
                const turma = row.getAttribute('data-turma');
                
                if (cpf.includes(filter) || nome.includes(filter) || turma.includes(filter)) {
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
            if (confirm('⚠️ ATENÇÃO!\n\nTem certeza que deseja excluir o certificado de:\n\n' + nome + '\n\n⚠️ O arquivo PDF também será excluído!\n\nEsta ação NÃO pode ser desfeita!')) {
                window.location.href = 'certificado?action=deletar&id=' + id;
            }
        }
    </script>
</body>
</html>