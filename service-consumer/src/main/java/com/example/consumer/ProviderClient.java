package com.example.consumer;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "service-provider", url = "http://localhost:5003")
public interface ProviderClient {
    
    @GetMapping("/provider/hello")
    String hello();
    
    @GetMapping("/provider/info")
    String getInfo();
}