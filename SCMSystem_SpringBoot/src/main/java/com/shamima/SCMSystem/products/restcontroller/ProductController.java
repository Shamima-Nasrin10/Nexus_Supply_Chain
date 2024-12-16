package com.shamima.SCMSystem.products.restcontroller;

import com.shamima.SCMSystem.products.entity.Product;
import com.shamima.SCMSystem.products.service.ProductService;
import com.shamima.SCMSystem.util.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @PostMapping("/save")
    public ApiResponse saveProduct(@RequestPart Product product,
                                   @RequestPart(required = false) MultipartFile imageFile) {
        return productService.saveProduct(product, imageFile);
    }

    @PutMapping("/update")
    public ApiResponse updateProduct(@RequestPart Product product,
                                     @RequestPart(required = false) MultipartFile imageFile) {
        return productService.updateProduct(product, imageFile);
    }

    @GetMapping("/list")
    public ApiResponse getAllProducts() {
        return productService.getAllProducts();
    }

    @GetMapping("/{id}")
    public ApiResponse findProductById(@PathVariable long id) {
        return productService.findProductById(id);
    }

    @DeleteMapping("/delete/{id}")
    public ApiResponse deleteProductById(@PathVariable long id) {
        return productService.deleteProductById(id);
    }

}
