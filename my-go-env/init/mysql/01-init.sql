-- Go 开发环境初始化数据库脚本

-- 创建示例数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS go_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE go_dev;

-- 创建用户表示例
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    avatar_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建文章表示例
CREATE TABLE IF NOT EXISTS articles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    author_id BIGINT NOT NULL,
    category VARCHAR(50),
    tags JSON,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    view_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_author_id (author_id),
    INDEX idx_category (category),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    FULLTEXT idx_title_content (title, content),
    
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入示例数据
INSERT INTO users (username, email, password_hash, full_name) VALUES
('developer', 'developer@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Developer User'),
('admin', 'admin@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User'),
('testuser', 'test@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Test User')
ON DUPLICATE KEY UPDATE username=VALUES(username);

INSERT INTO articles (title, content, author_id, category, tags, status) VALUES
('Go 语言入门指南', '这是一篇关于 Go 语言基础知识的文章...', 1, 'programming', '["go", "programming", "tutorial"]', 'published'),
('Docker 容器化实践', '介绍如何使用 Docker 进行应用容器化...', 1, 'devops', '["docker", "containerization", "devops"]', 'published'),
('微服务架构设计', '探讨现代微服务架构的设计原则和实践...', 2, 'architecture', '["microservices", "architecture", "design"]', 'draft')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- 创建配置表
CREATE TABLE IF NOT EXISTS configs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO configs (config_key, config_value, description) VALUES
('app_name', 'Go Development Environment', '应用名称'),
('version', '1.0.0', '应用版本'),
('debug_mode', 'true', '调试模式开关'),
('max_upload_size', '10485760', '最大上传文件大小（字节）')
ON DUPLICATE KEY UPDATE config_value=VALUES(config_value);

-- 显示创建结果
SHOW TABLES;
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS article_count FROM articles;
SELECT COUNT(*) AS config_count FROM configs;
