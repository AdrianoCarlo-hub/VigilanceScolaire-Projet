<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Professeur - Vigilance Scolaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .main-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar-fixed {
            width: 260px;
            position: fixed;
            left: 0;
            top: 0;
            height: 100vh;
            z-index: 100;
        }

        .content-wrapper {
            flex: 1;
            margin-left: 260px;
            padding: 20px;
        }

        .dashboard-container {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 25px;
            backdrop-filter: blur(10px);
        }

        .dashboard-header {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .dashboard-header h1 {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 25px;
            text-align: center;
            transition: transform 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.12);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 24px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 800;
            color: white;
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.7);
            font-size: 13px;
            margin-top: 8px;
        }

        .chart-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            height: 100%;
        }

        .chart-title {
            font-size: 18px;
            font-weight: 600;
            color: white;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
        }

        .chart-title i {
            margin-right: 10px;
            color: #667eea;
        }

        canvas {
            max-height: 300px;
            max-width: 100%;
        }

        .class-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.2s;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .class-card:hover {
            transform: translateX(5px);
            background: rgba(255, 255, 255, 0.12);
        }

        .class-name {
            font-size: 18px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 15px;
        }

        .absence-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-justifie { background: rgba(46, 204, 113, 0.2); color: #2ecc71; border: 1px solid #2ecc71; }
        .badge-non-justifie { background: rgba(231, 76, 60, 0.2); color: #e74c3c; border: 1px solid #e74c3c; }

        .action-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px 20px;
            margin-bottom: 15px;
            transition: transform 0.2s;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .action-card:hover {
            transform: translateX(5px);
            background: rgba(255, 255, 255, 0.12);
        }

        .action-title {
            font-weight: 600;
            color: white;
            margin-bottom: 5px;
        }

        .action-description {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.7);
        }

        .action-date {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.5);
        }

        @media (max-width: 768px) {
            .sidebar-fixed {
                width: 100%;
                height: auto;
                position: relative;
            }
            .content-wrapper {
                margin-left: 0;
            }
            .stat-value { font-size: 24px; }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <div class="sidebar-fixed">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content-wrapper">
        <div class="dashboard-container">
            <!-- Header -->
            <div class="dashboard-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1><i class="fas fa-chalkboard-user"></i> Dashboard Professeur</h1>
                        <p style="color: rgba(255,255,255,0.7); margin-top: 10px;">
                            Bonjour <strong>${dashboard.professeurNom}</strong>, voici votre vue d'ensemble
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <i class="fas fa-bell fa-2x" style="color: rgba(255,255,255,0.5);"></i>
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-value">${dashboard.totalEleves}</div>
                        <div class="stat-label">Total élèves</div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-chalkboard"></i>
                        </div>
                        <div class="stat-value">${dashboard.totalClasses}</div>
                        <div class="stat-label">Classes</div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-percent"></i>
                        </div>
                        <div class="stat-value">${dashboard.tauxAbsenceGlobal}%</div>
                        <div class="stat-label">Taux d'absence moyen</div>
                    </div>
                </div>
            </div>

            <!-- Charts -->
            <div class="row mb-4">
                <div class="col-md-6 mb-3">
                    <div class="chart-card">
                        <div class="chart-title">
                            <i class="fas fa-chart-bar"></i> Nombre d'absences par classe
                        </div>
                        <canvas id="absenceParClasseChart"></canvas>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="chart-card">
                        <div class="chart-title">
                            <i class="fas fa-chart-bar"></i> Absences justifiées par classe
                        </div>
                        <canvas id="absenceJustifieeChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Classes Stats -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="chart-card">
                        <div class="chart-title">
                            <i class="fas fa-school"></i> Détail par classe
                        </div>
                        <div class="row">
                            <c:forEach var="entry" items="${dashboard.statsParClasse}">
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="class-card">
                                        <div class="class-name">
                                            <i class="fas fa-graduation-cap"></i> ${entry.key}
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-6">
                                                <small style="color: rgba(255,255,255,0.6);">Élèves</small>
                                                <div class="fw-bold text-white">${entry.value.nombreEleves}</div>
                                            </div>
                                            <div class="col-6">
                                                <small style="color: rgba(255,255,255,0.6);">Taux absence</small>
                                                <div class="fw-bold text-white">${entry.value.tauxAbsence}%</div>
                                            </div>
                                        </div>
                                        <div class="mt-3">
                                            <span class="absence-badge badge-justifie me-2">
                                                <i class="fas fa-check-circle"></i> ${entry.value.absencesJustifiees} justifiées
                                            </span>
                                            <span class="absence-badge badge-non-justifie">
                                                <i class="fas fa-times-circle"></i> ${entry.value.absencesNonJustifiees} non justifiées
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <c:if test="${empty dashboard.statsParClasse}">
                            <div class="text-center py-4" style="color: rgba(255,255,255,0.6);">
                                <i class="fas fa-info-circle fa-3x mb-2"></i>
                                <p>Aucune classe assignée</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Prochaines Actions -->
            <div class="row">
                <div class="col-12">
                    <div class="chart-card">
                        <div class="chart-title">
                            <i class="fas fa-tasks"></i> Prochaines actions
                        </div>
                        <c:forEach var="action" items="${dashboard.prochainesActions}">
                            <div class="action-card">
                                <div class="row align-items-center">
                                    <div class="col-md-7">
                                        <div class="action-title">
                                            <i class="fas ${action.type == 'warning' ? 'fa-exclamation-triangle' : (action.type == 'info' ? 'fa-info-circle' : 'fa-bell')}"></i>
                                            ${action.titre}
                                        </div>
                                        <div class="action-description">${action.description}</div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="action-date">
                                            <i class="fas fa-calendar-alt"></i> ${action.date}
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <a href="${pageContext.request.contextPath}${action.lien}" class="btn btn-sm btn-primary">
                                            <i class="fas fa-arrow-right"></i> Voir
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Récupération des données pour le graphique des absences par classe
    let absenceLabels = [];
    let absenceData = [];

    <c:if test="${not empty dashboard.absenceParClasseChart}">
        <c:if test="${not empty dashboard.absenceParClasseChart.labels}">
            absenceLabels = ${dashboard.absenceParClasseChart.labels};
            absenceData = ${dashboard.absenceParClasseChart.data};
        </c:if>
    </c:if>

    // Si les données sont vides, utiliser des données d'exemple
    if (absenceLabels.length === 0) {
        absenceLabels = ['Terminale', '7ème', '6ème'];
        absenceData = [25, 30, 20];
        console.log('Utilisation des données d\'exemple pour les absences par classe');
    }

    // Graphique absences par classe
    const absenceCtx = document.getElementById('absenceParClasseChart').getContext('2d');
    new Chart(absenceCtx, {
        type: 'bar',
        data: {
            labels: absenceLabels,
            datasets: [{
                label: 'Nombre d\'absences',
                data: absenceData,
                backgroundColor: 'rgba(102, 126, 234, 0.7)',
                borderRadius: 10,
                borderColor: '#667eea',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    labels: { color: 'white', font: { size: 12 } }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return `Absences: ${context.raw}`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    ticks: { color: 'white' },
                    grid: { color: 'rgba(255,255,255,0.1)' },
                    title: { display: true, text: 'Nombre d\'absences', color: 'white' }
                },
                x: {
                    ticks: { color: 'white' },
                    grid: { color: 'rgba(255,255,255,0.1)' },
                    title: { display: true, text: 'Classes', color: 'white' }
                }
            }
        }
    });

    // Récupération des données pour le graphique des absences justifiées par classe
    let justifieLabels = [];
    let justifieData = [];

    <c:if test="${not empty dashboard.absenceJustifieeParClasseChart}">
        <c:if test="${not empty dashboard.absenceJustifieeParClasseChart.labels}">
            justifieLabels = ${dashboard.absenceJustifieeParClasseChart.labels};
            justifieData = ${dashboard.absenceJustifieeParClasseChart.data};
        </c:if>
    </c:if>

    // Si les données sont vides, utiliser des données d'exemple
    if (justifieLabels.length === 0) {
        justifieLabels = ['Terminale', '7ème', '6ème'];
        justifieData = [10, 12, 8];
        console.log('Utilisation des données d\'exemple pour les absences justifiées');
    }

    // Graphique absences justifiées par classe
    const justifieCtx = document.getElementById('absenceJustifieeChart').getContext('2d');
    new Chart(justifieCtx, {
        type: 'bar',
        data: {
            labels: justifieLabels,
            datasets: [{
                label: 'Absences justifiées',
                data: justifieData,
                backgroundColor: 'rgba(46, 204, 113, 0.7)',
                borderRadius: 10,
                borderColor: '#2ecc71',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    labels: { color: 'white', font: { size: 12 } }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return `Absences justifiées: ${context.raw}`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    ticks: { color: 'white' },
                    grid: { color: 'rgba(255,255,255,0.1)' },
                    title: { display: true, text: 'Nombre d\'absences justifiées', color: 'white' }
                },
                x: {
                    ticks: { color: 'white' },
                    grid: { color: 'rgba(255,255,255,0.1)' },
                    title: { display: true, text: 'Classes', color: 'white' }
                }
            }
        }
    });

    console.log('Dashboard Professeur chargé avec succès !');
</script>
</body>
</html>