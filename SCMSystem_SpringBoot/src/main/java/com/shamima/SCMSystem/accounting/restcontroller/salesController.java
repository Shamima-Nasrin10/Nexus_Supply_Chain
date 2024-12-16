package com.shamima.SCMSystem.accounting.restcontroller;

import com.shamima.SCMSystem.accounting.entity.Sales;
import com.shamima.SCMSystem.accounting.service.SalesService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sales")
public class salesController {

    @Autowired
    private SalesService salesService;

    @GetMapping("/list")
    public ApiResponse getAllSales() {
        return salesService.getAllSales();
    }

    @PostMapping("/save")
    public ApiResponse saveSale(@RequestBody Sales sales) {
        return salesService.saveSale(sales);
    }

    @PostMapping("/saveAll")
    public ApiResponse saveAllSales(@RequestBody List<Sales> salesList) {
        return salesService.saveAllSales(salesList);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteSaleById(@PathVariable long id) {
        return salesService.deleteSaleById(id);
    }

    @PutMapping("/update/{id}")
    public ApiResponse updateSale(@PathVariable Long id, @RequestBody Sales sales) {
        return salesService.updateSale(id, sales);
    }

    @GetMapping("/{id}")
    public ApiResponse getSaleById(@PathVariable long id) {
        return salesService.getSaleById(id);
    }

}
