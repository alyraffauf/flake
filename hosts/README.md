# 🖥️ Hosts

This directory contains NixOS or nix-darwin configurations for particular devices. Each subdirectory corresponds to a specific host, encapsulating its unique setup and specifications.

---

## 📂 Directory Structure

The `hosts/` directory is organized as follows:

```plaintext
hosts/
├── host1/
├── host2/
└── host3/
```

---

## 🛠️ Provisioning New Devices

To add a new device to this configuration, follow these steps:

1. **Create Host Configuration**:
   - Duplicate an existing host directory within `hosts/` and rename it to the new device's hostname.
   - Modify the `default.nix` and other relevant Nix modules (e.g., `disko.nix`, `hardware.nix`, `home.nix`) to match the new device's specifications.

1. **Update `flake.nix`**:
   - Add the new host to the `nixosConfigurations` section in `modules/flake/nixos.nix`.

1. **Install NixOS**:
   - Install NixOS on the new device using this flake.

---
