# Política de seguridad

## Principios

- Privilegios mínimos: cada rol de BD tiene solo los permisos necesarios.
- Secretos fuera del repositorio: las credenciales van en .env, no en GitHub.
- Aislamiento: los servicios corren en contenedores separados.

## Roles de PostgreSQL

| Rol | Permisos | Uso |
|-----|----------|-----|
| postgres | Superusuario | Administración |
| app_ia | SELECT, INSERT en inferencias | Aplicación FastAPI |

## Restricciones del rol app_ia

NO puede:
- DELETE
- UPDATE
- DROP
- CREATE
- ALTER

Solo puede:
- INSERT
- SELECT

### Evidencia

## Manejo de secretos

- Credenciales en .env (no versionado).
- .env.example muestra la estructura sin datos reales.
- .gitignore bloquea .env, .envrc, *.env.
