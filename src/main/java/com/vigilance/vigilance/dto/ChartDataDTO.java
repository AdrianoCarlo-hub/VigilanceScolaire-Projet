package com.vigilance.vigilance.dto;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.Map;

public class ChartDataDTO {
    private List<String> labels;
    private List<Long> data;
    private Map<String, Long> pieData;

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public ChartDataDTO() {}

    public ChartDataDTO(List<String> labels, List<Long> data) {
        this.labels = labels;
        this.data = data;
    }

    // Getters et Setters standards
    public List<String> getLabels() { return labels; }
    public void setLabels(List<String> labels) { this.labels = labels; }
    public List<Long> getData() { return data; }
    public void setData(List<Long> data) { this.data = data; }
    public Map<String, Long> getPieData() { return pieData; }
    public void setPieData(Map<String, Long> pieData) { this.pieData = pieData; }

    // Méthodes pour JSON sécurisé pour JavaScript
    public String getLabelsJson() {
        try {
            if (labels == null || labels.isEmpty()) {
                return "[]";
            }
            return objectMapper.writeValueAsString(labels);
        } catch (JsonProcessingException e) {
            return "[]";
        }
    }

    public String getDataJson() {
        try {
            if (data == null || data.isEmpty()) {
                return "[]";
            }
            return objectMapper.writeValueAsString(data);
        } catch (JsonProcessingException e) {
            return "[]";
        }
    }
}