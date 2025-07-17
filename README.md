# Forensic Analysis Docker Environment

This project provides a self-contained forensic analysis environment using Docker. It includes a lightweight Lubuntu desktop environment and a suite of common forensic tools.

## Prerequisites

- Docker
- Docker Compose

## Setup

1.  **Create Shared Folder:** Before you start, create a directory named `forensic_files` in this project's root directory. This folder will be mounted into the container as your shared workspace.

    ```
    ./
    ├── Dockerfile
    ├── docker-compose.yml
    └── forensic_files/  <-- Create this folder
    ```

2.  **Place Files:** Add any files you wish to analyze into the `forensic_files` directory.

## Usage

### 1. Start the Container

Open a terminal in the project root and run the following command to build (if necessary) and start the container in the background:

```bash
docker compose up -d
```

*(Note: If you modify the `Dockerfile`, run `docker compose up -d --build` to apply your changes.)*

### 2. Connect to the Desktop

You can now connect to the container's desktop environment using any Remote Desktop (RDP) client:

- **Address:** `127.0.0.1:3389`
- **Username:** `ubu`
- **Password:** `1234` (or whatever you set in your `docker-compose.yml`)

### 3. Access Your Files

Inside the Lubuntu desktop, open the file manager and navigate to the following directory:

```
/shared/workspace
```

This directory is directly linked to the `forensic_files` folder on your local machine.

### 4. Stop the Container

When you are finished with your session, run the following command from your local machine's terminal:

```bash
docker compose down
```

This will stop and remove the container, freeing up all resources. Your data in the `forensic_files` folder will not be affected.

## Included Tools

- **Lubuntu Desktop (LXQt):** A lightweight and fast desktop environment.
- **The Sleuth Kit:** A collection of command-line tools for forensic analysis of disk images.
- **Plaso (log2timeline):** A tool for creating super timelines.
- **Wireshark:** A network protocol analyzer.
- **NetworkMiner:** A Network Forensic Analysis Tool (NFAT).
- **Firefox:** A web browser.
