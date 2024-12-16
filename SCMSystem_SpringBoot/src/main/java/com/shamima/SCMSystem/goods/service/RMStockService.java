package com.shamima.SCMSystem.goods.service;

import com.shamima.SCMSystem.goods.entity.RawMaterialStock;
import com.shamima.SCMSystem.goods.repository.RMStockRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RMStockService {

    @Autowired
    private RMStockRepository rmStockRepository;

    public ApiResponse getAllStock() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMaterialStock> stocks = rmStockRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("stocks", stocks);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse getStockById(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Optional<RawMaterialStock> stock = rmStockRepository.findById(id);
            if (stock.isPresent()) {
                apiResponse.setSuccess(true);
                apiResponse.setData("stock", stock.get());
            } else {
                apiResponse.setMessage("Stock not found with ID " + id);
            }
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }
}
