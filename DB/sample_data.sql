USE gym_reservation;

-- ============== 权限数据 ==============
-- 1. 插入角色数据
INSERT INTO role (id, role_code, role_name, description, is_system, status) VALUES
(1, 'SUPER_ADMIN', '超级管理员', '系统超级管理员，拥有所有权限', true, 'ACTIVE'),
(2, 'ADMIN', '系统管理员', '系统管理员，管理整个系统', true, 'ACTIVE'),
(3, 'VENUE_MANAGER', '场馆管理员', '场馆管理员，管理指定场馆', false, 'ACTIVE'),
(4, 'USER', '普通用户', '普通用户，可以预约场地', true, 'ACTIVE');

-- 2. 插入权限数据
INSERT INTO permission (id, perm_code, perm_name, perm_type, parent_id, path, component, icon, sort_order, description) VALUES
-- 系统管理
(1, 'SYSTEM', '系统管理', 'MENU', 0, '/admin', NULL, 'system', 1, '系统管理菜单'),
(2, 'SYSTEM:USER', '用户管理', 'MENU', 1, '/admin/users', 'UserManagement', 'user', 1, '用户管理'),
(3, 'SYSTEM:USER:LIST', '用户列表', 'API', 2, '/api/admin/users', NULL, NULL, 1, '查看用户列表'),
(4, 'SYSTEM:USER:CREATE', '创建用户', 'API', 2, '/api/admin/users', NULL, NULL, 2, '创建用户'),
(5, 'SYSTEM:USER:UPDATE', '更新用户', 'API', 2, '/api/admin/users/*', NULL, NULL, 3, '更新用户'),
(6, 'SYSTEM:USER:DELETE', '删除用户', 'API', 2, '/api/admin/users/*', NULL, NULL, 4, '删除用户'),

(7, 'SYSTEM:ROLE', '角色管理', 'MENU', 1, '/admin/roles', 'RoleManagement', 'role', 2, '角色管理'),
(8, 'SYSTEM:ROLE:LIST', '角色列表', 'API', 7, '/api/admin/roles', NULL, NULL, 1, '查看角色列表'),
(9, 'SYSTEM:ROLE:CREATE', '创建角色', 'API', 7, '/api/admin/roles', NULL, NULL, 2, '创建角色'),
(10, 'SYSTEM:ROLE:UPDATE', '更新角色', 'API', 7, '/api/admin/roles/*', NULL, NULL, 3, '更新角色'),
(11, 'SYSTEM:ROLE:DELETE', '删除角色', 'API', 7, '/api/admin/roles/*', NULL, NULL, 4, '删除角色'),

-- 场馆管理
(20, 'VENUE', '场馆管理', 'MENU', 0, '/admin/venues', NULL, 'venue', 2, '场馆管理菜单'),
(21, 'VENUE:LIST', '场馆列表', 'API', 20, '/api/venues', NULL, NULL, 1, '查看场馆列表'),
(22, 'VENUE:CREATE', '创建场馆', 'API', 20, '/api/venues', NULL, NULL, 2, '创建场馆'),
(23, 'VENUE:UPDATE', '更新场馆', 'API', 20, '/api/venues/*', NULL, NULL, 3, '更新场馆'),
(24, 'VENUE:DELETE', '删除场馆', 'API', 20, '/api/venues/*', NULL, NULL, 4, '删除场馆'),

-- 场地管理
(30, 'COURT', '场地管理', 'MENU', 0, '/admin/courts', NULL, 'court', 3, '场地管理菜单'),
(31, 'COURT:LIST', '场地列表', 'API', 30, '/api/courts', NULL, NULL, 1, '查看场地列表'),
(32, 'COURT:CREATE', '创建场地', 'API', 30, '/api/courts', NULL, NULL, 2, '创建场地'),
(33, 'COURT:UPDATE', '更新场地', 'API', 30, '/api/courts/*', NULL, NULL, 3, '更新场地'),
(34, 'COURT:DELETE', '删除场地', 'API', 30, '/api/courts/*', NULL, NULL, 4, '删除场地'),

