package pack.board;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardDto {
    private int num, readcnt, gnum, onum, nested, rating, likeCount;
    private String name, pass, mail, title, cont, bip, bdate, imageUrl, releaseDate;

}
