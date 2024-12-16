package com.shamima.SCMSystem.goods.service;

import com.shamima.SCMSystem.goods.entity.Inventory;
import com.shamima.SCMSystem.goods.repository.InventoryRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class InventoryService {
    @Autowired
    private InventoryRepository inventoryRepository;

    @Transactional
    public ApiResponse saveInventory(Inventory inventory) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            inventory.setCreatedDate(LocalDateTime.now());
            inventory.setLastUpdatedDate(LocalDateTime.now());
            inventoryRepository.save(inventory);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Inventory saved successfully");
        } catch (Exception e) {
            apiResponse.setMessage("Failed to fetch inventories: " + e.getMessage());
        }

        return apiResponse;
    }


    public ApiResponse getAllInventories() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<Inventory> inventories = inventoryRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("inventories", inventories);
        } catch (Exception e) {
            apiResponse.setMessage("Failed to fetch inventories: " + e.getMessage());
        }
        return apiResponse;
    }


    public ApiResponse findInventoryById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Inventory inventory = inventoryRepository.findById(id).orElse(null);
            if (inventory == null) {
                apiResponse.setMessage("Inventory not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("inventory", inventory);
        } catch (Exception e) {
            apiResponse.setMessage("Failed to find inventory: " + e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateInventory(Inventory updatedInventory) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Inventory existingInventory = inventoryRepository.findById(updatedInventory.getId()).orElse(null);
            if (existingInventory == null) {
                apiResponse.setMessage("Inventory not found");
                return apiResponse;
            }
            existingInventory.setName(updatedInventory.getName());
            existingInventory.setCapacity(updatedInventory.getCapacity());
            existingInventory.setLastUpdatedDate(LocalDateTime.now());
            inventoryRepository.save(existingInventory);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Inventory updated successfully");
        } catch (Exception e) {
            apiResponse.setMessage("Failed to update inventory: " + e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse deleteInventoryById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Inventory inventory = inventoryRepository.findById(id).orElse(null);
            if (inventory == null) {
                apiResponse.setMessage("Inventory not found");
                return apiResponse;
            }

            inventoryRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Inventory deleted successfully");
        } catch (Exception e) {
            apiResponse.setMessage("Failed to delete inventory: " + e.getMessage());
        }
        return apiResponse;
    }


}
