package com.example.app_1;

import com.example.module_a.TestCaseRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Runner {
    public static void main(String args[]) {
        TestCaseRunner.test();
        TestCaseRunner.test2();
        TestCaseRunner.test3();
    }
}