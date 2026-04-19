<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div style="width:200px;float:left;background:#2c3e50;height:100vh;color:white;padding:10px;position:fixed;overflow-y:auto;">
    <h3 style="border-bottom: 1px solid #555; padding-bottom: 10px;">Vigilance</h3>

    <!-- Informations utilisateur connecté -->
    <div style="padding: 10px; background: #1a252f; border-radius: 5px; margin-bottom: 15px;">
        <sec:authentication property="name" var="username" />
        <sec:authentication property="authorities" var="roles" />
        <div style="font-size: 12px; color: #ffd700;">
            👤 ${username}<br>
            🎭 Rôle: <sec:authentication property="authorities" />
        </div>
    </div>

    <ul style="list-style:none;padding:0;">
        <!-- DASHBOARD - Visible pour tous -->
        <li style="margin-bottom: 5px;">
            <a href="/dashboard" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;margin:2px 0;transition:background 0.3s;background:#1a252f;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='#1a252f'">
                📊 Dashboard
            </a>
        </li>

        <!-- Séparateur -->
        <li style="margin: 10px 0; border-top: 1px solid #444;"></li>

        <!-- SECTION PRINCIPALE -->
        <li><a href="/eleve" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">📚 Élèves</a></li>
        <li><a href="/classe" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">🏫 Classes</a></li>
        <li><a href="/parent" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">👪 Parents</a></li>
        <li><a href="/absence" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">🚫 Absences</a></li>
        <li><a href="/communication" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">📢 Alertes</a></li>
        <li><a href="/note" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">📝 Notes</a></li>
        <li><a href="/historique/alertes" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">📜 Historique alertes</a></li>
        <li><a href="/bulletin" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
               onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">📊 Bulletins</a></li>

        <%-- Seul l'ADMIN voit le lien Utilisateurs --%>
        <sec:authorize access="hasRole('ADMIN')">
            <li><a href="/utilisateur" style="color:white;text-decoration:none;display:block;padding:10px;border-radius:4px;transition:background 0.3s;"
                   onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='transparent'">👥 Utilisateurs</a></li>
        </sec:authorize>

        <!-- Déconnexion -->
        <li style="margin-top: 20px; border-top: 1px solid #555; padding-top: 10px;">
            <form action="/logout" method="post" style="margin:0;">
                <button type="submit" style="background:none; border:none; color:#e74c3c; cursor:pointer; padding:10px; font-size:16px; width:100%; text-align:left; border-radius:4px; transition:background 0.3s;"
                        onmouseover="this.style.background='#34495e'" onmouseout="this.style.background='none'">
                    🔓 Déconnexion
                </button>
            </form>
        </li>
    </ul>
</div>

<style>
    div[style*="overflow-y:auto"]::-webkit-scrollbar {
        width: 5px;
    }
    div[style*="overflow-y:auto"]::-webkit-scrollbar-track {
        background: #1a252f;
    }
    div[style*="overflow-y:auto"]::-webkit-scrollbar-thumb {
        background: #ffd700;
        border-radius: 5px;
    }
    a.active {
        background: #34495e !important;
        border-left: 3px solid #ffd700;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const links = document.querySelectorAll('ul li a');
        links.forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            } else if (currentPath.includes('/dashboard') && link.getAttribute('href') === '/dashboard') {
                link.classList.add('active');
            }
        });
    });
</script>