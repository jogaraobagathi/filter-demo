package com.example.demo.repository;

import com.fasterxml.jackson.databind.JsonNode;
import org.postgresql.util.PGobject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;


@Repository
public class FilterRepository {

    @Autowired
    public JdbcTemplate jdbcTemplate;

    public void insert(JsonNode json) {

        int id = json.get("id").asInt();
        String condition = json.get("condition_").toString();
        int priority = json.get("priority").asInt();
        String action = json.get("action_").asText();

        Object[] params = new Object[]{
                id,
                condition,
                priority,
                action
        };
        String qry = "select * from public.insert(?,?::jsonb,?,? ::action_type)";

        jdbcTemplate.queryForObject(qry, params, PGobject.class);
    }

    public String filter(JsonNode values) {
        String qry = "select * from public.allow_or_block(?::jsonb)";
        String valuesString = values.toString();
        Object[] params = new Object[]{
                valuesString
        };
        return jdbcTemplate.queryForObject(qry, params, PGobject.class).getValue();
    }
}
