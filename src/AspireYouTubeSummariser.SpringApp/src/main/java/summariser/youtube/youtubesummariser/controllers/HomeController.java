package main.java.summariser.youtube.youtubesummariser.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String redirectSwaggerUi() {
        return "redirect:/swagger-ui.html";
    }
}