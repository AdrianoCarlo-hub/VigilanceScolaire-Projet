<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="index.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white; margin-top: 0;"><i class="fas fa-chart-pie"></i> Génération des Bulletins Scolaires</h2>

            <div class="trimestre-selector">
                <h3 style="color:white; margin: 0;"><i class="fas fa-filter"></i> Choisir la période :</h3>
                <div class="btn-trimestre-group">
                    <button class="btn-trimestre active" data-trimestre="1"><i class="fas fa-book-open"></i> 1er Trimestre</button>
                    <button class="btn-trimestre" data-trimestre="2"><i class="fas fa-book-open"></i> 2ème Trimestre</button>
                    <button class="btn-trimestre" data-trimestre="3"><i class="fas fa-book-open"></i> 3ème Trimestre</button>
                    <button class="btn-trimestre" data-trimestre="0"><i class="fas fa-calendar-alt"></i> Année complète</button>
                </div>
            </div>

            <h3 class="section-title" style="color:#ffd700;"><i class="fas fa-graduation-cap"></i> Sélectionner une classe</h3>

            <div class="class-grid">
                <c:forEach var="classe" items="${classes}">
                    <div class="class-card" onclick="selectionnerClasse(${classe.id_classe})">
                        <h3><i class="fas fa-users-class"></i> ${classe.nom}</h3>
                        <p><i class="fas fa-layer-group"></i> Niveau: ${classe.niveau}</p>
                        <p><i class="fas fa-history"></i> Année scolaire: ${classe.annee_scolaire}</p>
                        <p class="card-action-text" style="color: #ffd700;">
                            Cliquer pour voir les élèves <i class="fas fa-arrow-right"></i>
                        </p>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty classes}">
                <div class="empty-state">
                    <i class="fas fa-folder-open fa-3x"></i>
                    <p>Aucune classe trouvée ou assignée à votre profil de vigilance.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    // Initialisation par défaut de la période (Trimestre 1)
    let trimestreActuel = 1;

    // Gestion du basculement d'état visuel et de valeur des boutons de trimestre
    document.querySelectorAll('.btn-trimestre').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.btn-trimestre').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            trimestreActuel = parseInt(this.dataset.trimestre);
        });
    });

    // Redirection dynamique vers le contrôleur avec l'état de la période sélectionnée
    function selectionnerClasse(classeId) {
        window.location.href = '${pageContext.request.contextPath}/bulletin/classe/' + classeId + '?trimestre=' + trimestreActuel;
    }
</script>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>