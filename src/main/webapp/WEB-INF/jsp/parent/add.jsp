<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/parent" class="btn-back">← Retour aux parents</a>
    <h2>Ajouter un Parent</h2>

    <form action="${pageContext.request.contextPath}/parent/save" method="post">
        <div class="form-group">
            <label>Nom</label>
            <input type="text" name="nom" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Prénom</label>
            <input type="text" name="prenom" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Téléphone</label>
            <input type="tel" name="telephone" class="form-control" required placeholder="Ex: 0612345678">
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" class="form-control" placeholder="name@flowbite.com">
        </div>

        <div class="form-group">
            <label>Adresse</label>
            <input type="text" name="adresse" class="form-control">
        </div>

        <button type="submit" class="btn-submit">Ajouter le parent</button>
    </form>
</div>

</body>
</html>