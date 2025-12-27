package com.gym.util;

public class PasswordHashGenerator {
    public static void main(String[] args) {
        String password = "123456";
        String encodedPassword = Argon2Util.hash(password);
        System.out.println("原始密码: " + password);
        System.out.println("加密后的密码: " + encodedPassword);
        
        // 验证密码
        boolean isValid = Argon2Util.verify(encodedPassword, password);
        System.out.println("密码验证结果: " + isValid);
    }
}
