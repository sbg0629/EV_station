package com.boot.Main_Page.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.boot.Main_Page.service.EvLoadService;

@RestController
public class ApiTestController {

    @Autowired
    private EvLoadService evLoadService;

    // 브라우저 주소창에 http://localhost:8484/api/load 입력 시 실행
    @GetMapping("/api/load")
    public String loadData() {
        return evLoadService.loadApiData();
    }
}