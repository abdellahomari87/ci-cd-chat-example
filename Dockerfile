# Utilisation de Debian 12 comme image de base
FROM debian:12

# Mettre à jour les paquets et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    python3 \
    python3-venv \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copier requirements.txt et le dossier requirements/
COPY requirements.txt .
COPY requirements/ requirements/

# Créer un environnement virtuel et mettre à jour pip
RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install --upgrade pip

# Installer les dépendances Python à partir de requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Copier le reste des fichiers de l'application
COPY . .

# Ajouter le répertoire bin de l'environnement virtuel à la variable PATH
ENV PATH="/opt/venv/bin:$PATH"

# Exposer le port utilisé par l'application Django
EXPOSE 8000

# Commande pour démarrer le serveur Django
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
