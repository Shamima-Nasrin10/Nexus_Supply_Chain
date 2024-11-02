package com.shamima.nexus.service;


import com.shamima.nexus.model.Inventory;
import com.shamima.nexus.model.RawMaterial;
import com.shamima.nexus.model.Stock;
import com.shamima.nexus.model.product.Product;
import com.shamima.nexus.repository.InventoryRepository;
import com.shamima.nexus.repository.StockRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

@Service
public class InventoryService {


    @Autowired
    private  InventoryRepository inventoryRepository;

    @Autowired
    private StockRepository stockRepository;





    public void addToInventory(RawMaterial rawMaterial,int quantity,double unitPrice){
        //Check existing stock

        Stock existingStock=stockRepository.findByRawMaterial(rawMaterial);
        if (existingStock !=null){
            // Update existing stock quantity
            int updateQuantity= existingStock.getQuantity()+quantity;
            double previousUnitPrice=existingStock.getUnitPrice();


            // Set previous unit price
            existingStock.setPreviousPrice(previousUnitPrice);


//            double previousUnitPrice=existingStock.getUnitPrice();
//            double percentageChange=calculatePercentageChange(previousUnitPrice,unitPrice);
            double percentageChange = calculatePercentageChange(previousUnitPrice, unitPrice);




            existingStock.setIncrease((percentageChange > 0) ? (int) percentageChange : 0);
            existingStock.setDecrease((percentageChange < 0) ? (int) -percentageChange : 0);

            existingStock.setLastStockUpdateDate(new Date(System.currentTimeMillis()));
            existingStock.setQuantity(updateQuantity);
            existingStock.setUnitPrice(unitPrice);
            stockRepository.save(existingStock);
        }else {
            // Raw material doesn't exist in stock, create new entry
            Stock newStock=new Stock();
            newStock.setRawMaterial(rawMaterial);
            newStock.setQuantity(quantity);
            newStock.setUnitPrice(unitPrice);
            newStock.setLastStockUpdateDate(new Date(System.currentTimeMillis()));
            stockRepository.save(newStock);

            newStock.setIncrease(0);
            newStock.setDecrease(0);
        }

    }



//private double calculatePercentageChange(double previousValue,double currentValue){
//        if (previousValue==0){
//            return 0;
//        }
//        return ((currentValue - previousValue)/previousValue)*100;
//}

    private double calculatePercentageChange(double previousPrice, double newPrice) {
        return ((newPrice - previousPrice) / previousPrice) * 100;
    }

//    @Transactional
//
//    public void updateInventoryForProduction(Product product, int productionQuantity) {
//        Map<String, Integer> requiredMaterials = product.getRecipe();
//
//        for (Map.Entry<String, Integer> entry : requiredMaterials.entrySet()) {
//            updateInventory(entry.getKey(), entry.getValue() * productionQuantity);
//        }
//    }

    private void updateInventory(String materialName, int quantity) {
        Inventory inventoryEntry = inventoryRepository.findByRawMaterial_MaterialName(materialName);

        int currentQuantity = inventoryEntry.getQuantityInStock();
        inventoryEntry.setQuantityInStock(currentQuantity - quantity);
        inventoryEntry.setLastStockUpdateDate(Date.valueOf(LocalDate.now()));

        inventoryRepository.save(inventoryEntry);
    }

}
