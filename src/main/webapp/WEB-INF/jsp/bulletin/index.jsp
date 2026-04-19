<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<style>
    .class-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 20px;
        transition: transform 0.3s;
        cursor: pointer;
    }
    .class-card:hover { transform: translateY(-5px); }
    .class-card h3 { color: white; margin: 0 0 10px 0; }
    .class-card p { color: rgba(255,255,255,0.8); margin: 0; }
    .trimestre-selector { margin-bottom: 20px; padding: 15px; background: #1a252f; border-radius: 10px; }
    .btn-trimestre {
        background: #34495e; color: white; border: none; padding: 10px 20px;
        margin-right: 10px; border-radius: 5px; cursor: pointer;
    }
    .btn-trimestre.active { background: #00d4ff; color: #1a252f; }
    .row { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px; }
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white">📊 Génération des Bulletins Scolaires</h2>

            <div class="trimestre-selector">
                <h3 style="color:white; margin-bottom: 15px;">Choisir la période :</h3>
                <button class="btn-trimestre" data-trimestre="1">📖 1er Trimestre</button>
                <button class="btn-trimestre" data-trimestre="2">📖 2ème Trimestre</button>
                <button class="btn-trimestre" data-trimestre="3">📖 3ème Trimestre</button>
                <button class="btn-trimestre" data-trimestre="0">📅 Année complète</button>
            </div>

            <h3 style="color:#ffd700;">📚 Sélectionner une classe</h3>
            <div class="row">
                <c:forEach var="classe" items="${classes}">
                    <div class="class-card" onclick="selectionnerClasse(${classe.id_classe})">
                        <h3>📖 ${classe.nom}</h3>
                        <p>Niveau: ${classe.niveau}</p>
                        <p>Année scolaire: ${classe.annee_scolaire}</p>
                        <p style="margin-top: 10px; color: #ffd700;">👉 Cliquer pour voir les élèves</p>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty classes}">
                <div style="text-align: center; padding: 50px; color: white;">
                    <p>📭 Aucune classe trouvée pour votre profil</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    let trimestreActuel = 1;

    document.querySelectorAll('.btn-trimestre').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.btn-trimestre').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            trimestreActuel = parseInt(this.dataset.trimestre);
        });
    });

    function selectionnerClasse(classeId) {
        window.location.href = '/bulletin/classe/' + classeId + '?trimestre=' + trimestreActuel;
    }
</script>

<jsp:include page="../includes/footer.jsp" />