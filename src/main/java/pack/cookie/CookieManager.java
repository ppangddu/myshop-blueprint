package pack.cookie;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;
import jakarta.servlet.http.Cookie;

public class CookieManager {
    private static final CookieManager INSTANCE;
    private static final String ALGORITHM = "AES/CBC/PKCS5Padding";
    private static final String SECRET_KEY = "MySuperSecretKey";
    private static final String INIT_VECTOR = "InitVector123456";
    private static final int MAX_AGE = 60 * 60 * 24 * 400;
    private static final String CHARSET = "UTF-8";

    static { // 싱글톤 인스턴스 생성
        try { INSTANCE = new CookieManager();
        } catch (Exception e) { throw new RuntimeException("초기화 실패", e); }
    } public static CookieManager getInstance() { return INSTANCE; }

    private final SecretKeySpec secretKey;
    private final IvParameterSpec ivParameterSpec;

    private CookieManager() throws Exception {
        // 키 생성
        byte[] keyBytes = SECRET_KEY.getBytes(CHARSET);
        this.secretKey = new SecretKeySpec(keyBytes, "AES");
        // IV 생성
        byte[] ivBytes = INIT_VECTOR.getBytes(CHARSET);
        this.ivParameterSpec = new IvParameterSpec(ivBytes);
    }
    // 암호화
    public String encrypt(String value) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivParameterSpec);
        byte[] encrypted = cipher.doFinal(value.getBytes(CHARSET));
        return Base64.getUrlEncoder().encodeToString(encrypted);
    }
    // 복호화
    public String decrypt(String encryptedValue) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivParameterSpec);
        byte[] original = cipher.doFinal(Base64.getUrlDecoder().decode(encryptedValue));
        return new String(original);
    }
    // 쿠키 생성, 수정 리팩토링
    private Cookie refactoringCookie(String name, String value) throws Exception {
        Cookie cookie = new Cookie(name, value);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        cookie.setMaxAge(MAX_AGE);
        return cookie;
    }
    // 기본 쿠키 생성
    public Cookie createCookie(String name, String value) throws Exception { // 매개변수 쿠키이름, 쿠키값
        return refactoringCookie(name, value);
    }
    // 암호화 쿠키 생성
    public Cookie createEncryptCookie(String name, String value) throws Exception { // 매개변수 쿠키이름, 쿠키값
        return refactoringCookie(name, encrypt(value));
    }
    // 기본 쿠키 읽기
    public String readCookie(Cookie cookie) throws Exception { // 매개변수 쿠키이름
        if (cookie == null || cookie.getValue() == null) return null;
        return cookie.getValue();
    }
    // 복호화 쿠키 읽기
    public String readDecryptCookie(Cookie cookie) throws Exception { // 매개변수 쿠키이름
        if (cookie == null || cookie.getValue() == null) return null;
        return decrypt(cookie.getValue());
    }
    // 기본 쿠키 수정
    public Cookie updateCookie(String name, String newValue) throws Exception { // 매개변수 쿠키이름, 쿠키값
        return refactoringCookie(name, newValue);
    }
    // 암호화 쿠키 수정
    public Cookie updateEncryptCookie(String name, String newValue) throws Exception { // 매개변수 쿠키이름, 쿠키값
        return refactoringCookie(name, encrypt(newValue));
    }
    // 쿠키 삭제(암호화 여부 상관 없음)
    public Cookie deleteCookie(String name) { // 매개변수 쿠키이름
        Cookie cookie = new Cookie(name, ""); // 쿠키값 제거
        cookie.setMaxAge(0); // 쿠키수명 제거
        cookie.setPath("/");  // 동일한 쿠키의 쿠키값과 수명을 제거한 것을 설정시켜 쿠키 삭제 암호화 여부 상관 없음
        return cookie;
    }
}