-- 预约管理
(40, 'RESERVATION', '预约管理', 'MENU', 0, '/admin/reservations', NULL, 'reservation', 4, '预约管理菜单'),
(41, 'RESERVATION:LIST', '预约列表', 'API', 40, '/api/reservations', NULL, NULL, 1, '查看预约列表'),
(42, 'RESERVATION:UPDATE', '更新预约', 'API', 40, '/api/reservations/*', NULL, NULL, 2, '更新预约状态'),
(43, 'RESERVATION:DELETE', '删除预约', 'API', 40, '/api/reservations/*', NULL, NULL, 3, '删除预约'),

-- 用户功能
(50, 'USER_FUNC', '用户功能', 'MENU', 0, '/', NULL, 'user-func', 5, '用户功能菜单'),
(51, 'USER_FUNC:RESERVE', '预约场地', 'API', 50, '/api/reservations/my', NULL, NULL, 1, '预约场地'),
(52, 'USER_FUNC:MY_RESERVATIONS', '我的预约', 'API', 50, '/api/users/my/reservations', NULL, NULL, 2, '查看我的预约'),
(53, 'USER_FUNC:FAVORITES', '我的收藏', 'API', 50, '/api/users/my/favorites', NULL, NULL, 3, '管理收藏'),
(54, 'USER_FUNC:FEEDBACK', '意见反馈', 'API', 50, '/api/feedback/my', NULL, NULL, 4, '提交反馈');

-- 3. 插入默认角色权限配置
INSERT INTO default_role_permission (role_code, permission_id, is_required) VALUES
-- 超级管理员：所有权限
('SUPER_ADMIN', 1, true), ('SUPER_ADMIN', 2, true), ('SUPER_ADMIN', 3, true), ('SUPER_ADMIN', 4, true), ('SUPER_ADMIN', 5, true), ('SUPER_ADMIN', 6, true),
('SUPER_ADMIN', 7, true), ('SUPER_ADMIN', 8, true), ('SUPER_ADMIN', 9, true), ('SUPER_ADMIN', 10, true), ('SUPER_ADMIN', 11, true),
('SUPER_ADMIN', 20, true), ('SUPER_ADMIN', 21, true), ('SUPER_ADMIN', 22, true), ('SUPER_ADMIN', 23, true), ('SUPER_ADMIN', 24, true),
('SUPER_ADMIN', 30, true), ('SUPER_ADMIN', 31, true), ('SUPER_ADMIN', 32, true), ('SUPER_ADMIN', 33, true), ('SUPER_ADMIN', 34, true),
('SUPER_ADMIN', 40, true), ('SUPER_ADMIN', 41, true), ('SUPER_ADMIN', 42, true), ('SUPER_ADMIN', 43, true),
('SUPER_ADMIN', 50, true), ('SUPER_ADMIN', 51, true), ('SUPER_ADMIN', 52, true), ('SUPER_ADMIN', 53, true), ('SUPER_ADMIN', 54, true),

-- 系统管理员：除用户管理外的所有权限
('ADMIN', 20, true), ('ADMIN', 21, true), ('ADMIN', 22, true), ('ADMIN', 23, true), ('ADMIN', 24, true),
('ADMIN', 30, true), ('ADMIN', 31, true), ('ADMIN', 32, true), ('ADMIN', 33, true), ('ADMIN', 34, true),
('ADMIN', 40, true), ('ADMIN', 41, true), ('ADMIN', 42, true), ('ADMIN', 43, true),
('ADMIN', 50, true), ('ADMIN', 51, true), ('ADMIN', 52, true), ('ADMIN', 53, true), ('ADMIN', 54, true),

