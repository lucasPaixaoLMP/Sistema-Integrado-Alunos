package util;


import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

import java.io.FileOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import model.Aluno;

public class PDFGenerator {
    
    private static final Font FONT_TITLE = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
    private static final Font FONT_SUBTITLE = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
    private static final Font FONT_NORMAL = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
    private static final Font FONT_SMALL = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC);

    public static String gerarContrato(Aluno aluno, String diretorioPdf) throws DocumentException, IOException {
        String nomeArquivo = "contrato_" + aluno.getCpf().replaceAll("[^0-9]", "") + ".pdf";
        String caminhoCompleto = diretorioPdf + "/" + nomeArquivo;
        
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        PdfWriter.getInstance(document, new FileOutputStream(caminhoCompleto));
        
        document.open();
        
        adicionarCabecalho(document);
        
        Paragraph titulo = new Paragraph("CONTRATO DE PRESTAÇÃO DE SERVIÇOS EDUCACIONAIS", FONT_TITLE);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingAfter(20);
        document.add(titulo);
        
        adicionarDadosInstituicao(document);
        adicionarDadosAluno(document, aluno);
        adicionarDadosResponsavel(document, aluno);
        adicionarClausulas(document, aluno);
        adicionarAssinaturas(document, aluno);
        adicionarRodape(document);
        
        document.close();
        
        return caminhoCompleto;
    }

    private static void adicionarCabecalho(Document document) throws DocumentException {
        Paragraph instituicao = new Paragraph("INSTITUTO EDUCACIONAL EXEMPLO", FONT_SUBTITLE);
        instituicao.setAlignment(Element.ALIGN_CENTER);
        document.add(instituicao);
        
        Paragraph cnpj = new Paragraph("CNPJ: 12.345.678/0001-90", FONT_SMALL);
        cnpj.setAlignment(Element.ALIGN_CENTER);
        cnpj.setSpacingAfter(10);
        document.add(cnpj);
        
        LineSeparator line = new LineSeparator();
        document.add(new Chunk(line));
        document.add(Chunk.NEWLINE);
    }

    private static void adicionarDadosInstituicao(Document document) throws DocumentException {
        Paragraph qualificacao = new Paragraph("CONTRATANTE:", FONT_SUBTITLE);
        qualificacao.setSpacingBefore(10);
        document.add(qualificacao);
        
        document.add(new Paragraph("Instituto Educacional Exemplo Ltda, pessoa jurídica de direito privado, " +
                "inscrita no CNPJ sob nº 12.345.678/0001-90, com sede na Rua Exemplo, 123, Centro, " +
                "São Paulo-SP, CEP 01234-567.", FONT_NORMAL));
        document.add(Chunk.NEWLINE);
    }

    private static void adicionarDadosAluno(Document document, Aluno aluno) throws DocumentException {
        Paragraph contratado = new Paragraph("CONTRATADO (ALUNO):", FONT_SUBTITLE);
        document.add(contratado);
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        table.setSpacingAfter(15);
        
        try {
            table.setWidths(new float[]{1, 2});
        } catch (DocumentException e) {
        }
        
        adicionarCelula(table, "Nome:", true);
        adicionarCelula(table, aluno.getNome(), false);
        
        adicionarCelula(table, "CPF:", true);
        adicionarCelula(table, aluno.getCpf(), false);
        
        adicionarCelula(table, "RG:", true);
        adicionarCelula(table, aluno.getRg(), false);
        
        adicionarCelula(table, "Data de Nascimento:", true);
        String dataNascStr = aluno.getNasc() != null 
        ? aluno.getNasc().toInstant()
        .atZone(java.time.ZoneId.systemDefault())
        .toLocalDate()
        .format(formatter)
        : "Não informado";
        adicionarCelula(table, dataNascStr, false);
        
        adicionarCelula(table, "Telefone:", true);
        adicionarCelula(table, aluno.getTelefone(), false);
        
        adicionarCelula(table, "E-mail:", true);
        adicionarCelula(table, aluno.getEmail(), false);
        
        document.add(table);
    }
        
    private static void adicionarDadosResponsavel(Document document, Aluno aluno) throws DocumentException {
        Paragraph responsavel = new Paragraph("RESPONSÁVEL LEGAL:", FONT_SUBTITLE);
        document.add(responsavel);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        table.setSpacingAfter(15);
        
        try {
            table.setWidths(new float[]{1, 2});
        } catch (DocumentException e) {
        }
        
        adicionarCelula(table, "Nome do Responsável:", true);
        adicionarCelula(table, aluno.getNome_res(), false);
        
        adicionarCelula(table, "Parentesco:", true);
        adicionarCelula(table, aluno.getParentesco(), false);
        
        adicionarCelula(table, "Telefone:", true);
        adicionarCelula(table, aluno.getTelefone_res(), false);
        
        adicionarCelula(table, "E-mail:", true);
        adicionarCelula(table, aluno.getEmail_res(), false);
        
        document.add(table);
    }

    private static void adicionarClausulas(Document document, Aluno aluno) throws DocumentException {
        Paragraph clausulasTitulo = new Paragraph("CLÁUSULAS CONTRATUAIS", FONT_SUBTITLE);
        clausulasTitulo.setSpacingBefore(15);
        document.add(clausulasTitulo);
        
        document.add(Chunk.NEWLINE);
        
        Paragraph clausula1 = new Paragraph("CLÁUSULA PRIMEIRA - DO OBJETO", FONT_SUBTITLE);
        clausula1.setFont(new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        document.add(clausula1);
        document.add(new Paragraph("O presente contrato tem por objeto a prestação de serviços educacionais " +
                "pela CONTRATANTE ao CONTRATADO, conforme as normas vigentes e o regimento interno da instituição.", 
                FONT_NORMAL));
        document.add(Chunk.NEWLINE);
        
        Paragraph clausula2 = new Paragraph("CLÁUSULA SEGUNDA - DAS OBRIGAÇÕES DA CONTRATANTE", FONT_SUBTITLE);
        clausula2.setFont(new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        document.add(clausula2);
        document.add(new Paragraph("A CONTRATANTE compromete-se a fornecer ensino de qualidade, " +
                "infraestrutura adequada e corpo docente qualificado para o desenvolvimento educacional do aluno.", 
                FONT_NORMAL));
        document.add(Chunk.NEWLINE);
        
        Paragraph clausula3 = new Paragraph("CLÁUSULA TERCEIRA - DAS OBRIGAÇÕES DO CONTRATADO", FONT_SUBTITLE);
        clausula3.setFont(new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        document.add(clausula3);
        document.add(new Paragraph("O CONTRATADO ou seu RESPONSÁVEL LEGAL compromete-se a cumprir " +
                "as normas regimentais da instituição, frequentar as aulas regularmente e efetuar os pagamentos " +
                "nas datas estabelecidas.", FONT_NORMAL));
        document.add(Chunk.NEWLINE);
        
        Paragraph clausula4 = new Paragraph("CLÁUSULA QUARTA - DA VIGÊNCIA", FONT_SUBTITLE);
        clausula4.setFont(new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
        document.add(clausula4);
        
        // CORREÇÃO: Verificar se dataMatricula não é null
        // CORREÇÃO: Verificar se dataMatricula não é null
        // CORREÇÃO: Verificar se dataMatricula não é null
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String dataMatriculaStr;

        if (aluno.getData_matricula() != null) {
            // Converter Date para LocalDate
            java.time.LocalDate localDate = aluno.getData_matricula().toInstant()
                    .atZone(java.time.ZoneId.systemDefault())
                    .toLocalDate();
            dataMatriculaStr = localDate.format(formatter);
        } else {
            // Se for null, usar a data atual
            dataMatriculaStr = java.time.LocalDate.now().format(formatter);
        }
        
        document.add(new Paragraph("O presente contrato tem vigência de 12 (doze) meses, " +
                "iniciando-se na data de " + dataMatriculaStr + 
                ", podendo ser renovado mediante acordo entre as partes.", FONT_NORMAL));
    }

    private static void adicionarAssinaturas(Document document, Aluno aluno) throws DocumentException {
        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String dataAtual = java.time.LocalDate.now().format(formatter);
        
        Paragraph local = new Paragraph("São Paulo, " + dataAtual, FONT_NORMAL);
        local.setAlignment(Element.ALIGN_CENTER);
        document.add(local);
        
        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);
        
        PdfPTable assinaturas = new PdfPTable(2);
        assinaturas.setWidthPercentage(100);
        assinaturas.setSpacingBefore(30);
        
        PdfPCell cellContratante = new PdfPCell();
        cellContratante.setBorder(Rectangle.NO_BORDER);
        Paragraph assinaturaContratante = new Paragraph();
        assinaturaContratante.add(new Chunk("_______________________________\n", FONT_NORMAL));
        assinaturaContratante.add(new Chunk("CONTRATANTE\n", FONT_NORMAL));
        assinaturaContratante.add(new Chunk("Instituto Educacional Exemplo", FONT_SMALL));
        assinaturaContratante.setAlignment(Element.ALIGN_CENTER);
        cellContratante.addElement(assinaturaContratante);
        assinaturas.addCell(cellContratante);
        
        PdfPCell cellContratado = new PdfPCell();
        cellContratado.setBorder(Rectangle.NO_BORDER);
        Paragraph assinaturaContratado = new Paragraph();
        assinaturaContratado.add(new Chunk("_______________________________\n", FONT_NORMAL));
        assinaturaContratado.add(new Chunk("RESPONSÁVEL LEGAL\n", FONT_NORMAL));
        assinaturaContratado.add(new Chunk(aluno.getNome_res(), FONT_SMALL));
        assinaturaContratado.setAlignment(Element.ALIGN_CENTER);
        cellContratado.addElement(assinaturaContratado);
        assinaturas.addCell(cellContratado);
        
        document.add(assinaturas);
    }

    private static void adicionarRodape(Document document) throws DocumentException {
        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);
        
        Paragraph rodape = new Paragraph("Contrato gerado eletronicamente em " + 
                java.time.LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")), 
                FONT_SMALL);
        rodape.setAlignment(Element.ALIGN_CENTER);
        document.add(rodape);
    }

    private static void adicionarCelula(PdfPTable table, String texto, boolean negrito) {
        Font font = negrito ? new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD) : FONT_NORMAL;
        PdfPCell cell = new PdfPCell(new Phrase(texto, font));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPaddingBottom(5);
        table.addCell(cell);
    }
}
    