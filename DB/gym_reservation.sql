/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : gym_reservation

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 10/04/2026 15:05:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'SYSTEM' COMMENT '类型: SYSTEM, ACTIVITY, VENUE',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DRAFT' COMMENT '状态: DRAFT, PUBLISHED, EXPIRED',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, '元旦假期营业时间调整', '元旦假期期间（12月30日-1月2日），各场馆营业时间调整为10:00-20:00，请各位会员合理安排运动时间。', 'SYSTEM', 'PUBLISHED', '2025-12-27 14:16:24', NULL, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `announcement` VALUES (2, '新增瑜伽课程通知', '健身中心新增晚间瑜伽课程，每周二、四、六19:00-20:00，由专业教练指导，欢迎报名参加。', 'ACTIVITY', 'PUBLISHED', '2025-12-27 14:16:24', NULL, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `announcement` VALUES (3, '篮球场维护通知', '篮球场1将于本周日进行地板维护，当天暂停开放，给您带来不便敬请谅解。', 'VENUE', 'PUBLISHED', '2025-12-27 14:16:24', NULL, '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '优惠券ID',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '优惠券码',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型: AMOUNT, PERCENTAGE',
  `value` decimal(10, 2) NOT NULL COMMENT '面值/折扣',
  `min_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '最低消费',
  `start_time` datetime NOT NULL COMMENT '生效时间',
  `end_time` datetime NOT NULL COMMENT '失效时间',
  `total_quantity` int NOT NULL COMMENT '总数量',
  `used_quantity` int NOT NULL DEFAULT 0 COMMENT '已使用数量',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE, INACTIVE, EXPIRED',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coupon
-- ----------------------------
INSERT INTO `coupon` VALUES (1, 'NEWUSER10', '新用户优惠券', 'AMOUNT', 10.00, 50.00, '2025-12-27 14:16:24', '2026-01-26 14:16:24', 100, 0, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `coupon` VALUES (2, 'WEEKEND20', '周末优惠券', 'PERCENTAGE', 0.20, 100.00, '2025-12-27 14:16:24', '2026-01-11 14:16:24', 50, 0, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `coupon` VALUES (3, 'VIP30', 'VIP专享券', 'AMOUNT', 30.00, 200.00, '2025-12-27 14:16:24', '2026-02-25 14:16:24', 20, 1, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for court
-- ----------------------------
DROP TABLE IF EXISTS `court`;
CREATE TABLE `court`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '场地ID',
  `venue_id` bigint NOT NULL COMMENT '场馆ID',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '场地名称',
  `sport_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '运动类型: BASKETBALL, BADMINTON, TENNIS, FITNESS, YOGA, SWIMMING',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `capacity` int NOT NULL DEFAULT 1 COMMENT '容量',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片URL列表(JSON)',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AVAILABLE' COMMENT '状态: AVAILABLE, MAINTENANCE, CLOSED',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '场地表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of court
