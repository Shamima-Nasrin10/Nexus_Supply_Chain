package com.shamima.nexus.service;


import com.shamima.nexus.model.Procurement;
import com.shamima.nexus.repository.ProcurementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProcurementService {

    @Autowired
    private ProcurementRepository procurementRepository;

    public Procurement getProcurementById(Long id){
        return procurementRepository.findById(id).orElse(null);
    }

}
