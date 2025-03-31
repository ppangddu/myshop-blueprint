package pack.movie;

import pack.review.ReviewBean;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class MovieManager {
        private Connection conn;
        private PreparedStatement pstmt;
        private ResultSet rs;
        private DataSource ds;

        private int recTot;
        private int pageList = 10;
        private int pageTot;

        public MovieManager() {
            try {
                Context context = new InitialContext();
                ds = (DataSource) context.lookup("java:comp/env/jdbc_maria");
            } catch (Exception e) {
                System.out.println("Driver 로딩 실패 : " + e.getMessage());
            }
        }

        public int getPageSu() {
            pageTot = recTot / pageList;
            if (recTot % pageList > 0) pageTot++;
            return pageTot;
        }

        public int getTotalRecordCount() {
            return recTot;
        }

        public void totalList() {
            String sql = "SELECT COUNT(*) FROM movie";
            try (Connection conn = ds.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    recTot = rs.getInt(1);
                }
            } catch (Exception e) {
                System.out.println("totalList err : " + e);
            }
        }

        public ArrayList<MovieDto> getDataAll(int page, String searchType, String searchWord) {
            ArrayList<MovieDto> list = new ArrayList<>();
            String sql = "SELECT * FROM movie";

            try {
                conn = ds.getConnection();

                if (searchWord == null || searchWord.trim().isEmpty()) {
                    sql += " ORDER BY id DESC";
                    pstmt = conn.prepareStatement(sql);
                } else {
                    sql += " WHERE " + searchType + " LIKE ? ORDER BY id DESC";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, "%" + searchWord + "%");
                }

                rs = pstmt.executeQuery();

                for (int i = 0; i < (page - 1) * pageList; i++) {
                    rs.next();
                }

                int k = 0;
                while (rs.next() && k < pageList) {
                    MovieDto dto = new MovieDto();
                    dto.setId(rs.getInt("id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setGenre(rs.getString("genre"));
                    dto.setDescription(rs.getString("description"));
                    dto.setImageUrl(rs.getString("image_url"));
                    dto.setReleaseDate(rs.getString("release_date"));
                    dto.setActorName(rs.getString("actor_name"));
                    list.add(dto);
                    k++;
                }
            } catch (Exception e) {
                System.out.println("getDataAll (Movie) err : " + e);
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e2) {}
            }
            return list;
        }

        public void saveMovie(MovieBean bean) {
            String sql = "insert into movie(title, genre, description, image_url, release_date, actor_name) values(?, ?, ?, ?, ?, ?)";
            try (Connection conn = ds.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, bean.getTitle());
                pstmt.setString(2, bean.getGenre());
                pstmt.setString(3, bean.getDescription());
                pstmt.setString(4, bean.getImageUrl());
                pstmt.setString(5, bean.getReleaseDate());
                pstmt.setString(6, bean.getActorName());
                pstmt.executeUpdate();
            } catch (Exception e) {
                System.out.println("saveMovie err : " + e);
            }
    }
}
