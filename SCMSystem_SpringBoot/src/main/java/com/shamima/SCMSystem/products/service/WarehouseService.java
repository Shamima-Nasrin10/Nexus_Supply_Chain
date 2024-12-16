package com.shamima.SCMSystem.products.service;

import com.shamima.SCMSystem.products.entity.Warehouse;
import com.shamima.SCMSystem.products.repository.WarehouseRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class WarehouseService {
    @Autowired
    private WarehouseRepository warehouseRepository;


    public ApiResponse getAllWarehouses() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<Warehouse> warehouses = warehouseRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("warehouses", warehouses);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse findWarehouseById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Warehouse warehouse = warehouseRepository.findById(id).orElse(null);
            if (warehouse == null) {
                apiResponse.setMessage("Warehouse not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("warehouse", warehouse);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse saveWarehouse(Warehouse warehouse) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            warehouseRepository.save(warehouse);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Warehouse saved successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateWarehouse(Warehouse updatedWarehouse) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Warehouse existingWarehouse = warehouseRepository.findById(updatedWarehouse.getId()).orElse(null);
            if (existingWarehouse == null) {
                apiResponse.setMessage("Warehouse not found");
                return apiResponse;
            }

            // Update warehouse details
            existingWarehouse.setName(updatedWarehouse.getName());
            existingWarehouse.setLocation(updatedWarehouse.getLocation());

            warehouseRepository.save(existingWarehouse);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Warehouse updated successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse deleteWarehouseById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Warehouse warehouse = warehouseRepository.findById(id).orElse(null);
            if (warehouse == null) {
                apiResponse.setMessage("Warehouse not found");
                return apiResponse;
            }

            warehouseRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Warehouse deleted successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }


}
