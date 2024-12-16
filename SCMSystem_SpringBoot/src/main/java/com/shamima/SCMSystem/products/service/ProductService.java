package com.shamima.SCMSystem.products.service;

import com.shamima.SCMSystem.products.entity.Product;
import com.shamima.SCMSystem.products.repository.ProductRepository;
import com.shamima.SCMSystem.util.ApiResponse;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class ProductService {
    @Autowired
    private ProductRepository productRepository;

    @Value("src/main/resources/static/images")
    private String uploadDir;

    public ApiResponse getAllProducts() {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            List<Product> products = productRepository.findAll();
            apiResponse.setSuccess(true);
            apiResponse.setData("products", products);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @jakarta.transaction.Transactional
    public ApiResponse saveProduct(Product product, MultipartFile imageFile) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            // Handle Image Upload
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageFileName = saveImage(imageFile, product);
                product.setImage(imageFileName);
            }

            productRepository.save(product);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Product saved successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse deleteProductById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Product product = productRepository.findById(id).orElse(null);
            if (product == null) {
                apiResponse.setMessage("Product not found");
                return apiResponse;
            }
            productRepository.deleteById(id);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Product deleted successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    public ApiResponse findProductById(long id) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Product product = productRepository.findById(id).orElse(null);
            if (product == null) {
                apiResponse.setMessage("Product not found");
                return apiResponse;
            }
            apiResponse.setSuccess(true);
            apiResponse.setData("product", product);
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    @Transactional
    public ApiResponse updateProduct(Product updatedProduct, MultipartFile imageFile) {
        ApiResponse apiResponse = new ApiResponse(false);
        try {
            Product existingProduct = productRepository.findById(updatedProduct.getId()).orElse(null);
            if (existingProduct == null) {
                apiResponse.setMessage("Raw Material not found");
                return apiResponse;
            }

            existingProduct.setName(updatedProduct.getName());
            existingProduct.setDescription(updatedProduct.getDescription());


            if (imageFile != null && !imageFile.isEmpty()) {
                String imageFilename = saveImage(imageFile, existingProduct);
                existingProduct.setImage(imageFilename);
            }

            productRepository.save(existingProduct);
            apiResponse.setSuccess(true);
            apiResponse.setMessage("Raw Material updated successfully");
        } catch (Exception e) {
            apiResponse.setMessage(e.getMessage());
        }
        return apiResponse;
    }

    private String saveImage(MultipartFile file, Product rm) throws IOException {
        Path uploadPath = Paths.get(uploadDir + "/products");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename != null ?
                originalFilename.substring(originalFilename.lastIndexOf('.')) : "";

        String filename = rm.getName() + "_" + UUID.randomUUID() + fileExtension;
        Path filePath = uploadPath.resolve(filename);


        Files.copy(file.getInputStream(), filePath);

        return filename;
    }

}
