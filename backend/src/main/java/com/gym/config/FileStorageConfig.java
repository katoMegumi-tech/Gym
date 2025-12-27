package com.gym.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "file.storage")
public class FileStorageConfig {
    
    private String uploadDir = "uploads";
    private String avatarDir = "uploads/avatars";
    private String venueDir = "uploads/venues";
    private long maxFileSize = 5242880; // 5MB
    
    public String getUploadDir() {
        return uploadDir;
    }
    
    public void setUploadDir(String uploadDir) {
        this.uploadDir = uploadDir;
    }
    
    public String getAvatarDir() {
        return avatarDir;
    }
    
    public void setAvatarDir(String avatarDir) {
        this.avatarDir = avatarDir;
    }
    
    public String getVenueDir() {
        return venueDir;
    }
    
    public void setVenueDir(String venueDir) {
        this.venueDir = venueDir;
    }
    
    public long getMaxFileSize() {
        return maxFileSize;
    }
    
    public void setMaxFileSize(long maxFileSize) {
        this.maxFileSize = maxFileSize;
    }
}
