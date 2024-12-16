package com.shamima.SCMSystem.goods.service;


import com.shamima.SCMSystem.accounting.entity.Procurement;
import com.shamima.SCMSystem.accounting.repository.ProcurementRepository;
import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import com.shamima.SCMSystem.goods.repository.RawMaterialSupplierRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RawMaterialSupplierService {

    @Autowired
    private RawMaterialSupplierRepository rawMaterialSupplierRepository;
    @Autowired
    private ProcurementRepository procurementRepository;

    public ApiResponse getAllRawMaterialSuppliers() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMaterialSupplier> rawMaterialSuppliers = rawMaterialSupplierRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("rawMaterialSuppliers", rawMaterialSuppliers);
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    public ApiResponse saveRawMaterialSupplier(RawMaterialSupplier rmSupplier) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            rawMaterialSupplierRepository.save(rmSupplier);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Supplier saved successfully");
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    public ApiResponse updateRawMaterialSupplier(RawMaterialSupplier supplier) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterialSupplier existingSupplier = rawMaterialSupplierRepository.findById(supplier.getId()).orElse(null);
            if (existingSupplier == null) {
                apiResponse.setMessage("Supplier not found");
                return apiResponse;
            }
            rawMaterialSupplierRepository.save(supplier);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Supplier updated successfully");
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    @Transactional
    public ApiResponse deleteRawMaterialSupplier(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterialSupplier supplier = rawMaterialSupplierRepository.findById(id).orElse(null);
            if (supplier == null) {
                apiResponse.setMessage("Supplier not found");
                return apiResponse;
            }
            List<Procurement> procurements = procurementRepository.findAllByRawMaterialSupplier(supplier).orElse(null);
            if (procurements != null && !procurements.isEmpty()) {
                for (Procurement procurement : procurements) {
                    procurement.setRawMaterialSupplier(null);
                    procurementRepository.save(procurement);
                }
            }
            rawMaterialSupplierRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Supplier deleted successfully");
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

    public ApiResponse getRawMaterialSupplierById(Long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            RawMaterialSupplier supplier = rawMaterialSupplierRepository.findById(id).orElse(null);
            if (supplier == null) {
                apiResponse.setMessage("Supplier not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("rawMaterialSupplier", supplier);
            return apiResponse;
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
            return apiResponse;
        }
    }

}
