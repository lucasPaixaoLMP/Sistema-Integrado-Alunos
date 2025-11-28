<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Aluno</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }
        h1 { color: #333; text-align: center; margin-bottom: 10px; font-size: 2em; }
        .subtitle { text-align: center; color: #666; margin-bottom: 30px; }
        .secao {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .secao h2 { color: #667eea; margin-bottom: 20px; font-size: 1.3em; }
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 15px;
        }
        .form-group { display: flex; flex-direction: column; }
        label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
            font-size: 0.95em;
        }
        input, select {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
            transition: transform 0.2s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-back {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
            transition: transform 0.2s ease;
        }
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-ancora {
            color: white;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .erro {
            background: #fee;
            border-left: 4px solid #f44;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #c33;
        }
        .required { color: #f44; }
        
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
        <h1>📚 Cadastro de Aluno</h1>
        <p class="subtitle">Preencha todos os campos para gerar o contrato</p>
        
        <% if(request.getAttribute("erro") != null) { %>
            <div class="erro"><strong>Erro:</strong> <%= request.getAttribute("erro") %></div>
        <% } %>
        
        <form action="aluno" method="post">
            <div class="secao">
                <h2>👤 Dados do Aluno</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label for="nome">Nome Completo <span class="required">*</span></label>
                        <input type="text" id="nome" name="nome" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="cpf">CPF <span class="required">*</span></label>
                        <input type="text" id="cpf" name="cpf" placeholder="000.000.000-00" required>
                    </div>
                    <div class="form-group">
                        <label for="rg">RG <span class="required">*</span></label>
                        <input type="text" id="rg" name="rg" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="nasc">Data de Nascimento <span class="required">*</span></label>
                        <input type="date" id="nasc" name="nasc" required>
                    </div>
                    <div class="form-group">
                        <label for="telefone">Telefone <span class="required">*</span></label>
                        <input type="tel" id="telefone" name="telefone" placeholder="(00) 00000-0000" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">E-mail <span class="required">*</span></label>
                        <input type="email" id="email" name="email" required>
                    </div>
                </div>
            </div>
            
            <div class="secao">
                <h2>👨‍👩‍👧 Dados do Responsável Legal</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label for="nomeRes">Nome do Responsável <span class="required">*</span></label>
                        <input type="text" id="nomeRes" name="nomeRes" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="cpfRes">CPF do Responsável <span class="required">*</span></label>
                        <input type="text" id="cpfRes" name="cpfRes" placeholder="000.000.000-00" required>
                    </div>
                    <div class="form-group">
                        <label for="parentesco">Parentesco <span class="required">*</span></label>
                        <select id="parentesco" name="parentesco" required>
                            <option value="">Selecione...</option>
                            <option value="Pai">Pai</option>
                            <option value="Mãe">Mãe</option>
                            <option value="Avô">Avô</option>
                            <option value="Avó">Avó</option>
                            <option value="Tio">Tio</option>
                            <option value="Tia">Tia</option>
                            <option value="Tutor Legal">Tutor Legal</option>
                            <option value="Outro">Outro</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="telefoneRes">Telefone do Responsável <span class="required">*</span></label>
                        <input type="tel" id="telefoneRes" name="telefoneRes" placeholder="(00) 00000-0000" required>
                    </div>
                    <div class="form-group">
                        <label for="emailRes">E-mail do Responsável <span class="required">*</span></label>
                        <input type="email" id="emailRes" name="emailRes" required>
                    </div>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">📄 Cadastrar e Gerar Contrato</button>
            <button class="btn-back">
                <a href="menu.jsp" class="btn-ancora">🏠 Voltar</a>
            </button>
            
        </form>
    </div>
    
    <script>
        // Máscara para CPF
        function mascaraCPF(input) {
            input.addEventListener('input', function(e) {
                let v = e.target.value.replace(/\D/g, '');
                if (v.length <= 11) {
                    v = v.replace(/(\d{3})(\d)/, '$1.$2');
                    v = v.replace(/(\d{3})(\d)/, '$1.$2');
                    v = v.replace(/(\d{3})(\d{1,2})$/, '$1-$2');
                    e.target.value = v;
                }
            });
        }
        
        mascaraCPF(document.getElementById('cpf'));
        mascaraCPF(document.getElementById('cpfRes'));
        
        // Máscara para Telefone
        function mascaraTelefone(input) {
            input.addEventListener('input', function(e) {
                let v = e.target.value.replace(/\D/g, '');
                if (v.length <= 11) {
                    if (v.length > 10) {
                        v = v.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
                    } else if (v.length > 6) {
                        v = v.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
                    } else if (v.length > 2) {
                        v = v.replace(/(\d{2})(\d{0,5})/, '($1) $2');
                    } else {
                        v = v.replace(/(\d*)/, '($1');
                    }
                    e.target.value = v;
                }
            });
        }
        
        mascaraTelefone(document.getElementById('telefone'));
        mascaraTelefone(document.getElementById('telefoneRes'));
    </script>
</body>
</html>