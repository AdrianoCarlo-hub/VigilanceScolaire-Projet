package com.vigilance.vigilance.service;

import com.vigilance.vigilance.dto.AdminDashboardDTO;
import com.vigilance.vigilance.dto.ProfessorDashboardDTO;

public interface DashboardService {
    AdminDashboardDTO getAdminDashboard();
    ProfessorDashboardDTO getProfessorDashboard(Long professeurId);
}