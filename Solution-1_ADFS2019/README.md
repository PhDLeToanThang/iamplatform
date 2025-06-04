# iAM Security Platform:  Dựa trên giải pháp triển khai SSO (Single Sign-On) sử dụng Microsoft ADFS 2019:

## 1. 03 thành phần hệ thống tham gia giải pháp MS ADFS 2019 gồm:
----
- Certificate Authentication cho truy cập nội bộ (Enterprise)

- Federation URL cho các ứng dụng bên ngoài

- MFA/TOTP (Multi-Factor Authentication với Time-based One-Time Password)

---

## 🧩 1. Kiến trúc tổng quan

Microsoft ADFS 2019 sẽ đóng vai trò là Identity Provider (IdP), hỗ trợ xác thực người dùng cho các ứng dụng nội bộ và bên ngoài thông qua SAML 2.0 hoặc WS-Federation.

```Logic simple
 Người dùng → ADFS → Federation URL → Ứng dụng (SP)
```

---

## 🔐 2. Các thành phần chính:

| Thành phần | Mô tả |
|------------|-------|
| **ADFS Server** | Cài đặt trên Windows Server 2019, kết nối với Active Directory |
| **Web Application Proxy (WAP)** | Cho phép truy cập ADFS từ bên ngoài (Internet) |
| **Certificate Authentication** | Dùng cho xác thực nội bộ (Enterprise CA hoặc Smartcard) |
| **MFA (TOTP)** | Tích hợp với Microsoft Authenticator hoặc ứng dụng TOTP khác |
| **Federation Metadata URL** | Cung cấp metadata cho các ứng dụng liên kết (SP) |

---

## 🛠️ **3. Các bước triển khai**

### Bước 1: Cài đặt và cấu hình ADFS
- Cài đặt vai trò ADFS trên Windows Server 2019
- Kết nối với Active Directory
- Cấu hình SSL certificate cho ADFS service

### Bước 2: Cấu hình Certificate Authentication
- Cài đặt và cấu hình **Enterprise CA**
- Cho phép xác thực bằng certificate trong ADFS (Authentication Policies)
- Cấu hình **Client Certificate Mapping** nếu cần

### Bước 3: Cấu hình Federation URL
- Tạo **Relying Party Trusts** cho các ứng dụng sử dụng SAML hoặc WS-Fed
- Cung cấp **Federation Metadata URL** cho các bên liên kết

### Bước 4: Tích hợp MFA/TOTP
- Cài đặt và cấu hình **Azure MFA Server** hoặc sử dụng **ADFS built-in MFA adapter**
- Cho phép xác thực bằng TOTP (Microsoft Authenticator, Google Authenticator)
- Cấu hình **Access Control Policies** để yêu cầu MFA theo điều kiện (ví dụ: truy cập từ ngoài mạng nội bộ)

### Bước 5: Cấu hình WAP (Web Application Proxy)
- Cài đặt WAP để cho phép truy cập ADFS từ Internet
- Cấu hình **Pre-authentication** và **pass-through** cho các ứng dụng


## D. Phân loại cách thức triển khai MFA và Multi-Factors:
### 5.1. Trường hợp 1. MFA cho từng ứng dụng cụ thể triển khai khả thi:
#### 5.1.1. Màn hình Portal Workspace cho từng use người dùng có màn Pincode TOTP của Web/Outlook Email 

