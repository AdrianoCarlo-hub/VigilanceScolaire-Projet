<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<style>
    .img-thumbnail-custom {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #ddd;
    }

    .clickable-row {
        cursor: pointer;
        transition: background 0.3s;
    }
    .clickable-row:hover {
        background-color: rgba(52, 152, 219, 0.1) !important;
    }

    .class-section {
        margin-bottom: 40px;
        background: rgba(255,255,255,0.05);
        border-radius: 15px;
        padding: 20px;
    }

    .class-title {
        color: #ffd700;
        font-size: 24px;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 3px solid #ffd700;
        display: inline-block;
    }

    .badge-count {
        background: #ffd700;
        color: #333;
        padding: 5px 12px;
        border-radius: 20px;
        margin-left: 15px;
        font-size: 14px;
    }

    .justifie-oui {
        color: #2ecc71;
        font-weight: bold;
    }

    .justifie-non {
        color: #e74c3c;
        font-weight: bold;
    }

    .action-buttons {
        display: flex;
        gap: 10px;
    }

    .edit-link, .delete-link {
        padding: 5px 12px;
        border-radius: 5px;
        text-decoration: none;
        font-size: 12px;
        transition: all 0.3s;
        display: inline-block;
    }

    .edit-link {
        background: #3498db;
        color: white;
    }

    .edit-link:hover {
        background: #2980b9;
        color: white;
    }

    .delete-link {
        background: #e74c3c;
        color: white;
    }

    .delete-link:hover {
        background: #c0392b;
        color: white;
    }

    #absenceModal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.8);
        animation: fadeIn 0.3s;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    .modal-content {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        margin: 10% auto;
        padding: 30px;
        width: 50%;
        max-width: 600px;
        border-radius: 20px;
        animation: slideDown 0.3s;
    }

    @keyframes slideDown {
        from {
            transform: translateY(-50px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .close-btn {
        float: right;
        font-size: 28px;
        cursor: pointer;
        transition: transform 0.3s;
    }

    .close-btn:hover {
        transform: scale(1.1);
    }

    .modal-detail {
        margin: 15px 0;
        padding: 10px;
        background: rgba(255,255,255,0.1);
        border-radius: 8px;
    }

    .modal-detail strong {
        color: #ffd700;
        display: inline-block;
        width: 120px;
    }
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h2 style="color:white; margin:0;">📊 Gestion des Absences</h2>
                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                    <a href="${pageContext.request.contextPath}/absence/add" class="btn-add">➕ Enregistrer une absence</a>
                </sec:authorize>
            </div>

            <c:if test="${empty absencesByClass}">
                <div style="text-align: center; padding: 50px; color: white;">
                    <p>📭 Aucune absence trouvée pour votre profil</p>
                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                        <a href="${pageContext.request.contextPath}/absence/add" class="btn-add">Enregistrer une absence</a>
                    </sec:authorize>
                </div>
            </c:if>

            <c:forEach var="entry" items="${absencesByClass}">
                <div class="class-section">
                    <h3 class="class-title">
                        📖 ${entry.key}
                        <span class="badge-count">${fn:length(entry.value)} absence(s)</span>
                    </h3>

                    <table class="table-dark">
                        <thead>
                            <tr>
                                <th>Photo</th>
                                <th>Élève</th>
                                <th>Matricule</th>
                                <th>Date</th>
                                <th>Motif</th>
                                <th>Justifiée</th>
                                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                    <th>Actions</th>
                                </sec:authorize>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${entry.value}">
                                <tr class="clickable-row" onclick="showDetails(${a.id_absence})">
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty a.eleve.photo}">
                                                <img src="${pageContext.request.contextPath}/images/${a.eleve.photo}?t=${System.currentTimeMillis()}"
                                                     class="img-thumbnail-custom"
                                                     onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/default-avatar.png"
                                                     class="img-thumbnail-custom">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="product-name"><strong>${a.eleve.nom}</strong> ${a.eleve.prenom}</td>
                                    <td>${a.eleve.matricule}</td>
                                    <td>${a.date_absence}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty a.motif}">
                                                ${a.motif}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #aaa;">Non spécifié</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="${a.justifie ? 'justifie-oui' : 'justifie-non'}">
                                        ${a.justifie ? '✅ OUI' : '❌ NON'}
                                    </td>
                                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                        <td onclick="event.stopPropagation();" class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/absence/modifier/${a.id_absence}" class="edit-link">✏️ Modifier</a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <a href="${pageContext.request.contextPath}/absence/supprimer/${a.id_absence}"
                                                   class="delete-link"
                                                   onclick="return confirm('⚠️ Supprimer cette absence ?')">🗑️ Supprimer</a>
                                            </sec:authorize>
                                        </td>
                                    </sec:authorize>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Modal Détails -->
<div id="absenceModal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2 style="margin-top: 0;">📋 Détails de l'absence</h2>
        <hr style="border-color: rgba(255,255,255,0.3);">
        <div class="modal-detail">
            <strong>👨‍🎓 Élève :</strong> <span id="modalEleve"></span>
        </div>
        <div class="modal-detail">
            <strong>📚 Classe :</strong> <span id="modalClasse"></span>
        </div>
        <div class="modal-detail">
            <strong>📅 Date :</strong> <span id="modalDate"></span>
        </div>
        <div class="modal-detail">
            <strong>📝 Motif :</strong> <span id="modalMotif"></span>
        </div>
        <div class="modal-detail">
            <strong>✅ Justifiée :</strong> <span id="modalJustifie"></span>
        </div>
    </div>
</div>

<script>
    function showDetails(absenceId) {
        fetch('${pageContext.request.contextPath}/absence/api/' + absenceId)
            .then(response => response.json())
            .then(absence => {
                document.getElementById('modalEleve').innerText = absence.eleve.nom + " " + absence.eleve.prenom;
                document.getElementById('modalClasse').innerText = absence.eleve.classe ? absence.eleve.classe.nom : 'Non assigné';
                document.getElementById('modalDate').innerText = absence.date_absence;
                document.getElementById('modalMotif').innerText = absence.motif || 'Non spécifié';
                document.getElementById('modalJustifie').innerHTML = absence.justifie ? '✅ OUI' : '❌ NON';
                document.getElementById('absenceModal').style.display = "block";
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors du chargement des détails');
            });
    }

    function closeModal() {
        document.getElementById('absenceModal').style.display = "none";
    }

    window.onclick = function(event) {
        let modal = document.getElementById('absenceModal');
        if (event.target == modal) closeModal();
    }
</script>