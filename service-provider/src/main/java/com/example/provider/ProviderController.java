package com.example.provider;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RefreshScope
public class ProviderController {
    
    @Value("${provider.message:Default Provider Message}")
    private String message;
    
    @Value("${provider.version:1.0.0}")
    private String version;
    
    @GetMapping("/provider/info")
    public String getInfo() {
        return String.format("Provider Info - Message: %s, Version: %s", message, version);
    }
    
    @GetMapping("/provider/hello")
    public String hello() {
        return "Hello from Service Provider!";
    }
}