package com.shamima.SCMSystem.accounting.service;

import com.shamima.SCMSystem.accounting.entity.Sales;
import com.shamima.SCMSystem.accounting.repository.SalesRepository;
import com.shamima.SCMSystem.production.entity.ProductionProduct;
import com.shamima.SCMSystem.production.repository.ProdProductRepository;
import com.shamima.SCMSystem.products.entity.Warehouse;
import com.shamima.SCMSystem.util.ApiResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SalesService {

    @Autowired
    private SalesRepository salesRepository;

    @Autowired
    private ProdProductRepository prodProductRepository;

    public ApiResponse getAllSales() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<Sales> salesList = salesRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("sales", salesList);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse getAllMovedToWarehouseProducts() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<ProductionProduct> productionProducts = prodProductRepository.findAllMovedToWarehouseProducts();
            apiResponse.setSuccess(true);
            apiResponse.setData("productionProducts", productionProducts);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse saveAllSales(List<Sales> salesList) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            for (Sales sales : salesList) {
                sales.setTotalPrice(sales.getUnitPrice() * sales.getQuantity());
            }
            List<Sales> savedSales = salesRepository.saveAll(salesList);

            for (Sales sales : savedSales) {
                if (sales.getStatus() == Sales.Status.APPROVED) {
                    updateProdProductStock(sales);
                }
            }

            apiResponse.setSuccess(true);
            apiResponse.setMessage("Sales saved successfully");
            apiResponse.setData("sales", savedSales);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse saveSale(Sales sales) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            sales.setTotalPrice(sales.getUnitPrice() * sales.getQuantity());
            Sales savedSale = salesRepository.save(sales);

            if (sales.getStatus() == Sales.Status.APPROVED) {
                updateProdProductStock(sales);
            }

            apiResponse.setSuccess(true);
            apiResponse.setMessage("Sale saved successfully");
            apiResponse.setData("sale", savedSale);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    private void updateProdProductStock(Sales sales) {
        ProductionProduct productionProduct = sales.getProductionProduct();
        Warehouse warehouse = productionProduct.getWarehouse();

        if (productionProduct != null) {
            if (productionProduct.getQuantity() >= sales.getQuantity()) {
                productionProduct.setQuantity(productionProduct.getQuantity() - sales.getQuantity());
                prodProductRepository.save(productionProduct);
            } else {
                throw new RuntimeException("Insufficient stock for product: " + productionProduct.getProduct().getName());
            }
        }
    }

    @Transactional
    public ApiResponse deleteSaleById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            if (salesRepository.existsById(id)) {
                Sales sales = salesRepository.findById(id).orElse(null);
                if (sales == null) {
                    apiResponse.setMessage("Sale not found");
                    return apiResponse;
                }

                salesRepository.deleteById(id);

                apiResponse.setSuccess(true);
                apiResponse.setMessage("Sale deleted successfully");
            } else {
                apiResponse.setMessage("Sale not found with ID " + id);
            }
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateSale(long id, Sales updatedSale) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Sales existingSale = salesRepository.findById(id).orElse(null);

            if (existingSale == null) {
                apiResponse.setMessage("Sale not found with ID " + id);
                return apiResponse;
            }

            existingSale.setProductionProduct(updatedSale.getProductionProduct());
            existingSale.setQuantity(updatedSale.getQuantity());
            existingSale.setUnitPrice(updatedSale.getUnitPrice());
            existingSale.setTotalPrice(updatedSale.getQuantity() * updatedSale.getUnitPrice());
            existingSale.setStatus(updatedSale.getStatus());
            existingSale.setSalesDate(updatedSale.getSalesDate());

            Sales savedSale = salesRepository.save(existingSale);

            if (existingSale.getStatus() == Sales.Status.APPROVED) {
                updateProdProductStock(existingSale);
            }

            apiResponse.setSuccess(true);
            apiResponse.setMessage("Sale updated successfully");
            apiResponse.setData("sale", savedSale);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse getSaleById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Sales sales = salesRepository.findById(id).orElse(null);
            if (sales == null) {
                apiResponse.setMessage("Sale not found with ID " + id);
            } else {
                apiResponse.setSuccess(true);
                apiResponse.setData("sale", sales);
            }
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }
}
