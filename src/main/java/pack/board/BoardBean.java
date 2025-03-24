package pack.board;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
public class BoardBean {
    private int num, readcnt, gnum, onum, nested;
    private String name, pass, mail, title, cont, bip, bdate, imageUrl;

    public void setBdate() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        this.bdate = now.format(formatter);
    }
}