-- ----------------------------
INSERT INTO `court` VALUES (1, 1, '篮球场1', 'BASKETBALL', '标准篮球场，地面采用专业运动地板', 10, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (2, 1, '篮球场2', 'BASKETBALL', '标准篮球场，配备专业篮球架', 10, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (3, 1, '羽毛球场1', 'BADMINTON', '标准羽毛球场，灯光充足', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (4, 1, '羽毛球场2', 'BADMINTON', '标准羽毛球场，通风良好', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (5, 2, '羽毛球场3', 'BADMINTON', '专业羽毛球场，地胶优质', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (6, 2, '羽毛球场4', 'BADMINTON', '专业羽毛球场，环境舒适', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (7, 2, '羽毛球场5', 'BADMINTON', '专业羽毛球场，设施完善', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (8, 2, '羽毛球场6', 'BADMINTON', '专业羽毛球场，服务周到', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (9, 3, '网球场1', 'TENNIS', '标准网球场，场地平整', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (10, 3, '网球场2', 'TENNIS', '标准网球场，环境优美', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (11, 3, '网球场3', 'TENNIS', '标准网球场，设施先进', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (12, 3, '网球场4', 'TENNIS', '标准网球场，服务专业', 4, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (13, 4, '器械区A', 'FITNESS', '力量训练区，器械齐全', 20, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (14, 4, '器械区B', 'FITNESS', '有氧训练区，环境舒适', 20, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (15, 4, '瑜伽室1', 'YOGA', '专业瑜伽室，环境静谧', 15, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (16, 4, '瑜伽室2', 'YOGA', '专业瑜伽室，设施完善', 15, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (17, 5, '游泳池1', 'SWIMMING', '标准游泳池，水质优良', 30, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `court` VALUES (18, 5, '游泳池2', 'SWIMMING', '儿童游泳池，安全可靠', 20, NULL, 'AVAILABLE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for default_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `default_role_permission`;
CREATE TABLE `default_role_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色代码',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `is_required` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否必选权限',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission_default`(`role_code` ASC, `permission_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '默认角色权限配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of default_role_permission
-- ----------------------------
INSERT INTO `default_role_permission` VALUES (1, 'SUPER_ADMIN', 1, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (2, 'SUPER_ADMIN', 2, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (3, 'SUPER_ADMIN', 3, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (4, 'SUPER_ADMIN', 4, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (5, 'SUPER_ADMIN', 5, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (6, 'SUPER_ADMIN', 6, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (7, 'SUPER_ADMIN', 7, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (8, 'SUPER_ADMIN', 8, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (9, 'SUPER_ADMIN', 9, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (10, 'SUPER_ADMIN', 10, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (11, 'SUPER_ADMIN', 11, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (12, 'SUPER_ADMIN', 20, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (13, 'SUPER_ADMIN', 21, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (14, 'SUPER_ADMIN', 22, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (15, 'SUPER_ADMIN', 23, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (16, 'SUPER_ADMIN', 24, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (17, 'SUPER_ADMIN', 30, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (18, 'SUPER_ADMIN', 31, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (19, 'SUPER_ADMIN', 32, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (20, 'SUPER_ADMIN', 33, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (21, 'SUPER_ADMIN', 34, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (22, 'SUPER_ADMIN', 40, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (23, 'SUPER_ADMIN', 41, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (24, 'SUPER_ADMIN', 42, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (25, 'SUPER_ADMIN', 43, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (26, 'SUPER_ADMIN', 50, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (27, 'SUPER_ADMIN', 51, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (28, 'SUPER_ADMIN', 52, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (29, 'SUPER_ADMIN', 53, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (30, 'SUPER_ADMIN', 54, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (31, 'ADMIN', 20, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (32, 'ADMIN', 21, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (33, 'ADMIN', 22, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (34, 'ADMIN', 23, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (35, 'ADMIN', 24, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (36, 'ADMIN', 30, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (37, 'ADMIN', 31, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (38, 'ADMIN', 32, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (39, 'ADMIN', 33, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (40, 'ADMIN', 34, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (41, 'ADMIN', 40, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (42, 'ADMIN', 41, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (43, 'ADMIN', 42, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (44, 'ADMIN', 43, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (45, 'ADMIN', 50, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (46, 'ADMIN', 51, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (47, 'ADMIN', 52, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (48, 'ADMIN', 53, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (49, 'ADMIN', 54, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (50, 'VENUE_MANAGER', 20, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (51, 'VENUE_MANAGER', 21, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (52, 'VENUE_MANAGER', 23, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (53, 'VENUE_MANAGER', 30, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (54, 'VENUE_MANAGER', 31, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (55, 'VENUE_MANAGER', 32, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (56, 'VENUE_MANAGER', 33, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (57, 'VENUE_MANAGER', 40, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (58, 'VENUE_MANAGER', 41, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (59, 'VENUE_MANAGER', 42, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (60, 'VENUE_MANAGER', 50, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (61, 'VENUE_MANAGER', 51, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (62, 'VENUE_MANAGER', 52, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (63, 'VENUE_MANAGER', 53, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (64, 'VENUE_MANAGER', 54, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (65, 'USER', 21, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (66, 'USER', 31, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (67, 'USER', 41, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (68, 'USER', 50, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (69, 'USER', 51, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (70, 'USER', 52, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (71, 'USER', 53, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `default_role_permission` VALUES (72, 'USER', 54, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型: COURT, VENUE',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_favorite`(`user_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (1, 5, 'COURT', 1, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (2, 5, 'COURT', 3, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (3, 5, 'VENUE', 1, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (4, 6, 'COURT', 5, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (5, 6, 'COURT', 9, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (6, 6, 'VENUE', 2, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (7, 7, 'COURT', 9, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (8, 7, 'COURT', 13, '2025-12-27 14:16:24');
INSERT INTO `favorite` VALUES (9, 7, 'VENUE', 3, '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '反馈ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型: COMPLAINT, SUGGESTION, QUESTION',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容',
  `rating` int NULL DEFAULT NULL COMMENT '评分(1-5)',
  `reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '回复',
  `replied_at` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING, PROCESSING, RESOLVED, CLOSED',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '反馈表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback
-- ----------------------------
INSERT INTO `feedback` VALUES (1, 5, 'SUGGESTION', '建议增加更多时段', '场馆设施很好，但希望能增加更多晚间时段的选择', 4, NULL, NULL, 'PENDING', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `feedback` VALUES (2, 6, 'COMPLAINT', '场地清洁问题', '羽毛球场地面有些灰尘，建议加强清洁', 3, NULL, NULL, 'PROCESSING', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `feedback` VALUES (3, 7, 'QUESTION', '预约流程咨询', '请问如何取消已经支付的预约？', NULL, NULL, NULL, 'RESOLVED', '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for gym_user
-- ----------------------------
DROP TABLE IF EXISTS `gym_user`;
CREATE TABLE `gym_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码哈希',
  `role_id` bigint NOT NULL COMMENT '角色ID（一个用户一个角色）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `wechat_openid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信OpenID',
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态: ACTIVE, DISABLED',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gym_user
-- ----------------------------
INSERT INTO `gym_user` VALUES (1, 'superadmin', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 1, '13800000000', 'superadmin@gym.com', NULL, '/api/files/avatar/avatar_78f2a55b-381f-49ef-ae06-b09e203de5f2.webp', '超级管理员', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:25');
INSERT INTO `gym_user` VALUES (2, 'admin', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 2, '13800000001', 'admin@gym.com', NULL, NULL, '系统管理员', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:24');
INSERT INTO `gym_user` VALUES (3, 'venue_manager1', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 3, '13800000002', 'manager1@gym.com', NULL, NULL, '场馆管理员1', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:23');
INSERT INTO `gym_user` VALUES (4, 'venue_manager2', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 3, '13800000003', 'manager2@gym.com', NULL, NULL, '场馆管理员2', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:23');
INSERT INTO `gym_user` VALUES (5, 'alice', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 4, '13800000011', 'alice@example.com', NULL, NULL, '爱丽丝', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:22');
INSERT INTO `gym_user` VALUES (6, 'bob', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 4, '13800000012', 'bob@example.com', NULL, '/api/files/avatar/avatar_aac6cbb7-81fe-4489-9a22-8f29b77163fa.webp', '鲍勃', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 15:06:19');
INSERT INTO `gym_user` VALUES (7, 'charlie', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 4, '13800000013', 'charlie@example.com', NULL, NULL, '查理', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:21');
INSERT INTO `gym_user` VALUES (8, 'diana', '$argon2i$v=19$m=65536,t=2,p=1$XIbBKvhYuRCU1lcWJMdhhQ$FQeNWUP68Ftuk9WwUauEg/gU7ZRIlI2aPCrK5px6OoM', 4, '13800000014', 'diana@example.com', NULL, NULL, '戴安娜', 'ACTIVE', NULL, '2025-12-27 14:16:24', '2025-12-27 14:26:19');
INSERT INTO `gym_user` VALUES (9, 'wx__PkR_ym0', '', 4, NULL, NULL, 'o9Fxw3ZudarXfxdPa9qs_PkR_ym0', '/api/files/avatar/avatar_25fa4838-caeb-4a6a-a584-45c1f47e8f89.jpg', NULL, 'ACTIVE', NULL, '2026-03-04 13:57:48', '2026-03-04 13:58:08');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模块',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目标类型',
  `target_id` bigint NULL DEFAULT NULL COMMENT '目标ID',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'UserAgent',
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详情(JSON)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID',
  `reservation_id` bigint NOT NULL COMMENT '预约ID',
  `payment_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付单号',
  `amount` decimal(10, 2) NOT NULL COMMENT '支付金额',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付方式: WECHAT, ALIPAY, CASH, BALANCE',
  `payment_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING, SUCCESS, FAILED, REFUNDED',
  `transaction_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '第三方交易号',
  `paid_at` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '退款金额',
  `refunded_at` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `payment_no`(`payment_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment
-- ----------------------------
INSERT INTO `payment` VALUES (1, 5, 'P1768718593411', 75.00, 'WECHAT', 'SUCCESS', 'T1768718593411', '2026-01-18 14:43:13', NULL, NULL, '2026-01-18 14:43:13', '2026-01-18 14:43:13');
INSERT INTO `payment` VALUES (2, 4, 'P1768718603760', 80.00, 'WECHAT', 'SUCCESS', 'T1768718603760', '2026-01-18 14:43:24', NULL, NULL, '2026-01-18 14:43:23', '2026-01-18 14:43:23');
INSERT INTO `payment` VALUES (3, 6, 'P1772188974268', 50.00, 'WECHAT', 'SUCCESS', 'T1772188974268', '2026-02-27 18:42:54', NULL, NULL, '2026-02-27 18:42:54', '2026-02-27 18:42:54');
INSERT INTO `payment` VALUES (4, 7, 'P1772601477575', 30.00, 'WECHAT', 'SUCCESS', 'T1772601477576', '2026-03-04 13:17:58', NULL, NULL, '2026-03-04 13:17:57', '2026-03-04 13:17:57');

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `perm_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限代码',
  `perm_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限名称',
  `perm_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限类型: MENU, BUTTON, API, DATA',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父权限ID',
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由路径/接口路径',
  `component` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前端组件',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `perm_code`(`perm_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES (1, 'SYSTEM', '系统管理', 'MENU', 0, '/admin', NULL, 'system', 1, '系统管理菜单', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (2, 'SYSTEM:USER', '用户管理', 'MENU', 1, '/admin/users', 'UserManagement', 'user', 1, '用户管理', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (3, 'SYSTEM:USER:LIST', '用户列表', 'API', 2, '/api/admin/users', NULL, NULL, 1, '查看用户列表', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (4, 'SYSTEM:USER:CREATE', '创建用户', 'API', 2, '/api/admin/users', NULL, NULL, 2, '创建用户', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (5, 'SYSTEM:USER:UPDATE', '更新用户', 'API', 2, '/api/admin/users/*', NULL, NULL, 3, '更新用户', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (6, 'SYSTEM:USER:DELETE', '删除用户', 'API', 2, '/api/admin/users/*', NULL, NULL, 4, '删除用户', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (7, 'SYSTEM:ROLE', '角色管理', 'MENU', 1, '/admin/roles', 'RoleManagement', 'role', 2, '角色管理', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (8, 'SYSTEM:ROLE:LIST', '角色列表', 'API', 7, '/api/admin/roles', NULL, NULL, 1, '查看角色列表', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (9, 'SYSTEM:ROLE:CREATE', '创建角色', 'API', 7, '/api/admin/roles', NULL, NULL, 2, '创建角色', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (10, 'SYSTEM:ROLE:UPDATE', '更新角色', 'API', 7, '/api/admin/roles/*', NULL, NULL, 3, '更新角色', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (11, 'SYSTEM:ROLE:DELETE', '删除角色', 'API', 7, '/api/admin/roles/*', NULL, NULL, 4, '删除角色', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (20, 'VENUE', '场馆管理', 'MENU', 0, '/admin/venues', NULL, 'venue', 2, '场馆管理菜单', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (21, 'VENUE:LIST', '场馆列表', 'API', 20, '/api/venues', NULL, NULL, 1, '查看场馆列表', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (22, 'VENUE:CREATE', '创建场馆', 'API', 20, '/api/venues', NULL, NULL, 2, '创建场馆', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (23, 'VENUE:UPDATE', '更新场馆', 'API', 20, '/api/venues/*', NULL, NULL, 3, '更新场馆', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (24, 'VENUE:DELETE', '删除场馆', 'API', 20, '/api/venues/*', NULL, NULL, 4, '删除场馆', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (30, 'COURT', '场地管理', 'MENU', 0, '/admin/courts', NULL, 'court', 3, '场地管理菜单', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (31, 'COURT:LIST', '场地列表', 'API', 30, '/api/courts', NULL, NULL, 1, '查看场地列表', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (32, 'COURT:CREATE', '创建场地', 'API', 30, '/api/courts', NULL, NULL, 2, '创建场地', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (33, 'COURT:UPDATE', '更新场地', 'API', 30, '/api/courts/*', NULL, NULL, 3, '更新场地', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (34, 'COURT:DELETE', '删除场地', 'API', 30, '/api/courts/*', NULL, NULL, 4, '删除场地', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (40, 'RESERVATION', '预约管理', 'MENU', 0, '/admin/reservations', NULL, 'reservation', 4, '预约管理菜单', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (41, 'RESERVATION:LIST', '预约列表', 'API', 40, '/api/reservations', NULL, NULL, 1, '查看预约列表', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (42, 'RESERVATION:UPDATE', '更新预约', 'API', 40, '/api/reservations/*', NULL, NULL, 2, '更新预约状态', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (43, 'RESERVATION:DELETE', '删除预约', 'API', 40, '/api/reservations/*', NULL, NULL, 3, '删除预约', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (50, 'USER_FUNC', '用户功能', 'MENU', 0, '/', NULL, 'user-func', 5, '用户功能菜单', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (51, 'USER_FUNC:RESERVE', '预约场地', 'API', 50, '/api/reservations/my', NULL, NULL, 1, '预约场地', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (52, 'USER_FUNC:MY_RESERVATIONS', '我的预约', 'API', 50, '/api/users/my/reservations', NULL, NULL, 2, '查看我的预约', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (53, 'USER_FUNC:FAVORITES', '我的收藏', 'API', 50, '/api/users/my/favorites', NULL, NULL, 3, '管理收藏', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `permission` VALUES (54, 'USER_FUNC:FEEDBACK', '意见反馈', 'API', 50, '/api/feedback/my', NULL, NULL, 4, '提交反馈', 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for reservation
-- ----------------------------
DROP TABLE IF EXISTS `reservation`;
CREATE TABLE `reservation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `reservation_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `court_id` bigint NOT NULL COMMENT '场地ID',
  `slot_date` date NOT NULL COMMENT '预约日期',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING_PAYMENT' COMMENT '状态: PENDING_PAYMENT, PAID, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED, REFUNDED',
  `participants` int NOT NULL DEFAULT 1 COMMENT '参与人数',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `cancelled_at` datetime NULL DEFAULT NULL COMMENT '取消时间',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `reservation_no`(`reservation_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservation
-- ----------------------------
INSERT INTO `reservation` VALUES (1, 'R20251226001', 5, 1, '2025-12-27', '09:00:00', '10:00:00', 50.00, 'PAID', 2, '爱丽丝', '13800000011', NULL, NULL, NULL, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `reservation` VALUES (2, 'R20251226002', 6, 3, '2025-12-27', '10:00:00', '11:00:00', 30.00, 'CONFIRMED', 1, '鲍勃', '13800000012', NULL, NULL, NULL, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `reservation` VALUES (3, 'R20251226003', 7, 9, '2025-12-28', '09:00:00', '10:00:00', 80.00, 'PENDING_PAYMENT', 2, '查理', '13800000013', NULL, NULL, NULL, '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `reservation` VALUES (4, 'R1766820125575', 6, 1, '2025-12-27', '19:00:00', '20:00:00', 80.00, 'PAID', 1, '用户', '13800000000', NULL, NULL, NULL, '2025-12-27 15:22:06', '2025-12-27 15:22:06');
INSERT INTO `reservation` VALUES (5, 'R1768718586789703', 6, 1, '2026-01-18', '18:00:00', '19:00:00', 75.00, 'PAID', 1, '鲍勃', '19122187574', NULL, NULL, NULL, '2026-01-18 14:43:07', '2026-01-18 14:43:07');
INSERT INTO `reservation` VALUES (6, 'R1772188955095111', 6, 1, '2026-02-27', '08:00:00', '09:00:00', 50.00, 'PAID', 1, '鲍勃', '19122187574', NULL, NULL, NULL, '2026-02-27 18:42:35', '2026-02-27 18:42:35');
INSERT INTO `reservation` VALUES (7, 'R1772601472489190', 6, 5, '2026-03-04', '09:00:00', '10:00:00', 30.00, 'PAID', 1, '鲍勃', '19122187574', NULL, NULL, NULL, '2026-03-04 13:17:52', '2026-03-04 13:17:52');

-- ----------------------------
-- Table structure for reservation_coupon
-- ----------------------------
DROP TABLE IF EXISTS `reservation_coupon`;
CREATE TABLE `reservation_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `reservation_id` bigint NOT NULL COMMENT '预约ID',
  `user_coupon_id` bigint NOT NULL COMMENT '用户优惠券ID',
  `discount_amount` decimal(10, 2) NOT NULL COMMENT '优惠金额',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约优惠券关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservation_coupon
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色代码',
  `role_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `is_system` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否系统角色',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'SUPER_ADMIN', '超级管理员', '系统超级管理员，拥有所有权限', 1, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `role` VALUES (2, 'ADMIN', '系统管理员', '系统管理员，管理整个系统', 1, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `role` VALUES (3, 'VENUE_MANAGER', '场馆管理员', '场馆管理员，管理指定场馆', 0, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `role` VALUES (4, 'USER', '普通用户', '普通用户，可以预约场地', 1, 'ACTIVE', '2025-12-27 14:16:24', '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission`(`role_id` ASC, `permission_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (1, 2, 20, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (2, 2, 21, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (3, 2, 22, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (4, 2, 23, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (5, 2, 24, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (6, 2, 30, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (7, 2, 31, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (8, 2, 32, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (9, 2, 33, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (10, 2, 34, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (11, 2, 40, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (12, 2, 41, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (13, 2, 42, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (14, 2, 43, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (15, 2, 50, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (16, 2, 51, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (17, 2, 52, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (18, 2, 53, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (19, 2, 54, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (20, 1, 1, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (21, 1, 2, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (22, 1, 3, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (23, 1, 4, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (24, 1, 5, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (25, 1, 6, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (26, 1, 7, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (27, 1, 8, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (28, 1, 9, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (29, 1, 10, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (30, 1, 11, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (31, 1, 20, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (32, 1, 21, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (33, 1, 22, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (34, 1, 23, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (35, 1, 24, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (36, 1, 30, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (37, 1, 31, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (38, 1, 32, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (39, 1, 33, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (40, 1, 34, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (41, 1, 40, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (42, 1, 41, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (43, 1, 42, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (44, 1, 43, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (45, 1, 50, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (46, 1, 51, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (47, 1, 52, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (48, 1, 53, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (49, 1, 54, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (50, 4, 21, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (51, 4, 31, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (52, 4, 50, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (53, 4, 51, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (54, 4, 52, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (55, 4, 53, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (56, 4, 54, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (57, 3, 20, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (58, 3, 21, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (59, 3, 30, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (60, 3, 31, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (61, 3, 32, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (62, 3, 33, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (63, 3, 40, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (64, 3, 41, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (65, 3, 42, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (66, 3, 50, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (67, 3, 51, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (68, 3, 52, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (69, 3, 53, '2025-12-27 14:16:24');
INSERT INTO `role_permission` VALUES (70, 3, 54, '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for timeslot
-- ----------------------------
DROP TABLE IF EXISTS `timeslot`;
CREATE TABLE `timeslot`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '时间段ID',
  `court_id` bigint NOT NULL COMMENT '场地ID',
  `slot_date` date NOT NULL COMMENT '日期',
  `start_time` time NOT NULL COMMENT '开始时间',
  `end_time` time NOT NULL COMMENT '结束时间',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AVAILABLE' COMMENT '状态: AVAILABLE, BOOKED, UNAVAILABLE',
  `quota` int NOT NULL DEFAULT 1 COMMENT '可预约数',
  `booked_count` int NOT NULL DEFAULT 0 COMMENT '已预约数',
  `is_peak` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否高峰时段',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_court_slot`(`court_id` ASC, `slot_date` ASC, `start_time` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1668 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '时间段表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of timeslot
-- ----------------------------
INSERT INTO `timeslot` VALUES (1, 1, '2025-12-27', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (2, 1, '2025-12-27', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (3, 1, '2025-12-27', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (4, 1, '2025-12-27', '19:00:00', '20:00:00', 80.00, 'AVAILABLE', 1, 0, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (5, 1, '2025-12-27', '20:00:00', '21:00:00', 80.00, 'AVAILABLE', 1, 0, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (6, 3, '2025-12-27', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (7, 3, '2025-12-27', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (8, 3, '2025-12-27', '19:00:00', '20:00:00', 50.00, 'AVAILABLE', 1, 0, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (9, 9, '2025-12-27', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (10, 9, '2025-12-27', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (11, 1, '2025-12-28', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (12, 1, '2025-12-28', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (13, 1, '2025-12-28', '19:00:00', '20:00:00', 80.00, 'AVAILABLE', 1, 0, 1, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (14, 5, '2025-12-28', '09:00:00', '10:00:00', 35.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (15, 5, '2025-12-28', '14:00:00', '15:00:00', 35.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (16, 13, '2025-12-28', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (17, 13, '2025-12-28', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 1, 0, 0, '2025-12-27 14:16:24', '2025-12-27 14:16:24', 0);
INSERT INTO `timeslot` VALUES (18, 1, '2026-01-18', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (19, 1, '2026-01-18', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (20, 1, '2026-01-18', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (21, 1, '2026-01-18', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (22, 1, '2026-01-18', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (23, 1, '2026-01-18', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (24, 1, '2026-01-18', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (25, 1, '2026-01-18', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (26, 1, '2026-01-18', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (27, 1, '2026-01-18', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (28, 1, '2026-01-18', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 1, 1, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 1);
INSERT INTO `timeslot` VALUES (29, 1, '2026-01-18', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (30, 1, '2026-01-18', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (31, 1, '2026-01-18', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-01-18 14:42:46', '2026-01-18 14:42:46', 0);
INSERT INTO `timeslot` VALUES (32, 1, '2026-02-27', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 1, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 1);
INSERT INTO `timeslot` VALUES (33, 1, '2026-02-27', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (34, 1, '2026-02-27', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (35, 1, '2026-02-27', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (36, 1, '2026-02-27', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (37, 1, '2026-02-27', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (38, 1, '2026-02-27', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (39, 1, '2026-02-27', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (40, 1, '2026-02-27', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (41, 1, '2026-02-27', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (42, 1, '2026-02-27', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (43, 1, '2026-02-27', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (44, 1, '2026-02-27', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (45, 1, '2026-02-27', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-02-27 18:42:24', '2026-02-27 18:42:24', 0);
INSERT INTO `timeslot` VALUES (46, 5, '2026-03-04', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 1, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 1);
INSERT INTO `timeslot` VALUES (47, 5, '2026-03-04', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (48, 5, '2026-03-04', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (49, 5, '2026-03-04', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (50, 5, '2026-03-04', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (51, 5, '2026-03-04', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (52, 5, '2026-03-04', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (53, 5, '2026-03-04', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (54, 5, '2026-03-04', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (55, 5, '2026-03-04', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (56, 5, '2026-03-04', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (57, 5, '2026-03-04', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-03-04 13:17:43', '2026-03-04 13:17:43', 0);
INSERT INTO `timeslot` VALUES (58, 1, '2026-03-05', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (59, 1, '2026-03-05', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (60, 1, '2026-03-05', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (61, 1, '2026-03-05', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (62, 1, '2026-03-05', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (63, 1, '2026-03-05', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (64, 1, '2026-03-05', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (65, 1, '2026-03-05', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (66, 1, '2026-03-05', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (67, 1, '2026-03-05', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (68, 1, '2026-03-05', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (69, 1, '2026-03-05', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (70, 1, '2026-03-05', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (71, 1, '2026-03-05', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-03-05 22:39:55', '2026-03-05 22:39:55', 0);
INSERT INTO `timeslot` VALUES (72, 1, '2026-04-10', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (73, 1, '2026-04-10', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (74, 1, '2026-04-10', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (75, 1, '2026-04-10', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (76, 1, '2026-04-10', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (77, 1, '2026-04-10', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (78, 1, '2026-04-10', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (79, 1, '2026-04-10', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (80, 1, '2026-04-10', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (81, 1, '2026-04-10', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (82, 1, '2026-04-10', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (83, 1, '2026-04-10', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (84, 1, '2026-04-10', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (85, 1, '2026-04-10', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (86, 1, '2026-04-11', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (87, 1, '2026-04-11', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (88, 1, '2026-04-11', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (89, 1, '2026-04-11', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (90, 1, '2026-04-11', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (91, 1, '2026-04-11', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (92, 1, '2026-04-11', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (93, 1, '2026-04-11', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (94, 1, '2026-04-11', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (95, 1, '2026-04-11', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (96, 1, '2026-04-11', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (97, 1, '2026-04-11', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (98, 1, '2026-04-11', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (99, 1, '2026-04-11', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (100, 1, '2026-04-12', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (101, 1, '2026-04-12', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (102, 1, '2026-04-12', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (103, 1, '2026-04-12', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (104, 1, '2026-04-12', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (105, 1, '2026-04-12', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (106, 1, '2026-04-12', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (107, 1, '2026-04-12', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (108, 1, '2026-04-12', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (109, 1, '2026-04-12', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (110, 1, '2026-04-12', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (111, 1, '2026-04-12', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (112, 1, '2026-04-12', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (113, 1, '2026-04-12', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (114, 1, '2026-04-13', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (115, 1, '2026-04-13', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (116, 1, '2026-04-13', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (117, 1, '2026-04-13', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (118, 1, '2026-04-13', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (119, 1, '2026-04-13', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (120, 1, '2026-04-13', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (121, 1, '2026-04-13', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (122, 1, '2026-04-13', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (123, 1, '2026-04-13', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (124, 1, '2026-04-13', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (125, 1, '2026-04-13', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (126, 1, '2026-04-13', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (127, 1, '2026-04-13', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (128, 1, '2026-04-14', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (129, 1, '2026-04-14', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (130, 1, '2026-04-14', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (131, 1, '2026-04-14', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (132, 1, '2026-04-14', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (133, 1, '2026-04-14', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (134, 1, '2026-04-14', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (135, 1, '2026-04-14', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (136, 1, '2026-04-14', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (137, 1, '2026-04-14', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (138, 1, '2026-04-14', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (139, 1, '2026-04-14', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (140, 1, '2026-04-14', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (141, 1, '2026-04-14', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (142, 1, '2026-04-15', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (143, 1, '2026-04-15', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (144, 1, '2026-04-15', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (145, 1, '2026-04-15', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (146, 1, '2026-04-15', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (147, 1, '2026-04-15', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (148, 1, '2026-04-15', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (149, 1, '2026-04-15', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (150, 1, '2026-04-15', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (151, 1, '2026-04-15', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (152, 1, '2026-04-15', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (153, 1, '2026-04-15', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (154, 1, '2026-04-15', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (155, 1, '2026-04-15', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (156, 1, '2026-04-16', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (157, 1, '2026-04-16', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (158, 1, '2026-04-16', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (159, 1, '2026-04-16', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (160, 1, '2026-04-16', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (161, 1, '2026-04-16', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (162, 1, '2026-04-16', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (163, 1, '2026-04-16', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (164, 1, '2026-04-16', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (165, 1, '2026-04-16', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (166, 1, '2026-04-16', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (167, 1, '2026-04-16', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (168, 1, '2026-04-16', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (169, 1, '2026-04-16', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (170, 2, '2026-04-10', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (171, 2, '2026-04-10', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (172, 2, '2026-04-10', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (173, 2, '2026-04-10', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (174, 2, '2026-04-10', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (175, 2, '2026-04-10', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (176, 2, '2026-04-10', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (177, 2, '2026-04-10', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (178, 2, '2026-04-10', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (179, 2, '2026-04-10', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (180, 2, '2026-04-10', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (181, 2, '2026-04-10', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (182, 2, '2026-04-10', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (183, 2, '2026-04-10', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (184, 2, '2026-04-11', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (185, 2, '2026-04-11', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (186, 2, '2026-04-11', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (187, 2, '2026-04-11', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (188, 2, '2026-04-11', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (189, 2, '2026-04-11', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (190, 2, '2026-04-11', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (191, 2, '2026-04-11', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (192, 2, '2026-04-11', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (193, 2, '2026-04-11', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (194, 2, '2026-04-11', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (195, 2, '2026-04-11', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (196, 2, '2026-04-11', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (197, 2, '2026-04-11', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (198, 2, '2026-04-12', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (199, 2, '2026-04-12', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (200, 2, '2026-04-12', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (201, 2, '2026-04-12', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (202, 2, '2026-04-12', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (203, 2, '2026-04-12', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (204, 2, '2026-04-12', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (205, 2, '2026-04-12', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (206, 2, '2026-04-12', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (207, 2, '2026-04-12', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (208, 2, '2026-04-12', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (209, 2, '2026-04-12', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (210, 2, '2026-04-12', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (211, 2, '2026-04-12', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (212, 2, '2026-04-13', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (213, 2, '2026-04-13', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (214, 2, '2026-04-13', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (215, 2, '2026-04-13', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (216, 2, '2026-04-13', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (217, 2, '2026-04-13', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (218, 2, '2026-04-13', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (219, 2, '2026-04-13', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (220, 2, '2026-04-13', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (221, 2, '2026-04-13', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (222, 2, '2026-04-13', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (223, 2, '2026-04-13', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (224, 2, '2026-04-13', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (225, 2, '2026-04-13', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (226, 2, '2026-04-14', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (227, 2, '2026-04-14', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (228, 2, '2026-04-14', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (229, 2, '2026-04-14', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (230, 2, '2026-04-14', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (231, 2, '2026-04-14', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (232, 2, '2026-04-14', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (233, 2, '2026-04-14', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (234, 2, '2026-04-14', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (235, 2, '2026-04-14', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (236, 2, '2026-04-14', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (237, 2, '2026-04-14', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (238, 2, '2026-04-14', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (239, 2, '2026-04-14', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (240, 2, '2026-04-15', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (241, 2, '2026-04-15', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (242, 2, '2026-04-15', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (243, 2, '2026-04-15', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (244, 2, '2026-04-15', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (245, 2, '2026-04-15', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (246, 2, '2026-04-15', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (247, 2, '2026-04-15', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (248, 2, '2026-04-15', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (249, 2, '2026-04-15', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (250, 2, '2026-04-15', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (251, 2, '2026-04-15', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (252, 2, '2026-04-15', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (253, 2, '2026-04-15', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (254, 2, '2026-04-16', '08:00:00', '09:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (255, 2, '2026-04-16', '09:00:00', '10:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (256, 2, '2026-04-16', '10:00:00', '11:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (257, 2, '2026-04-16', '11:00:00', '12:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (258, 2, '2026-04-16', '12:00:00', '13:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (259, 2, '2026-04-16', '13:00:00', '14:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (260, 2, '2026-04-16', '14:00:00', '15:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (261, 2, '2026-04-16', '15:00:00', '16:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (262, 2, '2026-04-16', '16:00:00', '17:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (263, 2, '2026-04-16', '17:00:00', '18:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (264, 2, '2026-04-16', '18:00:00', '19:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (265, 2, '2026-04-16', '19:00:00', '20:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (266, 2, '2026-04-16', '20:00:00', '21:00:00', 75.00, 'AVAILABLE', 10, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (267, 2, '2026-04-16', '21:00:00', '22:00:00', 50.00, 'AVAILABLE', 10, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (268, 3, '2026-04-10', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (269, 3, '2026-04-10', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (270, 3, '2026-04-10', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (271, 3, '2026-04-10', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (272, 3, '2026-04-10', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (273, 3, '2026-04-10', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (274, 3, '2026-04-10', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (275, 3, '2026-04-10', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (276, 3, '2026-04-10', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (277, 3, '2026-04-10', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (278, 3, '2026-04-10', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (279, 3, '2026-04-10', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (280, 3, '2026-04-10', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (281, 3, '2026-04-10', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (282, 3, '2026-04-11', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (283, 3, '2026-04-11', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (284, 3, '2026-04-11', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (285, 3, '2026-04-11', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (286, 3, '2026-04-11', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (287, 3, '2026-04-11', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (288, 3, '2026-04-11', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (289, 3, '2026-04-11', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (290, 3, '2026-04-11', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (291, 3, '2026-04-11', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (292, 3, '2026-04-11', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (293, 3, '2026-04-11', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (294, 3, '2026-04-11', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (295, 3, '2026-04-11', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (296, 3, '2026-04-12', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (297, 3, '2026-04-12', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (298, 3, '2026-04-12', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (299, 3, '2026-04-12', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (300, 3, '2026-04-12', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (301, 3, '2026-04-12', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (302, 3, '2026-04-12', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (303, 3, '2026-04-12', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (304, 3, '2026-04-12', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (305, 3, '2026-04-12', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (306, 3, '2026-04-12', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (307, 3, '2026-04-12', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (308, 3, '2026-04-12', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (309, 3, '2026-04-12', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (310, 3, '2026-04-13', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (311, 3, '2026-04-13', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (312, 3, '2026-04-13', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (313, 3, '2026-04-13', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (314, 3, '2026-04-13', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (315, 3, '2026-04-13', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (316, 3, '2026-04-13', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (317, 3, '2026-04-13', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (318, 3, '2026-04-13', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (319, 3, '2026-04-13', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (320, 3, '2026-04-13', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (321, 3, '2026-04-13', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (322, 3, '2026-04-13', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (323, 3, '2026-04-13', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (324, 3, '2026-04-14', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (325, 3, '2026-04-14', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (326, 3, '2026-04-14', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (327, 3, '2026-04-14', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (328, 3, '2026-04-14', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (329, 3, '2026-04-14', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (330, 3, '2026-04-14', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (331, 3, '2026-04-14', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (332, 3, '2026-04-14', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (333, 3, '2026-04-14', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (334, 3, '2026-04-14', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (335, 3, '2026-04-14', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (336, 3, '2026-04-14', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (337, 3, '2026-04-14', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (338, 3, '2026-04-15', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (339, 3, '2026-04-15', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (340, 3, '2026-04-15', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (341, 3, '2026-04-15', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (342, 3, '2026-04-15', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (343, 3, '2026-04-15', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (344, 3, '2026-04-15', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (345, 3, '2026-04-15', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (346, 3, '2026-04-15', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (347, 3, '2026-04-15', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (348, 3, '2026-04-15', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (349, 3, '2026-04-15', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (350, 3, '2026-04-15', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (351, 3, '2026-04-15', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (352, 3, '2026-04-16', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (353, 3, '2026-04-16', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (354, 3, '2026-04-16', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (355, 3, '2026-04-16', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (356, 3, '2026-04-16', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (357, 3, '2026-04-16', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (358, 3, '2026-04-16', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (359, 3, '2026-04-16', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (360, 3, '2026-04-16', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (361, 3, '2026-04-16', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (362, 3, '2026-04-16', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (363, 3, '2026-04-16', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (364, 3, '2026-04-16', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (365, 3, '2026-04-16', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (366, 4, '2026-04-10', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (367, 4, '2026-04-10', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (368, 4, '2026-04-10', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (369, 4, '2026-04-10', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (370, 4, '2026-04-10', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (371, 4, '2026-04-10', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (372, 4, '2026-04-10', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (373, 4, '2026-04-10', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (374, 4, '2026-04-10', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (375, 4, '2026-04-10', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (376, 4, '2026-04-10', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (377, 4, '2026-04-10', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (378, 4, '2026-04-10', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (379, 4, '2026-04-10', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (380, 4, '2026-04-11', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (381, 4, '2026-04-11', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (382, 4, '2026-04-11', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (383, 4, '2026-04-11', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (384, 4, '2026-04-11', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (385, 4, '2026-04-11', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (386, 4, '2026-04-11', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (387, 4, '2026-04-11', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (388, 4, '2026-04-11', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (389, 4, '2026-04-11', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (390, 4, '2026-04-11', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (391, 4, '2026-04-11', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (392, 4, '2026-04-11', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (393, 4, '2026-04-11', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (394, 4, '2026-04-12', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (395, 4, '2026-04-12', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (396, 4, '2026-04-12', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (397, 4, '2026-04-12', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (398, 4, '2026-04-12', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (399, 4, '2026-04-12', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (400, 4, '2026-04-12', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (401, 4, '2026-04-12', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (402, 4, '2026-04-12', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (403, 4, '2026-04-12', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (404, 4, '2026-04-12', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (405, 4, '2026-04-12', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (406, 4, '2026-04-12', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (407, 4, '2026-04-12', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (408, 4, '2026-04-13', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (409, 4, '2026-04-13', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (410, 4, '2026-04-13', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (411, 4, '2026-04-13', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (412, 4, '2026-04-13', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (413, 4, '2026-04-13', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (414, 4, '2026-04-13', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (415, 4, '2026-04-13', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (416, 4, '2026-04-13', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (417, 4, '2026-04-13', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (418, 4, '2026-04-13', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (419, 4, '2026-04-13', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (420, 4, '2026-04-13', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (421, 4, '2026-04-13', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (422, 4, '2026-04-14', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (423, 4, '2026-04-14', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (424, 4, '2026-04-14', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (425, 4, '2026-04-14', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (426, 4, '2026-04-14', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (427, 4, '2026-04-14', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (428, 4, '2026-04-14', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (429, 4, '2026-04-14', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (430, 4, '2026-04-14', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (431, 4, '2026-04-14', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (432, 4, '2026-04-14', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (433, 4, '2026-04-14', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (434, 4, '2026-04-14', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (435, 4, '2026-04-14', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (436, 4, '2026-04-15', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (437, 4, '2026-04-15', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (438, 4, '2026-04-15', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (439, 4, '2026-04-15', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (440, 4, '2026-04-15', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (441, 4, '2026-04-15', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (442, 4, '2026-04-15', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (443, 4, '2026-04-15', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (444, 4, '2026-04-15', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (445, 4, '2026-04-15', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (446, 4, '2026-04-15', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (447, 4, '2026-04-15', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (448, 4, '2026-04-15', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (449, 4, '2026-04-15', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (450, 4, '2026-04-16', '08:00:00', '09:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (451, 4, '2026-04-16', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (452, 4, '2026-04-16', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (453, 4, '2026-04-16', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (454, 4, '2026-04-16', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (455, 4, '2026-04-16', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (456, 4, '2026-04-16', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (457, 4, '2026-04-16', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (458, 4, '2026-04-16', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (459, 4, '2026-04-16', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (460, 4, '2026-04-16', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (461, 4, '2026-04-16', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (462, 4, '2026-04-16', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (463, 4, '2026-04-16', '21:00:00', '22:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (464, 5, '2026-04-10', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (465, 5, '2026-04-10', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (466, 5, '2026-04-10', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (467, 5, '2026-04-10', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (468, 5, '2026-04-10', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (469, 5, '2026-04-10', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (470, 5, '2026-04-10', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (471, 5, '2026-04-10', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (472, 5, '2026-04-10', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (473, 5, '2026-04-10', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (474, 5, '2026-04-10', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (475, 5, '2026-04-10', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (476, 5, '2026-04-11', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (477, 5, '2026-04-11', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (478, 5, '2026-04-11', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (479, 5, '2026-04-11', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (480, 5, '2026-04-11', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (481, 5, '2026-04-11', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (482, 5, '2026-04-11', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (483, 5, '2026-04-11', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (484, 5, '2026-04-11', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (485, 5, '2026-04-11', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (486, 5, '2026-04-11', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (487, 5, '2026-04-11', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (488, 5, '2026-04-12', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (489, 5, '2026-04-12', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (490, 5, '2026-04-12', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (491, 5, '2026-04-12', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (492, 5, '2026-04-12', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (493, 5, '2026-04-12', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (494, 5, '2026-04-12', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (495, 5, '2026-04-12', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (496, 5, '2026-04-12', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (497, 5, '2026-04-12', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (498, 5, '2026-04-12', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (499, 5, '2026-04-12', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (500, 5, '2026-04-13', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (501, 5, '2026-04-13', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (502, 5, '2026-04-13', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (503, 5, '2026-04-13', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (504, 5, '2026-04-13', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (505, 5, '2026-04-13', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (506, 5, '2026-04-13', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (507, 5, '2026-04-13', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (508, 5, '2026-04-13', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (509, 5, '2026-04-13', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (510, 5, '2026-04-13', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (511, 5, '2026-04-13', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (512, 5, '2026-04-14', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (513, 5, '2026-04-14', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (514, 5, '2026-04-14', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (515, 5, '2026-04-14', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (516, 5, '2026-04-14', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (517, 5, '2026-04-14', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (518, 5, '2026-04-14', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (519, 5, '2026-04-14', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (520, 5, '2026-04-14', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (521, 5, '2026-04-14', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (522, 5, '2026-04-14', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (523, 5, '2026-04-14', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (524, 5, '2026-04-15', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (525, 5, '2026-04-15', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (526, 5, '2026-04-15', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (527, 5, '2026-04-15', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (528, 5, '2026-04-15', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (529, 5, '2026-04-15', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (530, 5, '2026-04-15', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (531, 5, '2026-04-15', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (532, 5, '2026-04-15', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (533, 5, '2026-04-15', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (534, 5, '2026-04-15', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (535, 5, '2026-04-15', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (536, 5, '2026-04-16', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (537, 5, '2026-04-16', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (538, 5, '2026-04-16', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (539, 5, '2026-04-16', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (540, 5, '2026-04-16', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (541, 5, '2026-04-16', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (542, 5, '2026-04-16', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (543, 5, '2026-04-16', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (544, 5, '2026-04-16', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (545, 5, '2026-04-16', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (546, 5, '2026-04-16', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (547, 5, '2026-04-16', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (548, 6, '2026-04-10', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (549, 6, '2026-04-10', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (550, 6, '2026-04-10', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (551, 6, '2026-04-10', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (552, 6, '2026-04-10', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (553, 6, '2026-04-10', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (554, 6, '2026-04-10', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (555, 6, '2026-04-10', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (556, 6, '2026-04-10', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (557, 6, '2026-04-10', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (558, 6, '2026-04-10', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (559, 6, '2026-04-10', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (560, 6, '2026-04-11', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (561, 6, '2026-04-11', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (562, 6, '2026-04-11', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (563, 6, '2026-04-11', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (564, 6, '2026-04-11', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (565, 6, '2026-04-11', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (566, 6, '2026-04-11', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (567, 6, '2026-04-11', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (568, 6, '2026-04-11', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (569, 6, '2026-04-11', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (570, 6, '2026-04-11', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (571, 6, '2026-04-11', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (572, 6, '2026-04-12', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (573, 6, '2026-04-12', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (574, 6, '2026-04-12', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (575, 6, '2026-04-12', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (576, 6, '2026-04-12', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (577, 6, '2026-04-12', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (578, 6, '2026-04-12', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (579, 6, '2026-04-12', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (580, 6, '2026-04-12', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (581, 6, '2026-04-12', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (582, 6, '2026-04-12', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (583, 6, '2026-04-12', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (584, 6, '2026-04-13', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (585, 6, '2026-04-13', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (586, 6, '2026-04-13', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (587, 6, '2026-04-13', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (588, 6, '2026-04-13', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (589, 6, '2026-04-13', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (590, 6, '2026-04-13', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (591, 6, '2026-04-13', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (592, 6, '2026-04-13', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (593, 6, '2026-04-13', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (594, 6, '2026-04-13', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (595, 6, '2026-04-13', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (596, 6, '2026-04-14', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (597, 6, '2026-04-14', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (598, 6, '2026-04-14', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (599, 6, '2026-04-14', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (600, 6, '2026-04-14', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (601, 6, '2026-04-14', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (602, 6, '2026-04-14', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (603, 6, '2026-04-14', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (604, 6, '2026-04-14', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (605, 6, '2026-04-14', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (606, 6, '2026-04-14', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (607, 6, '2026-04-14', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (608, 6, '2026-04-15', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (609, 6, '2026-04-15', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (610, 6, '2026-04-15', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (611, 6, '2026-04-15', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (612, 6, '2026-04-15', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (613, 6, '2026-04-15', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (614, 6, '2026-04-15', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (615, 6, '2026-04-15', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (616, 6, '2026-04-15', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (617, 6, '2026-04-15', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (618, 6, '2026-04-15', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (619, 6, '2026-04-15', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (620, 6, '2026-04-16', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (621, 6, '2026-04-16', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (622, 6, '2026-04-16', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (623, 6, '2026-04-16', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (624, 6, '2026-04-16', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (625, 6, '2026-04-16', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (626, 6, '2026-04-16', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (627, 6, '2026-04-16', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (628, 6, '2026-04-16', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (629, 6, '2026-04-16', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (630, 6, '2026-04-16', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (631, 6, '2026-04-16', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (632, 7, '2026-04-10', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (633, 7, '2026-04-10', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (634, 7, '2026-04-10', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (635, 7, '2026-04-10', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (636, 7, '2026-04-10', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (637, 7, '2026-04-10', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (638, 7, '2026-04-10', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (639, 7, '2026-04-10', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (640, 7, '2026-04-10', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (641, 7, '2026-04-10', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (642, 7, '2026-04-10', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (643, 7, '2026-04-10', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (644, 7, '2026-04-11', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (645, 7, '2026-04-11', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (646, 7, '2026-04-11', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (647, 7, '2026-04-11', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (648, 7, '2026-04-11', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (649, 7, '2026-04-11', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (650, 7, '2026-04-11', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (651, 7, '2026-04-11', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (652, 7, '2026-04-11', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (653, 7, '2026-04-11', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (654, 7, '2026-04-11', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (655, 7, '2026-04-11', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (656, 7, '2026-04-12', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (657, 7, '2026-04-12', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (658, 7, '2026-04-12', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (659, 7, '2026-04-12', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (660, 7, '2026-04-12', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (661, 7, '2026-04-12', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (662, 7, '2026-04-12', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (663, 7, '2026-04-12', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (664, 7, '2026-04-12', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (665, 7, '2026-04-12', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (666, 7, '2026-04-12', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (667, 7, '2026-04-12', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (668, 7, '2026-04-13', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (669, 7, '2026-04-13', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (670, 7, '2026-04-13', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (671, 7, '2026-04-13', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (672, 7, '2026-04-13', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (673, 7, '2026-04-13', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (674, 7, '2026-04-13', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (675, 7, '2026-04-13', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (676, 7, '2026-04-13', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (677, 7, '2026-04-13', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (678, 7, '2026-04-13', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (679, 7, '2026-04-13', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (680, 7, '2026-04-14', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (681, 7, '2026-04-14', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (682, 7, '2026-04-14', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (683, 7, '2026-04-14', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (684, 7, '2026-04-14', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (685, 7, '2026-04-14', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (686, 7, '2026-04-14', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (687, 7, '2026-04-14', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (688, 7, '2026-04-14', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (689, 7, '2026-04-14', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (690, 7, '2026-04-14', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (691, 7, '2026-04-14', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (692, 7, '2026-04-15', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (693, 7, '2026-04-15', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (694, 7, '2026-04-15', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (695, 7, '2026-04-15', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (696, 7, '2026-04-15', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (697, 7, '2026-04-15', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (698, 7, '2026-04-15', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (699, 7, '2026-04-15', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (700, 7, '2026-04-15', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (701, 7, '2026-04-15', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (702, 7, '2026-04-15', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (703, 7, '2026-04-15', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (704, 7, '2026-04-16', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (705, 7, '2026-04-16', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (706, 7, '2026-04-16', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (707, 7, '2026-04-16', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (708, 7, '2026-04-16', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (709, 7, '2026-04-16', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (710, 7, '2026-04-16', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (711, 7, '2026-04-16', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (712, 7, '2026-04-16', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (713, 7, '2026-04-16', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (714, 7, '2026-04-16', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (715, 7, '2026-04-16', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (716, 8, '2026-04-10', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (717, 8, '2026-04-10', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (718, 8, '2026-04-10', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (719, 8, '2026-04-10', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (720, 8, '2026-04-10', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (721, 8, '2026-04-10', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (722, 8, '2026-04-10', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (723, 8, '2026-04-10', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (724, 8, '2026-04-10', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (725, 8, '2026-04-10', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (726, 8, '2026-04-10', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (727, 8, '2026-04-10', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (728, 8, '2026-04-11', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (729, 8, '2026-04-11', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (730, 8, '2026-04-11', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (731, 8, '2026-04-11', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (732, 8, '2026-04-11', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (733, 8, '2026-04-11', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (734, 8, '2026-04-11', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (735, 8, '2026-04-11', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (736, 8, '2026-04-11', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (737, 8, '2026-04-11', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (738, 8, '2026-04-11', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (739, 8, '2026-04-11', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (740, 8, '2026-04-12', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (741, 8, '2026-04-12', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (742, 8, '2026-04-12', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (743, 8, '2026-04-12', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (744, 8, '2026-04-12', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (745, 8, '2026-04-12', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (746, 8, '2026-04-12', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (747, 8, '2026-04-12', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (748, 8, '2026-04-12', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (749, 8, '2026-04-12', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (750, 8, '2026-04-12', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (751, 8, '2026-04-12', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (752, 8, '2026-04-13', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (753, 8, '2026-04-13', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (754, 8, '2026-04-13', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (755, 8, '2026-04-13', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (756, 8, '2026-04-13', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (757, 8, '2026-04-13', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (758, 8, '2026-04-13', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (759, 8, '2026-04-13', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (760, 8, '2026-04-13', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (761, 8, '2026-04-13', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (762, 8, '2026-04-13', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (763, 8, '2026-04-13', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (764, 8, '2026-04-14', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (765, 8, '2026-04-14', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (766, 8, '2026-04-14', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (767, 8, '2026-04-14', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (768, 8, '2026-04-14', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (769, 8, '2026-04-14', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (770, 8, '2026-04-14', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (771, 8, '2026-04-14', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (772, 8, '2026-04-14', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (773, 8, '2026-04-14', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (774, 8, '2026-04-14', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (775, 8, '2026-04-14', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (776, 8, '2026-04-15', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (777, 8, '2026-04-15', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (778, 8, '2026-04-15', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (779, 8, '2026-04-15', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (780, 8, '2026-04-15', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (781, 8, '2026-04-15', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (782, 8, '2026-04-15', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (783, 8, '2026-04-15', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (784, 8, '2026-04-15', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (785, 8, '2026-04-15', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (786, 8, '2026-04-15', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (787, 8, '2026-04-15', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (788, 8, '2026-04-16', '09:00:00', '10:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (789, 8, '2026-04-16', '10:00:00', '11:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (790, 8, '2026-04-16', '11:00:00', '12:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (791, 8, '2026-04-16', '12:00:00', '13:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (792, 8, '2026-04-16', '13:00:00', '14:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (793, 8, '2026-04-16', '14:00:00', '15:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (794, 8, '2026-04-16', '15:00:00', '16:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (795, 8, '2026-04-16', '16:00:00', '17:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (796, 8, '2026-04-16', '17:00:00', '18:00:00', 30.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (797, 8, '2026-04-16', '18:00:00', '19:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (798, 8, '2026-04-16', '19:00:00', '20:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (799, 8, '2026-04-16', '20:00:00', '21:00:00', 45.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (800, 9, '2026-04-10', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (801, 9, '2026-04-10', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (802, 9, '2026-04-10', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (803, 9, '2026-04-10', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (804, 9, '2026-04-10', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (805, 9, '2026-04-10', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (806, 9, '2026-04-10', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (807, 9, '2026-04-10', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (808, 9, '2026-04-10', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (809, 9, '2026-04-10', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (810, 9, '2026-04-10', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (811, 9, '2026-04-10', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (812, 9, '2026-04-10', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (813, 9, '2026-04-10', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (814, 9, '2026-04-11', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (815, 9, '2026-04-11', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (816, 9, '2026-04-11', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (817, 9, '2026-04-11', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (818, 9, '2026-04-11', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (819, 9, '2026-04-11', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (820, 9, '2026-04-11', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (821, 9, '2026-04-11', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (822, 9, '2026-04-11', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (823, 9, '2026-04-11', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (824, 9, '2026-04-11', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (825, 9, '2026-04-11', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (826, 9, '2026-04-11', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (827, 9, '2026-04-11', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (828, 9, '2026-04-12', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (829, 9, '2026-04-12', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (830, 9, '2026-04-12', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (831, 9, '2026-04-12', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (832, 9, '2026-04-12', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (833, 9, '2026-04-12', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (834, 9, '2026-04-12', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (835, 9, '2026-04-12', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (836, 9, '2026-04-12', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (837, 9, '2026-04-12', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (838, 9, '2026-04-12', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (839, 9, '2026-04-12', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (840, 9, '2026-04-12', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (841, 9, '2026-04-12', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (842, 9, '2026-04-13', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (843, 9, '2026-04-13', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (844, 9, '2026-04-13', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (845, 9, '2026-04-13', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (846, 9, '2026-04-13', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (847, 9, '2026-04-13', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (848, 9, '2026-04-13', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (849, 9, '2026-04-13', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (850, 9, '2026-04-13', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (851, 9, '2026-04-13', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (852, 9, '2026-04-13', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (853, 9, '2026-04-13', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (854, 9, '2026-04-13', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (855, 9, '2026-04-13', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (856, 9, '2026-04-14', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (857, 9, '2026-04-14', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (858, 9, '2026-04-14', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (859, 9, '2026-04-14', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (860, 9, '2026-04-14', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (861, 9, '2026-04-14', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (862, 9, '2026-04-14', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (863, 9, '2026-04-14', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (864, 9, '2026-04-14', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (865, 9, '2026-04-14', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (866, 9, '2026-04-14', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (867, 9, '2026-04-14', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (868, 9, '2026-04-14', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (869, 9, '2026-04-14', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (870, 9, '2026-04-15', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (871, 9, '2026-04-15', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (872, 9, '2026-04-15', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (873, 9, '2026-04-15', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (874, 9, '2026-04-15', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (875, 9, '2026-04-15', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (876, 9, '2026-04-15', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (877, 9, '2026-04-15', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (878, 9, '2026-04-15', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (879, 9, '2026-04-15', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (880, 9, '2026-04-15', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (881, 9, '2026-04-15', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (882, 9, '2026-04-15', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (883, 9, '2026-04-15', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (884, 9, '2026-04-16', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (885, 9, '2026-04-16', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (886, 9, '2026-04-16', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (887, 9, '2026-04-16', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (888, 9, '2026-04-16', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (889, 9, '2026-04-16', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (890, 9, '2026-04-16', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (891, 9, '2026-04-16', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (892, 9, '2026-04-16', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (893, 9, '2026-04-16', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (894, 9, '2026-04-16', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (895, 9, '2026-04-16', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (896, 9, '2026-04-16', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (897, 9, '2026-04-16', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (898, 10, '2026-04-10', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (899, 10, '2026-04-10', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (900, 10, '2026-04-10', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (901, 10, '2026-04-10', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (902, 10, '2026-04-10', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (903, 10, '2026-04-10', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (904, 10, '2026-04-10', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (905, 10, '2026-04-10', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (906, 10, '2026-04-10', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (907, 10, '2026-04-10', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (908, 10, '2026-04-10', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (909, 10, '2026-04-10', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (910, 10, '2026-04-10', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (911, 10, '2026-04-10', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (912, 10, '2026-04-11', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (913, 10, '2026-04-11', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (914, 10, '2026-04-11', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (915, 10, '2026-04-11', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (916, 10, '2026-04-11', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (917, 10, '2026-04-11', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (918, 10, '2026-04-11', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (919, 10, '2026-04-11', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (920, 10, '2026-04-11', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (921, 10, '2026-04-11', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (922, 10, '2026-04-11', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (923, 10, '2026-04-11', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (924, 10, '2026-04-11', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (925, 10, '2026-04-11', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (926, 10, '2026-04-12', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (927, 10, '2026-04-12', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (928, 10, '2026-04-12', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (929, 10, '2026-04-12', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (930, 10, '2026-04-12', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (931, 10, '2026-04-12', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (932, 10, '2026-04-12', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (933, 10, '2026-04-12', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (934, 10, '2026-04-12', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (935, 10, '2026-04-12', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (936, 10, '2026-04-12', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (937, 10, '2026-04-12', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (938, 10, '2026-04-12', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (939, 10, '2026-04-12', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (940, 10, '2026-04-13', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (941, 10, '2026-04-13', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (942, 10, '2026-04-13', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (943, 10, '2026-04-13', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (944, 10, '2026-04-13', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (945, 10, '2026-04-13', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (946, 10, '2026-04-13', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (947, 10, '2026-04-13', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (948, 10, '2026-04-13', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (949, 10, '2026-04-13', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (950, 10, '2026-04-13', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (951, 10, '2026-04-13', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (952, 10, '2026-04-13', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (953, 10, '2026-04-13', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (954, 10, '2026-04-14', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (955, 10, '2026-04-14', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (956, 10, '2026-04-14', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (957, 10, '2026-04-14', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (958, 10, '2026-04-14', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (959, 10, '2026-04-14', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (960, 10, '2026-04-14', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (961, 10, '2026-04-14', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (962, 10, '2026-04-14', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (963, 10, '2026-04-14', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (964, 10, '2026-04-14', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (965, 10, '2026-04-14', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (966, 10, '2026-04-14', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (967, 10, '2026-04-14', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (968, 10, '2026-04-15', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (969, 10, '2026-04-15', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (970, 10, '2026-04-15', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (971, 10, '2026-04-15', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (972, 10, '2026-04-15', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (973, 10, '2026-04-15', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (974, 10, '2026-04-15', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (975, 10, '2026-04-15', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (976, 10, '2026-04-15', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (977, 10, '2026-04-15', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (978, 10, '2026-04-15', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (979, 10, '2026-04-15', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (980, 10, '2026-04-15', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (981, 10, '2026-04-15', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (982, 10, '2026-04-16', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (983, 10, '2026-04-16', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (984, 10, '2026-04-16', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (985, 10, '2026-04-16', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (986, 10, '2026-04-16', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (987, 10, '2026-04-16', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (988, 10, '2026-04-16', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (989, 10, '2026-04-16', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (990, 10, '2026-04-16', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (991, 10, '2026-04-16', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (992, 10, '2026-04-16', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (993, 10, '2026-04-16', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (994, 10, '2026-04-16', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (995, 10, '2026-04-16', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (996, 11, '2026-04-10', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (997, 11, '2026-04-10', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (998, 11, '2026-04-10', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (999, 11, '2026-04-10', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1000, 11, '2026-04-10', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1001, 11, '2026-04-10', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1002, 11, '2026-04-10', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1003, 11, '2026-04-10', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1004, 11, '2026-04-10', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1005, 11, '2026-04-10', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1006, 11, '2026-04-10', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1007, 11, '2026-04-10', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1008, 11, '2026-04-10', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1009, 11, '2026-04-10', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1010, 11, '2026-04-11', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1011, 11, '2026-04-11', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1012, 11, '2026-04-11', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1013, 11, '2026-04-11', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1014, 11, '2026-04-11', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1015, 11, '2026-04-11', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1016, 11, '2026-04-11', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1017, 11, '2026-04-11', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1018, 11, '2026-04-11', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1019, 11, '2026-04-11', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1020, 11, '2026-04-11', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1021, 11, '2026-04-11', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1022, 11, '2026-04-11', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1023, 11, '2026-04-11', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1024, 11, '2026-04-12', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1025, 11, '2026-04-12', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1026, 11, '2026-04-12', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1027, 11, '2026-04-12', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1028, 11, '2026-04-12', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1029, 11, '2026-04-12', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1030, 11, '2026-04-12', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1031, 11, '2026-04-12', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1032, 11, '2026-04-12', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1033, 11, '2026-04-12', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1034, 11, '2026-04-12', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1035, 11, '2026-04-12', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1036, 11, '2026-04-12', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1037, 11, '2026-04-12', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1038, 11, '2026-04-13', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1039, 11, '2026-04-13', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1040, 11, '2026-04-13', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1041, 11, '2026-04-13', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1042, 11, '2026-04-13', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1043, 11, '2026-04-13', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1044, 11, '2026-04-13', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1045, 11, '2026-04-13', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1046, 11, '2026-04-13', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1047, 11, '2026-04-13', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1048, 11, '2026-04-13', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1049, 11, '2026-04-13', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1050, 11, '2026-04-13', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1051, 11, '2026-04-13', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1052, 11, '2026-04-14', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1053, 11, '2026-04-14', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1054, 11, '2026-04-14', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1055, 11, '2026-04-14', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1056, 11, '2026-04-14', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1057, 11, '2026-04-14', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1058, 11, '2026-04-14', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1059, 11, '2026-04-14', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1060, 11, '2026-04-14', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1061, 11, '2026-04-14', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1062, 11, '2026-04-14', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1063, 11, '2026-04-14', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1064, 11, '2026-04-14', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1065, 11, '2026-04-14', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1066, 11, '2026-04-15', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1067, 11, '2026-04-15', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1068, 11, '2026-04-15', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1069, 11, '2026-04-15', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1070, 11, '2026-04-15', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1071, 11, '2026-04-15', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1072, 11, '2026-04-15', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1073, 11, '2026-04-15', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1074, 11, '2026-04-15', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1075, 11, '2026-04-15', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1076, 11, '2026-04-15', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1077, 11, '2026-04-15', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1078, 11, '2026-04-15', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1079, 11, '2026-04-15', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1080, 11, '2026-04-16', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1081, 11, '2026-04-16', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1082, 11, '2026-04-16', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1083, 11, '2026-04-16', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1084, 11, '2026-04-16', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1085, 11, '2026-04-16', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1086, 11, '2026-04-16', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1087, 11, '2026-04-16', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1088, 11, '2026-04-16', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1089, 11, '2026-04-16', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1090, 11, '2026-04-16', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1091, 11, '2026-04-16', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1092, 11, '2026-04-16', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1093, 11, '2026-04-16', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1094, 12, '2026-04-10', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1095, 12, '2026-04-10', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1096, 12, '2026-04-10', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1097, 12, '2026-04-10', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1098, 12, '2026-04-10', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1099, 12, '2026-04-10', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1100, 12, '2026-04-10', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1101, 12, '2026-04-10', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1102, 12, '2026-04-10', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1103, 12, '2026-04-10', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1104, 12, '2026-04-10', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1105, 12, '2026-04-10', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1106, 12, '2026-04-10', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1107, 12, '2026-04-10', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1108, 12, '2026-04-11', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1109, 12, '2026-04-11', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1110, 12, '2026-04-11', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1111, 12, '2026-04-11', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1112, 12, '2026-04-11', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1113, 12, '2026-04-11', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1114, 12, '2026-04-11', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1115, 12, '2026-04-11', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1116, 12, '2026-04-11', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1117, 12, '2026-04-11', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1118, 12, '2026-04-11', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1119, 12, '2026-04-11', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1120, 12, '2026-04-11', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1121, 12, '2026-04-11', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:32', '2026-04-10 14:17:32', 0);
INSERT INTO `timeslot` VALUES (1122, 12, '2026-04-12', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1123, 12, '2026-04-12', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1124, 12, '2026-04-12', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1125, 12, '2026-04-12', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1126, 12, '2026-04-12', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1127, 12, '2026-04-12', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1128, 12, '2026-04-12', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1129, 12, '2026-04-12', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1130, 12, '2026-04-12', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1131, 12, '2026-04-12', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1132, 12, '2026-04-12', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1133, 12, '2026-04-12', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1134, 12, '2026-04-12', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1135, 12, '2026-04-12', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1136, 12, '2026-04-13', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1137, 12, '2026-04-13', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1138, 12, '2026-04-13', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1139, 12, '2026-04-13', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1140, 12, '2026-04-13', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1141, 12, '2026-04-13', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1142, 12, '2026-04-13', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1143, 12, '2026-04-13', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1144, 12, '2026-04-13', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1145, 12, '2026-04-13', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1146, 12, '2026-04-13', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1147, 12, '2026-04-13', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1148, 12, '2026-04-13', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1149, 12, '2026-04-13', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1150, 12, '2026-04-14', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1151, 12, '2026-04-14', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1152, 12, '2026-04-14', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1153, 12, '2026-04-14', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1154, 12, '2026-04-14', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1155, 12, '2026-04-14', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1156, 12, '2026-04-14', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1157, 12, '2026-04-14', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1158, 12, '2026-04-14', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1159, 12, '2026-04-14', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1160, 12, '2026-04-14', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1161, 12, '2026-04-14', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1162, 12, '2026-04-14', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1163, 12, '2026-04-14', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1164, 12, '2026-04-15', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1165, 12, '2026-04-15', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1166, 12, '2026-04-15', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1167, 12, '2026-04-15', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1168, 12, '2026-04-15', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1169, 12, '2026-04-15', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1170, 12, '2026-04-15', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1171, 12, '2026-04-15', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1172, 12, '2026-04-15', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1173, 12, '2026-04-15', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1174, 12, '2026-04-15', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1175, 12, '2026-04-15', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1176, 12, '2026-04-15', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1177, 12, '2026-04-15', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1178, 12, '2026-04-16', '08:00:00', '09:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1179, 12, '2026-04-16', '09:00:00', '10:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1180, 12, '2026-04-16', '10:00:00', '11:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1181, 12, '2026-04-16', '11:00:00', '12:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1182, 12, '2026-04-16', '12:00:00', '13:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1183, 12, '2026-04-16', '13:00:00', '14:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1184, 12, '2026-04-16', '14:00:00', '15:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1185, 12, '2026-04-16', '15:00:00', '16:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1186, 12, '2026-04-16', '16:00:00', '17:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1187, 12, '2026-04-16', '17:00:00', '18:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1188, 12, '2026-04-16', '18:00:00', '19:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1189, 12, '2026-04-16', '19:00:00', '20:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1190, 12, '2026-04-16', '20:00:00', '21:00:00', 120.00, 'AVAILABLE', 4, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1191, 12, '2026-04-16', '21:00:00', '22:00:00', 80.00, 'AVAILABLE', 4, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1192, 13, '2026-04-10', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1193, 13, '2026-04-10', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1194, 13, '2026-04-10', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1195, 13, '2026-04-10', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1196, 13, '2026-04-10', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1197, 13, '2026-04-10', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1198, 13, '2026-04-10', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1199, 13, '2026-04-10', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1200, 13, '2026-04-10', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1201, 13, '2026-04-10', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1202, 13, '2026-04-10', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1203, 13, '2026-04-10', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1204, 13, '2026-04-10', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1205, 13, '2026-04-10', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1206, 13, '2026-04-10', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1207, 13, '2026-04-10', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1208, 13, '2026-04-10', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1209, 13, '2026-04-11', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1210, 13, '2026-04-11', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1211, 13, '2026-04-11', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1212, 13, '2026-04-11', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1213, 13, '2026-04-11', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1214, 13, '2026-04-11', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1215, 13, '2026-04-11', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1216, 13, '2026-04-11', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1217, 13, '2026-04-11', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1218, 13, '2026-04-11', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1219, 13, '2026-04-11', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1220, 13, '2026-04-11', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1221, 13, '2026-04-11', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1222, 13, '2026-04-11', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1223, 13, '2026-04-11', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1224, 13, '2026-04-11', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1225, 13, '2026-04-11', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1226, 13, '2026-04-12', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1227, 13, '2026-04-12', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1228, 13, '2026-04-12', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1229, 13, '2026-04-12', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1230, 13, '2026-04-12', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1231, 13, '2026-04-12', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1232, 13, '2026-04-12', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1233, 13, '2026-04-12', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1234, 13, '2026-04-12', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1235, 13, '2026-04-12', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1236, 13, '2026-04-12', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1237, 13, '2026-04-12', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1238, 13, '2026-04-12', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1239, 13, '2026-04-12', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1240, 13, '2026-04-12', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1241, 13, '2026-04-12', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1242, 13, '2026-04-12', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1243, 13, '2026-04-13', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1244, 13, '2026-04-13', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1245, 13, '2026-04-13', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1246, 13, '2026-04-13', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1247, 13, '2026-04-13', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1248, 13, '2026-04-13', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1249, 13, '2026-04-13', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1250, 13, '2026-04-13', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1251, 13, '2026-04-13', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1252, 13, '2026-04-13', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1253, 13, '2026-04-13', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1254, 13, '2026-04-13', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1255, 13, '2026-04-13', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1256, 13, '2026-04-13', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1257, 13, '2026-04-13', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1258, 13, '2026-04-13', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1259, 13, '2026-04-13', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1260, 13, '2026-04-14', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1261, 13, '2026-04-14', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1262, 13, '2026-04-14', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1263, 13, '2026-04-14', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1264, 13, '2026-04-14', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1265, 13, '2026-04-14', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1266, 13, '2026-04-14', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1267, 13, '2026-04-14', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1268, 13, '2026-04-14', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1269, 13, '2026-04-14', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1270, 13, '2026-04-14', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1271, 13, '2026-04-14', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1272, 13, '2026-04-14', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1273, 13, '2026-04-14', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1274, 13, '2026-04-14', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1275, 13, '2026-04-14', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1276, 13, '2026-04-14', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1277, 13, '2026-04-15', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1278, 13, '2026-04-15', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1279, 13, '2026-04-15', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1280, 13, '2026-04-15', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1281, 13, '2026-04-15', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1282, 13, '2026-04-15', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1283, 13, '2026-04-15', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1284, 13, '2026-04-15', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1285, 13, '2026-04-15', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1286, 13, '2026-04-15', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1287, 13, '2026-04-15', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1288, 13, '2026-04-15', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1289, 13, '2026-04-15', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1290, 13, '2026-04-15', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1291, 13, '2026-04-15', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1292, 13, '2026-04-15', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1293, 13, '2026-04-15', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1294, 13, '2026-04-16', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1295, 13, '2026-04-16', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1296, 13, '2026-04-16', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1297, 13, '2026-04-16', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1298, 13, '2026-04-16', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1299, 13, '2026-04-16', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1300, 13, '2026-04-16', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1301, 13, '2026-04-16', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1302, 13, '2026-04-16', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1303, 13, '2026-04-16', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1304, 13, '2026-04-16', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1305, 13, '2026-04-16', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1306, 13, '2026-04-16', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1307, 13, '2026-04-16', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1308, 13, '2026-04-16', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1309, 13, '2026-04-16', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1310, 13, '2026-04-16', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1311, 14, '2026-04-10', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1312, 14, '2026-04-10', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1313, 14, '2026-04-10', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1314, 14, '2026-04-10', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1315, 14, '2026-04-10', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1316, 14, '2026-04-10', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1317, 14, '2026-04-10', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1318, 14, '2026-04-10', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1319, 14, '2026-04-10', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1320, 14, '2026-04-10', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1321, 14, '2026-04-10', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1322, 14, '2026-04-10', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1323, 14, '2026-04-10', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1324, 14, '2026-04-10', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1325, 14, '2026-04-10', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1326, 14, '2026-04-10', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1327, 14, '2026-04-10', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1328, 14, '2026-04-11', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1329, 14, '2026-04-11', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1330, 14, '2026-04-11', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1331, 14, '2026-04-11', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1332, 14, '2026-04-11', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1333, 14, '2026-04-11', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1334, 14, '2026-04-11', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1335, 14, '2026-04-11', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1336, 14, '2026-04-11', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1337, 14, '2026-04-11', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1338, 14, '2026-04-11', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1339, 14, '2026-04-11', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1340, 14, '2026-04-11', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1341, 14, '2026-04-11', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1342, 14, '2026-04-11', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1343, 14, '2026-04-11', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1344, 14, '2026-04-11', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1345, 14, '2026-04-12', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1346, 14, '2026-04-12', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1347, 14, '2026-04-12', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1348, 14, '2026-04-12', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1349, 14, '2026-04-12', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1350, 14, '2026-04-12', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1351, 14, '2026-04-12', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1352, 14, '2026-04-12', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1353, 14, '2026-04-12', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1354, 14, '2026-04-12', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1355, 14, '2026-04-12', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1356, 14, '2026-04-12', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1357, 14, '2026-04-12', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1358, 14, '2026-04-12', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1359, 14, '2026-04-12', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1360, 14, '2026-04-12', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1361, 14, '2026-04-12', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1362, 14, '2026-04-13', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1363, 14, '2026-04-13', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1364, 14, '2026-04-13', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1365, 14, '2026-04-13', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1366, 14, '2026-04-13', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1367, 14, '2026-04-13', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1368, 14, '2026-04-13', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1369, 14, '2026-04-13', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1370, 14, '2026-04-13', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1371, 14, '2026-04-13', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1372, 14, '2026-04-13', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1373, 14, '2026-04-13', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1374, 14, '2026-04-13', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1375, 14, '2026-04-13', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1376, 14, '2026-04-13', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1377, 14, '2026-04-13', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1378, 14, '2026-04-13', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1379, 14, '2026-04-14', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1380, 14, '2026-04-14', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1381, 14, '2026-04-14', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1382, 14, '2026-04-14', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1383, 14, '2026-04-14', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1384, 14, '2026-04-14', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1385, 14, '2026-04-14', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1386, 14, '2026-04-14', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1387, 14, '2026-04-14', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1388, 14, '2026-04-14', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1389, 14, '2026-04-14', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1390, 14, '2026-04-14', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1391, 14, '2026-04-14', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1392, 14, '2026-04-14', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1393, 14, '2026-04-14', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1394, 14, '2026-04-14', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1395, 14, '2026-04-14', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1396, 14, '2026-04-15', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1397, 14, '2026-04-15', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1398, 14, '2026-04-15', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1399, 14, '2026-04-15', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1400, 14, '2026-04-15', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1401, 14, '2026-04-15', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1402, 14, '2026-04-15', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1403, 14, '2026-04-15', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1404, 14, '2026-04-15', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1405, 14, '2026-04-15', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1406, 14, '2026-04-15', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1407, 14, '2026-04-15', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1408, 14, '2026-04-15', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1409, 14, '2026-04-15', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1410, 14, '2026-04-15', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1411, 14, '2026-04-15', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1412, 14, '2026-04-15', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1413, 14, '2026-04-16', '06:00:00', '07:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1414, 14, '2026-04-16', '07:00:00', '08:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1415, 14, '2026-04-16', '08:00:00', '09:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1416, 14, '2026-04-16', '09:00:00', '10:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1417, 14, '2026-04-16', '10:00:00', '11:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1418, 14, '2026-04-16', '11:00:00', '12:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1419, 14, '2026-04-16', '12:00:00', '13:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1420, 14, '2026-04-16', '13:00:00', '14:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1421, 14, '2026-04-16', '14:00:00', '15:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1422, 14, '2026-04-16', '15:00:00', '16:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1423, 14, '2026-04-16', '16:00:00', '17:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1424, 14, '2026-04-16', '17:00:00', '18:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1425, 14, '2026-04-16', '18:00:00', '19:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1426, 14, '2026-04-16', '19:00:00', '20:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1427, 14, '2026-04-16', '20:00:00', '21:00:00', 37.50, 'AVAILABLE', 20, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1428, 14, '2026-04-16', '21:00:00', '22:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1429, 14, '2026-04-16', '22:00:00', '23:00:00', 25.00, 'AVAILABLE', 20, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1430, 15, '2026-04-10', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1431, 15, '2026-04-10', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1432, 15, '2026-04-10', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1433, 15, '2026-04-10', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1434, 15, '2026-04-10', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1435, 15, '2026-04-10', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1436, 15, '2026-04-10', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1437, 15, '2026-04-10', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1438, 15, '2026-04-10', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1439, 15, '2026-04-10', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1440, 15, '2026-04-10', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1441, 15, '2026-04-10', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1442, 15, '2026-04-10', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1443, 15, '2026-04-10', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1444, 15, '2026-04-10', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1445, 15, '2026-04-10', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1446, 15, '2026-04-10', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1447, 15, '2026-04-11', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1448, 15, '2026-04-11', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1449, 15, '2026-04-11', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1450, 15, '2026-04-11', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1451, 15, '2026-04-11', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1452, 15, '2026-04-11', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1453, 15, '2026-04-11', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1454, 15, '2026-04-11', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1455, 15, '2026-04-11', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1456, 15, '2026-04-11', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1457, 15, '2026-04-11', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1458, 15, '2026-04-11', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1459, 15, '2026-04-11', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1460, 15, '2026-04-11', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1461, 15, '2026-04-11', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1462, 15, '2026-04-11', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1463, 15, '2026-04-11', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1464, 15, '2026-04-12', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1465, 15, '2026-04-12', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1466, 15, '2026-04-12', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1467, 15, '2026-04-12', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1468, 15, '2026-04-12', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1469, 15, '2026-04-12', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1470, 15, '2026-04-12', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1471, 15, '2026-04-12', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1472, 15, '2026-04-12', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1473, 15, '2026-04-12', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1474, 15, '2026-04-12', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1475, 15, '2026-04-12', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1476, 15, '2026-04-12', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1477, 15, '2026-04-12', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1478, 15, '2026-04-12', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1479, 15, '2026-04-12', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1480, 15, '2026-04-12', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1481, 15, '2026-04-13', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1482, 15, '2026-04-13', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1483, 15, '2026-04-13', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1484, 15, '2026-04-13', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1485, 15, '2026-04-13', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1486, 15, '2026-04-13', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1487, 15, '2026-04-13', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1488, 15, '2026-04-13', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1489, 15, '2026-04-13', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1490, 15, '2026-04-13', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1491, 15, '2026-04-13', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1492, 15, '2026-04-13', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1493, 15, '2026-04-13', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1494, 15, '2026-04-13', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1495, 15, '2026-04-13', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1496, 15, '2026-04-13', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1497, 15, '2026-04-13', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1498, 15, '2026-04-14', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1499, 15, '2026-04-14', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1500, 15, '2026-04-14', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1501, 15, '2026-04-14', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1502, 15, '2026-04-14', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1503, 15, '2026-04-14', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1504, 15, '2026-04-14', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1505, 15, '2026-04-14', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1506, 15, '2026-04-14', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1507, 15, '2026-04-14', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1508, 15, '2026-04-14', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1509, 15, '2026-04-14', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1510, 15, '2026-04-14', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1511, 15, '2026-04-14', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1512, 15, '2026-04-14', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1513, 15, '2026-04-14', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1514, 15, '2026-04-14', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1515, 15, '2026-04-15', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1516, 15, '2026-04-15', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1517, 15, '2026-04-15', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1518, 15, '2026-04-15', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1519, 15, '2026-04-15', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1520, 15, '2026-04-15', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1521, 15, '2026-04-15', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1522, 15, '2026-04-15', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1523, 15, '2026-04-15', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1524, 15, '2026-04-15', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1525, 15, '2026-04-15', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1526, 15, '2026-04-15', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1527, 15, '2026-04-15', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1528, 15, '2026-04-15', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1529, 15, '2026-04-15', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1530, 15, '2026-04-15', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1531, 15, '2026-04-15', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1532, 15, '2026-04-16', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1533, 15, '2026-04-16', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1534, 15, '2026-04-16', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1535, 15, '2026-04-16', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1536, 15, '2026-04-16', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1537, 15, '2026-04-16', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1538, 15, '2026-04-16', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1539, 15, '2026-04-16', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1540, 15, '2026-04-16', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1541, 15, '2026-04-16', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1542, 15, '2026-04-16', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1543, 15, '2026-04-16', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1544, 15, '2026-04-16', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1545, 15, '2026-04-16', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1546, 15, '2026-04-16', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1547, 15, '2026-04-16', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1548, 15, '2026-04-16', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1549, 16, '2026-04-10', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1550, 16, '2026-04-10', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1551, 16, '2026-04-10', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1552, 16, '2026-04-10', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1553, 16, '2026-04-10', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1554, 16, '2026-04-10', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1555, 16, '2026-04-10', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1556, 16, '2026-04-10', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1557, 16, '2026-04-10', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1558, 16, '2026-04-10', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1559, 16, '2026-04-10', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1560, 16, '2026-04-10', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1561, 16, '2026-04-10', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1562, 16, '2026-04-10', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1563, 16, '2026-04-10', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1564, 16, '2026-04-10', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1565, 16, '2026-04-10', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1566, 16, '2026-04-11', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1567, 16, '2026-04-11', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1568, 16, '2026-04-11', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1569, 16, '2026-04-11', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1570, 16, '2026-04-11', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1571, 16, '2026-04-11', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1572, 16, '2026-04-11', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1573, 16, '2026-04-11', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1574, 16, '2026-04-11', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1575, 16, '2026-04-11', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1576, 16, '2026-04-11', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1577, 16, '2026-04-11', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1578, 16, '2026-04-11', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1579, 16, '2026-04-11', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1580, 16, '2026-04-11', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1581, 16, '2026-04-11', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1582, 16, '2026-04-11', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1583, 16, '2026-04-12', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1584, 16, '2026-04-12', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1585, 16, '2026-04-12', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1586, 16, '2026-04-12', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1587, 16, '2026-04-12', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1588, 16, '2026-04-12', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1589, 16, '2026-04-12', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1590, 16, '2026-04-12', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1591, 16, '2026-04-12', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1592, 16, '2026-04-12', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1593, 16, '2026-04-12', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1594, 16, '2026-04-12', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1595, 16, '2026-04-12', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1596, 16, '2026-04-12', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1597, 16, '2026-04-12', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1598, 16, '2026-04-12', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1599, 16, '2026-04-12', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1600, 16, '2026-04-13', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1601, 16, '2026-04-13', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1602, 16, '2026-04-13', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1603, 16, '2026-04-13', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1604, 16, '2026-04-13', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1605, 16, '2026-04-13', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1606, 16, '2026-04-13', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1607, 16, '2026-04-13', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1608, 16, '2026-04-13', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1609, 16, '2026-04-13', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1610, 16, '2026-04-13', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1611, 16, '2026-04-13', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1612, 16, '2026-04-13', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1613, 16, '2026-04-13', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1614, 16, '2026-04-13', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1615, 16, '2026-04-13', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1616, 16, '2026-04-13', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1617, 16, '2026-04-14', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1618, 16, '2026-04-14', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1619, 16, '2026-04-14', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1620, 16, '2026-04-14', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1621, 16, '2026-04-14', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1622, 16, '2026-04-14', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1623, 16, '2026-04-14', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1624, 16, '2026-04-14', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1625, 16, '2026-04-14', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1626, 16, '2026-04-14', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1627, 16, '2026-04-14', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1628, 16, '2026-04-14', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1629, 16, '2026-04-14', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1630, 16, '2026-04-14', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1631, 16, '2026-04-14', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1632, 16, '2026-04-14', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1633, 16, '2026-04-14', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1634, 16, '2026-04-15', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1635, 16, '2026-04-15', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1636, 16, '2026-04-15', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1637, 16, '2026-04-15', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1638, 16, '2026-04-15', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1639, 16, '2026-04-15', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1640, 16, '2026-04-15', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1641, 16, '2026-04-15', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1642, 16, '2026-04-15', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1643, 16, '2026-04-15', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1644, 16, '2026-04-15', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1645, 16, '2026-04-15', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1646, 16, '2026-04-15', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1647, 16, '2026-04-15', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1648, 16, '2026-04-15', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1649, 16, '2026-04-15', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1650, 16, '2026-04-15', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1651, 16, '2026-04-16', '06:00:00', '07:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1652, 16, '2026-04-16', '07:00:00', '08:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1653, 16, '2026-04-16', '08:00:00', '09:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1654, 16, '2026-04-16', '09:00:00', '10:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1655, 16, '2026-04-16', '10:00:00', '11:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1656, 16, '2026-04-16', '11:00:00', '12:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1657, 16, '2026-04-16', '12:00:00', '13:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1658, 16, '2026-04-16', '13:00:00', '14:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1659, 16, '2026-04-16', '14:00:00', '15:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1660, 16, '2026-04-16', '15:00:00', '16:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1661, 16, '2026-04-16', '16:00:00', '17:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1662, 16, '2026-04-16', '17:00:00', '18:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1663, 16, '2026-04-16', '18:00:00', '19:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1664, 16, '2026-04-16', '19:00:00', '20:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1665, 16, '2026-04-16', '20:00:00', '21:00:00', 60.00, 'AVAILABLE', 15, 0, 1, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1666, 16, '2026-04-16', '21:00:00', '22:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);
INSERT INTO `timeslot` VALUES (1667, 16, '2026-04-16', '22:00:00', '23:00:00', 40.00, 'AVAILABLE', 15, 0, 0, '2026-04-10 14:17:33', '2026-04-10 14:17:33', 0);

-- ----------------------------
-- Table structure for user_coupon
-- ----------------------------
DROP TABLE IF EXISTS `user_coupon`;
CREATE TABLE `user_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `coupon_id` bigint NOT NULL COMMENT '优惠券ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UNUSED' COMMENT '状态: UNUSED, USED, EXPIRED',
  `used_at` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `expire_at` datetime NOT NULL COMMENT '过期时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_coupon`(`user_id` ASC, `coupon_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户优惠券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_coupon
-- ----------------------------
INSERT INTO `user_coupon` VALUES (1, 5, 1, 'UNUSED', NULL, '2026-01-26 14:16:24', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `user_coupon` VALUES (2, 6, 1, 'UNUSED', NULL, '2026-01-26 14:16:24', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `user_coupon` VALUES (3, 7, 2, 'UNUSED', NULL, '2026-01-11 14:16:24', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `user_coupon` VALUES (4, 6, 3, 'UNUSED', NULL, '2026-02-25 14:16:24', '2026-01-18 14:43:31', '2026-01-18 14:43:31');

-- ----------------------------
-- Table structure for user_venue
-- ----------------------------
DROP TABLE IF EXISTS `user_venue`;
CREATE TABLE `user_venue`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `venue_id` bigint NOT NULL COMMENT '场馆ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_venue`(`user_id` ASC, `venue_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户场馆关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_venue
-- ----------------------------
INSERT INTO `user_venue` VALUES (1, 3, 1, '2025-12-27 14:16:24');
INSERT INTO `user_venue` VALUES (2, 3, 2, '2025-12-27 14:16:24');
INSERT INTO `user_venue` VALUES (3, 4, 3, '2025-12-27 14:16:24');
INSERT INTO `user_venue` VALUES (4, 4, 4, '2025-12-27 14:16:24');
INSERT INTO `user_venue` VALUES (5, 4, 5, '2025-12-27 14:16:24');

-- ----------------------------
-- Table structure for venue
-- ----------------------------
DROP TABLE IF EXISTS `venue`;
CREATE TABLE `venue`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '场馆ID',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '场馆名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `open_time` time NOT NULL DEFAULT '08:00:00' COMMENT '开放时间',
  `close_time` time NOT NULL DEFAULT '22:00:00' COMMENT '关闭时间',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片URL列表(JSON)',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'OPEN' COMMENT '状态: OPEN, CLOSED, MAINTENANCE',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '场馆表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of venue
-- ----------------------------
INSERT INTO `venue` VALUES (1, '体育馆A', '校区东门体育中心1号楼', '021-12345678', '综合性体育馆，设施齐全，环境优雅，提供多种运动项目', '08:00:00', '22:00:00', '/api/files/venue/venue_d7391e7d-4540-441d-ba5b-63236dcf1572.webp', 'OPEN', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `venue` VALUES (2, '体育馆B', '校区西门体育中心2号楼', '021-12345679', '专业羽毛球馆，拥有12片标准场地，灯光充足', '09:00:00', '21:00:00', '/api/files/venue/venue_5ed4685d-764b-4aa7-835f-693063f84e94.webp', 'OPEN', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `venue` VALUES (3, '体育馆C', '校区南门体育中心3号楼', '021-12345680', '网球运动中心，4片标准网球场，专业教练指导', '08:00:00', '22:00:00', '/api/files/venue/venue_bdded006-0aea-40d1-b72d-bb62f9d3fc2a.webp', 'OPEN', '2025-12-27 14:16:24', '2025-12-27 14:16:24');
INSERT INTO `venue` VALUES (4, '健身中心', '校区北门健身大厦', '021-12345681', '现代化健身中心，器械齐全，环境舒适', '06:00:00', '23:00:00', '/api/files/venue/venue_5e799ffc-e640-4558-8697-d64e1a11956b.webp', 'OPEN', '2025-12-27 14:16:24', '2025-12-27 14:16:24');

SET FOREIGN_KEY_CHECKS = 1;
