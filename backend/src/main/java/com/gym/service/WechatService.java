package com.gym.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gym.config.WechatConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class WechatService {
    
    private final WechatConfig wechatConfig;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    /**
     * 使用code换取openid和session_key
     * @param code 微信登录凭证
     * @return openid
     */
    public String getOpenId(String code) {
        String url = String.format(
            "https://api.weixin.qq.com/sns/jscode2session?appid=%s&secret=%s&js_code=%s&grant_type=authorization_code",
            wechatConfig.getAppId(),
            wechatConfig.getAppSecret(),
            code
        );
        
        try {
            log.info("调用微信API获取openid, code={}", code);
            
            // 使用 String 接收响应，然后手动解析
            ResponseEntity<String> responseEntity = restTemplate.getForEntity(url, String.class);
            String responseBody = responseEntity.getBody();
            
            log.info("微信API响应: {}", responseBody);
            
            // 手动解析JSON
            Map<String, Object> response = objectMapper.readValue(responseBody, Map.class);
            
            if (response.containsKey("openid")) {
                String openid = (String) response.get("openid");
                log.info("获取openid成功: {}", openid);
                return openid;
            } else if (response.containsKey("errcode")) {
                Integer errcode = (Integer) response.get("errcode");
                String errmsg = (String) response.get("errmsg");
                log.error("微信API返回错误: errcode={}, errmsg={}", errcode, errmsg);
                throw new RuntimeException("微信登录失败: " + errmsg);
            } else {
                log.error("获取openid失败: {}", response);
                throw new RuntimeException("获取openid失败");
            }
        } catch (Exception e) {
            log.error("调用微信API失败", e);
            throw new RuntimeException("微信登录失败: " + e.getMessage());
        }
    }
}
