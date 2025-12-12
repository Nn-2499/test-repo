#!/data/data/com.termux/files/usr/bin/bash

echo "=== สคริปต์ตั้งค่า SSH Key สำหรับ GitHub ==="
echo ""

# ตั้งค่าข้อมูลผู้ใช้
EMAIL="nekan2499@gmail.com"
GITHUB_USERNAME="Nn-2499"

echo "อีเมล: $EMAIL"
echo "GitHub Username: $GITHUB_USERNAME"
echo ""

# สร้างโฟลเดอร์ .ssh ถ้ายังไม่มี
echo "📁 กำลังสร้างโฟลเดอร์ .ssh..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# สร้าง SSH Key
echo "🔑 กำลังสร้าง SSH Key..."
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N ""

# แสดง public key
echo ""
echo "📋 Public Key ของคุณ:"
echo "========================================"
cat ~/.ssh/id_ed25519.pub
echo "========================================"
echo ""

# เพิ่ม key ไปยัง ssh-agent
echo "⚙️  กำลังเริ่มต้น ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# ตั้งค่า config
echo "📝 กำลังตั้งค่า config..."
cat > ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config

# ทดสอบการเชื่อมต่อ
echo "🔍 ทดสอบการเชื่อมต่อกับ GitHub..."
ssh -T git@github.com

echo ""
echo "✅ การตั้งค่าเสร็จสิ้น!"
echo ""
echo "📌 คำแนะนำ:"
echo "1. คัดลอก Public Key ด้านบน"
echo "2. ไปที่ https://github.com/settings/keys"
echo "3. คลิก 'New SSH key'"
echo "4. วาง key และบันทึก"
echo ""
echo "📂 ตำแหน่งไฟล์:"
echo "Private Key: ~/.ssh/id_ed25519"
echo "Public Key:  ~/.ssh/id_ed25519.pub"
