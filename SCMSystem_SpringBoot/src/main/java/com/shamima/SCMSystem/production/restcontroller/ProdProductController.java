
package com.shamima.SCMSystem.production.restcontroller;

import com.shamima.SCMSystem.accounting.service.SalesService;
import com.shamima.SCMSystem.production.entity.ProductionProduct;
import com.shamima.SCMSystem.production.service.ProdProductService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/productionProduct")
public class ProdProductController {

    @Autowired
    private ProdProductService prodProductService;

    @Autowired
    private SalesService salesService;

    @PostMapping("/save")
    public ApiResponse save(@RequestBody ProductionProduct productionProduct) {
        return prodProductService.saveProdProduct(productionProduct);
    }


    // Endpoint to update the status of a ProductionProduct
    @PutMapping("/status/{id}")
    public ApiResponse updateProductionStatus(
            @PathVariable Long id,
            @RequestParam ProductionProduct.Status status,
            @RequestParam(required = false) Long warehouseId) {
        return prodProductService.updateProductionStatus(id, status, warehouseId);
    }

    // Endpoint to get all ProductionProducts
    @GetMapping("/list")
    public ApiResponse getAllProductionProducts() {
        return prodProductService.getAllProductionProducts();
    }


    @GetMapping("/warehouse/{warehouseId}")
    public ApiResponse getProdProductByWarehouseId(@PathVariable Long warehouseId) {
        return prodProductService.getProductionProductsByWarehouseId(warehouseId);
    }

    @GetMapping("/moved-to-warehouse")
    public ApiResponse getMovedToWarehouseProducts() {
        return salesService.getAllMovedToWarehouseProducts();
    }

    @GetMapping("/warehouse-stock")
    public ApiResponse getProductStockGroupedByWarehouse() {
        return prodProductService.getStockGroupedByWarehouseAndProduct();
    }

}

