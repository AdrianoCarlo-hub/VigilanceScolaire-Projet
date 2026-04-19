<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/evenement" class="btn-back">← Retour au journal</a>
    <h2>Signaler un Événement</h2>

    <form action="${pageContext.request.contextPath}/evenement/save" method="post">
        <div class="form-group">
            <label>Élève concerné (ID)</label>
            <input type="number" name="eleve.id_eleve" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Type d'événement</label>
            <input type="text" name="type" class="form-control" placeholder="Ex: Retard, Conduite">
        </div>

        <div class="form-group">
            <label>Gravité</label>
            <select name="gravite" class="form-control">
                <option value="FAIBLE">Faible</option>
                <option value="MOYENNE">Moyenne</option>
                <option value="HAUTE">Haute</option>
            </select>
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea name="description" class="form-control" placeholder="Détails de l'incident..."></textarea>
        </div>

        <button type="submit" class="btn-submit">Signaler l'événement</button>
    </form>
</div>

</body>
</html>