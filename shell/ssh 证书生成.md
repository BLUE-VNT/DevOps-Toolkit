# 安装
sudo apt update
sudo apt install -y putty-tools

# 生成 RSA 4096 私钥（PuTTY 格式）
puttygen -t rsa -b 4096 -C "ec2-user" -o aws-key.ppk

# 导出 PEM 格式私钥
puttygen aws-key.ppk -O private-openssh -o aws-key.pem

# 导出 AWS 可导入的公钥
puttygen aws-key.ppk -O public-openssh -o aws-key.pub

# 如果 -O private-openssh 不支持，可改用：
puttygen aws-key.ppk -O private-openssh-new -o aws-key.pem

# 设置权限
chmod 400 aws-key.pem
chmod 644 aws-key.pub