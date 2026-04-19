<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Envoyer une communication</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
        h1 { color: #333; }
        .card { border: 1px solid #ddd; border-radius: 8px; margin-bottom: 20px; overflow: hidden; }
        .card-header { background: #4CAF50; color: white; padding: 10px 15px; font-weight: bold; }
        .card-body { padding: 15px; }
        .info-row { margin-bottom: 10px; }
        .label { font-weight: bold; width: 150px; display: inline-block; }
        .message-auto { background: #f0f0f0; padding: 10px; border-radius: 5px; margin-top: 10px; white-space: pre-wrap; }
        textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-family: Arial; box-sizing: border-box; }
        button { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        button:hover { background-color: #45a049; }
        .btn-annuler { background-color: #f44336; margin-left: 10px; text-decoration: none; padding: 10px 20px; border-radius: 5px; color: white; display: inline-block; }
        .btn-annuler:hover { background-color: #da190b; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📨 Envoyer une communication</h1>

        <div class="card">
            <div class="card-header">
                📋 Informations de l'élève
            </div>
            <div class="card-body">
                <div class="info-row">
                    <span class="label">👨‍🎓 Élève :</span>
                    ${alerte.prenomEleve} ${alerte.nomEleve}
                </div>
                <div class="info-row">
                    <span class="label">📧 Email parent :</span>
                    ${alerte.emailParent}
                </div>
                <div class="info-row">
                    <span class="label">📱 Téléphone :</span>
                    ${alerte.telephoneParent}
                </div>
                <div class="info-row">
                    <span class="label">⚠️ Type d'alerte :</span>
                    ${alerte.typeAlerte}
                </div>
                <div class="message-auto">
                    <strong>📝 Message automatique :</strong><br>
                    ${alerte.messageAuto}
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                ✏️ Rédiger votre message
            </div>
            <div class="card-body">
                <form action="/communication/envoyer" method="post">
                    <input type="hidden" name="idAlerte" value="${alerte.idAlerte}">

                    <label for="messagePersonnalise"><strong>Message personnalisé :</strong></label>
                    <textarea id="messagePersonnalise" name="messagePersonnalise" rows="5"
                              placeholder="Exemple : Bonjour, veuillez prendre connaissance de cette alerte concernant votre enfant..."
                              required></textarea>

                    <div style="margin-top: 15px;">
                        <button type="submit">📱 Envoyer par SMS et Email</button>
                        <a href="/communication/alertes" class="btn-annuler">❌ Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>