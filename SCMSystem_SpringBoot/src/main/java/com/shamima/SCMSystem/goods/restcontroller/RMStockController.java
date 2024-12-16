package com.shamima.SCMSystem.goods.restcontroller;


import com.shamima.SCMSystem.goods.service.RMStockService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/stock")
public class RMStockController {

    @Autowired
    private RMStockService rmStockService;

    @GetMapping("/list")
    public ApiResponse getAllStock() {
        return rmStockService.getAllStock();
    }

    @GetMapping("/{id}")
    public ApiResponse getStockById(@PathVariable Long id) {
        return rmStockService.getStockById(id);
    }

}
