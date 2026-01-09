package com.gym.util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * Redis分布式锁工具类
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RedisLockUtil {
    
    private final StringRedisTemplate redisTemplate;
    
    private static final String LOCK_PREFIX = "lock:";
    
    // Lua脚本：原子性释放锁（只有持有者才能释放）
    private static final String RELEASE_LOCK_SCRIPT = 
        "if redis.call('get', KEYS[1]) == ARGV[1] then " +
        "   return redis.call('del', KEYS[1]) " +
        "else " +
        "   return 0 " +
        "end";
    
    /**
     * 尝试获取分布式锁
     * @param key 锁的key
     * @param expireSeconds 锁过期时间（秒）
     * @return 锁标识（成功）或 null（失败）
     */
    public String tryLock(String key, long expireSeconds) {
        String lockKey = LOCK_PREFIX + key;
        String lockValue = UUID.randomUUID().toString();
        
        Boolean success = redisTemplate.opsForValue()
                .setIfAbsent(lockKey, lockValue, expireSeconds, TimeUnit.SECONDS);
        
        if (Boolean.TRUE.equals(success)) {
            log.debug("获取锁成功: key={}, value={}", lockKey, lockValue);
            return lockValue;
        }
        
        log.debug("获取锁失败: key={}", lockKey);
        return null;
    }
    
    /**
     * 释放分布式锁
     * @param key 锁的key
     * @param lockValue 锁标识
     * @return 是否释放成功
     */
    public boolean releaseLock(String key, String lockValue) {
        String lockKey = LOCK_PREFIX + key;
        
        DefaultRedisScript<Long> script = new DefaultRedisScript<>();
        script.setScriptText(RELEASE_LOCK_SCRIPT);
        script.setResultType(Long.class);
        
        Long result = redisTemplate.execute(script, 
                Collections.singletonList(lockKey), lockValue);
        
        boolean success = result != null && result == 1;
        log.debug("释放锁: key={}, success={}", lockKey, success);
        return success;
    }
    
    /**
     * 生成预约锁的key
     */
    public static String buildReservationLockKey(Long courtId, String slotDate, String startTime) {
        return String.format("reservation:%d:%s:%s", courtId, slotDate, startTime);
    }
}
