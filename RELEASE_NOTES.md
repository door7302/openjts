# OpenJTS 1.3.0 — Release Notes

OpenJTS **1.3.0** ships a new YANG Schema Explorer, in-app update notifications,
Chronograf HTTPS support, a backup/restore helper, and broader device coverage
across the design profiles.

- **Stack version:** `1.2.3` → `1.3.0`
- **JTSO application:** `v1.1.2` → `1.2.0`

## ✨ New Features

### YANG Schema Explorer (Tools > Yang Schema Explorer)
- Download all YANG **state data model** files directly from a device using the
  `get-schema` NETCONF RPC, then browse the schemas.
- Schemas are stored per `[platform]_[version]` on the OpenJTS VM and reused, so
  the same platform/version is only downloaded once (a **Force Download** option
  is available to refresh).
- Browse schemas as XPaths with optional **Type** and **Description** columns,
  plus search.
- Requires the following on the device:
  ```junos
  set system services netconf netconf-monitoring netconf-state-schemas retrieve-standard-yang-modules
  set system services netconf netconf-monitoring netconf-state-schemas retrieve-custom-yang-modules
  ```
- New persistent volume `./jtso/yang:/var/yang`.

### New-release notification badge
- A **yellow badge** appears in the top-right of the navigation bar when a newer
  OpenJTS release is available; clicking it opens the update procedure.

### Chronograf HTTPS support
- Chronograf configuration is now externalized via `compose/chronograf/chronograf.ini`
  and an `entrypoint.sh` loader.
- HTTPS can be enabled by uncommenting `TLS_CERTIFICATE` / `TLS_PRIVATE_KEY`
  (certificates mounted from `./grafana/cert`).
- TLS is **off by default** for all GUIs.

### Backup / restore helper (`jts_backup.sh`)
- New script to back up and restore environment and configuration files
  (`.env`, `jtso.db`, `config.yml`, `grafana.ini`, `chronograf.ini`, and
  certificates):
  ```shell
  ./jts_backup.sh backup
  ./jts_backup.sh restore
  ```

### Kafka export improvements
- Kafka export can now be enabled **per profile collection** (Profiles >
  Associations) via a **Publish to Kafka** option, with a Kafka badge indicating
  exported devices. On-demand profiles remain exportable.

### On-demand Browser
- New **Set Timeout** option to extend the default 30-second collection window
  for scaled sensor paths.

## 📈 Expanded Device Coverage

| Profile | Added platforms |
| ------- | --------------- |
| BGP     | `qfx`, `ex`, `crpd`, `vjunos`, `vevo` |
| Health  | `ex`, `vevo`, `vjunos` |
| Traffic | `qfx`, `ex` |

## 🔧 Changes

- **Update procedure** reworked (`docs/update.md`) with explicit backup and
  restore steps using `jts_backup.sh`.
- `docker-compose.yml`: Chronograf now runs with `restart: always`, externalized
  config/entrypoint, certs and data volumes; JTSO build pinned to `1.2.0`.
- Chronograf default public port moved to **TCP 8081**.
- Health dashboards consolidated: `dashboard-health-vmx.json` removed and folded
  into `dashboard-health.json`.
- Documentation and screenshots refreshed across `config.md`, `usage.md`,
  `update.md`, and `install.md`.

## 🗑️ Removals

- TWAMP `ptx` profile removed (`design_profile/twamp/ptx_twamp.json`).
- Consolidated VMX health dashboard (`dashboard-health-vmx.json`).

## ⬆️ Upgrade Notes

1. Stop the stack: `docker compose down`.
2. Back up your environment: `./jts_backup.sh backup` (recommended from 1.3.0).
3. Pull changes, remove old images, and rebuild: `docker compose build --no-cache`.
4. Restore your environment: `./jts_backup.sh restore`.
5. Restart: `docker compose up -d`.

> **Note:** Starting with 1.3.0, also back up `compose/chronograf/chronograf.ini`.
> To enable Chronograf HTTPS, uncomment the TLS lines in that file and restart
> the Chronograf container.
