-- 更新所有用户的密码为 123456 的Argon2哈希值
-- 原始密码: 123456
-- 加密后的密码: $argon2i$v=19$m=65536,t=2,p=1$IuDYZFzHU/q6+jyec3ik9g$3hIovaZlJLg2ZDoLoy8EX/2uzWY6sye91lotFqCe/Oo

USE gym_reservation;

UPDATE gym_user SET password_hash = '$argon2i$v=19$m=65536,t=2,p=1$IuDYZFzHU/q6+jyec3ik9g$3hIovaZlJLg2ZDoLoy8EX/2uzWY6sye91lotFqCe/Oo' 
WHERE id IN (1, 2, 3, 4, 5, 6, 7, 8);

-- 验证更新
SELECT id, username, password_hash FROM gym_user;
