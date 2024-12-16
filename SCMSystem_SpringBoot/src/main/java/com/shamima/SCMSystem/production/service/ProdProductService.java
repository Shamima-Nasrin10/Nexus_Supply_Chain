package com.shamima.SCMSystem.production.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.shamima.SCMSystem.goods.entity.RawMaterial;
import com.shamima.SCMSystem.goods.entity.RawMaterialStock;
import com.shamima.SCMSystem.goods.repository.RMStockRepository;
import com.shamima.SCMSystem.goods.repository.RawMaterialRepository;
import com.shamima.SCMSystem.production.entity.ProductionProduct;
import com.shamima.SCMSystem.production.entity.RawMatUsage;
import com.shamima.SCMSystem.production.repository.ProdProductRepository;
import com.shamima.SCMSystem.production.repository.RawMatUsageRepository;
import com.shamima.SCMSystem.products.entity.Warehouse;
import com.shamima.SCMSystem.products.repository.WarehouseRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProdProductService {

    @Autowired
    private ProdProductRepository prodProductRepository;

    @Autowired
    private RawMaterialRepository rawMaterialRepository;

    @Autowired
    private RMStockRepository rmStockRepository;

    @Autowired
    private WarehouseRepository warehouseRepository;

    @Value("src/main/resources/static/images/qrcodes")
    private String qrCodeDir;
    @Autowired
    private RawMatUsageRepository rawMatUsageRepository;


    public ApiResponse getAllProductionProducts() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<ProductionProduct> productionProducts = prodProductRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("productionProducts", productionProducts);
        } catch (Exception e) {
            apiResponse.setMessage("Error retrieving production products: " + e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse saveProdProduct(ProductionProduct productionProduct) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<RawMatUsage> rawMatUsages = productionProduct.getRawMatUsages();
            for (RawMatUsage rawMatUsage : rawMatUsages) {
                RawMaterial rawMaterial = rawMatUsage.getRawMaterial();
                rawMaterial = rawMaterialRepository.findById(rawMaterial.getId()).orElse(null);
                if (rawMaterial == null) {
                    apiResponse.setMessage("Raw Material not found");
                    return apiResponse;
                }
                RawMaterialStock stock = rmStockRepository.findByRawMaterial(rawMaterial);
                if (stock == null) {
                    apiResponse.setMessage("Raw Material stock not found. Please order first.");
                    return apiResponse;
                }
                if (stock.getQuantity() < rawMatUsage.getQuantity()) {
                    apiResponse.setMessage("Insufficient stock. Please order more.");
                    return apiResponse;
                }

                stock.setQuantity(stock.getQuantity() - rawMatUsage.getQuantity());
                rmStockRepository.save(stock);

                rawMatUsage.setRawMaterial(rawMaterial);
                rawMatUsage.setProductionProduct(productionProduct);
            }
            rawMatUsageRepository.saveAll(rawMatUsages);

            productionProduct = prodProductRepository.save(productionProduct);
            String qrCodePath = generateQRCodeForProduct(productionProduct);
            productionProduct.setQrCodePath(qrCodePath);
            prodProductRepository.save(productionProduct);

            apiResponse.setSuccess(true);
            apiResponse.setMessage("Production saved successfully");
            apiResponse.setData("productionProduct", productionProduct);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateProductionStatus(Long productionProductId, ProductionProduct.Status status, Long warehouseId) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            ProductionProduct productionProduct = prodProductRepository.findById(productionProductId)
                    .orElseThrow(() -> new RuntimeException("Production product not found"));

            productionProduct.setStatus(status);

            if (status == ProductionProduct.Status.COMPLETED) {
                productionProduct.setCompletionDate(new Date());
            } else if (status == ProductionProduct.Status.MOVED_TO_WAREHOUSE) {
                productionProduct.setMovedToWarehouseDate(new Date());

                // Manually assign the selected warehouse
                Warehouse selectedWarehouse = warehouseRepository.findById(warehouseId)
                        .orElseThrow(() -> new RuntimeException("Selected warehouse not found"));
                productionProduct.setWarehouse(selectedWarehouse);

                if (productionProduct.getQrCodePath() == null) {
                    String qrCodePath = generateQRCodeForProduct(productionProduct);
                    productionProduct.setQrCodePath(qrCodePath);
                }
            }

            prodProductRepository.save(productionProduct);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Production product status updated successfully");
            apiResponse.setData("productionProduct", productionProduct);
        } catch (Exception e) {
            apiResponse.setMessage("Error updating production status: " + e.getMessage());
        }
        return apiResponse;
    }

    private String generateQRCodeForProduct(ProductionProduct productionProduct) throws Exception {
        Path qrCodePath = Paths.get(qrCodeDir);
        if (!Files.exists(qrCodePath)) {
            Files.createDirectories(qrCodePath);
        }

        String qrCodeData = "Product Name: " + productionProduct.getProduct().getName() + "\n" +
                "Batch Number: " + productionProduct.getBatchNumber() + "\n" +
                "Manufacturing Date: " + new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        String fileName = productionProduct.getId() + "_qrcode.png";
        Path filePath = qrCodePath.resolve(fileName);

        BitMatrix matrix = new MultiFormatWriter().encode(qrCodeData, BarcodeFormat.QR_CODE, 300, 300);
        MatrixToImageWriter.writeToPath(matrix, "PNG", filePath);

        return filePath.toString();
    }

    public ApiResponse getProductionProductsByWarehouseId(Long warehouseId) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Warehouse warehouse = warehouseRepository.findById(warehouseId)
                    .orElseThrow(() -> new RuntimeException("Warehouse not found"));

            List<ProductionProduct> products = prodProductRepository.findProdProductByWarehouseId(warehouseId);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Products fetched successfully");
            apiResponse.setData("prodProducts", products);

        } catch (Exception e) {
            apiResponse.setMessage("Error fetching products: " + e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse getStockGroupedByWarehouseAndProduct() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<Map<String, Object>> stockData = prodProductRepository.getStockGroupedByWarehouseAndProduct();
            apiResponse.setSuccess(true);
            apiResponse.setData("stockData", stockData);
        } catch (Exception e) {
            apiResponse.setMessage("Error fetching stock data: " + e.getMessage());
        }
        return apiResponse;
    }


}
