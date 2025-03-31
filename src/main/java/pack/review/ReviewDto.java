package pack.review;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewDto {
    private int num, movieId, gnum, onum, nested, rating, likeCount;
    private String userId, cdate, cont, nickname;
}
