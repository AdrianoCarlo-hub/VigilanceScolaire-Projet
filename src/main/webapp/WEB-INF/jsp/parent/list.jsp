<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="list.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content">
        <div class="custom-table-container">

            <div class="table-header">
                <h2><i class="fas fa-user-friends"></i> Liste des Parents</h2>
                <a href="${contextPath}/parent/add" class="btn-add">
                    <i class="fas fa-user-plus"></i> Ajouter un Parent
                </a>
            </div>

            <div class="search-filter-bar" style="display: flex; gap: 12px; margin-bottom: 25px; align-items: center;">
               <div style="position: relative; width: 350px; max-width: 100%;">
                    <i class="fas fa-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                    <input type="text" id="searchGlobal" placeholder="Rechercher par nom, prénom, téléphone, email ou adresse..." onkeyup="instantSearch()" style="width: 100%; padding: 12px 15px 12px 45px; border-radius: 6px; border: 1px solid #444; background: #111; color: #fff; outline: none;">
                </div>
                <button class="btn-reset" onclick="resetFilters()" style="padding: 12px 20px; border-radius: 6px; border: none; background: #e63946; color: white; cursor: pointer; white-space: nowrap; font-weight: 500;">
                    <i class="fas fa-times"></i> Réinitialiser
                </button>
            </div>

            <div class="responsive-table-wrapper">
                <table class="table-dark">
                    <thead>
                    <tr>
                        <th onclick="sortColumn('id')" style="cursor: pointer;"><i class="fas fa-hashtag"></i> ID <i id="sort-id" class="fas fa-sort"></i></th>
                        <th onclick="sortColumn('nom')" style="cursor: pointer;"><i class="fas fa-user"></i> Nom & Prénom <i id="sort-nom" class="fas fa-sort"></i></th>
                        <th onclick="sortColumn('telephone')" style="cursor: pointer;"><i class="fas fa-phone-alt"></i> Téléphone <i id="sort-telephone" class="fas fa-sort"></i></th>
                        <th onclick="sortColumn('email')" style="cursor: pointer;"><i class="fas fa-envelope"></i> Email <i id="sort-email" class="fas fa-sort"></i></th>
                        <th onclick="sortColumn('adresse')" style="cursor: pointer;"><i class="fas fa-map-marker-alt"></i> Adresse <i id="sort-adresse" class="fas fa-sort"></i></th>
                        <th><i class="fas fa-tools"></i> Actions</th>
                    </tr>
                    </thead>
                    <tbody id="parentTableBody">
                        <tr>
                            <td colspan="6" style="text-align: center;">
                                <i class="fas fa-spinner fa-spin"></i> Chargement des données...
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<div id="toastContainer" class="toast-container"></div>

<script>
    const contextPath = "${contextPath}";
</script>
<script src="${contextPath}/js/parent/list.js"></script>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>