package com.shamima.SCMSystem.goods.restcontroller;

import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.entity.RawMaterialCategory;
import com.shamima.SCMSystem.goods.repository.RawMaterialCategoryRepository;
import com.shamima.SCMSystem.goods.service.RawMaterialService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("api/rawmaterial")
public class RawMaterialController {

    @Autowired
    private RawMaterialService rawMaterialService;

    @Autowired
    private RawMaterialCategoryRepository rawMaterialCategoryRepository;

    @PostMapping( "/save")
    public ApiResponse save(@RequestPart RawMaterial rawMaterial,
                            @RequestPart(required = false) MultipartFile imageFile) {
        return rawMaterialService.saveRawMaterial(rawMaterial, imageFile);
    }

    @GetMapping("/list")
    public ApiResponse getRawMaterials() {
        return rawMaterialService.getAllRawMaterials();
    }

    @PutMapping("/update")
    public ApiResponse updateRawMaterial(@RequestPart RawMaterial rawMaterial,
                                         @RequestPart(required = false) MultipartFile imageFile) {
        return rawMaterialService.updateRawMaterial(rawMaterial, imageFile);
    }

    @GetMapping("/{id}")
    public ApiResponse findRawMaterialById(@PathVariable long id) {
        return rawMaterialService.findRawMaterialById(id);
    }
    

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteRawMaterialById(@PathVariable long id) {
        return rawMaterialService.deleteRawMaterialById(id);
    }

}