-- 场馆管理员：场馆和场地管理权限
('VENUE_MANAGER', 20, true), ('VENUE_MANAGER', 21, true), ('VENUE_MANAGER', 23, false),
('VENUE_MANAGER', 30, true), ('VENUE_MANAGER', 31, true), ('VENUE_MANAGER', 32, true), ('VENUE_MANAGER', 33, true),
('VENUE_MANAGER', 40, true), ('VENUE_MANAGER', 41, true), ('VENUE_MANAGER', 42, true),
('VENUE_MANAGER', 50, true), ('VENUE_MANAGER', 51, true), ('VENUE_MANAGER', 52, true), ('VENUE_MANAGER', 53, true), ('VENUE_MANAGER', 54, true),

-- 普通用户：基本用户功能
('USER', 21, true), ('USER', 31, true), ('USER', 41, false),
('USER', 50, true), ('USER', 51, true), ('USER', 52, true), ('USER', 53, true), ('USER', 54, true);

-- ============== 用户数据 ==============
-- 4. 插入用户数据
INSERT INTO gym_user (id, username, password_hash, role_id, phone, email, real_name, status) VALUES
-- 超级管理员
(1, 'superadmin', '+TboxEds7ISk252QCHvQILrZL0', 1, '13800000000', 'superadmin@gym.com', '超级管理员', 'ACTIVE'),
-- 系统管理员
(2, 'admin', '+TboxEds7ISk252QCHvQILrZL0', 2, '13800000001', 'admin@gym.com', '系统管理员', 'ACTIVE'),
-- 场馆管理员
(3, 'venue_manager1', '+TboxEds7ISk252QCHvQILrZL0', 3, '13800000002', 'manager1@gym.com', '场馆管理员1', 'ACTIVE'),
(4, 'venue_manager2', '+TboxEds7ISk252QCHvQILrZL0', 3, '13800000003', 'manager2@gym.com', '场馆管理员2', 'ACTIVE'),
-- 普通用户
(5, 'alice', '+TboxEds7ISk252QCHvQILrZL0', 4, '13800000011', 'alice@example.com', '爱丽丝', 'ACTIVE'),
(6, 'bob', '+TboxEds7ISk252QCHvQILrZL0', 4, '13800000012', 'bob@example.com', '鲍勃', 'ACTIVE'),
(7, 'charlie', '+TboxEds7ISk252QCHvQILrZL0', 4, '13800000013', 'charlie@example.com', '查理', 'ACTIVE'),
(8, 'diana', '+TboxEds7ISk252QCHvQILrZL0', 4, '13800000014', 'diana@example.com', '戴安娜', 'ACTIVE');

-- 5. 插入角色权限关联（基于默认配置）
INSERT INTO role_permission (role_id, permission_id)
SELECT 
    r.id as role_id,
    drp.permission_id
FROM role r
JOIN default_role_permission drp ON r.role_code = drp.role_code
WHERE drp.is_required = true;

-- ============== 场馆场地数据 ==============
-- 6. 插入场馆数据
INSERT INTO venue (id, name, address, contact_phone, description, open_time, close_time, status) VALUES
(1, '体育馆A', '校区东门体育中心1号楼', '021-12345678', '综合性体育馆，设施齐全，环境优雅，提供多种运动项目', '08:00:00', '22:00:00', 'OPEN'),
(2, '体育馆B', '校区西门体育中心2号楼', '021-12345679', '专业羽毛球馆，拥有12片标准场地，灯光充足', '09:00:00', '21:00:00', 'OPEN'),
(3, '体育馆C', '校区南门体育中心3号楼', '021-12345680', '网球运动中心，4片标准网球场，专业教练指导', '08:00:00', '22:00:00', 'OPEN'),
(4, '健身中心', '校区北门健身大厦', '021-12345681', '现代化健身中心，器械齐全，环境舒适', '06:00:00', '23:00:00', 'OPEN'),
(5, '游泳馆', '校区中心水上运动馆', '021-12345682', '标准游泳池，水质优良，安全设施完备', '07:00:00', '21:30:00', 'OPEN');

