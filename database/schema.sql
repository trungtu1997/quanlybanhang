-- Schema Database (SQL) - Đã sửa lỗi thứ tự

-- PHẦN 1: CẤU HÌNH & PHÂN QUYỀN (SYSTEM & IAM)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Bảng Phân quyền (Roles)
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name TEXT NOT NULL UNIQUE,
    description TEXT,
    permissions JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Bảng Người dùng/Nhân viên (Users)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role_id UUID REFERENCES roles(id),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    birth_day DATE,
    image_url TEXT,
    address TEXT,
    cccd_id TEXT,
    mst TEXT,
    bhxh TEXT,
    bank_number TEXT,
    start_day DATE NOT NULL DEFAULT CURRENT_DATE,
    end_day DATE,
    is_active BOOLEAN DEFAULT TRUE,
    file_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 2: QUẢN LÝ ĐỐI TÁC (CRM & PARTNERS)

-- 3. Nhà cung cấp (Suppliers)
CREATE TABLE suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    contact_name TEXT,
    phone TEXT,
    email TEXT,
    address TEXT,
    tax_code TEXT,
    note TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Nhóm khách hàng (Customer Groups)
CREATE TABLE customer_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_name TEXT NOT NULL,
    default_discount NUMERIC(5,2) DEFAULT 0,
    description TEXT
);

-- 5. Khách hàng (Customers)
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE,
    email TEXT,
    address TEXT,
    birth_day DATE,
    gender TEXT,
    customer_group_id UUID REFERENCES customer_groups(id),
    source TEXT,
    loyalty_points INT DEFAULT 0,
    current_debt NUMERIC(15, 2) DEFAULT 0,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 3: QUẢN LÝ SẢN PHẨM (PIM)

-- 6. Thương hiệu (Brands)
CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE,
    logo_url TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Danh mục sản phẩm (Categories)
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID REFERENCES categories(id),
    name TEXT NOT NULL,
    slug TEXT UNIQUE,
    icon_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Sản phẩm cha (Products)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE,
    category_id UUID NOT NULL REFERENCES categories(id),
    brand_id UUID NOT NULL REFERENCES brands(id),
    supplier_id UUID NOT NULL REFERENCES suppliers(id),
    description TEXT,
    content TEXT,
    base_unit TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    is_for_sales BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. Biến thể sản phẩm (Product Variants)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    sku TEXT NOT NULL UNIQUE,
    barcode TEXT,
    variant_name TEXT NOT NULL,
    cost_price NUMERIC(15, 2) DEFAULT 0,
    retail_price NUMERIC(15, 2) DEFAULT 0,
    wholesale_price NUMERIC(15, 2) DEFAULT 0,
    weight NUMERIC(10, 2),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. Hình ảnh biến thể (Product Variant Images)
CREATE TABLE product_variant_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    is_thumbnail BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. Định nghĩa Tên thuộc tính (Attributes)
CREATE TABLE attributes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    code TEXT UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 12. Giá trị thuộc tính (Attribute Values)
CREATE TABLE attribute_values (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attribute_id UUID NOT NULL REFERENCES attributes(id) ON DELETE CASCADE,
    value TEXT NOT NULL,
    code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. Bảng liên kết Biến thể - Giá trị thuộc tính
CREATE TABLE variant_attribute_values (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   product_variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
   attribute_value_id UUID NOT NULL REFERENCES attribute_values(id) ON DELETE CASCADE,
   UNIQUE(product_variant_id, attribute_value_id)
);

-- PHẦN 4: KHO VẬN (INVENTORY & WAREHOUSE)

-- 14. Kho bãi (Warehouses)
CREATE TABLE warehouses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    manager_user_id UUID REFERENCES users(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 15. Tồn kho (Inventories)
CREATE TABLE inventories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    warehouse_id UUID REFERENCES warehouses(id),
    product_variant_id UUID REFERENCES product_variants(id),
    quantity_on_hand INT DEFAULT 0,
    quantity_reserved INT DEFAULT 0,
    quantity_available INT GENERATED ALWAYS AS (quantity_on_hand - quantity_reserved) STORED,
    bin_location TEXT,
    min_stock_level INT DEFAULT 10,
    UNIQUE(warehouse_id, product_variant_id)
);

-- 16. Lịch sử biến động kho (Inventory Transactions)
CREATE TABLE inventory_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    warehouse_id UUID REFERENCES warehouses(id),
    product_variant_id UUID REFERENCES product_variants(id),
    transaction_type TEXT NOT NULL,
    quantity_change INT NOT NULL,
    quantity_after INT NOT NULL,
    reference_code TEXT,
    note TEXT,
    created_by_user_id UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 5: MARKETING & KHUYẾN MÃI (ĐƯA LÊN TRƯỚC BÁN HÀNG)

-- 17. Chương trình khuyến mãi (Promotions) - ĐỔI STT
CREATE TABLE promotions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    type TEXT NOT NULL,
    value NUMERIC(15, 2) NOT NULL,
    max_discount_value NUMERIC(15, 2),
    min_order_value NUMERIC(15, 2) DEFAULT 0,
    quantity_limit INT,
    quantity_used INT DEFAULT 0,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 6: BÁN HÀNG & ĐƠN HÀNG (SALES & ORDERS)

-- 18. Kênh bán hàng (Sales Channels)
CREATE TABLE sales_channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_name TEXT NOT NULL,
    type TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- 19. Phương thức thanh toán (Payment Methods)
CREATE TABLE payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    is_active BOOLEAN DEFAULT TRUE
);

