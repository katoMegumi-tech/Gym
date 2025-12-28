# 体育馆场地预约系统业务场景设计图

## 图4.1 用户预约场地类图

```mermaid
classDiagram
    direction LR
    class User {
        -Long id
        -String username
        -String phone
        -String status
        +login()
        +updateInfo()
    }
    
    class Court {
        -Long id
        -String name
        -String sportType
        -String status
        +getCourtInfo()
    }
    
    class Timeslot {
        -Long id
        -Date slotDate
        -Time startTime
        -BigDecimal price
        -String status
        +checkAvailable()
    }
    
    class Reservation {
        -Long id
        -String reservationNo
        -Date slotDate
        -BigDecimal amount
        -String status
        +createReserve()
        +updateStatus()
    }
    
    class Payment {
        -Long id
        -String paymentNo
        -BigDecimal amount
        -String paymentStatus
        +processPayment()
    }
    
    User "1" --> "*" Reservation
    Court "1" --> "*" Timeslot
    Court "1" --> "*" Reservation
    Reservation "1" --> "1" Payment
```

## 图4.2 用户预约场地时序图

```mermaid
sequenceDiagram
    autonumber
    participant U as 用户
    participant MP as 小程序
    participant CC as CourtController
    participant CS as CourtService
    participant TC as TimeslotController
    participant TS as TimeslotService
    participant RC as ReservationController
    participant RS as ReservationService
    participant PC as PaymentController
    participant PS as PaymentService
    participant DB as 数据库
    
    U->>MP: 登录并浏览场地
    MP->>CC: GET /courts
    CC->>CS: 查询场地
    CS->>DB: 查询数据
    DB-->>CS: 返回场地列表
    CS-->>MP: 返回结果
    
    U->>MP: 选择场地和日期
    MP->>TC: GET /timeslots
    TC->>TS: 查询时间段
    TS->>DB: 查询可用时间
    DB-->>TS: 返回时间段
    TS-->>MP: 返回可用时间段
    
    U->>MP: 填写信息并提交
    MP->>RC: POST /reservations
    RC->>RS: 创建预约
    RS->>DB: 存储预约
    DB-->>RS: 返回预约ID
    RS-->>MP: 返回订单信息
    
    U->>MP: 完成支付
    MP->>PC: POST /payments
    PC->>PS: 处理支付
    PS->>DB: 更新订单状态
    DB-->>PS: 返回结果
    PS-->>MP: 支付成功
    MP-->>U: 预约成功
```

## 图4.3 场馆管理类图

```mermaid
classDiagram
    direction LR
    class Admin {
        -Long id
        -String username
        -String phone
        -String status
        +login()
        +verifyPermission()
    }
    
    class Venue {
        -Long id
        -String name
        -String address
        -Time openTime
        -String status
        +createVenue()
        +updateVenue()
        +deleteVenue()
    }
    
    class OperationLog {
        -Long id
        -Long userId
        -String action
        -String module
        -DateTime createdAt
        +createLog()
    }
    
    Admin "1" --> "*" Venue : 管理
    Admin "1" --> "*" OperationLog : 产生
```

## 图4.4 场馆管理时序图

```mermaid
sequenceDiagram
    autonumber
    participant A as 管理员
    participant W as 管理后台
    participant VC as VenueController
    participant VS as VenueService
    participant FS as FileService
    participant OLS as OperationLogService
    participant DB as 数据库
    
    A->>W: 登录并进入场馆管理
    A->>W: 点击新增场馆
    W->>VC: GET /venues/form
    VC-->>W: 返回表单配置
    
    A->>W: 填写信息并上传图片
    W->>FS: POST /files
    FS->>DB: 保存文件
    DB-->>FS: 返回URL
    FS-->>W: 返回图片URL
    
    A->>W: 提交表单
    W->>VC: POST /venues
    VC->>VS: 验证并创建
    VS->>DB: 存储场馆
    DB-->>VS: 返回场馆ID
    
    VS->>OLS: 记录操作日志
    OLS->>DB: 存储日志
    DB-->>OLS: 返回结果
    OLS-->>VS: 完成记录
    
    VS-->>VC: 返回成功
    VC-->>W: 创建成功
    W-->>A: 显示成功提示
```

## 使用说明

### 方法1：在线渲染（推荐）
1. 访问 https://mermaid.live/
2. 复制上面的Mermaid代码
3. 粘贴到编辑器中
4. 调整样式
5. 导出为PNG或SVG格式

### 方法2：使用支持Mermaid的工具
- **Typora**：直接支持Mermaid渲染
- **VS Code**：安装Mermaid Preview插件
- **Notion**：支持Mermaid代码块
- **GitHub/GitLab**：Markdown中直接支持

### 方法3：使用Draw.io重绘
如果Mermaid渲染效果不理想，可以参考这些图的结构在Draw.io中手动绘制：

#### 类图绘制要点：
1. 使用矩形框表示类
2. 分为三部分：类名、属性、方法
3. 使用箭头表示关联关系
4. 标注多重性（1, *, 0..1等）

#### 时序图绘制要点：
1. 顶部横向排列参与对象
2. 使用虚线表示对象生命线
3. 使用实线箭头表示消息传递
4. 按时间顺序从上到下排列
5. 标注序号和消息内容

### 样式建议

#### 类图样式：
- 类框：白色填充，黑色边框
- 属性前缀：- 表示private，+ 表示public
- 关联线：实线箭头
- 多重性：标注在关联线两端

#### 时序图样式：
- 参与者框：浅蓝色填充
- 生命线：虚线
- 消息箭头：实线箭头
- 返回箭头：虚线箭头
- 序号：标注在箭头上方

## 图表说明

### 图4.1 用户预约场地类图
展示了用户预约场地涉及的5个核心类及其关系：
- User类：用户信息和操作
- Court类：场地信息
- Timeslot类：时间段管理
- Reservation类：预约订单
- Payment类：支付处理

### 图4.2 用户预约场地时序图
展示了从用户登录到完成支付的完整交互流程，包含43个步骤，涉及：
- 前端：用户、小程序
- 后端：4个Controller、4个Service、4个Mapper
- 数据库：MySQL

### 图4.3 场馆管理类图
展示了场馆管理涉及的3个核心类及其关系：
- Admin类：管理员信息和权限
- Venue类：场馆信息和操作
- OperationLog类：操作日志记录

### 图4.4 场馆管理时序图
展示了管理员创建场馆的完整交互流程，包含29个步骤，涉及：
- 前端：管理员、管理后台
- 后端：VenueController、VenueService、FileService、OperationLogService及对应Mapper
- 数据库：MySQL

## 导出建议

### 导出为PNG（推荐用于Word）
1. 在mermaid.live中渲染
2. 点击"Actions" → "PNG"
3. 选择合适的分辨率（建议2x或3x）
4. 下载并插入Word文档

### 导出为SVG（推荐用于高质量打印）
1. 在mermaid.live中渲染
2. 点击"Actions" → "SVG"
3. 下载SVG文件
4. 可以在Word中插入或转换为其他格式