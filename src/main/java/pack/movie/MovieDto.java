package pack.movie;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MovieDto {
    private int id;
    private String title, description, imageUrl, releaseDate, actorName, genre;
}
