package com.shamima.SCMSystem.goods.repository;

import com.shamima.SCMSystem.goods.entity.RawMaterialCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface RawMaterialCategoryRepository extends JpaRepository<RawMaterialCategory, Long> {

}
