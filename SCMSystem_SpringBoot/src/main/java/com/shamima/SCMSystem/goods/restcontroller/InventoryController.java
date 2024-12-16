package com.shamima.SCMSystem.goods.restcontroller;


import com.shamima.SCMSystem.goods.entity.Inventory;
import com.shamima.SCMSystem.goods.service.InventoryService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    @Autowired
    private InventoryService inventoryService;

    @PostMapping("/save")
    public ApiResponse saveInventory(@RequestBody Inventory inventory) {
        return inventoryService.saveInventory(inventory);
    }

    @GetMapping("/list")
    public ApiResponse getInventories() {
        return inventoryService.getAllInventories();
    }


    @GetMapping("/{id}")
    public ApiResponse getInventoryById(@PathVariable long id) {
        return inventoryService.findInventoryById(id);
    }


    @PutMapping("/update")
    public ApiResponse updateInventory(@RequestBody Inventory updatedInventory) {
        return inventoryService.updateInventory(updatedInventory);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteInventoryById(@PathVariable long id) {
        return inventoryService.deleteInventoryById(id);
    }
}
