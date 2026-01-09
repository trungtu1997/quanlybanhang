-- 1. Kích hoạt tiện ích mã hóa (nếu chưa có)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. Hàm tự động mã hóa mật khẩu khi Thêm/Sửa nhân viên
CREATE OR REPLACE FUNCTION encrypt_password()
RETURNS TRIGGER AS $$
BEGIN
    -- Chỉ mã hóa nếu có mật khẩu và mật khẩu thay đổi
    IF NEW.password IS NOT NULL AND (TG_OP = 'INSERT' OR NEW.password <> OLD.password) THEN
        NEW.password := crypt(NEW.password, gen_salt('bf'));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Gắn hàm vào bảng users
DROP TRIGGER IF EXISTS trigger_encrypt_password ON users;
CREATE TRIGGER trigger_encrypt_password
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION encrypt_password();

-- 4. Hàm RPC Đăng nhập (Vue.js sẽ gọi hàm này)
CREATE OR REPLACE FUNCTION login_user(u_username TEXT, u_password TEXT)
RETURNS JSON AS $$
DECLARE
    found_user users%ROWTYPE;
BEGIN
    SELECT * INTO found_user FROM users WHERE username = u_username;
    
    IF found_user.id IS NOT NULL AND found_user.password = crypt(u_password, found_user.password) THEN
        -- Trả về thông tin user (loại bỏ password)
        RETURN json_build_object(
            'id', found_user.id,
            'username', found_user.username,
            'full_name', found_user.full_name,
            'role_id', found_user.role_id,
            'image_url', found_user.image_url,
            'success', true
        );
    ELSE
        RETURN json_build_object('success', false, 'message', 'Sai tài khoản hoặc mật khẩu');
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Tạo 1 User mẫu để test (Mật khẩu là: 123456)
-- Bạn cần có role trước
INSERT INTO roles (role_name, description) VALUES ('Admin', 'Quản trị viên hệ thống');

-- Tạo user admin (Trigger sẽ tự mã hóa 123456 thành chuỗi bảo mật)
INSERT INTO users (username, password, full_name, role_id) 
VALUES ('admin', '123456', 'Quản Trị Viên', (SELECT id FROM roles WHERE role_name = 'Admin' LIMIT 1));

-- Cho phép cột supplier_id trong bảng products được để trống
ALTER TABLE products ALTER COLUMN supplier_id DROP NOT NULL;

-- Xóa ràng buộc khóa ngoại cũ
ALTER TABLE inventories 
DROP CONSTRAINT inventories_product_variant_id_fkey;

-- Thêm ràng buộc mới có tính năng "ON DELETE CASCADE" (Xóa cha chết con)
ALTER TABLE inventories 
ADD CONSTRAINT inventories_product_variant_id_fkey 
FOREIGN KEY (product_variant_id) 
REFERENCES product_variants (id) 
ON DELETE CASCADE;

-- 1. Xử lý bảng liên kết Thuộc Tính (Thường hay bị lỗi ở đây nhất)
ALTER TABLE variant_attribute_values
DROP CONSTRAINT IF EXISTS variant_attribute_values_product_variant_id_fkey;

ALTER TABLE variant_attribute_values
ADD CONSTRAINT variant_attribute_values_product_variant_id_fkey
FOREIGN KEY (product_variant_id)
REFERENCES product_variants(id)
ON DELETE CASCADE;

-- 2. Xử lý bảng Ảnh biến thể
ALTER TABLE product_variant_images
DROP CONSTRAINT IF EXISTS product_variant_images_product_variant_id_fkey;

ALTER TABLE product_variant_images
ADD CONSTRAINT product_variant_images_product_variant_id_fkey
FOREIGN KEY (product_variant_id)
REFERENCES product_variants(id)
ON DELETE CASCADE;