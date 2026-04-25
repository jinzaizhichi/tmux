#!/usr/bin/env bash

# 定义颜色
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}==> 开始独立部署 Tmux 配置...${NC}"

# 1. 下载配置文件 (如果是克隆了整个库，则直接链接)
if [ -f "dot_tmux.conf.tmpl" ]; then
    # 如果是从 chezmoi 仓库拷过来的，去掉 .tmpl 后缀
    cp dot_tmux.conf.tmpl ~/.tmux.conf
elif [ -f "tmux.conf" ]; then
    cp tmux.conf ~/.tmux.conf
fi

# 2. 安装 TPM
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo -e "${BLUE}==> 安装 TPM 管理器...${NC}"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# 3. 自动安装插件
echo -e "${BLUE}==> 正在后台下载插件...${NC}"
if command -v tmux &> /dev/null; then
    # 启动临时 server 安装并关闭
    tmux start-server
    tmux new-session -d
    "$TPM_DIR/bin/install_plugins"
    tmux kill-server
    echo -e "${GREEN}==> 插件安装成功！${NC}"
else
    echo -e "${BLUE}==> 提示: 请手动安装 tmux 软件包后运行 'Prefix + I' 安装插件${NC}"
fi

echo -e "${GREEN}==> 部署完成。${NC}"
