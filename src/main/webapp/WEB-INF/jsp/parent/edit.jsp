<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/parent" class="btn-back">← Retour à la liste</a>
    <h2>Modifier le Parent</h2>

    <form action="${pageContext.request.contextPath}/parent/save" method="post">
        <input type="hidden" name="id_parent" value="${parent.id_parent}">

        <div class="form-group"><label>Nom</label>
            <input type="text" name="nom" value="${parent.nom}" class="form-control" required></div>

        <div class="form-group"><label>Prénom</label>
            <input type="text" name="prenom" value="${parent.prenom}" class="form-control"></div>

        <div class="form-group"><label>Téléphone</label>
            <input type="text" name="telephone" value="${parent.telephone}" class="form-control"></div>

        <div class="form-group"><label>Email</label>
            <input type="email" name="email" value="${parent.email}" class="form-control"></div>

        <button type="submit" class="btn-submit">Mettre à jour</button>
    </form>
</div>
</body>
</html>