package com.gym.controller;

import com.gym.service.FileStorageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

@Tag(name = "文件管理", description = "文件上传、下载、删除接口")
@RestController
@RequestMapping("/files")
public class FileController {
    
    @Autowired
    private FileStorageService fileStorageService;
    
    @Operation(summary = "上传用户头像")
    @PostMapping(value = "/upload/avatar", produces = "application/json;charset=UTF-8")
    public ResponseEntity<Map<String, Object>> uploadAvatar(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = fileStorageService.uploadAvatar(file);
            String fileUrl = "/api/files/avatar/" + fileName;
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("fileName", fileName);
            response.put("fileUrl", fileUrl);
            response.put("message", "头像上传成功");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @Operation(summary = "上传场馆图片")
    @PostMapping(value = "/upload/venue", produces = "application/json;charset=UTF-8")
    public ResponseEntity<Map<String, Object>> uploadVenueImage(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = fileStorageService.uploadVenueImage(file);
            String fileUrl = "/api/files/venue/" + fileName;
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("fileName", fileName);
            response.put("fileUrl", fileUrl);
            response.put("message", "场馆图片上传成功");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @Operation(summary = "下载/查看头像")
    @GetMapping("/avatar/{fileName:.+}")
    public ResponseEntity<Resource> downloadAvatar(@PathVariable String fileName) {
        return downloadFile(fileName, "avatar");
    }
    
    @Operation(summary = "下载/查看场馆图片")
    @GetMapping("/venue/{fileName:.+}")
    public ResponseEntity<Resource> downloadVenueImage(@PathVariable String fileName) {
        return downloadFile(fileName, "venue");
    }
    
    @Operation(summary = "删除头像")
    @DeleteMapping("/avatar/{fileName:.+}")
    public ResponseEntity<Map<String, Object>> deleteAvatar(@PathVariable String fileName) {
        return deleteFile(fileName, "avatar");
    }
    
    @Operation(summary = "删除场馆图片")
    @DeleteMapping("/venue/{fileName:.+}")
    public ResponseEntity<Map<String, Object>> deleteVenueImage(@PathVariable String fileName) {
        return deleteFile(fileName, "venue");
    }
    
    /**
     * 下载文件通用方法
     */
    private ResponseEntity<Resource> downloadFile(String fileName, String type) {
        try {
            Path filePath = fileStorageService.getFilePath(fileName, type);
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists() && resource.isReadable()) {
                String contentType = determineContentType(fileName);
                
                return ResponseEntity.ok()
                        .contentType(MediaType.parseMediaType(contentType))
                        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * 删除文件通用方法
     */
    private ResponseEntity<Map<String, Object>> deleteFile(String fileName, String type) {
        try {
            fileStorageService.deleteFile(fileName, type);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "文件删除成功");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * 根据文件扩展名确定 Content-Type
     */
    private String determineContentType(String fileName) {
        String extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            case "webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }
}
