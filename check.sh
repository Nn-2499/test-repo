#!/data/data/com.termux/files/usr/bin/bash

echo "=== ตรวจสอบสถานะ SSH ==="
echo ""

echo "📁 ตรวจสอบไฟล์ใน ~/.ssh:"
ls -la ~/.ssh/

echo ""
echo "🔑 ตรวจสอบ SSH Key:"
ssh-add -l

echo ""
echo "🌐 ทดสอบเชื่อมต่อ GitHub:"
ssh -T git@github.com

echo ""
echo "⚙️  Git Config && Repository:"
git init
git config --global user.name "Nn-2499"
git config --global user.email "nekan2499@gmail.com"
echo "# Test Project(ssh-key)"> README.md
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin git@github.com:Nn-2499/test-repo.git
git push -u origin main










