package com.shamima.SCMSystem.accounting.restcontroller;

import com.shamima.SCMSystem.accounting.entity.Procurement;
import com.shamima.SCMSystem.accounting.service.ProcurementService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/procurement")
public class ProcurementController {

    @Autowired
    private ProcurementService procurementService;

    @GetMapping("/list")
    public ApiResponse getAllProcurement() {
        return procurementService.getAllProcurement();
    }

    @PostMapping("/save")
    public ApiResponse saveProcurement(@RequestBody Procurement procurement) {
        return procurementService.saveProcurement(procurement);
    }

    @PostMapping("/saveAll")
    public ApiResponse saveProcurements(@RequestBody List<Procurement> procurements) {
        return procurementService.saveProcurements(procurements);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteProcurementById(@PathVariable long id) {
        return procurementService.deleteProcurementById(id);
    }
    @PutMapping("/update/{id}")
    public ApiResponse updateProcurement(@PathVariable Long id, @RequestBody Procurement procurement) {
        return procurementService.updateProcurement(id,procurement);
    }

    @GetMapping("/{id}")
    public ApiResponse getProcurementById(@PathVariable long id) {
        return procurementService.getProcurementById(id);
    }

}
