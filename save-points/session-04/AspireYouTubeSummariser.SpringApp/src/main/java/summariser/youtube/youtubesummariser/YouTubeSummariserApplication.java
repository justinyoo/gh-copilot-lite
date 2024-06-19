package summariser.youtube.youtubesummariser;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan({"main.java.summariser.youtube.youtubesummariser.controllers"})
public class YouTubeSummariserApplication {

	public static void main(String[] args) {
		SpringApplication.run(YouTubeSummariserApplication.class, args);
	}

}
