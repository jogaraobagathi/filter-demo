package com.example.demo.controller;

import com.example.demo.repository.FilterRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FilterController {


    @Autowired
    public FilterRepository filterRepository;

    @PostMapping("/insert")
    public ResponseEntity insert(@RequestBody JsonNode body) {

        filterRepository.insert(body);
        return ResponseEntity.ok("done");
    }
    @PostMapping ("/filter")
    public  ResponseEntity filter(@RequestBody JsonNode body){
        return ResponseEntity.ok(filterRepository.filter(body));

    }
}
