package com.example.demo.config;

import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

@Configuration
public class DataBaseConfig {

    @Primary
    @Bean("clientDataSource")
    public HikariDataSource clientDataSource(){
        HikariDataSource dataSource=new HikariDataSource();

        dataSource.setJdbcUrl("jdbc:postgresql://localhost:5437/postgres");
        dataSource.setUsername("rd2");
        dataSource.setPassword("rd2");
        return  dataSource;
    }
    @Primary
    @Bean
    public JdbcTemplate clientJdbcTemplate(@Qualifier("clientDataSource") DataSource dsClient){
        return  new JdbcTemplate(dsClient);
    }

}
