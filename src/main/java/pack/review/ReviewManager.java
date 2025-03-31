package pack.review;

import pack.movie.MovieDto;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class ReviewManager {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private DataSource ds;

    private int recTot;
    private int pageList = 10;
    private int pageTot;

    public ReviewManager() {
        try {
            Context context = new InitialContext();
            ds = (DataSource) context.lookup("java:comp/env/jdbc_maria");
        } catch (Exception e) {
            System.out.println("Driver 로딩 실패 : " + e.getMessage());
        }
    }

    public void totalList() {
        String sql = "select count(*) from review where num=gnum";
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

//    public ArrayList<ReviewDto> getDataAll(int page, String searchType, String searchWord) {
//        ArrayList<ReviewDto> list = new ArrayList<>();
//        String sql = "select * from review";
//
//        try {
//            conn = ds.getConnection();
//
//            if (searchWord == null || searchWord.trim().isEmpty()) {
//                sql += " WHERE num=gnum ORDER BY num DESC";
//                pstmt = conn.prepareStatement(sql);
//            } else {
//                sql += " WHERE num=gnum AND " + searchType + " LIKE ? ORDER BY num DESC";
//                pstmt = conn.prepareStatement(sql);
//                pstmt.setString(1, "%" + searchWord + "%");
//            }
//
//            rs = pstmt.executeQuery();
//
//            for (int i = 0; i < (page - 1) * pageList; i++) {
//                rs.next();
//            }
//
//            int k = 0;
//            while (rs.next() && k < pageList) {
//                ReviewDto dto = new ReviewDto();
//                dto.setNum(rs.getInt("num"));
//                dto.setTitle(rs.getString("title"));
//                dto.setBdate(rs.getString("bdate"));
//                dto.setReadcnt(rs.getInt("readcnt"));
//                dto.setNested(rs.getInt("nested"));
//                dto.setImageUrl(rs.getString("image_url"));
//                dto.setRating(rs.getInt("rating"));
//                dto.setLikeCount(rs.getInt("like_count"));
//                dto.setReleaseDate(rs.getString("release_date"));
//                dto.setDirectorName(rs.getString("director_name"));
//                list.add(dto);
//                k++;
//            }
//        } catch (Exception e) {
//            System.out.println("getDataAll err : " + e);
//        } finally {
//            try {
//                if (rs != null) rs.close();
//                if (pstmt != null) pstmt.close();
//                if (conn != null) conn.close();
//            } catch (Exception e2) {
//            }
//        }
//        return list;
//    }

    public int currentMaxNum() {
        String sql = "select max(num) from review";
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

    public void saveData(ReviewBean bean) {
        String sql = "INSERT INTO review (movie_id, user_id, cdate, gnum, onum, nested, rating, like_count, cont) VALUES (?, ?, now(), ?, ?, ?, ?, ?, ?)";
        int num = currentMaxNum() + 1;
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bean.getMovieId());       // foreign key
            pstmt.setString(2, bean.getUserId());
            pstmt.setInt(3, num);
            pstmt.setInt(4, 0);
            pstmt.setInt(5, 0);
            pstmt.setInt(6, bean.getRating());
            pstmt.setInt(7, 0); // like count
            pstmt.setString(8, bean.getCont());

            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("saveData err : " + e);
        }
    }


    public void updateReadcnt(String num) {
        String sql = "update review set readcnt=readcnt + 1 where num=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, num);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("updateReadcnt err : " + e);
        }
    }

    public ReviewDto getData(String num) {
        ReviewDto dto = null;
        String sql = "SELECT * FROM review WHERE num=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, num);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new ReviewDto();
                    dto.setNum(rs.getInt("num"));
                    dto.setMovieId(rs.getInt("movie_id"));
                    dto.setUserId(rs.getString("user_id"));
                    dto.setCdate(rs.getString("cdate"));
                    dto.setGnum(rs.getInt("gnum"));
                    dto.setOnum(rs.getInt("onum"));
                    dto.setNested(rs.getInt("nested"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setLikeCount(rs.getInt("like_count"));
                    dto.setCont(rs.getString("cont"));
                    // 필요하다면 nickname도 세팅
                }
            }
        } catch (Exception e) {
            System.out.println("getData err: " + e);
        }
        return dto;
    }


    public ReviewDto getReplyData(int num) {
        String sql = "SELECT movie_id, gnum, onum, nested FROM review WHERE num=?";
        ReviewDto dto = null;

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, num);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new ReviewDto();
                    dto.setMovieId(rs.getInt("movie_id"));
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
        String sql = "update review set onum = onum + 1 where onum >= ? and gnum = ?";
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

    // 새 댓글 저장 메서드
    public void saveReplyData(ReviewBean bean) {
        String sql = "INSERT INTO review (movie_id, user_id, cdate, gnum, onum, nested, rating, like_count, cont) "
                + "VALUES (?, ?, now(), ?, ?, ?, ?, 0, ?)";

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bean.getMovieId());  // 영화 id 필수
            pstmt.setString(2, bean.getUserId());
            pstmt.setInt(3, bean.getGnum());
            pstmt.setInt(4, bean.getOnum());
            pstmt.setInt(5, bean.getNested());
            pstmt.setInt(6, bean.getRating());
            pstmt.setString(7, bean.getCont());

            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("saveReplyData err : " + e);
        }
    }


    public boolean checkPassword(int num, String newPass) {
        boolean b = false;
        String sql = "select pass from review where num=?";
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

//    public void saveEdit(ReviewBean bean) {
//        String sql = "update review set title=?, director_name=?, cont=?, image_url=? where num=?";
//        try {
//            conn = ds.getConnection();
//            pstmt = conn.prepareStatement(sql);
//            pstmt.setString(1, bean.getTitle());
//            pstmt.setString(2, bean.getDirectorName());
//            pstmt.setString(3, bean.getCont());
//            pstmt.setString(4, bean.getImageUrl());
//            pstmt.setInt(5, bean.getNum());
//            pstmt.executeUpdate();
//        } catch (Exception e) {
//            System.out.println("saveEdit err: " + e);
//        } finally {
//            try {
//                if (rs != null) rs.close();
//                if (pstmt != null) pstmt.close();
//                if (conn != null) conn.close();
//            } catch (Exception e2) {
//            }
//        }
//    }

    public void delData(String num) {
        String sql = "delete from review where gnum=?";
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

    public ArrayList<ReviewDto> getComments(int gnum) {
        ArrayList<ReviewDto> all = new ArrayList<>();
        ArrayList<List<ReviewDto>> grouped = new ArrayList<>();

        String sql = "SELECT r.*, u.nickname " +
                "FROM review r " +
                "JOIN user u ON r.user_id = u.id " +
                "WHERE r.gnum=? " +
                "ORDER BY r.onum ASC";

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gnum);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDto dto = new ReviewDto();
                dto.setNum(rs.getInt("num"));
                dto.setCont(rs.getString("cont"));
                dto.setCdate(rs.getString("cdate"));
                dto.setNested(rs.getInt("nested"));
                dto.setRating(rs.getInt("rating"));
                dto.setLikeCount(rs.getInt("like_count"));
                dto.setOnum(rs.getInt("onum"));
                dto.setUserId(rs.getString("user_id"));
                dto.setNickname(rs.getString("nickname"));
                all.add(dto);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("getComments err : " + e);
        }

        // 1. 댓글 + 대댓글 그룹핑
        for (int i = 0; i < all.size(); i++) {
            ReviewDto dto = all.get(i);
            if (dto.getNested() == 1) {
                List<ReviewDto> group = new ArrayList<>();
                group.add(dto);

                for (int j = i + 1; j < all.size(); j++) {
                    ReviewDto next = all.get(j);
                    if (next.getNested() == 1) break;
                    group.add(next);
                }

                List<ReviewDto> replies = group.stream()
                        .filter(r -> r.getNested() > 1)
                        .sorted((r1, r2) -> {
                            int nestedCmp = Integer.compare(r1.getNested(), r2.getNested());
                            return (nestedCmp != 0) ? nestedCmp :
                                    Integer.compare(r2.getLikeCount(), r1.getLikeCount());
                        })
                        .collect(Collectors.toList());

                List<ReviewDto> combined = new ArrayList<>();
                combined.add(group.get(0)); // 원댓글
                combined.addAll(replies);
                grouped.add(combined);
            }
        }

        // 2. 그룹 정렬 (원댓글 좋아요 기준)
        grouped.sort((g1, g2) -> Integer.compare(g2.get(0).getLikeCount(), g1.get(0).getLikeCount()));

        // 3. flatten
        ArrayList<ReviewDto> result = new ArrayList<>();
        for (List<ReviewDto> group : grouped) {
            result.addAll(group);
        }

        return result;
    }





    public int getTotalRecordCount() {
        return recTot;
    }

    public void increaseLikeCount(int num) {
        String sql = "update review set like_count = like_count + 1 where num=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, num);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("increaseLikeCount err : " + e);
        }
    }

    public int getLikeCount(int num) {
        String sql = "SELECT like_count FROM review WHERE num=?";
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

    public double getAverageRating(int movieId) {
        double avg = 0;
        String sql = "SELECT AVG(rating) FROM review WHERE movie_id=? AND nested=1 AND rating > 0";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, movieId); // 이 부분 수정 필수!
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                avg = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println("getAverageRating err : " + e);
        }
        return avg;
    }


    public MovieDto getMovieById(int movieId) {
        MovieDto movie = null;
        String sql = "SELECT * FROM movie WHERE id = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, movieId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    movie = new MovieDto();
                    movie.setId(rs.getInt("id"));
                    movie.setTitle(rs.getString("title"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setDescription(rs.getString("description"));
                    movie.setImageUrl(rs.getString("image_url"));
                    movie.setReleaseDate(rs.getString("release_date"));
                    movie.setActorName(rs.getString("actor_name"));
                }
            }
        } catch (Exception e) {
            System.out.println("getMovieById err: " + e);
        }
        return movie;
    }

    public ArrayList<ReviewDto> getCommentsByMovieId(int movieId) {
        ArrayList<ReviewDto> all = new ArrayList<>();
        ArrayList<List<ReviewDto>> grouped = new ArrayList<>();

        String sql = "SELECT r.*, u.nickname " +
                "FROM review r JOIN user u ON r.user_id = u.id " +
                "WHERE r.movie_id=? ORDER BY r.gnum, r.onum";

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, movieId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDto dto = new ReviewDto();
                dto.setNum(rs.getInt("num"));
                dto.setCont(rs.getString("cont"));
                dto.setCdate(rs.getString("cdate"));
                dto.setNested(rs.getInt("nested"));
                dto.setRating(rs.getInt("rating"));
                dto.setLikeCount(rs.getInt("like_count"));
                dto.setOnum(rs.getInt("onum"));
                dto.setUserId(rs.getString("user_id"));
                dto.setNickname(rs.getString("nickname"));
                all.add(dto);
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("getCommentsByMovieId err : " + e);
        }

        // 댓글 그룹핑 (원댓글과 대댓글 묶기)
        for (int i = 0; i < all.size(); i++) {
            ReviewDto dto = all.get(i);
            if (dto.getNested() == 1) {
                List<ReviewDto> group = new ArrayList<>();
                group.add(dto);

                for (int j = i + 1; j < all.size(); j++) {
                    ReviewDto next = all.get(j);
                    if (next.getNested() == 1) break; // 다음 원댓글 나오면 그룹 종료
                    group.add(next); // 대댓글 추가
                }
                grouped.add(group);
            }
        }

        // 각 그룹(댓글+대댓글)을 원댓글의 좋아요 순서로 정렬
        grouped.sort((g1, g2) -> Integer.compare(g2.get(0).getLikeCount(), g1.get(0).getLikeCount()));

        // 정렬된 그룹 다시 리스트로 펼치기
        ArrayList<ReviewDto> result = new ArrayList<>();
        for (List<ReviewDto> group : grouped) {
            result.addAll(group);
        }

        return result;
    }


}