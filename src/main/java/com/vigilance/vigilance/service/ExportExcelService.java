package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.EleveModel;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import java.io.ByteArrayOutputStream;
import java.util.List;

@Service
public class ExportExcelService {

    public byte[] exportElevesToExcel(List<EleveModel> eleves, String classeNom) {
        // Nettoyage du nom de la feuille (max 31 car, pas de caractères spéciaux)
        String safeSheetName = classeNom.replaceAll("[\\\\/?*:\\[\\]]", "_");
        if (safeSheetName.length() > 30) safeSheetName = safeSheetName.substring(0, 30);

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             Workbook workbook = new XSSFWorkbook()) {

            Sheet sheet = workbook.createSheet(safeSheetName);

            // Style d'en-tête
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);

            // En-têtes
            String[] columns = {"Matricule", "Nom", "Prénom", "Sexe", "Date Naissance", "Parent", "Téléphone"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // Remplissage des données
            int rowNum = 1;
            for (EleveModel eleve : eleves) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(eleve.getMatricule());
                row.createCell(1).setCellValue(eleve.getNom());
                row.createCell(2).setCellValue(eleve.getPrenom());
                row.createCell(3).setCellValue(eleve.getSexe());
                row.createCell(4).setCellValue(eleve.getDate_naissance() != null ? eleve.getDate_naissance().toString() : "");

                if (eleve.getParent() != null) {
                    row.createCell(5).setCellValue(eleve.getParent().getNom() + " " + eleve.getParent().getPrenom());
                    row.createCell(6).setCellValue(eleve.getParent().getTelephone());
                }
            }

            // Ajustement automatique des colonnes
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(baos);
            return baos.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
            return new byte[0];
        }
    }
}