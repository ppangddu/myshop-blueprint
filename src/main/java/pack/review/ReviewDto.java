package pack.review;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewDto {
    private int num, readcnt, gnum, onum, nested, rating, likeCount;
    private String userId, title, cont, bip, bdate, imageUrl, releaseDate, directorName, nickname;

}
