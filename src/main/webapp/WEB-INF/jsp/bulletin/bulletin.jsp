<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../includes/header.jsp" />

<style>
    /* Styles pour le bulletin officiel */
    .bulletin-container {
        max-width: 1000px;
        margin: 0 auto;
        background: white;
        color: #333;
        font-family: 'Times New Roman', serif;
    }
    .bulletin-header { text-align: center; padding: 20px; border-bottom: 3px solid #333; margin-bottom: 20px; }
    .bulletin-header h1 { color: #333; margin: 0; font-size: 28px; text-transform: uppercase; letter-spacing: 2px; }
    .bulletin-header h3 { color: #555; margin: 5px 0; }
    .info-eleve { background: #f5f5f5; padding: 15px; border-radius: 5px; margin-bottom: 20px; display: flex; justify-content: space-between; flex-wrap: wrap; }
    .info-group { margin: 5px 0; }
    .info-group strong { min-width: 120px; display: inline-block; }
    .notes-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .notes-table th { background: #333; color: white; padding: 12px; text-align: left; }
    .notes-table td { border-bottom: 1px solid #ddd; padding: 10px; }
    .moyenne-box { background: #333; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center; }
    .moyenne-box h2 { margin: 0; font-size: 36px; }
    .rang-box { background: #f9f9f9; padding: 10px; border-radius: 5px; text-align: center; margin-bottom: 20px; border: 1px solid #ddd; }
    .appreciation { background: #f0f0f0; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 5px solid #333; }
    .signatures { display: flex; justify-content: space-between; margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; }
    .signature-line { text-align: center; width: 200px; }
    .signature-line .line { border-top: 1px solid #333; margin-top: 30px; padding-top: 5px; }

    /* Impression */
    @media print {
        .sidebar-container, .no-print, .btn-back, .btn-print { display: none !important; }
        .bulletin-container { margin: 0; padding: 0; }
        .main-layout { margin: 0 !important; padding: 0 !important; }
        .content { margin-left: 0 !important; padding: 10px !important; }
        .info-eleve { background: none; border: 1px solid #ddd; }
        .moyenne-box { background: #333; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
        .notes-table th { background: #333; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    }

    .btn-print { background: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin-right: 10px; }
    .btn-back { background: #666; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; }
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div style="text-align: right; margin-bottom: 20px;" class="no-print">
            <button onclick="window.print()" class="btn-print">🖨️ Imprimer le bulletin</button>
            <a href="/bulletin/classe/${bulletin.classe.id_classe}?trimestre=${trimestre}" class="btn-back">← Retour</a>
        </div>

        <div class="bulletin-container">
            <div class="bulletin-header">
                <h1>📜 BULLETIN SCOLAIRE</h1>
                <h3>Établissement Scolaire Vigilance</h3>
                <p>Année scolaire: ${bulletin.classe.annee_scolaire}</p>
                <p><strong>Période:</strong> ${bulletin.periode}</p>
                <p><strong>Date d'édition:</strong> <fmt:formatDate value="${bulletin.dateEdition}" pattern="dd/MM/yyyy"/></p>
            </div>

            <div class="info-eleve">
                <div class="info-group"><strong>👨‍🎓 Élève :</strong> ${bulletin.eleve.nom} ${bulletin.eleve.prenom}</div>
                <div class="info-group"><strong>📚 Classe :</strong> ${bulletin.classe.nom}</div>
                <div class="info-group"><strong>🔢 Matricule :</strong> ${bulletin.eleve.matricule}</div>
                <div class="info-group"><strong>👨‍🏫 Professeur principal :</strong> ${bulletin.nomProfesseurPrincipal}</div>
            </div>

            <table class="notes-table">
                <thead><tr><th>Matière</th><th>Note /20</th><th>Coefficient</th><th>Total</th></tr></thead>
                <tbody>
                    <c:forEach var="matiere" items="${bulletin.matieres}">
                        <tr>
                            <td><strong>${matiere.matiere}</strong></td>
                            <td style="text-align: center; font-weight: bold;
                                <c:choose>
                                    <c:when test="${matiere.note >= 16}">color: #27ae60;</c:when>
                                    <c:when test="${matiere.note >= 10}">color: #f39c12;</c:when>
                                    <c:otherwise>color: #e74c3c;</c:otherwise>
                                </c:choose>
                            ">${matiere.note}</td>
                            <td style="text-align: center;">${matiere.coefficient}</td>
                            <td style="text-align: center;">${matiere.total}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="moyenne-box">
                <h2>${bulletin.moyenneGenerale}/20</h2>
                <p>Moyenne Générale du Trimestre</p>
            </div>

            <div class="rang-box">
                <strong>🏆 RANG DANS LA CLASSE :</strong> ${bulletin.rang} / ${bulletin.totalEleves}
                <c:if test="${bulletin.rang == 1}"> 👑</c:if>
                <c:if test="${bulletin.rang == 2}"> 🥈</c:if>
                <c:if test="${bulletin.rang == 3}"> 🥉</c:if>
            </div>

            <div class="appreciation">
                <strong>📝 APPRÉCIATION DU PROFESSEUR PRINCIPAL :</strong><br><br>
                ${bulletin.appreciation}
            </div>

            <div class="appreciation" style="background: #fff8e1; border-left-color: #ff9800;">
                <strong>📌 OBSERVATIONS :</strong><br><br>
                <textarea rows="3" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;"
                          placeholder="Observations complémentaires..."></textarea>
            </div>

            <div class="signatures">
                <div class="signature-line"><div class="line"></div><p>Signature du parent</p></div>
                <div class="signature-line"><div class="line"></div><p>Signature du professeur</p></div>
                <div class="signature-line"><div class="line"></div><p>Cachet de l'établissement</p></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />