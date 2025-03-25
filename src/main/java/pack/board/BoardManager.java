package pack.board;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BoardManager {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private DataSource ds;

    private int recTot;
    private int pageList = 10;
    private int pageTot;

    public BoardManager() {
        try {
            Context context = new InitialContext();
            ds = (DataSource) context.lookup("java:comp/env/jdbc_maria");
        } catch (Exception e) {
            System.out.println("Driver 로딩 실패 : " + e.getMessage());
        }
    }

    public void totalList() {
        String sql = "select count(*) from board where num=gnum";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            rs.next();
            recTot = rs.getInt(1);
        } catch (Exception e) {
            System.out.println("totalList err : " + e);
        }
    }

    public int getPageSu() {
        pageTot = recTot / pageList;
        if (recTot % pageList > 0) pageTot++;
        return pageTot;
    }

    public ArrayList<BoardDto> getDataAll(int page, String searchType, String searchWord) {
        ArrayList<BoardDto> list = new ArrayList<>();
        String sql = "select * from board";

        try {
            conn = ds.getConnection();

            if (searchWord == null || searchWord.trim().isEmpty()) {
                sql += " WHERE num=gnum ORDER BY num DESC";
                pstmt = conn.prepareStatement(sql);
            } else {
                sql += " WHERE num=gnum AND " + searchType + " LIKE ? ORDER BY num DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
            }

            rs = pstmt.executeQuery();

            for (int i = 0; i < (page - 1) * pageList; i++) {
                rs.next();
            }

            int k = 0;
            while (rs.next() && k < pageList) {
                BoardDto dto = new BoardDto();
                dto.setNum(rs.getInt("num"));
                dto.setName(rs.getString("name"));
                dto.setTitle(rs.getString("title"));
                dto.setBdate(rs.getString("bdate"));
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setNested(rs.getInt("nested"));
                dto.setImageUrl(rs.getString("image_url"));
                dto.setRating(rs.getInt("rating"));
                dto.setLikeCount(rs.getInt("like_count"));
                dto.setReleaseDate(rs.getString("release_date"));
                list.add(dto);
                k++;
            }
        } catch (Exception e) {
            System.out.println("getDataAll err : " + e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
            }
        }
        return list;
    }

    public int currentMaxNum() {
        String sql = "select max(num) from board";
        int num = 0;
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) num = rs.getInt(1);
        } catch (Exception e) {
            System.out.println("currentMaxNum err : " + e);
        }
        return num;
    }

    public void saveData(BoardBean bean) {
        String sql = "INSERT INTO board (num, name, pass, mail, title, cont, bip, bdate, readcnt, gnum, onum, nested, image_url, rating, like_count, release_date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

        int num = currentMaxNum() + 1;

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, num);
            pstmt.setString(2, bean.getName());
            pstmt.setString(3, bean.getPass());
            pstmt.setString(4, bean.getMail());
            pstmt.setString(5, bean.getTitle());
            pstmt.setString(6, bean.getCont());
            pstmt.setString(7, bean.getBip());
            pstmt.setString(8, bean.getBdate());
            pstmt.setInt(9, 0);
            pstmt.setInt(10, num);
            pstmt.setInt(11, 0);
            pstmt.setInt(12, 0);
            pstmt.setString(13, bean.getImageUrl());
            pstmt.setInt(14, 0);
            pstmt.setInt(15, 0);
            pstmt.setString(16, bean.getReleaseDate());
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("saveData err : " + e);
        }
    }

    public void updateReadcnt(String num) {
        String sql = "update board set readcnt=readcnt + 1 where num=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, num);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("updateReadcnt err : " + e);
        }
    }

    public BoardDto getData(String num) {
        String sql = "select * from board where num=?";
        BoardDto dto = null;
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, num);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new BoardDto();
                    dto.setNum(rs.getInt("num"));
                    dto.setName(rs.getString("name"));
                    dto.setPass(rs.getString("pass"));
                    dto.setMail(rs.getString("mail"));
                    dto.setTitle(rs.getString("title"));
                    dto.setCont(rs.getString("cont"));
                    dto.setBip(rs.getString("bip"));
                    dto.setBdate(rs.getString("bdate"));
                    dto.setReadcnt(rs.getInt("readcnt"));
                    dto.setImageUrl(rs.getString("image_url"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setLikeCount(rs.getInt("like_count"));
                    dto.setReleaseDate(rs.getString("release_date"));
                }
            }
        } catch (Exception e) {
            System.out.println("getData err : " + e);
        }
        return dto;
    }

    public BoardDto getReplyData(String num) {
        String sql = "select * from board where num=?";
        BoardDto dto = null;
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, num);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new BoardDto();
                    dto.setTitle(rs.getString("title"));
                    dto.setGnum(rs.getInt("gnum"));
                    dto.setOnum(rs.getInt("onum"));
                    dto.setNested(rs.getInt("nested"));
                }
            }
        } catch (Exception e) {
            System.out.println("getReplyData err : " + e);
        }
        return dto;
    }

    public void updateOnum(int gnum, int onum) {
        String sql = "update board set onum = onum + 1 where onum >= ? and gnum = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, onum);
            pstmt.setInt(2, gnum);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("updateOnum err : " + e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
            }
        }
    }

    public void saveReplyData(BoardBean bean) {
        String sql = "insert into board values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bean.getNum());
            pstmt.setString(2, bean.getName());
            pstmt.setString(3, bean.getPass());
            pstmt.setString(4, bean.getMail());
            pstmt.setString(5, bean.getTitle());
            pstmt.setString(6, bean.getCont());
            pstmt.setString(7, bean.getBip());
            pstmt.setString(8, bean.getBdate());
            pstmt.setInt(9, 0);
            pstmt.setInt(10, bean.getGnum());
            pstmt.setInt(11, bean.getOnum());
            pstmt.setInt(12, bean.getNested());
            pstmt.setString(13, bean.getImageUrl());
            pstmt.setInt(14, bean.getRating());
            pstmt.setInt(15,0);
            pstmt.setString(16, bean.getReleaseDate());
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("saveReplyData err : " + e);
        }
    }

    public boolean checkPassword(int num, String newPass) {
        boolean b = false;
        String sql = "select pass from board where num=?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                if (newPass.equals(rs.getString("pass"))) {
                    b = true;
                }
            }
        } catch (Exception e) {
            System.out.println("checkPassword err : " + e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
            }
        }
        return b;
    }

    public void saveEdit(BoardBean bean) {
        String sql = "update board set name=?,mail=?,title=?,cont=?, image_url=? where num=?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bean.getName());
            pstmt.setString(2, bean.getMail());
            pstmt.setString(3, bean.getTitle());
            pstmt.setString(4, bean.getCont());
            pstmt.setString(5, bean.getImageUrl());
            pstmt.setInt(6, bean.getNum());
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("saveEdit err: " + e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
            }
        }
    }

    public void delData(String num) {
        String sql = "delete from board where gnum=?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, num);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("delData err : " + e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
            }
        }
    }

    public ArrayList<BoardDto> getComments(int originalNum) {
        ArrayList<BoardDto> comments = new ArrayList<>();
        String sql = "SELECT * FROM board WHERE gnum=? AND num != ? ORDER BY onum ASC";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, originalNum);
            pstmt.setInt(2, originalNum);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                BoardDto dto = new BoardDto();
                dto.setNum(rs.getInt("num"));
                dto.setName(rs.getString("name"));
                dto.setCont(rs.getString("cont"));
                dto.setBdate(rs.getString("bdate"));
                dto.setNested(rs.getInt("nested"));
                dto.setTitle(rs.getString("title"));
                dto.setImageUrl(rs.getString("image_url"));
                dto.setRating(rs.getInt("rating"));
                dto.setLikeCount(rs.getInt("like_count"));
                comments.add(dto);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("getComments err : " + e);
        }
        return comments;
    }

    public int getTotalRecordCount() {
        return recTot;
    }

    public void increaseLikeCount(int num) {
        String sql = "update board set like_count = like_count + 1 where num=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, num);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("increaseLikeCount err : " + e);
        }
    }

    public int getLikeCount(int num) {
        String sql = "SELECT like_count FROM board WHERE num=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, num);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("like_count");
            }
        } catch (Exception e) {
            System.out.println("getLikeCount err : " + e);
        }
        return 0;
    }


}