-- 20. Đơn hàng (Orders - Header)
-- BÂY GIỜ BẢNG NÀY ĐÃ CÓ THỂ GỌI ĐƯỢC BẢNG PROMOTIONS Ở TRÊN
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    customer_id UUID REFERENCES customers(id),
    sales_channel_id UUID REFERENCES sales_channels(id),
    seller_user_id UUID REFERENCES users(id),
    warehouse_id UUID REFERENCES warehouses(id),
    
    -- ĐÃ SỬA ĐƯỢC LỖI TẠI DÒNG NÀY
    promotion_id UUID REFERENCES promotions(id),
    
    total_line_items_price NUMERIC(15, 2) DEFAULT 0,
    total_discount NUMERIC(15, 2) DEFAULT 0,
    shipping_fee NUMERIC(15, 2) DEFAULT 0,
    marketplace_fee NUMERIC(15, 2) DEFAULT 0,
    packaging_fee NUMERIC(15, 2) DEFAULT 0,
    insurance_fee NUMERIC(15, 2) DEFAULT 0,
    platform_voucher_amount NUMERIC(15, 2) DEFAULT 0,
    tax_amount NUMERIC(15, 2) DEFAULT 0,
    final_amount NUMERIC(15, 2) DEFAULT 0,
    paid_amount NUMERIC(15, 2) DEFAULT 0,
    
    order_status TEXT DEFAULT 'pending',
    payment_status TEXT DEFAULT 'unpaid',
    delivery_status TEXT DEFAULT 'unshipped',
    shipping_address TEXT,
    shipping_note TEXT,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 21. Chi tiết đơn hàng (Order Items)
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_variant_id UUID REFERENCES product_variants(id),
    product_name TEXT NOT NULL,
    sku TEXT NOT NULL,
    quantity INT NOT NULL,
    price NUMERIC(15, 2) NOT NULL,
    discount NUMERIC(15, 2) DEFAULT 0,
    total_price NUMERIC(15, 2) GENERATED ALWAYS AS (quantity * price - discount) STORED
);

-- 22. Giao dịch thanh toán (Order Payment Transactions)
CREATE TABLE order_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id),
    payment_method_id UUID REFERENCES payment_methods(id),
    amount NUMERIC(15, 2) NOT NULL,
    reference_code TEXT,
    status TEXT DEFAULT 'success',
    created_by_user_id UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 7: MODULE QUẢN LÝ CHI PHÍ VẬN HÀNH (EXPENSES)

-- 23. Loại chi phí (Expense Categories)
CREATE TABLE expense_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 24. Khoản mục chi phí con (Expense Types)
CREATE TABLE expense_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES expense_categories(id),
    name TEXT NOT NULL,
    is_recurring BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 25. Phiếu chi (Expenses)
CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT UNIQUE,
    expense_type_id UUID REFERENCES expense_types(id),
    created_by_user_id UUID REFERENCES users(id),
    approved_by_user_id UUID REFERENCES users(id),
    amount NUMERIC(15, 2) NOT NULL,
    payment_method_id UUID REFERENCES payment_methods(id),
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    campaign_name TEXT,
    platform TEXT,
    description TEXT,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 8: MODULE LƯƠNG NHÂN VIÊN (PAYROLL)

-- 26. Kỳ lương (Payroll Periods)
CREATE TABLE payroll_periods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    start_date DATE,
    end_date DATE,
    status TEXT DEFAULT 'draft'
);

