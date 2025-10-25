# ⚙️ Universal Nuitka Build Script  
### By [Laroussi Boulanouar](https://laroussigsm.net/)

---
## 📖 Description:
The Universal Nuitka Build Script is a fully automated batch tool designed to simplify the process of converting Python projects — particularly PySide6-based GUI applications — into standalone Windows executables (.exe) using Nuitka.

It provides an interactive, user-friendly interface directly in the command prompt, automatically handles dependencies, checks Python versions, installs required packages, and supports SQLite, MySQL, or both database engines.

Whether you're a developer, engineer, or hobbyist, this script offers a professional, flexible, and ready-to-use build system for Python desktop applications.

---

<img width="1366" height="720" alt="2025-10-25_111527" src="https://github.com/user-attachments/assets/2f6eb2ac-300a-44a8-b71c-f3547f3c4d6c" />


## 🚀 Features:

✅ Auto Environment Detection
- Automatically detects your Python version.
- Warns about unsupported Python 3.13 and provides a fix (MSVC compiler mode).

✅ Smart Compiler Selection
- Automatically chooses between MinGW64 or MSVC (Visual Studio Build Tools).

✅ Virtual Environment Integration
- Detects and activates your virtual environment (venv) automatically.

✅ Dependency Management
- Installs or updates Nuitka, PySide6, and MySQL Connector (if needed).

✅ Configurable Build Options
- Main script name (main.py by default)
- Output directory
- Product and company name
- Database engine selection (SQLite, MySQL, or Both)
- Single-file mode (--onefile) or standalone directory

✅ Automatic Configuration File Generation
- Creates config/app.ini with essential application and database settings.

✅ Smart Data Inclusion
- Automatically includes directories like config, db, qss, icons, json, ui, and themes.
- Skips pure Python folders intelligently.

✅ One-File or Standalone Build Modes
- Choose between a single executable file or a standalone folder build.

✅ Version Metadata Support
- Automatically embeds metadata such as:
- Company name
- Product name
- File version and description
- Application icon

✅ Automatic Cleanup & Rebuild
- Removes previous builds before recompiling to ensure clean outputs.

✅ User-Friendly Output Summary
- Displays build result and opens the output folder automatically.

---

<img width="1360" height="768" alt="170301 069" src="https://github.com/user-attachments/assets/1ee3dbdb-5fd9-4573-b93c-1798e9cdcaa9" />


## 🧠 Supported Technologies:

- Python 3.7 → 3.12
- Nuitka Compiler
- PySide6 / Qt6
- MySQL (via mysql-connector-python)
- SQLite
- Windows OS (x64)

## 🏗️ Example Build Workflow:

1- Place your main script (e.g., main.py) in your project root.

2- Run the script:
```sh
Universal_Build.bat
```
3- Place your main script (e.g., main.py) in your project root.
Run the script:
- Choose database type (MySQL / SQLite)
- Choose onefile or folder build
- Confirm project metadata

4- The script automatically:
- Installs Nuitka (if missing)
- Includes all non-Python resource folders
- Builds your .exe using Nuitka
- Opens the output folder

## 🧾 Example Command Output:

```sh
Detected Python version: 3.12.6
Building as ONEFILE executable...
Including folder: config
Including folder: db
Including folder: qss
Building main.py with Nuitka...
Build successful!
Output file:
   dist\main.exe
```

## 🧑‍💻 Example Generated Configuration:

```sh
[app]
product_name=MyApplication

[database]
engine=mysql
mysql_host=localhost
mysql_port=3306
mysql_user=root
mysql_password=
mysql_database=MyApplication
sqlite_path=db/app.db
```

<img width="1360" height="768" alt="170345 543" src="https://github.com/user-attachments/assets/d1d00ad4-ba6d-41a3-bcd6-e2f758bba420" />

## 🪄 Advantages Over Manual Nuitka Commands:

- Environment detection
- Dependency installation
- Auto-database setup
- Data folder inclusion
- Clean build automation
- Interactive user input
- Single/Multiple DB support
- MSVC/MinGW64 auto switch

## 🧱 Folder Structure Example:

```sh
MyProject/
│
├── main.py
├── app.ico
├── config/
│   └── app.ini
├── db/
│   └── app.db
├── qss/
│   └── style.qss
├── ui/
│   └── main_window.ui
├── themes/
│   └── dark.qss
└── Universal_Build.bat
```

## 📦 Output Example:
OneFile Mode:

```sh
dist/
 └── main.exe
```
Standalone Mode:

```sh
dist/
 └── main.dist/
     ├── main.exe
     ├── PySide6/
     ├── platforms/
     └── imageformats/
```

## ⚠️ Requirements:

- Windows 10/11 (x64)
- Python 3.7–3.12
- Nuitka installed (pip install nuitka)
- Optional: Visual Studio Build Tools for Python 3.13+
- Optional: MySQL Connector (pip install mysql-connector-python)

## 💬 Author Information:

👨‍💻 Developer: Laroussi Boulanouar
🌐 Website: https://laroussigsm.net/
📘 Facebook: facebook.com/LaroussiGsm
💬 Telegram: t.me/laroussigsm

## 📜 License:

This project is released under the MIT License, allowing full use, modification, and distribution — provided proper credit is given to the original author.

## 🏁 Tagline:

```sh
Universal Nuitka Build Script –
A professional, intelligent, and flexible compiler assistant for PySide6 and database-powered Python projects.
Created with passion by Laroussi Boulanouar 💻🔥
```

