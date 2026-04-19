<jsp:include page="../includes/sidebar.jsp" />

<div style="margin-left:220px;padding:20px;">
    <h2>Modifier alerte</h2>

    <form action="/alertes/update" method="post">
        <input type="hidden" name="id_alerte" value="${alerte.id_alerte}">

        Canal: <input type="text" name="canal" value="${alerte.canal}"><br>
        Message: <textarea name="message">${alerte.message}</textarea><br>
        Statut: <input type="text" name="statut" value="${alerte.statut}"><br>
        Type: <input type="text" name="type" value="${alerte.type}"><br>
        Date: <input type="datetime-local" name="date_alerte" value="${alerte.date_alerte}"><br>
        ID Eleve: <input type="number" name="id_eleve" value="${alerte.id_eleve}"><br>

        <button type="submit">Mettre à jour</button>
    </form>
</div>