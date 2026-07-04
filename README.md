# Inception.1337


1. **Containers vs VMs vs processes** — why Docker exists at all
2. **Images, layers, Dockerfiles** — why no `latest` tag, why a specific base image
3. **PID 1 and `exec`** — why no `tail -f` / `sleep infinity`
4. **Env vars vs Docker secrets** — the confidentiality model
5. **Docker networking** — bridge networks, service discovery, why `-link`/`host` are banned
6. **Volumes vs bind mounts** — persistence model
7. **TLS basics** — what "TLS 1.2/1.3 only" actually means
8. **The 3-tier architecture** — nginx → php-fpm → mariadb, and why php-fpm has no bundled server
9. **WordPress specifics** — wp-config, wp-cli, the two-user requirement
10. **Docker Compose orchestration** — how the pieces get wired together
11. **Full request lifecycle** — tracing one HTTP request through the whole stack
12. **Defense mechanics** — how evaluators probe, and the live-modification test