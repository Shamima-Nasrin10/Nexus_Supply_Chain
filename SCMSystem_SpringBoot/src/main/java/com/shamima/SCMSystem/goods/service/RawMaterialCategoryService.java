package com.shamima.SCMSystem.goods.service;

import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.entity.RawMaterialCategory;
import com.shamima.SCMSystem.goods.repository.RawMaterialCategoryRepository;
import com.shamima.SCMSystem.goods.repository.RawMaterialRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RawMaterialCategoryService {

    @Autowired
    private RawMaterialCategoryRepository rawMaterialCategoryRepository;

    @Autowired
    private RawMaterialRepository rawMaterialRepository;

    public ApiResponse getRawMaterialCategories() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMaterialCategory> categories = rawMaterialCategoryRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("categories", categories);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse saveRawMaterialCategory(RawMaterialCategory rmc) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            rawMaterialCategoryRepository.save(rmc);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material Category saved successfully");
            apiResponse.setData("category", rmc);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateRawMaterialCategory(RawMaterialCategory rmc) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterialCategory existingRMC = rawMaterialCategoryRepository.findById(rmc.getId()).orElse(null);
            if (existingRMC == null) {
                apiResponse.setMessage("Category with ID " + rmc.getId() + " not found");
                return apiResponse;
            }
            rawMaterialCategoryRepository.save(rmc);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material Category updated successfully");
            apiResponse.setData("category", rmc);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse findRawMaterialCategoryById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterialCategory category = rawMaterialCategoryRepository.findById(id).orElse(null);
            if (category == null) {
                apiResponse.setMessage("Category with ID " + id + " not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("category", category);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse deleteRawMaterialCategoryById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMaterial> existingRawMaterials = rawMaterialRepository.findAllByCategoryId(id);
            for (RawMaterial rawMaterial : existingRawMaterials) {
                rawMaterialRepository.delete(rawMaterial);
            }
            rawMaterialCategoryRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material Category and related materials deleted successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }
}

