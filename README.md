# ❄️ flake

Fully featured Nix flake template, featuring nix-darwin, NixOS, home-manager, automatic CI, devShells, formatters (treefmt), and more.

---

# 🚀 Usage

To use this flake template, create a new directory and run the following command:

```bash
nix flake init -t github:alyraffauf/flake
```

---

## 📂 Repository Structure

```plaintext
.
├── flake.nix                # Main entry point
├── hosts/                   # NixOS and nix-darwin host configurations
└── modules/                 # Nix modules
    ├── darwin/              # macOS-specific modules
    ├── home/                # home-manager modules
    ├── flake/               # Organized flake components
    │   ├── darwin.nix       # macOS-specific configurations
    │   ├── home-manager.nix # home-manager configurations
    │   ├── nixos.nix        # NixOS-specific configurations
    │   └── ...              # Other flake components
    └── nixos/               # NixOS-specific modules
```

---

## 🤝 Contributing

Open to contributions! If you notice something wrong or that needs improvement with this template, please feel free to open an issue or submit a pull request.

---

## 📜 License

This repository is licensed under the **[MIT License](LICENSE.md)**.

---

## ⭐ Stargazers Over Time

[![Stargazers over time](https://starchart.cc/alyraffauf/flake.svg?variant=adaptive)](https://starchart.cc/alyraffauf/flake)

---
