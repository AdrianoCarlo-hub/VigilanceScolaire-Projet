<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Vigilance Scolaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%); font-family: 'Segoe UI', sans-serif; min-height: 100vh; }
        .main-wrapper { display: flex; min-height: 100vh; }
        .sidebar-fixed { width: 260px; position: fixed; left: 0; top: 0; height: 100vh; z-index: 100; }
        .content-wrapper { flex: 1; margin-left: 260px; padding: 20px; }
        .dashboard-container { background: rgba(255,255,255,0.05); border-radius: 20px; padding: 25px; backdrop-filter: blur(10px); }
        .dashboard-header { background: rgba(255,255,255,0.08); border-radius: 20px; padding: 20px 30px; margin-bottom: 30px; border: 1px solid rgba(255,255,255,0.1); }
        .dashboard-header h1 { font-size: 28px; font-weight: 700; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin: 0; }
        .stat-card { background: rgba(255,255,255,0.08); border-radius: 20px; padding: 25px; text-align: center; transition: transform 0.3s; border: 1px solid rgba(255,255,255,0.1); backdrop-filter: blur(10px); height: 100%; }
        .stat-card:hover { transform: translateY(-5px); background: rgba(255,255,255,0.12); }
        .stat-icon { width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; font-size: 30px; }
        .stat-icon.primary { background: linear-gradient(135deg, #667eea, #764ba2); color: white; }
        .stat-icon.success { background: linear-gradient(135deg, #11998e, #38ef7d); color: white; }
        .stat-icon.warning { background: linear-gradient(135deg, #f2994a, #f2c94c); color: white; }
        .stat-icon.info { background: linear-gradient(135deg, #4facfe, #00f2fe); color: white; }
        .stat-value { font-size: 36px; font-weight: 800; color: white; margin: 10px 0; }
        .stat-label { color: rgba(255,255,255,0.7); font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 1px; }
        .chart-card { background: rgba(255,255,255,0.08); border-radius: 20px; padding: 20px; margin-bottom: 30px; border: 1px solid rgba(255,255,255,0.1); backdrop-filter: blur(10px); height: 100%; }
        .chart-title { font-size: 18px; font-weight: 600; color: white; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid rgba(255,255,255,0.1); }
        .chart-title i { margin-right: 10px; color: #667eea; }
        canvas { max-height: 300px; max-width: 100%; }
        .alerts-list { background: rgba(255,255,255,0.08); border-radius: 20px; padding: 20px; height: 100%; border: 1px solid rgba(255,255,255,0.1); }
        .alert-item { padding: 15px; border-left: 4px solid; margin-bottom: 15px; border-radius: 10px; transition: transform 0.2s; cursor: pointer; background: rgba(0,0,0,0.2); }
        .alert-item:hover { transform: translateX(5px); }
        .alert-item.danger { border-left-color: #e74c3c; background: rgba(231,76,60,0.1); }
        .alert-item.warning { border-left-color: #f39c12; background: rgba(243,156,18,0.1); }
        .alert-item.info { border-left-color: #3498db; background: rgba(52,152,219,0.1); }
        .alert-title { font-weight: 600; color: white; margin-bottom: 5px; }
        .alert-date { font-size: 12px; color: rgba(255,255,255,0.6); }
        @media (max-width: 768px) { .sidebar-fixed { width: 100%; height: auto; position: relative; } .content-wrapper { margin-left: 0; } .stat-value { font-size: 28px; } }
    </style>
</head>
<body>
<div class="main-wrapper">
    <div class="sidebar-fixed">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>
    <div class="content-wrapper">
        <div class="dashboard-container">
            <div class="dashboard-header">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1><i class="fas fa-chalkboard-user"></i> Dashboard Administrateur</h1>
                        <p style="color: rgba(255,255,255,0.7); margin-top: 10px;">Vue d'ensemble de l'établissement</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="badge bg-primary fs-6 px-3 py-2">
                            <i class="fas fa-calendar-alt"></i> Année scolaire 2024-2025
                        </span>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-md-3 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon primary"><i class="fas fa-user-graduate"></i></div>
                        <div class="stat-value">${dashboard.totalEleves}</div>
                        <div class="stat-label">Total Élèves</div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon success"><i class="fas fa-chalkboard"></i></div>
                        <div class="stat-value">${dashboard.totalClasses}</div>
                        <div class="stat-label">Classes</div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon warning"><i class="fas fa-chalkboard-user"></i></div>
                        <div class="stat-value">${dashboard.totalProfesseurs}</div>
                        <div class="stat-label">Professeurs</div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon info"><i class="fas fa-percent"></i></div>
                        <div class="stat-value">${dashboard.tauxAssiduiteGlobal}%</div>
                        <div class="stat-label">Taux d'assiduité</div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-md-6 mb-3">
                    <div class="chart-card">
                        <div class="chart-title"><i class="fas fa-chart-pie"></i> Répartition des élèves par classe</div>
                        <canvas id="repartitionChart"></canvas>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="chart-card">
                        <div class="chart-title"><i class="fas fa-chart-line"></i> Évolution des absences (2025)</div>
                        <canvas id="assiduiteChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-5 mb-3">
                    <div class="chart-card">
                        <div class="chart-title"><i class="fas fa-chart-donut"></i> Absences justifiées vs non justifiées</div>
                        <canvas id="justifieChart"></canvas>
                    </div>
                </div>
                <div class="col-md-7 mb-3">
                    <div class="alerts-list">
                        <div class="chart-title"><i class="fas fa-bell"></i> Alertes récentes</div>
                        <c:forEach var="alerte" items="${dashboard.alertesRecentes}">
                            <div class="alert-item ${alerte.type == 'danger' ? 'danger' : (alerte.type == 'warning' ? 'warning' : 'info')}">
                                <div class="alert-title"><i class="fas fa-exclamation-circle"></i> ${alerte.message}</div>
                                <div class="alert-date"><i class="fas fa-user"></i> ${alerte.eleveNom} &nbsp;|&nbsp; <i class="fas fa-calendar"></i> ${alerte.date}</div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty dashboard.alertesRecentes}">
                            <div class="text-center py-4" style="color: rgba(255,255,255,0.6);">
                                <i class="fas fa-check-circle fa-3x mb-2"></i>
                                <p>Aucune alerte récente</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Récupération des données JSON sécurisées
    const repartitionLabels = ${dashboard.repartitionClassesChart.labelsJson};
    const repartitionData = ${dashboard.repartitionClassesChart.dataJson};
    const absencesLabels = ${dashboard.assiduiteMensuelleChart.labelsJson};
    const absencesData = ${dashboard.assiduiteMensuelleChart.dataJson};
    const justifieLabels = ${dashboard.absencesJustifieesChart.labelsJson};
    const justifieData = ${dashboard.absencesJustifieesChart.dataJson};

    console.log("Labels répartition:", repartitionLabels);
    console.log("Data répartition:", repartitionData);

    // Graphique 1: Camembert
    if (repartitionLabels.length > 0 && repartitionData.length > 0) {
        new Chart(document.getElementById('repartitionChart'), {
            type: 'pie',
            data: { labels: repartitionLabels, datasets: [{ data: repartitionData, backgroundColor: ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b', '#f2c94c', '#e74c3c', '#3498db', '#1abc9c', '#e67e22', '#95a5a6', '#2c3e50'], borderWidth: 0 }] },
            options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { position: 'bottom', labels: { color: 'white' } } } }
        });
    }

    // Graphique 2: Courbe
    if (absencesLabels.length > 0 && absencesData.length > 0) {
        new Chart(document.getElementById('assiduiteChart'), {
            type: 'line',
            data: { labels: absencesLabels, datasets: [{ label: 'Nombre d\'absences', data: absencesData, borderColor: '#667eea', backgroundColor: 'rgba(102,126,234,0.1)', borderWidth: 3, fill: true, tension: 0.4, pointBackgroundColor: '#667eea', pointBorderColor: 'white', pointRadius: 5 }] },
            options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { labels: { color: 'white' } } }, scales: { y: { ticks: { color: 'white' }, grid: { color: 'rgba(255,255,255,0.1)' } }, x: { ticks: { color: 'white' }, grid: { color: 'rgba(255,255,255,0.1)' } } } }
        });
    }

    // Graphique 3: Donut
    if (justifieLabels.length > 0 && justifieData.length > 0) {
        new Chart(document.getElementById('justifieChart'), {
            type: 'doughnut',
            data: { labels: justifieLabels, datasets: [{ data: justifieData, backgroundColor: ['#2ecc71', '#e74c3c'], borderWidth: 0 }] },
            options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { position: 'bottom', labels: { color: 'white' } } } }
        });
    }
</script>
</body>
</html>