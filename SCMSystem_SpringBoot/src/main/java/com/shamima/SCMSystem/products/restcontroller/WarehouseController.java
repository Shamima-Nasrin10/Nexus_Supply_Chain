package com.shamima.SCMSystem.products.restcontroller;

import com.shamima.SCMSystem.products.entity.Warehouse;
import com.shamima.SCMSystem.products.service.WarehouseService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/warehouse")
public class WarehouseController {

    @Autowired
    private WarehouseService warehouseService;
    
    @PostMapping("/save")
    public ApiResponse saveWarehouse(@RequestBody Warehouse warehouse) {
        return warehouseService.saveWarehouse(warehouse);
    }


    @GetMapping("/list")
    public ApiResponse getAllWarehouses() {
        return warehouseService.getAllWarehouses();
    }


    @PutMapping("/update")
    public ApiResponse updateWarehouse(@RequestBody Warehouse warehouse) {
        return warehouseService.updateWarehouse(warehouse);
    }


    @GetMapping("/{id}")
    public ApiResponse findWarehouseById(@PathVariable long id) {
        return warehouseService.findWarehouseById(id);
    }

    // Delete a warehouse by ID
    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteWarehouseById(@PathVariable long id) {
        return warehouseService.deleteWarehouseById(id);
    }


}
