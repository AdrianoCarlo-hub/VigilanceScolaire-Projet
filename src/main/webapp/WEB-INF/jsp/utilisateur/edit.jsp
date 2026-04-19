<jsp:include page="../includes/sidebar.jsp" />

<div style="margin-left:220px;padding:20px;">
    <h2>Modifier utilisateur</h2>

    <form action="/utilisateurs/update" method="post">
        <input type="hidden" name="id_utilisateur" value="${utilisateur.id_utilisateur}">

        Username: <input type="text" name="username" value="${utilisateur.username}"><br>
        Password: <input type="text" name="password" value="${utilisateur.password}"><br>
        Role: <input type="text" name="role" value="${utilisateur.role}"><br>

        <button type="submit">Mettre à jour</button>
    </form>
</div>