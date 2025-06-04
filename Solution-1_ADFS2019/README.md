# iAM Security Platform:  Dựa trên giải pháp triển khai SSO (Single Sign-On) sử dụng Microsoft ADFS 2019:

## 1. 03 thành phần hệ thống tham gia giải pháp MS ADFS 2019 gồm:

- Certificate Authentication cho truy cập nội bộ (Enterprise).

- Federation URL cho các ứng dụng bên ngoài.

- MFA/TOTP (Multi-Factor Authentication với Time-based One-Time Password).

![image](https://github.com/PhDLeToanThang/iamplatform/blob/main/Solution-1_ADFS2019/ADFS2019.drawio.svg)

---

### 🧩 1. Kiến trúc tổng quan

Microsoft ADFS 2019 sẽ đóng vai trò là Identity Provider (IdP), hỗ trợ xác thực người dùng cho các ứng dụng nội bộ và bên ngoài thông qua SAML 2.0 hoặc WS-Federation.

```Logic simple
 Người dùng → ADFS → Federation URL → Ứng dụng (SP)
```

---

### 🔐 2. Các thành phần chính:

| Thành phần | Mô tả |
|------------|-------|
| **ADFS Server** | Cài đặt trên Windows Server 2019, kết nối với Active Directory |
| **Web Application Proxy (WAP)** | Cho phép truy cập ADFS từ bên ngoài (Internet) |
| **Certificate Authentication** | Dùng cho xác thực nội bộ (Enterprise CA hoặc Smartcard) |
| **MFA (TOTP)** | Tích hợp với Microsoft Authenticator hoặc ứng dụng TOTP khác |
| **Federation Metadata URL** | Cung cấp metadata cho các ứng dụng liên kết (SP) |

---

### 🛠️ **3. Các bước triển khai**

#### Bước 1: Cài đặt và cấu hình ADFS

- Cài đặt vai trò ADFS trên Windows Server 2019.

- Kết nối với Active Directory.

- Cấu hình SSL certificate cho ADFS service.

#### Bước 2: Cấu hình Certificate Authentication:

- Cài đặt và cấu hình **Enterprise CA**

- Cho phép xác thực bằng certificate trong ADFS (Authentication Policies)

- Cấu hình **Client Certificate Mapping** nếu cần

#### Bước 3: Cấu hình Federation URL

- Tạo **Relying Party Trusts** cho các ứng dụng sử dụng SAML hoặc WS-Fed

- Cung cấp **Federation Metadata URL** cho các bên liên kết

#### Bước 4: Tích hợp MFA/TOTP:

- Cài đặt và cấu hình **Azure MFA Server** hoặc sử dụng **ADFS built-in MFA adapter**

- Cho phép xác thực bằng TOTP (Microsoft Authenticator, Google Authenticator).

- Cấu hình **Access Control Policies** để yêu cầu MFA theo điều kiện (ví dụ: truy cập từ ngoài mạng nội bộ).

#### Bước 5: Cấu hình WAP (Web Application Proxy)

- Cài đặt WAP để cho phép truy cập ADFS từ Internet.

- Cấu hình **Pre-authentication** và **pass-through** cho các ứng dụng.

---

### 🔄 4. Luồng xác thực mẫu

1. Người dùng truy cập ứng dụng → chuyển hướng đến ADFS

2. ADFS kiểm tra chính sách xác thực:

- Nếu nội bộ → yêu cầu Certificate Authentication

- Nếu bên ngoài → yêu cầu MFA (TOTP)

3. Sau khi xác thực thành công → trả về token SAML/WS-Fed cho ứng dụng

---

### ✅ 5. Lợi ích:

- Bảo mật cao: Kết hợp xác thực bằng certificate và MFA.

- Trải nghiệm người dùng tốt: SSO cho nhiều ứng dụng.

- Tích hợp linh hoạt: Hỗ trợ nhiều giao thức (SAML, WS-Fed, OAuth).

---

## 2. Phân tích các yêu tố bắt buộc của Giải pháp:

>> Các yếu tố kỹ thuật bắt buộc phải dùng Microsoft ADFS 2019 là gì ? và phần cấu hình tích hợp với MS Power BI Report Server vì sao phải dùng MS ADFS 2019 ?

---

### ✅ **I. Các yếu tố kỹ thuật bắt buộc phải dùng Microsoft ADFS 2019**

#### 1. **Tích hợp xác thực liên kết (Federation)**

- ADFS 2019 hỗ trợ các giao thức **SAML 2.0**, **WS-Federation**, và **OAuth 2.0/OpenID Connect**, là các giao thức phổ biến để tích hợp SSO với các ứng dụng bên ngoài.

- Nếu ứng dụng yêu cầu **Federation Metadata URL** hoặc **SAML Assertion**, thì ADFS là giải pháp Microsoft chính thức để cung cấp.

#### 2. **Hỗ trợ xác thực bằng Certificate (Client Certificate Authentication)**

- ADFS 2019 hỗ trợ xác thực bằng **Smartcard hoặc Certificate** ở tầng xác thực đầu tiên (Primary Authentication).

- Đây là yêu cầu bảo mật bắt buộc trong nhiều tổ chức chính phủ hoặc doanh nghiệp lớn.

#### 3. **Tích hợp MFA nội bộ**

- ADFS 2019 có thể tích hợp với **Azure MFA**, hoặc sử dụng **MFA Adapter** để triển khai TOTP (Time-based One-Time Password).

- Cho phép cấu hình chính sách xác thực linh hoạt: theo IP, nhóm người dùng, thiết bị, v.v.

#### 4. **Hỗ trợ Web Application Proxy (WAP)**

- Cho phép người dùng bên ngoài truy cập ADFS một cách an toàn thông qua reverse proxy.

#### 5. **Khả năng mở rộng và tích hợp với hệ sinh thái Microsoft**

- ADFS 2019 tích hợp tốt với các sản phẩm Microsoft như **Exchange, SharePoint, Power BI Report Server**, v.v.

---

### 📊 **II. Vì sao phải dùng ADFS 2019 để tích hợp với Power BI Report Server?**

#### 1. **Power BI Report Server không hỗ trợ Azure AD trực tiếp**

- Không giống Power BI Service (cloud), **Power BI Report Server (on-premises)** không hỗ trợ xác thực trực tiếp qua Azure AD hoặc các IdP hiện đại như Okta.

- Do đó, để triển khai **SSO hoặc MFA**, cần một giải pháp xác thực trung gian như **ADFS**.

#### 2. **ADFS hỗ trợ xác thực Windows và SAML**:

- Power BI Report Server sử dụng **Windows Authentication** hoặc **Forms Authentication**.

- ADFS có thể cung cấp **Forms-based Authentication** với MFA, hoặc **Windows Integrated Authentication** nếu truy cập nội bộ.

#### 3. **Tích hợp với Kerberos và Claims-based Authentication**

- ADFS có thể phát hành **Kerberos tickets** hoặc **SAML claims** cho Power BI Report Server, giúp duy trì quyền truy cập theo vai trò (role-based access).

#### 4. **Hỗ trợ truy cập từ xa an toàn**
- Khi triển khai qua **WAP + ADFS**, người dùng có thể truy cập Power BI Report Server từ Internet với MFA, mà không cần VPN.

---

## Logic Topology tích hợp ADFS với PBIRS:

![image](https://github.com/PhDLeToanThang/iamplatform/blob/main/Solution-1_ADFS2019/ADFS2019_PBIRS.drawio.svg)
