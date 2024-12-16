package com.shamima.SCMSystem.goods.service;

import com.shamima.SCMSystem.goods.entity.*;
import com.shamima.SCMSystem.goods.repository.*;
import com.shamima.SCMSystem.util.ApiResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class RawMaterialService {

    @Autowired
    private RawMaterialRepository rawMaterialRepository;

    @Autowired
    RawMaterialCategoryRepository rawMaterialCategoryRepository;

    @Autowired
    RMStockRepository rmStockRepository;

    @Value("src/main/resources/static/images")
    private String uploadDir;

    public ApiResponse getAllRawMaterials() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMaterial> rawMaterials = rawMaterialRepository.findAll();
            List<RawMaterialStock> rawMaterialStocks = rmStockRepository.findAll();
            for (RawMaterial rawMaterial : rawMaterials) {
                for (RawMaterialStock rawMaterialStock : rawMaterialStocks) {
                    if (rawMaterial.getId() == rawMaterialStock.getRawMaterial().getId()) {
                        rawMaterial.setQuantity(rawMaterialStock.getQuantity());
                    }
                }
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("rawMaterials", rawMaterials);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse saveRawMaterial(RawMaterial rm, MultipartFile imageFile) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            // Verify Category
            RawMaterialCategory rawMaterialCategory = rawMaterialCategoryRepository.findById(rm.getCategory().getId()).orElse(null);
            if (rawMaterialCategory == null) {
                apiResponse.setMessage("Category not found");
                return apiResponse;
            }
            rm.setCategory(rawMaterialCategory);

            // Handle Image Upload
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageFileName = saveImage(imageFile, rm);
                rm.setImage(imageFileName);
            }

            rawMaterialRepository.save(rm);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material saved successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse deleteRawMaterialById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterial rawMaterial = rawMaterialRepository.findById(id).orElse(null);
            if (rawMaterial == null) {
                apiResponse.setMessage("Raw Material not found");
                return apiResponse;
            }
            rawMaterialRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material deleted successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse findRawMaterialById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterial rawMaterial = rawMaterialRepository.findById(id).orElse(null);
            if (rawMaterial == null) {
                apiResponse.setMessage("Raw Material not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("rawMaterial", rawMaterial);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateRawMaterial(RawMaterial updatedRM, MultipartFile imageFile) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterial existingRM = rawMaterialRepository.findById(updatedRM.getId()).orElse(null);
            if (existingRM == null) {
                apiResponse.setMessage("Raw Material not found");
                return apiResponse;
            }

            // Update Category if provided
            if (updatedRM.getCategory() != null && updatedRM.getCategory().getId() != null) {
                RawMaterialCategory rmCategory = rawMaterialCategoryRepository.findById(updatedRM.getCategory().getId()).orElse(null);
                if (rmCategory != null) {
                    existingRM.setCategory(rmCategory);
                } else {
                    apiResponse.setMessage("Category not found");
                    return apiResponse;
                }
            }

            // Update Raw Material details
            existingRM.setName(updatedRM.getName());
            existingRM.setUnit(updatedRM.getUnit());

            // Update image if provided
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageFilename = saveImage(imageFile, existingRM);
                existingRM.setImage(imageFilename);
            }

            rawMaterialRepository.save(existingRM);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material updated successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    private String saveImage(MultipartFile file, RawMaterial rm) throws IOException {
        Path uploadPath = Paths.get(uploadDir + "/rawmaterial");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename != null ?
                originalFilename.substring(originalFilename.lastIndexOf('.')) : "";

        // Generate a unique filename
        String filename = rm.getName() + "_" + UUID.randomUUID() + fileExtension;
        Path filePath = uploadPath.resolve(filename);

        // Save the file
        Files.copy(file.getInputStream(), filePath);

        return filename; // Return the filename for storing in the database
    }

}

