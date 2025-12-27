package com.gym.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.gym.entity.OperationLog;

public interface OperationLogService extends IService<OperationLog> {
    /**
     * 记录操作日志
     */
    void log(Long userId, String action, String module, String targetType, Long targetId, String ip, String userAgent, String details);
}
