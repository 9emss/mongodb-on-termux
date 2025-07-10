# 📦 MongoDB on Termux (with termux-services)

This repository provides a **step-by-step guide and installer script** for running MongoDB on Android via Termux, including integration with `termux-services` to run `mongod` as a background service.

---

## 📖 Features
- Install MongoDB using the **tur-repo** (trusted user repository).
- Configure MongoDB with a custom `mongod.conf`.
- Set up `termux-services` to start/stop MongoDB as a daemon.
- Automatically configure logging and database directories.

---

## 🚀 Quick Start (One-liner Installer)

```bash
pkg install git -y
git clone https://github.com/<your-username>/termux-mongodb.git
cd termux-mongodb
bash install-mongodb.sh
```
---

## 🛠 Manual Installation Steps
1️⃣ Install Prerequisites
Install Termux and update packages:
```bash
pkg update && pkg upgrade -y
pkg install tur-repo termux-services -y
```

2️⃣ Install MongoDB
Install MongoDB from tur-repo:
```bash
pkg install mongodb -y
```

3️⃣ Create MongoDB Config
Create a custom config at:
```bash
mkdir -p mongodb/data/cluster0
mkdir -p mongodb/data/log
nano mongodb/mongod.conf
```
Paste the following configuration:
```yaml
systemLog:
  destination: file
  path: /data/data/com.termux/files/home/mongodb/data/log/mongod.log
net:
  bindIp: 0.0.0.0
  port: 2025
processManagement:
  fork: false
```

4️⃣ Setup Termux Service
Create a service directory:
```bash
mkdir -p $PREFIX/var/service/mongod/log
nano $PREFIX/var/service/mongod/run
```
Paste the run service script:
```yaml
#!/data/data/com.termux/files/usr/bin/sh
exec mongod  --auth \
  --dbpath ~/mongodb/data/cluster0 \
  -f ~/mongodb/mongod.conf \
  2>&1
```
Then run this command:
```bash
chmod +x nano $PREFIX/var/service/mongod/run

## Symlink log file
ln -sF /data/data/com.termux/files/usr/share/termux-services/svlogger $PREFIX/var/service/mongod/log/run

```

5️⃣ Enable and Start Service
```bash
## Enable service
sv-enable mongod

## Start MongoDB
sv up mongod

## Check MongoDB status
sv status mongod

// You should see something like:
run: mongod: (pid ID) 0s; run: log: (pid ID) 0s

```

## 🐚 Using MongoDB
Connect to MongoDB shell:
```bash
mongo --port 2025
```
⚠️ If you prefer the newer `mongosh`, you can try building it manually since it's not yet available in Termux repos.

## 📜 License
MIT License

## 📚 References
- [MongoDB Documentation](https://www.mongodb.com/docs/manual/)
- [Termux Wiki: termux-services](https://wiki.termux.com/wiki/Termux-services)
- [tur-repo (Trusted User Repository for Termux)](https://github.com/termux/tur-repo)
```
