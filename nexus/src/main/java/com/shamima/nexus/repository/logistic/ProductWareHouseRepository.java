package com.shamima.nexus.repository.logistic;

import com.shamima.nexus.model.logistic.ProductWareHouse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ProductWareHouseRepository extends JpaRepository<ProductWareHouse, Long> {
}
