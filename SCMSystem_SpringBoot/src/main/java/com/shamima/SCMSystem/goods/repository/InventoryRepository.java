package com.shamima.SCMSystem.goods.repository;

import com.shamima.SCMSystem.goods.entity.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {

}
