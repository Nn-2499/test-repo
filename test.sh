#!/data/data/com.termux/files/usr/bin/bash

echo "=== สคริปต์สร้าง GitHub Repository ==="
echo "GitHub User: Nn-2499"
echo "Email: nekan2499@gmail.com"
echo ""

# ตรวจสอบว่าอยู่ใน Git repository หรือไม่
if [ -d ".git" ]; then
    echo "⚠️  พบ Git repository อยู่แล้วในโฟลเดอร์นี้"
    echo "ต้องการสร้าง repository ใหม่ในโฟลเดอร์ย่อยหรือไม่? (y/n): "
    read -r response
    if [[ "$response" != "y" && "$response" != "Y" ]]; then
        echo "❌ ออกจากสคริปต์"
        exit 1
    fi
fi

# รับชื่อ repository
echo "📝 ป้อนชื่อ repository (ไม่มีช่องว่าง, ใช้ - แทน): "
read -r REPO_NAME

if [ -z "$REPO_NAME" ]; then
    echo "❌ ชื่อ repository ไม่สามารถว่างได้"
    exit 1
fi

# รับคำอธิบาย repository
echo "📝 ป้อนคำอธิบาย repository (ไม่บังคับ): "
read -r REPO_DESC

# ตั้งค่าผู้ใช้ Git
echo "⚙️  ตั้งค่า Git config..."
git config --global user.name "Nn-2499"
git config --global user.email "nekan2499@gmail.com"

# สร้างโฟลเดอร์ใหม่ (ถ้าจำเป็น)
CURRENT_DIR=$(pwd)
if [ ! -d ".git" ]; then
    echo "📁 กำลังสร้าง repository ในโฟลเดอร์ปัจจุบัน..."
    
    # ตรวจสอบว่าเป็นโฟลเดอร์ว่างหรือมีไฟล์อยู่
    if [ "$(ls -A 2>/dev/null)" ]; then
        echo "📦 พบไฟล์ในโฟลเดอร์นี้ จะใช้เป็น repository เดิม"
    else
        echo "📄 สร้างไฟล์เริ่มต้น..."
        echo "# $REPO_NAME" > README.md
        echo "" >> README.md
        if [ -n "$REPO_DESC" ]; then
            echo "$REPO_DESC" >> README.md
        fi
        echo "" >> README.md
        echo "สร้างโดย: Nn-2499" >> README.md
        echo "อีเมล: nekan2499@gmail.com" >> README.md
        
        # สร้าง .gitignore สำหรับ Termux/Python
        cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
.env
.vscode/

# Termux
termux/
*.deb
*.rpm

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
    fi
else
    # สร้างโฟลเดอร์ใหม่สำหรับ repository
    echo "📁 สร้างโฟลเดอร์ใหม่: $REPO_NAME"
    mkdir -p "$REPO_NAME"
    cd "$REPO_NAME" || exit 1
    echo "# $REPO_NAME" > README.md
    if [ -n "$REPO_DESC" ]; then
        echo "" >> README.md
        echo "$REPO_DESC" >> README.md
    fi
fi

# ตรวจสอบว่าต้องใช้ Token หรือไม่
echo ""
echo "🔐 ต้องการใช้ GitHub Token สำหรับสร้าง repository? (y/n): "
read -r USE_TOKEN

GITHUB_USER="Nn-2499"
REPO_URL=""

if [[ "$USE_TOKEN" == "y" || "$USE_TOKEN" == "Y" ]]; then
    echo "📝 ป้อน GitHub Token (สร้างได้ที่: https://github.com/settings/tokens): "
    echo "⚠️  Token จะไม่แสดงบนหน้าจอ: "
    read -rs GITHUB_TOKEN
    echo ""
    
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "🌐 กำลังสร้าง repository บน GitHub..."
        
        # สร้าง repository ผ่าน GitHub API
        RESPONSE=$(curl -s -X POST \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/user/repos \
            -d "{\"name\":\"$REPO_NAME\",\"description\":\"$REPO_DESC\",\"private\":false}")
        
        if echo "$RESPONSE" | grep -q '"clone_url"'; then
            REPO_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
            echo "✅ สร้าง repository สำเร็จ: https://github.com/$GITHUB_USER/$REPO_NAME"
        else
            echo "❌ ไม่สามารถสร้าง repository ได้"
            echo "Response: $RESPONSE"
            echo ""
            echo "สร้าง repository ด้วยวิธี manual แทน..."
            REPO_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
        fi
    fi
else
    echo "ℹ️  จะสร้าง repository แบบ manual"
    echo "โปรดสร้าง repository ที่: https://github.com/new"
    echo "ชื่อ repository: $REPO_NAME"
    echo "คำอธิบาย: $REPO_DESC"
    echo ""
    echo "กด Enter เมื่อสร้าง repository เสร็จแล้ว..."
    read -r
    
    REPO_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
fi

# เริ่มต้น Git repository
echo "🐙 เริ่มต้น Git repository..."
git init
git add .
git commit -m "Initial commit"

# เพิ่ม remote origin
echo "🔗 เพิ่ม remote origin..."
git remote add origin "$REPO_URL"

# ตั้งค่า branch หลัก
git branch -M main

# พยายาม push
echo "🚀 พยายาม push ไปยัง GitHub..."
if git push -u origin main; then
    echo "✅ Push สำเร็จ!"
else
    echo "⚠️  ไม่สามารถ push ได้ หรือ repository ยังไม่ได้สร้างบน GitHub"
    echo ""
    echo "คำแนะนำเพิ่มเติม:"
    echo "1. สร้าง repository ที่: https://github.com/new"
    echo "2. ชื่อ: $REPO_NAME"
    echo "3. คำอธิบาย: $REPO_DESC"
    echo "4. แล้วรันคำสั่งต่อไปนี้:"
    echo ""
    echo "git remote add origin $REPO_URL"
    echo "git push -u origin main"
fi

echo ""
echo "📊 สรุป:"
echo "Repository: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "Local directory: $(pwd)"
echo "Remote URL: $REPO_URL"
echo ""
echo "✅ เสร็จสิ้น!"
