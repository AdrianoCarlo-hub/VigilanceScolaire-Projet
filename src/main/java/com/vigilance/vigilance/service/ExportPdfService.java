package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.EleveModel;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import org.springframework.stereotype.Service;
import java.io.ByteArrayOutputStream;
import java.util.List;

@Service
public class ExportPdfService {

    public byte[] exportElevesToPdf(List<EleveModel> eleves, String classeNom) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            Document document = new Document(PageSize.A4.rotate());
            PdfWriter.getInstance(document, baos);
            document.open();

            // Titre
            Font titleFont = new Font(Font.HELVETICA, 18, Font.BOLD);
            Paragraph title = new Paragraph("Liste des élèves - " + classeNom, titleFont);
            title.setAlignment(Paragraph.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph(" "));

            // Date d'édition
            Font dateFont = new Font(Font.HELVETICA, 10, Font.NORMAL);
            Paragraph date = new Paragraph("Date d'édition: " + new java.util.Date(), dateFont);
            date.setAlignment(Paragraph.ALIGN_RIGHT);
            document.add(date);
            document.add(new Paragraph(" "));

            // Tableau
            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            // En-têtes
            String[] headers = {"ID", "Matricule", "Nom", "Prénom", "Sexe", "Date Naissance", "Parent"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, new Font(Font.HELVETICA, 12, Font.BOLD)));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                table.addCell(cell);
            }

            // Données
            for (EleveModel eleve : eleves) {
                table.addCell(new Phrase(String.valueOf(eleve.getId_eleve() != null ? eleve.getId_eleve() : "")));
                table.addCell(new Phrase(eleve.getMatricule() != null ? eleve.getMatricule() : ""));
                table.addCell(new Phrase(eleve.getNom() != null ? eleve.getNom() : ""));
                table.addCell(new Phrase(eleve.getPrenom() != null ? eleve.getPrenom() : ""));
                table.addCell(new Phrase(eleve.getSexe() != null ? eleve.getSexe() : ""));
                table.addCell(new Phrase(eleve.getDate_naissance() != null ? eleve.getDate_naissance().toString() : ""));

                String parent = eleve.getParent() != null ? eleve.getParent().getNom() + " " + eleve.getParent().getPrenom() : "";
                table.addCell(new Phrase(parent));
            }

            document.add(table);

            // Pied de page
            document.add(new Paragraph(" "));
            document.add(new Paragraph("Total élèves: " + eleves.size(), dateFont));

            document.close();
            return baos.toByteArray();

        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de l'export PDF: " + e.getMessage(), e);
        }
    }
}