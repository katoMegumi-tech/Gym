package com.gym.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gym.entity.OperationLog;
import com.gym.mapper.OperationLogMapper;
import com.gym.service.OperationLogService;
import org.springframework.stereotype.Service;

@Service
public class OperationLogServiceImpl extends ServiceImpl<OperationLogMapper, OperationLog> implements OperationLogService {
    
    @Override
    public void log(Long userId, String action, String module, String targetType, Long targetId, String ip, String userAgent, String details) {
        OperationLog log = new OperationLog();
        log.setUserId(userId);
        log.setAction(action);
        log.setModule(module);
        log.setTargetType(targetType);
        log.setTargetId(targetId);
        log.setIp(ip);
        log.setUserAgent(userAgent);
        log.setDetails(details);
        save(log);
    }
}
