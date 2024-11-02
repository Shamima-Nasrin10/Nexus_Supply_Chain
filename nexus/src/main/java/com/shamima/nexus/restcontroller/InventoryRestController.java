package com.shamima.nexus.restcontroller;


import com.shamima.nexus.model.Inventory;
import com.shamima.nexus.model.Stock;
import com.shamima.nexus.repository.InventoryRepository;
import com.shamima.nexus.repository.RawMaterialRepository;
import com.shamima.nexus.repository.StockRepository;
import com.shamima.nexus.service.InventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/inventory")
public class InventoryRestController {

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private RawMaterialRepository rawMaterialRepository;

    @Autowired
    private InventoryService inventoryService;


    @Autowired
    private StockRepository stockRepository;



    @PostMapping("/save")
    public ResponseEntity<String> saveInventory(@RequestBody Inventory inventory){
        Long procurementId=inventory.getProcurement().getId();

        // Check if inventory for this procurement ID already exists
        Optional<Inventory> existingInventory=inventoryRepository.findByProcurement_Id(procurementId);

        if (existingInventory.isPresent()){
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Inventory for Procurement ID "+procurementId+ " already exists");
        }



        // Call the addToInventory method in the InventoryService to add inventory
        inventoryService.addToInventory(inventory.getRawMaterial(),inventory.getQuantityInStock(),inventory.getUnitPrice());
        inventoryRepository.save(inventory);
        return ResponseEntity.status(HttpStatus.CREATED).body("Inventory Saved Successfully");

    }



    @GetMapping("/inventory-details")
    public ResponseEntity<List<Inventory>> showInventoryDetails() {
        List<Inventory> inventorySummary = inventoryRepository.findAll();
        return new ResponseEntity<>(inventorySummary, HttpStatus.OK);
    }

    @GetMapping("/stock-details")
    public ResponseEntity<List<Stock>> showStockDetails() {
        List<Stock> stockSummary = stockRepository.findAll();
        return new ResponseEntity<>(stockSummary, HttpStatus.OK);
    }


}