-- 27. Bảng lương chi tiết (Payroll Details)
CREATE TABLE payroll_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payroll_period_id UUID REFERENCES payroll_periods(id),
    user_id UUID REFERENCES users(id),
    base_salary NUMERIC(15, 2) DEFAULT 0,
    commission_salary NUMERIC(15, 2) DEFAULT 0,
    allowance NUMERIC(15, 2) DEFAULT 0,
    bonus NUMERIC(15, 2) DEFAULT 0,
    deduction NUMERIC(15, 2) DEFAULT 0,
    total_salary NUMERIC(15, 2) GENERATED ALWAYS AS (base_salary + commission_salary + allowance + bonus - deduction) STORED,
    is_paid BOOLEAN DEFAULT FALSE,
    note TEXT
);

-- PHẦN 9: MODULE NHẬP HÀNG (PURCHASE ORDERS)

-- 28. Phiếu đặt hàng nhập (Purchase Orders)
CREATE TABLE purchase_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    supplier_id UUID NOT NULL REFERENCES suppliers(id),
    warehouse_id UUID NOT NULL REFERENCES warehouses(id),
    creator_user_id UUID REFERENCES users(id),
    total_quantity INT DEFAULT 0,
    total_amount NUMERIC(15, 2) DEFAULT 0,
    discount_amount NUMERIC(15, 2) DEFAULT 0,
    tax_amount NUMERIC(15, 2) DEFAULT 0,
    final_amount NUMERIC(15, 2) DEFAULT 0,
    paid_amount NUMERIC(15, 2) DEFAULT 0,
    status TEXT DEFAULT 'draft',
    payment_status TEXT DEFAULT 'unpaid',
    expected_delivery_date DATE,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 29. Chi tiết hàng nhập (Purchase Order Items)
CREATE TABLE purchase_order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_order_id UUID REFERENCES purchase_orders(id) ON DELETE CASCADE,
    product_variant_id UUID REFERENCES product_variants(id),
    quantity_ordered INT NOT NULL,
    quantity_received INT DEFAULT 0,
    import_price NUMERIC(15, 2) NOT NULL,
    total_price NUMERIC(15, 2) GENERATED ALWAYS AS (quantity_ordered * import_price) STORED
);

-- 30. Lịch sử chi trả nhà cung cấp (Purchase Payments)
CREATE TABLE purchase_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    purchase_order_id UUID REFERENCES purchase_orders(id),
    payment_method_id UUID REFERENCES payment_methods(id),
    amount NUMERIC(15, 2) NOT NULL,
    reference_code TEXT,
    note TEXT,
    created_by_user_id UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 10: MODULE ĐỔI TRẢ HÀNG (RETURNS / RMA)

-- 31. Phiếu trả hàng (Return Orders)
CREATE TABLE return_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    order_id UUID REFERENCES orders(id),
    customer_id UUID REFERENCES customers(id),
    warehouse_id UUID REFERENCES warehouses(id),
    refund_amount NUMERIC(15, 2) DEFAULT 0,
    refund_status TEXT DEFAULT 'pending',
    reason TEXT,
    status TEXT DEFAULT 'received',
    created_by_user_id UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 32. Chi tiết hàng trả (Return Items)
CREATE TABLE return_order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    return_order_id UUID REFERENCES return_orders(id) ON DELETE CASCADE,
    product_variant_id UUID REFERENCES product_variants(id),
    quantity INT NOT NULL,
    condition TEXT DEFAULT 'good',
    refund_price NUMERIC(15, 2) DEFAULT 0
);

-- PHẦN 11: MODULE GIAO VẬN (SHIPMENTS)

-- 33. Phiếu giao hàng (Shipments)
CREATE TABLE shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id),
    carrier_name TEXT,
    tracking_code TEXT,
    shipping_fee_paid_to_carrier NUMERIC(15, 2) DEFAULT 0,
    status TEXT DEFAULT 'ready_to_pick',
    cod_amount NUMERIC(15, 2) DEFAULT 0,
    pick_up_time TIMESTAMPTZ,
    delivered_time TIMESTAMPTZ,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PHẦN 12: MODULE CẤU HÌNH & LOG (SYSTEM & LOGS)

-- 34. Nhật ký hoạt động (Audit Logs)
CREATE TABLE system_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action TEXT NOT NULL,
    table_name TEXT,
    record_id UUID,
    old_value JSONB,
    new_value JSONB,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 35. Cấu hình hệ thống (System Settings)
CREATE TABLE system_settings (
    key_name TEXT PRIMARY KEY,
    value TEXT,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);