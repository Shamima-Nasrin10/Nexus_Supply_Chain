package com.shamima.SCMSystem.accounting.repository;

import com.shamima.SCMSystem.accounting.entity.Procurement;
import com.shamima.SCMSystem.accounting.entity.Sales;
import com.shamima.SCMSystem.goods.entity.RawMaterialSupplier;
import com.shamima.SCMSystem.products.entity.ProductRetailer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SalesRepository extends JpaRepository<Sales, Long> {

    Optional<List<Sales>> findAllByProductRetailer(ProductRetailer productRetailer);

}
