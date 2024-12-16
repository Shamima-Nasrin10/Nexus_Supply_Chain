package com.shamima.SCMSystem.goods.restcontroller;

import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import com.shamima.SCMSystem.goods.service.RawMaterialSupplierService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/supplier")
public class RawMaterialSupplierController {

    @Autowired
    private RawMaterialSupplierService rawMaterialSupplierService;

    @GetMapping("/list")
    public ApiResponse getAllRawMaterialSuppliers() {
        return rawMaterialSupplierService.getAllRawMaterialSuppliers();
    }

    @GetMapping("/{id}")
    public ApiResponse getAllRawMaterialSuppliers(@PathVariable long id) {
        return rawMaterialSupplierService.getRawMaterialSupplierById(id);
    }

    @PostMapping("/save")
    public ApiResponse saveRawMaterialSupplier(@RequestBody RawMaterialSupplier rmSupplier) {
        return rawMaterialSupplierService.saveRawMaterialSupplier(rmSupplier);
    }

    @PutMapping("/update")
    public ApiResponse updateRawMaterialSupplier(@RequestBody RawMaterialSupplier rmSupplier) {
        return rawMaterialSupplierService.updateRawMaterialSupplier(rmSupplier);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteRawMaterialSupplier(@PathVariable long id) {
        return rawMaterialSupplierService.deleteRawMaterialSupplier(id);
    }
}