-- 7. 插入场地数据
INSERT INTO court (id, venue_id, name, sport_type, description, capacity, status) VALUES
-- 体育馆A的场地
(1, 1, '篮球场1', 'BASKETBALL', '标准篮球场，地面采用专业运动地板', 10, 'AVAILABLE'),
(2, 1, '篮球场2', 'BASKETBALL', '标准篮球场，配备专业篮球架', 10, 'AVAILABLE'),
(3, 1, '羽毛球场1', 'BADMINTON', '标准羽毛球场，灯光充足', 4, 'AVAILABLE'),
(4, 1, '羽毛球场2', 'BADMINTON', '标准羽毛球场，通风良好', 4, 'AVAILABLE'),

-- 体育馆B的场地
(5, 2, '羽毛球场3', 'BADMINTON', '专业羽毛球场，地胶优质', 4, 'AVAILABLE'),
(6, 2, '羽毛球场4', 'BADMINTON', '专业羽毛球场，环境舒适', 4, 'AVAILABLE'),
(7, 2, '羽毛球场5', 'BADMINTON', '专业羽毛球场，设施完善', 4, 'AVAILABLE'),
(8, 2, '羽毛球场6', 'BADMINTON', '专业羽毛球场，服务周到', 4, 'AVAILABLE'),

-- 体育馆C的场地
(9, 3, '网球场1', 'TENNIS', '标准网球场，场地平整', 4, 'AVAILABLE'),
(10, 3, '网球场2', 'TENNIS', '标准网球场，环境优美', 4, 'AVAILABLE'),
(11, 3, '网球场3', 'TENNIS', '标准网球场，设施先进', 4, 'AVAILABLE'),
(12, 3, '网球场4', 'TENNIS', '标准网球场，服务专业', 4, 'AVAILABLE'),

-- 健身中心的场地
(13, 4, '器械区A', 'FITNESS', '力量训练区，器械齐全', 20, 'AVAILABLE'),
(14, 4, '器械区B', 'FITNESS', '有氧训练区，环境舒适', 20, 'AVAILABLE'),
(15, 4, '瑜伽室1', 'YOGA', '专业瑜伽室，环境静谧', 15, 'AVAILABLE'),
(16, 4, '瑜伽室2', 'YOGA', '专业瑜伽室，设施完善', 15, 'AVAILABLE'),

-- 游泳馆的场地
(17, 5, '游泳池1', 'SWIMMING', '标准游泳池，水质优良', 30, 'AVAILABLE'),
(18, 5, '游泳池2', 'SWIMMING', '儿童游泳池，安全可靠', 20, 'AVAILABLE');

-- 8. 插入用户场馆关联（场馆管理员管理的场馆）
INSERT INTO user_venue (user_id, venue_id) VALUES
(3, 1), (3, 2),  -- 场馆管理员1管理体育馆A和B
(4, 3), (4, 4), (4, 5);  -- 场馆管理员2管理体育馆C、健身中心和游泳馆

