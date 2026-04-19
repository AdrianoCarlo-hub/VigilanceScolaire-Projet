package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.EvenementModel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EvenementRepository extends JpaRepository<EvenementModel, Long>{
}
