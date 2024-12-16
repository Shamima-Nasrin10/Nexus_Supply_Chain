package com.shamima.SCMSystem.production.restcontroller;

import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.service.RawMaterialService;
import com.shamima.SCMSystem.production.entity.RawMatUsage;
import com.shamima.SCMSystem.production.service.RawMatUsageService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("api/rawmatusage")
public class RawMatUsageController {

    @Autowired
    private RawMatUsageService rawMatUsageService;

    @GetMapping("/list")
    public ApiResponse getAllRawMatUsages() {
        return rawMatUsageService.getAllRawMatUsages();
    }

    @GetMapping("/{id}")
    public ApiResponse getRawMatUsageById(@PathVariable Long id) {
        return rawMatUsageService.getRawMatUsageById(id);
    }

    @PostMapping("/save")
    public ApiResponse saveRawMatUsage(@RequestBody RawMatUsage rawMatUsage) {
        return rawMatUsageService.saveRawMatUsage(rawMatUsage);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteRawMatUsageById(@PathVariable Long id) {
        return rawMatUsageService.deleteRawMatUsageById(id);
    }

}

