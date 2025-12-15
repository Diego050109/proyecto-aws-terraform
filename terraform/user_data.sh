#!/bin/bash
yum update -y

# Instalar Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Crear carpeta de la app
mkdir -p /opt/app
cd /opt/app

# Crear docker-compose.yml
cat <<EOF > docker-compose.yml
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: apppass
    volumes:
      - pgdata:/var/lib/postgresql/data
    restart: always

  backend:
    image: ddiego24/backend-db:latest
    ports:
      - "80:80"
    environment:
      DB_HOST: postgres
      DB_USER: appuser
      DB_PASSWORD: apppass
      DB_NAME: appdb
    depends_on:
      - postgres
    restart: always

volumes:
  pgdata:
EOF

# Levantar contenedores
/usr/local/bin/docker-compose up -d
