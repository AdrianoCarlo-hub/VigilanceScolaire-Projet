<jsp:include page="../includes/sidebar.jsp" />

<div style="margin-left:220px;padding:20px;">
    <h2>Modifier événement</h2>

    <form action="/evenements/update" method="post">
        <input type="hidden" name="id_evenement" value="${evenement.id_evenement}">

        Description: <input type="text" name="description" value="${evenement.description}"><br>
        Type: <input type="text" name="type" value="${evenement.type}"><br>
        Gravité: <input type="text" name="gravite" value="${evenement.gravite}"><br>
        Date: <input type="datetime-local" name="date_evenement" value="${evenement.date_evenement}"><br>
        ID Eleve: <input type="number" name="id_eleve" value="${evenement.id_eleve}"><br>

        <button type="submit">Mettre à jour</button>
    </form>
</div>