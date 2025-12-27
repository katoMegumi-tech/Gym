package com.gym.service;

import com.gym.config.FileStorageConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageService {
    
    private final Path avatarLocation;
    private final Path venueLocation;
    private final FileStorageConfig fileStorageConfig;
    
    @Autowired
    public FileStorageService(FileStorageConfig fileStorageConfig) {
        this.fileStorageConfig = fileStorageConfig;
        this.avatarLocation = Paths.get(fileStorageConfig.getAvatarDir()).toAbsolutePath().normalize();
        this.venueLocation = Paths.get(fileStorageConfig.getVenueDir()).toAbsolutePath().normalize();
        
        try {
            Files.createDirectories(this.avatarLocation);
            Files.createDirectories(this.venueLocation);
        } catch (Exception ex) {
            throw new RuntimeException("无法创建文件存储目录", ex);
        }
    }
    
    /**
     * 上传用户头像
     */
    public String uploadAvatar(MultipartFile file) {
        return storeFile(file, avatarLocation, "avatar");
    }
    
    /**
     * 上传场馆图片
     */
    public String uploadVenueImage(MultipartFile file) {
        return storeFile(file, venueLocation, "venue");
    }
    
    /**
     * 存储文件
     */
    private String storeFile(MultipartFile file, Path location, String prefix) {
        // 验证文件
        if (file.isEmpty()) {
            throw new RuntimeException("文件为空");
        }
        
        if (file.getSize() > fileStorageConfig.getMaxFileSize()) {
            throw new RuntimeException("文件大小超过限制");
        }
        
        // 获取原始文件名
        String originalFilename = StringUtils.cleanPath(file.getOriginalFilename());
        
        // 验证文件扩展名
        String extension = getFileExtension(originalFilename);
        if (!isValidImageExtension(extension)) {
            throw new RuntimeException("不支持的文件类型");
        }
        
        try {
            // 生成唯一文件名
            String fileName = prefix + "_" + UUID.randomUUID().toString() + "." + extension;
            Path targetLocation = location.resolve(fileName);
            
            // 复制文件
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            
            return fileName;
        } catch (IOException ex) {
            throw new RuntimeException("文件存储失败", ex);
        }
    }
    
    /**
     * 删除文件
     */
    public void deleteFile(String fileName, String type) {
        try {
            Path location = "avatar".equals(type) ? avatarLocation : venueLocation;
            Path filePath = location.resolve(fileName).normalize();
            Files.deleteIfExists(filePath);
        } catch (IOException ex) {
            throw new RuntimeException("文件删除失败", ex);
        }
    }
    
    /**
     * 获取文件路径
     */
    public Path getFilePath(String fileName, String type) {
        Path location = "avatar".equals(type) ? avatarLocation : venueLocation;
        return location.resolve(fileName).normalize();
    }
    
    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String filename) {
        if (filename == null) {
            return "";
        }
        int dotIndex = filename.lastIndexOf('.');
        return (dotIndex == -1) ? "" : filename.substring(dotIndex + 1).toLowerCase();
    }
    
    /**
     * 验证图片扩展名
     */
    private boolean isValidImageExtension(String extension) {
        return extension.equals("jpg") || extension.equals("jpeg") || 
               extension.equals("png") || extension.equals("gif") || 
               extension.equals("webp");
    }
}
