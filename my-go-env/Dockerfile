# 基于 Ubuntu 22.04 构建轻量 Go 开发环境（无 C 编译器）
FROM ubuntu:22.04

# 设置环境变量避免交互式安装时的提示
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 更新包管理器并安装基础工具（使用 --no-install-recommends 避免安装构建工具）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    unzip \
    openssh-server \
    sudo \
    tzdata \
    ca-certificates \
    zsh \
    python3 \
    python3-pip \
    python3-venv \
    fzf \
    && rm -rf /var/lib/apt/lists/* \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装 Go 1.25
ENV GO_VERSION=1.25.0
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# 安装 Go，创建工作目录，验证安装
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && mkdir -p $GOPATH/src $GOPATH/bin $GOPATH/pkg \
    && go version

# 创建用户，配置 SSH，设置密码
RUN useradd -m -s /bin/zsh -G sudo developer \
    && echo 'developer:developer' | chpasswd \
    && echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir /var/run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
    && echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config \
    && echo 'AuthorizedKeysFile .ssh/authorized_keys' >> /etc/ssh/sshd_config \
    && echo 'root:root123' | chpasswd

# 为 developer 用户设置 SSH 目录和环境
USER developer

# 配置 developer 用户环境：SSH目录 + oh-my-zsh + 环境变量 + 别名 + fzf
RUN mkdir -p /home/developer/.ssh \
    && chmod 700 /home/developer/.ssh \
    && touch /home/developer/.ssh/authorized_keys \
    && chmod 600 /home/developer/.ssh/authorized_keys \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended \
    && echo 'alias python=python3' >> /home/developer/.zshrc \
    && echo 'alias pip=pip3' >> /home/developer/.zshrc \
    && echo 'export GOROOT=/usr/local/go' >> /home/developer/.zshrc \
    && echo 'export GOPATH=/go' >> /home/developer/.zshrc \
    && echo 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH' >> /home/developer/.zshrc \
    && echo 'cd /workspace' >> /home/developer/.zshrc \
    && echo '[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh' >> /home/developer/.zshrc \
    && echo '[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh' >> /home/developer/.zshrc

# 切换回 root 用户
USER root

# 创建工作目录
RUN mkdir -p /workspace \
    && chown developer:developer /workspace

# 复制启动脚本并设置权限
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# 设置工作目录
WORKDIR /workspace

# 暴露端口
EXPOSE 22

# 启动命令
CMD ["/usr/local/bin/start.sh"]
