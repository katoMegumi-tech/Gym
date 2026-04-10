# 体育馆场地预约系统

基于SpringBoot + Vue3 + 微信小程序的体育馆场地预约管理系统

## 技术栈

### 后端
- SpringBoot 3.1.5
- MyBatis-Plus 3.5.7
- Sa-Token 1.37.0
- MySQL 8.0
- Redis
- Knife4j (API文档)
- Argon2 (密码加密)

### 前端管理后台
- Vue 3
- Vite 4.5
- Ant Design Vue
- Pinia
- Vue Router

### 微信小程序
- 原生微信小程序框架

## 功能特性

### 用户端（小程序）
- 用户登录注册
- 场馆浏览
- 场地查询（按运动类型筛选）
- 在线预约
- 我的预约管理
- 优惠券领取使用
- 收藏场馆/场地
- 意见反馈

### 管理端（Web）
- 仪表盘统计
- 场馆管理（CRUD）
- 场地管理（CRUD）
- 预约管理（查看、取消）
- 用户管理
- 支付管理（退款）
- 优惠券管理
- 公告管理
- 反馈管理

## 快速开始

### 1. 数据库配置

```bash
# 创建数据库并导入完整脚本
mysql -u root -p < DB/gym_reservation.sql

# 或者手动执行（在MySQL命令行中）
# CREATE DATABASE gym_reservation CHARACTER SET utf8mb4;
# USE gym_reservation;
# SOURCE DB/gym_reservation.sql;
```

### 2. 后端启动

```bash
cd backend
mvn clean spring-boot:run
```

后端服务运行在: http://localhost:8080/api
API文档地址: http://localhost:8080/api/doc.html

### 3. 前端管理后台启动

```bash
cd frontend-admin
npm install
npm run dev
```

管理后台运行在: http://localhost:3000

默认管理员账号: admin / 123456

### 4. 微信小程序

1. 使用微信开发者工具打开 `frontend-miniapp` 目录
2. 在"详情-本地设置"中勾选"不校验合法域名"
3. 编译运行

测试账号: alice / 123456

## 项目结构

```
├── backend/                    # 后端项目
│   ├── src/main/java/com/gym/
│   │   ├── config/            # 配置类
│   │   ├── controller/        # 控制器
│   │   ├── entity/            # 实体类
│   │   ├── mapper/            # Mapper接口
│   │   ├── service/           # 服务层
│   │   └── util/              # 工具类
│   └── src/main/resources/
│       └── application.yml    # 配置文件
├── frontend-admin/            # 管理后台
│   ├── src/
│   │   ├── api/              # API接口
│   │   ├── assets/           # 静态资源
│   │   ├── layouts/          # 布局组件
│   │   ├── router/           # 路由配置
│   │   ├── stores/           # 状态管理
│   │   ├── utils/            # 工具函数
│   │   └── views/            # 页面组件
│   └── vite.config.js        # Vite配置
├── frontend-miniapp/          # 微信小程序
│   ├── pages/                # 页面
│   ├── utils/                # 工具函数
│   ├── app.js                # 小程序入口
│   └── app.json              # 小程序配置
└── DB/                        # 数据库脚本
    └── gym_reservation.sql    # 完整的数据库导出脚本（包含表结构和示例数据）
```

## 数据库表说明

系统包含18个数据库表：

1. role - 角色表
2. permission - 权限表
3. default_role_permission - 默认角色权限配置
4. role_permission - 角色权限关联
5. gym_user - 用户表
6. user_venue - 用户场馆关联
7. venue - 场馆表
8. court - 场地表
9. timeslot - 时间段表
10. reservation - 预约表
11. payment - 支付表
12. coupon - 优惠券表
13. user_coupon - 用户优惠券表
14. reservation_coupon - 预约优惠券关联
15. announcement - 公告表
16. feedback - 反馈表
17. favorite - 收藏表
18. operation_log - 操作日志表

## API接口

所有API接口文档可通过Knife4j访问: http://localhost:8080/api/doc.html

主要接口模块：
- /auth - 认证接口
- /users - 用户管理
- /venues - 场馆管理
- /courts - 场地管理
- /timeslots - 时间段查询
- /reservations - 预约管理
- /payments - 支付管理
- /coupons - 优惠券管理
- /announcements - 公告管理
- /feedback - 反馈管理
- /favorites - 收藏管理

## 注意事项

1. **数据库准备**
   - 确保MySQL 8.0及以上版本已安装并启动
   - 首次运行需要导入完整的数据库脚本 `DB/gym_reservation.sql`
   
2. **配置文件**
   - 修改 `backend/src/main/resources/application.yml` 中的数据库连接密码
   - 根据实际环境配置Redis连接

3. **微信小程序开发**
   - 需要在开发者工具中关闭域名校验（用于测试）
   - 生产环境需要配置真实的微信小程序AppID和AppSecret

4. **测试账号**
   - 超级管理员：superadmin / 123456（密码为argon2加密）
   - 系统管理员：admin / 123456
   - 普通用户：alice / 123456
   - 所有默认密码均为：123456

## 项目状态

### 已实现功能
- ✅ 用户认证系统（账号密码+微信登录）
- ✅ 场馆和场地管理
- ✅ 场地预约系统
- ✅ 角色权限管理
- ✅ 优惠券管理
- ✅ 公告系统
- ✅ 反馈管理
- ✅ 文件上传功能

### 功能说明

**支付功能**：当前支付功能为模拟实现，接收支付请求并更新预约状态为已支付，用于测试。
实际生产环境需要接入真实的支付网关（微信支付/支付宝）。

**文件上传**：上传的文件存储在项目的 `uploads` 目录下，包括：
- `avatars/` - 用户头像
- `venues/` - 场馆图片

生产环境建议配置文件存储服务（如阿里云OSS、七牛云等）。

## 开发团队

体育馆场地预约系统开发团队

## 许可证

MIT License
