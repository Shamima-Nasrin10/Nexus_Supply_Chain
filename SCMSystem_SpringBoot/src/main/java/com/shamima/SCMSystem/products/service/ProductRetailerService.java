package com.shamima.SCMSystem.products.service;


import com.shamima.SCMSystem.accounting.entity.Sales;
import com.shamima.SCMSystem.accounting.repository.SalesRepository;
import com.shamima.SCMSystem.products.entity.ProductRetailer;
import com.shamima.SCMSystem.products.repository.ProductRetailerRepository;
import com.shamima.SCMSystem.products.repository.WarehouseRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductRetailerService {

    @Autowired
    private ProductRetailerRepository productRetailerRepository;

    @Autowired
    private SalesRepository salesRepository;

    public ApiResponse getAllProductRetailers() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<ProductRetailer> productRetailers = productRetailerRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("productRetailers", productRetailers);
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    public ApiResponse saveProductRetailers(ProductRetailer pRetailer) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            productRetailerRepository.save(pRetailer);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Retailer saved successfully");
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    public ApiResponse updateProductRetailer(ProductRetailer pRetailer) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            ProductRetailer existingRetailer = productRetailerRepository.findById(pRetailer.getId()).orElse(null);
            if (existingRetailer == null) {
                apiResponse.setMessage("Retailer not found");
                return apiResponse;
            }
            productRetailerRepository.save(pRetailer);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Retailer updated successfully");
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    @Transactional
    public ApiResponse deleteProductRetailer(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            ProductRetailer pRetailer = productRetailerRepository.findById(id).orElse(null);
            if (pRetailer == null) {
                apiResponse.setMessage("Retailer not found");
                return apiResponse;
            }
            List<Sales> salesList = salesRepository.findAllByProductRetailer(pRetailer).orElse(null);
            if (salesList != null && !salesList.isEmpty()) {
                for (Sales sales : salesList) {
                    sales.setProductRetailer(null);
                    salesRepository.save(sales);
                }
            }
            productRetailerRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Retailer deleted successfully");
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    public ApiResponse getProductRetailerById(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            ProductRetailer pRetailer = productRetailerRepository.findById(id).orElse(null);
            if (pRetailer == null) {
                apiResponse.setMessage("Retailer not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("productRetailer", pRetailer);
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

}
