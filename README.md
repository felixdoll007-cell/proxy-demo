# Reverse-Proxy-Stack

3-Tier-Stack mit Proxy, Backend und Redis-Datenbank, Netze getrennt.
iron 
Start: `docker compose up -d`, dann `localhost:8080` im Browser öffnen.
 
## Architektur

```
Browser -> localhost:8080 -> proxy -> backend -> db
                             (Nginx)  (Nginx)   (Redis)
```

| Container | Netz | Port nach außen |
|---|---|---|
| proxy | frontend-net | 8080 (auf 80 im Container) |
| backend | frontend-net und backend-net | keiner |
| db | backend-net | keiner |

Das Backend ist die einzige Brücke zwischen beiden Netzen. Der Proxy erreicht die Datenbank deshalb nicht, weder per Name noch per IP. Die Redis-Daten liegen im Named Volume `redisdaten` und überleben `docker compose down` (nicht aber `down -v`).

## Backup und Restore

Backup des Volumes in eine Datei im aktuellen Ordner:

```bash
docker compose exec db redis-cli save
docker run --rm \
  -v proxy-demo_redisdaten:/quelle:ro \
  -v $(pwd):/ziel \
  alpine tar czf /ziel/redis-backup.tar.gz -C /quelle .
```

Restore, wenn die Daten verloren sind. Redis muss dabei gestoppt sein, sonst überschreibt es die Datei beim Herunterfahren:

```bash
docker compose stop db
docker run --rm \
  -v proxy-demo_redisdaten:/ziel \
  -v $(pwd):/quelle \
  alpine tar xzf /quelle/redis-backup.tar.gz -C /ziel
docker compose start db
```