-- ============== 时间段数据 ==============
-- 9. 插入时间段数据（今天和未来几天）
INSERT INTO timeslot (court_id, slot_date, start_time, end_time, price, status, quota, is_peak) VALUES
-- 今天的时间段
(1, CURDATE(), '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 1, false),
(1, CURDATE(), '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 1, false),
(1, CURDATE(), '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 1, false),
(1, CURDATE(), '19:00:00', '20:00:00', 80.00, 'AVAILABLE', 1, true),
(1, CURDATE(), '20:00:00', '21:00:00', 80.00, 'AVAILABLE', 1, true),

(3, CURDATE(), '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 1, false),
(3, CURDATE(), '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 1, false),
(3, CURDATE(), '19:00:00', '20:00:00', 50.00, 'AVAILABLE', 1, true),

(9, CURDATE(), '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 1, false),
(9, CURDATE(), '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 1, false),

-- 明天的时间段
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 1, false),
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 1, false),
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:00:00', '20:00:00', 80.00, 'AVAILABLE', 1, true),

(5, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '10:00:00', 35.00, 'AVAILABLE', 1, false),
(5, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '15:00:00', 35.00, 'AVAILABLE', 1, false),

(13, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 1, false),
(13, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 1, false);

-- ============== 预约数据 ==============
-- 10. 插入预约数据
INSERT INTO reservation (id, reservation_no, user_id, court_id, slot_date, start_time, end_time, amount, status, participants, contact_name, contact_phone) VALUES
(1, 'R20251226001', 5, 1, CURDATE(), '09:00:00', '10:00:00', 50.00, 'PAID', 2, '爱丽丝', '13800000011'),
(2, 'R20251226002', 6, 3, CURDATE(), '10:00:00', '11:00:00', 30.00, 'CONFIRMED', 1, '鲍勃', '13800000012'),
(3, 'R20251226003', 7, 9, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '10:00:00', 80.00, 'PENDING_PAYMENT', 2, '查理', '13800000013');

-- ============== 优惠券数据 ==============
-- 11. 插入优惠券数据
INSERT INTO coupon (id, code, name, type, value, min_amount, start_time, end_time, total_quantity, status) VALUES
(1, 'NEWUSER10', '新用户优惠券', 'AMOUNT', 10.00, 50.00, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 100, 'ACTIVE'),
(2, 'WEEKEND20', '周末优惠券', 'PERCENTAGE', 0.20, 100.00, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY), 50, 'ACTIVE'),
(3, 'VIP30', 'VIP专享券', 'AMOUNT', 30.00, 200.00, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), 20, 'ACTIVE');

-- 12. 插入用户优惠券
INSERT INTO user_coupon (user_id, coupon_id, status, expire_at) VALUES
(5, 1, 'UNUSED', DATE_ADD(NOW(), INTERVAL 30 DAY)),
(6, 1, 'UNUSED', DATE_ADD(NOW(), INTERVAL 30 DAY)),
(7, 2, 'UNUSED', DATE_ADD(NOW(), INTERVAL 15 DAY));

-- ============== 其他功能数据 ==============
-- 13. 插入公告数据
INSERT INTO announcement (id, title, content, type, status, publish_time) VALUES
(1, '元旦假期营业时间调整', '元旦假期期间（12月30日-1月2日），各场馆营业时间调整为10:00-20:00，请各位会员合理安排运动时间。', 'SYSTEM', 'PUBLISHED', NOW()),
(2, '新增瑜伽课程通知', '健身中心新增晚间瑜伽课程，每周二、四、六19:00-20:00，由专业教练指导，欢迎报名参加。', 'ACTIVITY', 'PUBLISHED', NOW()),
(3, '篮球场维护通知', '篮球场1将于本周日进行地板维护，当天暂停开放，给您带来不便敬请谅解。', 'VENUE', 'PUBLISHED', NOW());

-- 14. 插入反馈数据
INSERT INTO feedback (id, user_id, type, title, content, rating, status) VALUES
(1, 5, 'SUGGESTION', '建议增加更多时段', '场馆设施很好，但希望能增加更多晚间时段的选择', 4, 'PENDING'),
(2, 6, 'COMPLAINT', '场地清洁问题', '羽毛球场地面有些灰尘，建议加强清洁', 3, 'PROCESSING'),
(3, 7, 'QUESTION', '预约流程咨询', '请问如何取消已经支付的预约？', NULL, 'RESOLVED');

-- 15. 插入收藏数据
INSERT INTO favorite (user_id, target_type, target_id) VALUES
(5, 'COURT', 1), (5, 'COURT', 3), (5, 'VENUE', 1),
(6, 'COURT', 5), (6, 'COURT', 9), (6, 'VENUE', 2),
(7, 'COURT', 9), (7, 'COURT', 13), (7, 'VENUE', 3);