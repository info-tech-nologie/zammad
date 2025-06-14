# Dockerfile
FROM ghcr.io/zammad/zammad:6.5.0-75

# Si vous souhaitez ajouter des personnalisations, décommentez ou ajoutez des instructions ici

# Exposer le port 8080 si nécessaire
EXPOSE 8080

# Commande par défaut (si vous souhaitez lancer NGINX ou autre)
CMD ["zammad-nginx"]
