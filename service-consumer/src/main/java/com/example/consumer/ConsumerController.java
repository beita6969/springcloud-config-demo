package com.example.consumer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RefreshScope
public class ConsumerController {
    
    @Autowired
    private ProviderClient providerClient;
    
    @Value("${consumer.message:Default Consumer Message}")
    private String message;
    
    @Value("${consumer.provider-url:http://service-provider}")
    private String providerUrl;
    
    @GetMapping("/consumer/info")
    public String getInfo() {
        return String.format("Consumer Info - Message: %s, Provider URL: %s", message, providerUrl);
    }
    
    @GetMapping("/consumer/call-provider")
    public String callProvider() {
        String providerResponse = providerClient.hello();
        return String.format("Consumer called provider: %s", providerResponse);
    }
    
    @GetMapping("/consumer/provider-info")
    public String getProviderInfo() {
        String providerInfo = providerClient.getInfo();
        return String.format("Provider info from consumer: %s", providerInfo);
    }
}