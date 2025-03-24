package pack.board;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class BoardDto {
    private int num, readcnt, gnum, onum, nested, rating;
    private String name, pass, mail, title, cont, bip, bdate, imageUrl;

}
