package com.shamima.SCMSystem.production.service;

import com.shamima.SCMSystem.production.entity.RawMatUsage;
import com.shamima.SCMSystem.production.repository.RawMatUsageRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RawMatUsageService {

    @Autowired
    private RawMatUsageRepository rawMatUsageRepository;

    public ApiResponse getAllRawMatUsages() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMatUsage> rawMatUsages = rawMatUsageRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("rawMatUsages", rawMatUsages);
        } catch (Exception e) {
            apiResponse.setMessage("Error retrieving raw material usage data: " + e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse saveRawMatUsage(RawMatUsage rawMatUsage) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMatUsage savedRawMatUsage = rawMatUsageRepository.save(rawMatUsage);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw material usage saved successfully.");
            apiResponse.setData("rawMatUsage", savedRawMatUsage);
        } catch (Exception e) {
            apiResponse.setMessage("Error saving raw material usage: " + e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse deleteRawMatUsageById(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            if (rawMatUsageRepository.existsById(id)) {
                rawMatUsageRepository.deleteById(id);
                apiResponse.setSuccess(true);
                apiResponse.setMessage("Raw material usage deleted successfully.");
            } else {
                apiResponse.setMessage("Raw material usage not found with ID " + id);
            }
        } catch (Exception e) {
            apiResponse.setMessage("Error deleting raw material usage: " + e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse getRawMatUsageById(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Optional<RawMatUsage> rawMatUsage = rawMatUsageRepository.findById(id);
            if (rawMatUsage.isPresent()) {
                apiResponse.setSuccess(true);
                apiResponse.setData("rawMatUsage", rawMatUsage.get());
            } else {
                apiResponse.setMessage("Raw material usage not found with ID " + id);
            }
        } catch (Exception e) {
            apiResponse.setMessage("Error retrieving raw material usage: " + e.getMessage());
        }
        return apiResponse;
    }

}
