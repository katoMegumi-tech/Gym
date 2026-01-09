-- 为timeslot表添加乐观锁版本字段
-- 执行此SQL以支持高并发预约

ALTER TABLE timeslot ADD COLUMN version INT NOT NULL DEFAULT 0 COMMENT '乐观锁版本号';

-- 为已有数据初始化version
UPDATE timeslot SET version = 0 WHERE version IS NULL;
