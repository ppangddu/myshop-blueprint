package pack.review;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
public class ReviewBean {
    private int num, movieId, gnum, onum, nested, rating, likeCount;
    private String userId, cdate, cont, nickname;
}
