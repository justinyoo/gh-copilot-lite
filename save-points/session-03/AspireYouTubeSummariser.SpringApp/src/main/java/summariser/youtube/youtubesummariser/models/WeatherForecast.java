package main.java.summariser.youtube.youtubesummariser.models;

import java.time.LocalDate;

public class WeatherForecast {
    private LocalDate date;
    private int temperatureC;
    private String summary;

    // Constructor
    public WeatherForecast(LocalDate date, int temperatureC, String summary) {
        this.date = date;
        this.temperatureC = temperatureC;
        this.summary = summary;
    }

    // Getters and Setters
    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getTemperatureC() {
        return temperatureC;
    }

    public void setTemperatureC(int temperatureC) {
        this.temperatureC = temperatureC;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }
}