5.1.2. Ví dụ 1. Moodle - Elearning - LMS tích hợp với Source code/Plugin: MFA-TOTP.  (https://mooc.cloud.edu.vn)

5.1.3. Ví dụ 2. GLPI - ITSM/ITSAM tích hợp với Source code/Plugin: MFA-TOTP.  (https://itsm.atcom.vn )

5.1.4. Ví dụ 3. SEO - tích hợp với Source code/Plugin: MFA -TOTP. ( https://seo.cloud.edu.vn )

5.1.5. Đề xuất mỗi người dùng đều có màn màn Authenticator Multi-Factor và Multi-Apps TOTP để tự được quyền nhận PinCode cho mình dùng Web/Outlook Email (trên Thiết bị Smart phone cài Microsoft Authneticator của Doanh nghiệp, phù hợp với chính sách của Doanh nghiệp cho phép tự mua sắm và sử dụng công khai). 

### 5.2. Trường hợp 2. MFA cho từng ứng dụng cụ thể triển khai khả thi nhưng chính sách sử dụng 2FA của Doanh nghiệp không cho phép:
#### 5.2.1. Đề xuất màn Authenticator Multi-Factor và Multi-User TOTP để một số trong nhóm Leaders/Co-hort được quyền cung cấp PinCode cho người dùng Web/Outlook Email (trên Thiết bị Tablet/ipad đặt tại Bộ phận IT Audit của Doanh nghiệp). 
### - Rủi ro:
5.2.1.1. Quá nhiều người yêu cầu khi login Web/Outlook, IT Audit bận lo việc khác không hồi đáp thông tin pincode thay đổi sau 30s.

5.2.1.2. Nếu đã thêm Authenticator xác thực OuAth hoặc Software TOTP của mọi người vào cùng 1 thiết bị đặt lại Doanh nghiệp, thì các dịch vụ Web/Outlook bắt xác thực bằng 2FA sẽ không thể thêm ở nới khác (ví dụ: nhà riêng hoặc thiết bị xác thực thứ 3 cho cá nhân người dùng).

5.2.1.3. Màn hình để tiếp nhận Multi-factor cho multi-user TOTP phải đủ lớn vì rất nhiều dòng TOTP xuất hiện cùng lúc, phải tra cứu tìm kiếm theo người dùng nên phải ghi thông tin đăng ký App Auth dễ hiểu, chính xác, Phải backup thường xuyên các RSA Token Encryption của người dùng để tránh sự cố mất dữ liệu Vault Keys...

### 5.2.2. Đề xuất dùng Khóa cứng HOTP như yubikey/HOTP token/TrustedKey...  
### - Rủi ro: 
5.2.2.1. Chính sách chặn dùng USB sẽ khó đảm bảo khi mọi người đều dùng USB Token.

5.2.2.2. Các USB key đều cần có Token Manager để quản lý/xóa/sửa/thu hồi/renew CA nên vẫn phải vá lỗi nâng cấp bảo mật SSL/TLS token.

5.2.2.3. Chi phí token key cao, Vẫn phải duy trì bảo hành, Phải backup thường xuyên các RSA Token Encryption của người dùng để tránh sự cố mất dữ liệu Vault Keys...

### 5.3. Trường hợp 3. MFA khó cấu hình và tích hợp TOTP cho các ứng dụng Code đóng, không có source code để sửa.
#### 5.3.1. Màn hình Portal Workspace cho từng use người dùng có màn Pincode TOTP của Web/Outlook Email 

5.3.2. Ví dụ 3. Cloud Edge - Remote Control Cloud tích hợp MFA - TOTP source code/Plugin: MFA-TOTP 

#### - Hệ thống Điện toán này quản lý các kết nối Remote tới Máy Chủ Ảo/ HĐH máy client đã cài các phần mềm (không có source code để sửa).
Lưu ý: Các phần mềm trên vẫn cho phép cài lại, cài mới trên các HĐH phiên bản cũ 32/64bit ví dụ: Windows XP/Win7/8x/10x/11x/12x hoặc 2k3 64bit/ 2k8 x64bit/2k12 x63bit/2k16/2k19/2k22... Linux x64bit.

#### - Hệ thống giải pháp "Điện toán ứng dụng - Cloud App" hoặc Web hóa toàn bộ ứng dụng theo chuẩn HTML5 hoặc K8s sẽ giúp tích hợp MFA và TOTP trên tầng Portal Workspace của người dùng, dẽ dàng tích hợp SSO - LDAPs ở tầng ứng dụng phần mềm (không có source code để sửa) vì cấu hình giữa HĐH của máy người dùng và Windows Authenticate Apps là có sẵn các phương thức cấu hình bypass hoặc Use Passkey dựa trên thư viện phần mềm hãng thứ 3 với HĐH ví dụ: Github, Google, Linkedin Login với Windows Authenticate.
