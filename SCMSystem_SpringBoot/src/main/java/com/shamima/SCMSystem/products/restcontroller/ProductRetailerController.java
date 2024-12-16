package com.shamima.SCMSystem.products.restcontroller;

import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import com.shamima.SCMSystem.goods.service.RawMaterialSupplierService;
import com.shamima.SCMSystem.products.entity.ProductRetailer;
import com.shamima.SCMSystem.products.service.ProductRetailerService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/retailer")
public class ProductRetailerController {

    @Autowired
    private ProductRetailerService productRetailerService;

    @GetMapping("/list")
    public ApiResponse getAllProductRetailers() {
        return productRetailerService.getAllProductRetailers();
    }

    @GetMapping("/{id}")
    public ApiResponse getProductRetailerById(@PathVariable long id) {
        return productRetailerService.getProductRetailerById(id);
    }

    @PostMapping("/save")
    public ApiResponse saveRawMaterialSupplier(@RequestBody ProductRetailer pRetailer) {
        return productRetailerService.saveProductRetailers(pRetailer);
    }

    @PutMapping("/update")
    public ApiResponse updateRawMaterialSupplier(@RequestBody ProductRetailer pRetailer) {
        return productRetailerService.updateProductRetailer(pRetailer);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteRawMaterialSupplier(@PathVariable long id) {
        return productRetailerService.deleteProductRetailer(id);
    }
}

