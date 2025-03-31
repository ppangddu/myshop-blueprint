package pack.movie;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MovieBean {
    private int id;
    private String title, description, imageUrl, releaseDate, actorName, genre;
}
