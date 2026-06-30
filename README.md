```markdown
# FitTrackee Installer for Debian 12

**One-click installer** for [FitTrackee](https://github.com/SamR1/FitTrackee) — a self-hosted outdoor activity tracker.

This script automates the complete installation of FitTrackee on a fresh **Debian 12** (netinstall recommended).

---

## ✨ Features

- Fully automated installation
- Creates isolated Python virtual environment
- Sets up PostgreSQL + PostGIS database
- Creates admin user
- Configures systemd service for autostart
- Supports update command
- Colorful console output

---

## 📥 Installation

### 1. Download the script

```bash
wget https://github.com/YOURUSERNAME/fittrackee-installer/raw/main/fittrackee_installer_v0.9.1.sh
chmod +x fittrackee_installer_v0.9.1.sh
```

### 2. Run the installer

```bash
sudo ./fittrackee_installer_v0.9.1.sh -i
```

During installation you can customize:
- Admin username & password
- PostgreSQL credentials
- Host and port

---

## 🔧 Usage

| Command | Description |
|--------|-------------|
| `-i`   | Install FitTrackee (first time) |
| `-u`   | Update FitTrackee to latest version |
| `-h`   | Show help |
| `-si`  | Show script information |

### Example: Update

```bash
sudo ./fittrackee_installer_v0.9.1.sh -u
```

---

## 🌐 Access

After installation, open your browser:

**http://YOUR-SERVER-IP:5000**

**Default admin credentials** (change them immediately!):
- Email: `admin@root.net`
- Password: `admin123` (or the one you set)

---

## 📁 Installed Locations

- Application: `~/fittrackee/`
- Virtual Environment: `~/fittrackee/fittrackee_venv/`
- Uploads: `~/fittrackee/uploads/`
- Config: `~/fittrackee/env.cfg`
- Service: `/etc/systemd/system/fittrackee.service`
- Start script: `/usr/local/bin/start_fittrackee.sh`

---

## 🔄 Changelog

**v0.9.1** (current)
- Added PostGIS support
- Improved compatibility with FitTrackee 1.0.7+

See full changelog at the bottom of the installer script.

---

## ⚠️ Important Notes

- Run on a **fresh Debian 12** installation for best results
- The script must **not** be executed as root (it uses `sudo` internally)
- Change default passwords immediately after installation
- For production use, consider setting up a reverse proxy (Nginx/Caddy) with HTTPS

---

## 📜 License

The installer script is licensed under **CC BY-NC-SA**.

FitTrackee itself is licensed under AGPLv3.

---

## 🙏 Credits

- Original FitTrackee: [SamR1](https://github.com/SamR1/FitTrackee)
- Script author: **speefak** (`itoss@gmx.de`)


--------------------------------------------------------------------------------------------------------------

This script was created and published free of charge for the open source community.
If you find it useful and would like to support future development, consider making a small donation:

    Bitcoin (BTC): 33AXe8Z8XBuGKx9eHHmGnvbawrNYjSgDcM

    Ethereum (ETH): 0xa61d178EA84C2200A8617b51B4bCf98F87ff59Ff

    Solana (SOL): BDf5EgsN8fRUicYzeM8cuaNhL7zdty2qsEj2mC2jA4Fm

    Ripple (XRP): rLHzPsX6oXkzU2qL12kHCH8G8cnZv1rBJh

    Cardano (ADA): addr1q8anur2wvvc6pv3cpp30vv05makyra8huh0lk0yhdk6hcnlrzr27g03klu862usxqsru794d03gzkk8n86ta34n85z0svn5ams   

    USTether (USDT): 0xa61d178EA84C2200A8617b51B4bCf98F87ff59Ff


Thank you for your support! 🙏
