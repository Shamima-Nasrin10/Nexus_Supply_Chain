package com.shamima.SCMSystem.util;

import com.shamima.SCMSystem.goods.repository.RawMaterialSupplierRepository;
import com.shamima.SCMSystem.production.service.ProdProductService;
import com.shamima.SCMSystem.products.repository.ProductRetailerRepository;
import com.shamima.SCMSystem.products.repository.WarehouseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("api/dashboard")
public class DashboardController {

    @Autowired
    private RawMaterialSupplierRepository supplierRepository;

    @Autowired
    private ProductRetailerRepository retailerRepository;

    @Autowired
    private ProdProductService prodProductService;

    @GetMapping("/stats")
    public ApiResponse getDashboardStats() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            // Fetch counts for suppliers and retailers
            long supplierCount = supplierRepository.count();
            long retailerCount = retailerRepository.count();

            // Fetch product stock grouped by warehouse and product
            ApiResponse stockResponse = prodProductService.getStockGroupedByWarehouseAndProduct();

            apiResponse.setSuccess(true);
            apiResponse.setData("supplierCount", supplierCount);
            apiResponse.setData("retailerCount", retailerCount);
            apiResponse.setData("productStock", stockResponse.getData().get("stockData"));
        } catch (Exception e) {
            apiResponse.setMessage("Error fetching dashboard stats: " + e.getMessage());
        }
        return apiResponse;
    }
}
