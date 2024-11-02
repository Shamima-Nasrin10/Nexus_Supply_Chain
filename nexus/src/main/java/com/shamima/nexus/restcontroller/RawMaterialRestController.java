package com.shamima.nexus.restcontroller;


import com.shamima.nexus.model.RawMaterial;
import com.shamima.nexus.repository.RawMaterialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rawmaterials")
public class RawMaterialRestController {

    @Autowired
    private RawMaterialRepository rawMaterialRepository;

    @GetMapping
    public List<RawMaterial> getAllRawMaterials(){
        return rawMaterialRepository.findAll();
    }

    @PostMapping
    public RawMaterial addRawMaterial(@RequestBody RawMaterial rawMaterial){
        return rawMaterialRepository.save(rawMaterial);
    }

    @PutMapping("/{id}")
    public RawMaterial updateRawMaterial(@PathVariable Long id, @RequestBody RawMaterial rawMaterial){
        rawMaterial.setMaterialID(id);
        return rawMaterialRepository.save(rawMaterial);
    }

    @DeleteMapping("/{id}")
    public void deleteRawMaterial(@PathVariable Long id){
        rawMaterialRepository.deleteById(id);
    }

}
