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

1. The VIP List (Linux Groups)
In Linux, security is everything. Every file, folder, and application checks who you are before letting you do anything. To make managing permissions easier, Linux uses Groups. Think of a group like a VIP list for a specific club. If your username is on the list, you are granted access to whatever that group controls.

2. The Docker Daemon (The Engine)
When you installed Docker, it started a continuous background program called the Docker Daemon (dockerd). This daemon is the heavy lifter—it talks directly to the Linux kernel to create isolated networks, allocate hard drive space, and spawn your containers.

Because doing those things deeply affects the host machine, the Docker Daemon strictly runs as the root user (the ultimate system administrator).

3. The Problem
By default, if a normal, non-root user (like oait-si-) types a command like docker ps to see running containers, the daemon looks at the user, sees they aren't the root administrator, and immediately blocks them with a Permission Denied error.

If we left it like this, you would be forced to type sudo docker... or switch to the su - root user every single time you wanted to run a project command. That gets incredibly tedious.

4. The Solution: The Docker Group
When Docker is installed, it automatically creates a special new Linux group literally just called docker. It configures the daemon with a strict rule: "If a user is not root, but they are on this VIP list, allow them to give you commands."

When you ran the command usermod -aG docker oait-si-:

usermod: Modify a user account.

-aG docker: Append the user to a secondary Group named docker.

oait-si-: Your specific username.

By adding yourself to that group, you gave your normal user account the permanent VIP pass required to control the Docker engine safely and easily from your Mac terminal.