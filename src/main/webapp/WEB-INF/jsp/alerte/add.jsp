<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/alerte" class="btn-back">← Retour au journal</a>
    <h2>Créer une Alerte</h2>

    <form action="${pageContext.request.contextPath}/alerte/save" method="post">
        <div class="form-group">
            <label>Élève concerné (ID)</label>
            <input type="number" name="eleve.id_eleve" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Type d'alerte</label>
            <select name="type" class="form-control">
                <option value="ABSENCE">Absence</option>
                <option value="RETARD">Retard</option>
                <option value="NOTE">Note</option>
                <option value="DISCIPLINE">Discipline</option>
            </select>
        </div>

        <div class="form-group">
            <label>Canal d'envoi</label>
            <select name="canal" class="form-control">
                <option value="SMS">SMS</option>
                <option value="EMAIL">Email</option>
            </select>
        </div>

        <div class="form-group">
            <label>Message</label>
            <textarea name="message" class="form-control" placeholder="Contenu du message..."></textarea>
        </div>

        <button type="submit" class="btn-submit">Envoyer l'alerte</button>
    </form>
</div>

</body>
</html>