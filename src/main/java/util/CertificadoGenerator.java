package util;

import model.Aluno;
import model.Turma;
import model.Certificado;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;

public class CertificadoGenerator {
    
    private static final Font FONT_TITLE = new Font(Font.FontFamily.HELVETICA, 28, Font.BOLD);
    private static final Font FONT_NORMAL = new Font(Font.FontFamily.HELVETICA, 14, Font.NORMAL);
    private static final Font FONT_LARGE = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);

    public static String gerarCertificado(Certificado certificado, Aluno aluno, Turma turma, String diretorioPdf) 
            throws DocumentException, IOException {
        
        String nomeArquivo = "certificado_" + aluno.getCpf().replaceAll("[^0-9]", "") + "_" + 
                             turma.getId() + ".pdf";
        String caminhoCompleto = diretorioPdf + "/" + nomeArquivo;
        
        // Documento A4 horizontal (paisagem)
        Document document = new Document(PageSize.A4.rotate(), 50, 50, 50, 50);
        PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(caminhoCompleto));
        
        document.open();
        
        // Adicionar bordas decorativas
        adicionarBorda(writer, document);
        
        // Espaçamento inicial
        document.add(new Paragraph("\n\n"));
        
        // Título CERTIFICADO
        Paragraph titulo = new Paragraph("CERTIFICADO", FONT_TITLE);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingAfter(30);
        document.add(titulo);
        
        // Texto de certificação
        Paragraph texto1 = new Paragraph("Certificamos que", FONT_NORMAL);
        texto1.setAlignment(Element.ALIGN_CENTER);
        document.add(texto1);
        
        document.add(new Paragraph("\n"));
        
        // Nome do aluno em destaque
        Paragraph nomeAluno = new Paragraph(aluno.getNome().toUpperCase(), FONT_LARGE);
        nomeAluno.setAlignment(Element.ALIGN_CENTER);
        document.add(nomeAluno);
        
        document.add(new Paragraph("\n"));
        
        // CPF
        Paragraph cpf = new Paragraph("CPF: " + aluno.getCpf(), FONT_NORMAL);
        cpf.setAlignment(Element.ALIGN_CENTER);
        document.add(cpf);
        
        document.add(new Paragraph("\n"));
        
        // Texto do curso
        String textoCurso = "concluiu com êxito o curso de " + turma.getCurso() + 
                           ", turma " + turma.getNome() + ", com carga horária de " + 
                           turma.getCarga_horaria() + " horas, no período " + turma.getTurno() + ".";
        
        Paragraph curso = new Paragraph(textoCurso, FONT_NORMAL);
        curso.setAlignment(Element.ALIGN_CENTER);
        document.add(curso);
        
        document.add(new Paragraph("\n\n"));
        
        // Data de emissão
        SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy");
        String dataFormatada = sdf.format(certificado.getData_emissao());
        
        Paragraph data = new Paragraph("São Paulo, " + dataFormatada, FONT_NORMAL);
        data.setAlignment(Element.ALIGN_CENTER);
        document.add(data);
        
        document.add(new Paragraph("\n\n\n"));
        
        // Assinatura
        PdfPTable assinatura = new PdfPTable(1);
        assinatura.setWidthPercentage(40);
        assinatura.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.TOP);
        cell.setBorderWidthTop(1);
        cell.setPaddingTop(5);
        
        Paragraph diretor = new Paragraph("Direção Acadêmica\nInstituto Educacional Exemplo", FONT_NORMAL);
        diretor.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(diretor);
        
        assinatura.addCell(cell);
        document.add(assinatura);
        
        document.close();
        
        return caminhoCompleto;
    }

    private static void adicionarBorda(PdfWriter writer, Document document) {
        PdfContentByte canvas = writer.getDirectContent();
        Rectangle page = document.getPageSize();
        
        // Borda externa (azul)
        canvas.setLineWidth(3);
        canvas.setColorStroke(new BaseColor(102, 126, 234));
        canvas.rectangle(30, 30, page.getWidth() - 60, page.getHeight() - 60);
        canvas.stroke();
        
        // Borda interna (fina)
        canvas.setLineWidth(1);
        canvas.rectangle(35, 35, page.getWidth() - 70, page.getHeight() - 70);
        canvas.stroke();
    }
}