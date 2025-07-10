#!/data/data/com.termux/files/usr/bin/bash

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} 🚀 MongoDB Installer for Termux ${NC}"
echo -e "${BLUE}=========================================${NC}"

# Step 1: Update & install dependencies
echo -e "${YELLOW}[1/6] Updating package list...${NC}"
pkg update -y && pkg upgrade -y

echo -e "${YELLOW}[2/6] Installing dependencies...${NC}"
pkg install -y tur-repo termux-services git wget curl build-essential

# Step 2: Install MongoDB
echo -e "${YELLOW}[3/6] Installing MongoDB from tur-repo...${NC}"
pkg install -y mongodb

# Step 3: Create data & log folders
echo -e "${YELLOW}[4/6] Creating data and log folders...${NC}"
mkdir -p ~/mongodb/data/cluster0
mkdir -p ~/mongodb/data/log

# Step 4: Create mongod.conf
echo -e "${YELLOW}[5/6] Creating mongod.conf file...${NC}"
cat > ~/mongodb/mongod.conf << 'EOF'
systemLog:
  destination: file
  path: /data/data/com.termux/files/home/mongodb/data/log/mongod.log
net:
  bindIp: 0.0.0.0
  port: 2025
processManagement:
  fork: false
EOF

# Step 5: Setup termux-services
echo -e "${YELLOW}[6/6] Setting up termux service for MongoDB...${NC}"
mkdir -p /data/data/com.termux/files/usr/var/service/mongod
cat > /data/data/com.termux/files/usr/var/service/mongod/run << 'EOF'
#!/data/data/com.termux/files/usr/bin/sh
exec mongod  --auth \
  --dbpath ~/mongodb/data/cluster0 \
  -f ~/mongodb/mongod.conf \
  2>&1
EOF

chmod +x /data/data/com.termux/files/usr/var/service/mongod/run

# Create log/run symlink
mkdir -p /data/data/com.termux/files/usr/var/service/mongod/log
ln -sF /data/data/com.termux/files/usr/share/termux-services/svlogger /data/data/com.termux/files/usr/var/service/mongod/log/run

echo -e "${GREEN}✅ MongoDB installation & service setup completed!${NC}"
echo -e "${BLUE}-----------------------------------------${NC}"
echo -e "${YELLOW}📌 To run MongoDB service : sv-enable mongod${NC}"
echo -e "${YELLOW}📌 To check MongoDB status: sv status mongod${NC}"
echo -e "${YELLOW}📌 To connect to MongoDB  : mongo --port 2025${NC}"
echo -e "${YELLOW}📌 MongoDB Run on Port    : 2025${NC}"
echo -e "${YELLOW}📌 Data Folder            : ~/mongodb/data/cluster0${NC}"
echo -e "${YELLOW}📌 Log File               : ~/mongodb/data/log/mongod.log${NC}"
echo -e "${YELLOW}📌 Conf File              : ~/mongodb/data/mongod.conf${NC}"
echo -e "${BLUE}-----------------------------------------${NC}"
