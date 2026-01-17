<template>
  <div class="products-page">
    <div class="nav-tabs-container">
        <div class="nav-tabs-wrapper">
            <button 
                class="nav-tab-btn" 
                :class="{ active: currentTab === 'products' }"
                @click="currentTab = 'products'"
            >
                Sản phẩm
            </button>
            <button 
                class="nav-tab-btn" 
                :class="{ active: currentTab === 'categories' }"
                @click="currentTab = 'categories'"
            >
                Danh mục
            </button>
            <button 
                class="nav-tab-btn" 
                :class="{ active: currentTab === 'brands' }"
                @click="currentTab = 'brands'"
            >
                Thương hiệu
            </button>
        </div>
    </div>
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">{{ pageTitle }}</h1> <ul class="breadcrumb">
          <li>Thêm, xóa, cập nhật và xuất file Excel dữ liệu</li>
        </ul>
      </div>
      
      <div class="header-actions">
        <button v-if="currentTab === 'products'" @click="openForm()" class="btn btn-black">
          <span class="icon">+</span> Thêm sản phẩm
        </button>
        <button class="btn btn-white" v-if="currentTab === 'products'" @click="exportToExcel">
           <span class="icon" style="margin-right: 8px; display: flex; align-items: center;">
             <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#107c41" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><line x1="10" y1="9" x2="8" y2="9"></line></svg>
           </span>
           Xuất Excel
        </button>
      </div>
    </div>

    <div v-if="currentTab === 'products'">
      <div class="hero-stats-banner">
    
    <div class="hero-left">
        <div class="hero-user-info">
            <div class="hero-avatar">
                <div class="stat-icon-wrapper mono">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                </div>
            </div>
            <div class="hero-text-group">
                <span class="text-label">Số sản phẩm</span>
                <h1 class="hero-big-number">
                    {{ products.filter(p => p.status === 'active').length }}
                </h1>
                <p class="hero-sub-text">
                    <span class="highlight-green">Đang bán</span> • Có trong kho
                </p>
            </div>
        </div>
    </div>

    <div class="hero-right">
                <div class="stats-list">
                    <div class="stat-row">
                        <span class="s-label">Còn hàng</span>
                        <span class="s-value">{{ inStockCount }}</span>
                    </div>
                    <div class="stat-row">
                        <span class="s-label">Hết hàng</span>
                        <span class="s-value red">{{ outOfStockCount }}</span>
                    </div>
                    <div class="stat-row">
                        <span class="s-label">Danh mục</span>
                        <span class="s-value">{{ categories.length }}</span>
                    </div>
                    <div class="stat-row">
                        <span class="s-label">Thương hiệu</span>
                        <span class="s-value">{{ brands.length }}</span>
                    </div>
                </div>

                <div class="ai-widget">
                    <div class="ai-ring-container">
                        <div class="ai-ring-light"></div>
                        <div class="ai-ring-blur"></div>
                        <div class="ai-content">
                            <span class="ai-label">TOTAL<br>PRODUCT</span>
                            <span class="ai-number">{{ products.length }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="filter-bar">
          <div class="search-wrapper">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <input 
              v-model="searchQuery" 
              placeholder="Tìm kiếm theo tên, SKU..." 
              class="search-input" 
            />
          </div>
          <div class="filter-actions">
            <select class="filter-select" v-model="filterCategory">
              <option value="">Tất cả danh mục</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
            <select class="filter-select" v-model="filterStatus">
              <option value="">Tất cả trạng thái</option>
              <option value="active">Đang bán</option>
              <option value="draft">Bản nháp (Chưa bán)</option>
              <option value="inactive">Ngừng bán</option>
            </select>
          </div>
        </div>

        <div class="table-card">
          <table class="product-table">
            <thead>
              <tr>
                <th>SKU</th>
                <th>SẢN PHẨM</th>
                <th>DANH MỤC</th>
                <th>ĐƠN VỊ</th>
                <th>TỒN KHO</th>
                <th v-if="role === 'admin'">GIÁ NHẬP</th>
                <th>GIÁ BÁN</th> 
                <th class="text-right">HÀNH ĐỘNG</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="paginatedProducts.length === 0">
                <td colspan="9" class="text-center empty-state">Không tìm thấy sản phẩm nào</td>
              </tr>
              <tr v-for="product in paginatedProducts" :key="product.id">
                <td>
                    <span class="sku-tag">{{ getProductSKU(product) }}</span>
                </td>
                <td>
                  <div class="product-info-cell">
                    <div class="product-avatar">
                      <img 
                        v-if="getProductImage(product)" 
                        :src="getProductImage(product)" 
                        alt="Product image" 
                        class="product-img"
                        @error="handleImageError(product)"
                      />
                      <div v-else class="mono-avatar">
                        {{ product.name ? product.name.charAt(0).toUpperCase() : 'P' }}
                      </div>
                    </div>
                    <div class="product-details">
                        <span class="product-name-text">{{ product.name }}</span>
                        <span class="variant-count-text" v-if="product.product_variants && product.product_variants.length > 0">
                            {{ product.product_variants.length }} biến thể
                        </span>
                    </div>
                  </div>
                </td>
                <td>
                    <span class="category-tag">{{ getCategoryName(product.category_id) }}</span>
                </td>
                <td>{{ product.base_unit }}</td>
                <td>
                  <span class="stock-badge" :class="getStockClass(product.total_stock)">
                    {{ product.total_stock || 0 }}
                  </span>
                </td>
                <td v-if="role === 'admin'">{{ getCostPriceRange(product) }}</td>
                <td class="font-bold">
                    {{ getPriceRange(product) }}
                </td>
                <td class="actions text-right">
                  <div class="action-buttons">
                  <button class="action-btn view" @click="openViewModal(product)" title="Xem chi tiết">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                  </button>
                  <button class="action-btn edit" @click="openForm(product)" title="Chỉnh sửa">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                  </button>
                  <button v-if="role === 'admin'" class="action-btn delete" @click="deleteProduct(product.id)" title="Xóa">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                  </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="pagination-wrapper">
          <div class="pagination-info">
            Hiển thị <strong>{{ (currentPage - 1) * pageSize + 1 }}</strong> - <strong>{{ Math.min(currentPage * pageSize, filteredProducts.length) }}</strong> của <strong>{{ filteredProducts.length }}</strong> sản phẩm
          </div>
          <div class="pagination-controls">
            <button @click="currentPage--" :disabled="currentPage === 1" class="btn-page-nav">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"></polyline></svg>
            </button>
            <div class="page-numbers">
               <button class="page-number active">{{ currentPage }}</button>
            </div>
            <button @click="currentPage++" :disabled="currentPage === totalPages" class="btn-page-nav">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
            </button>
          </div>
        </div>
    </div>

    <div v-if="currentTab === 'categories'">
        <div class="table-card">
            <table class="product-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên danh mục</th>
                        <th>Số lượng SP</th> <th class="text-right">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="categories.length === 0">
                        <td colspan="4" class="text-center empty-state">Chưa có danh mục nào</td>
                    </tr>
                    <tr v-for="cat in categories" :key="cat.id">
                        <td><span class="sku-tag">{{ cat.id.slice(0, 8) }}...</span></td>
                        <td class="font-bold">{{ cat.name }}</td>
                        <td>-</td> <td class="actions text-right">
                             <button class="action-btn edit" title="Chỉnh sửa"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                             <button class="action-btn delete" title="Xóa"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div v-if="currentTab === 'brands'">
        <div class="table-card">
            <table class="product-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên thương hiệu</th>
                        <th class="text-right">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="brands.length === 0">
                        <td colspan="3" class="text-center empty-state">Chưa có thương hiệu nào</td>
                    </tr>
                    <tr v-for="brand in brands" :key="brand.id">
                        <td><span class="sku-tag">{{ brand.id.slice(0, 8) }}...</span></td>
                        <td class="font-bold">{{ brand.name }}</td>
                        <td class="actions text-right">
                             <button class="action-btn edit" title="Chỉnh sửa"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg></button>
                             <button class="action-btn delete" title="Xóa"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div v-if="showForm" class="modal-overlay" @click.self="showForm = false">
      <div class="modal-card">
        <div class="modal-header">
           <h2>{{ editingProduct ? 'Cập Nhật Sản Phẩm' : 'Thêm Sản Phẩm Mới' }}</h2>
           <button class="btn-close-modal" @click="showForm = false">&times;</button>
        </div>
        
        <form @submit.prevent="saveProduct" class="product-form">
          <div class="form-scrollable-content">
              <div class="form-section-title">Thông tin chung</div>
              <div class="form-grid">
                <div class="form-group">
                  <label>Tên sản phẩm <span class="required">*</span></label>
                  <input 
                      v-model="form.name" 
                      @input="updateAllVariantNames" 
                      required 
                      class="form-input" 
                      placeholder="Nhập tên sản phẩm..." 
                  />
                </div>
                <div class="form-group">
                  <label>Slug (URL) <span class="required">*</span></label>
                  <input v-model="form.slug" required class="form-input" placeholder="ten-san-pham" />
                </div>
                <div class="form-group">
                  <label>Danh mục <span class="required">*</span></label>
                  <select v-model="form.category_id" required class="form-select">
                    <option value="">-- Chọn danh mục --</option>
                    <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Thương hiệu <span class="required">*</span></label>
                  <select v-model="form.brand_id" required class="form-select">
                    <option value="">-- Chọn thương hiệu --</option>
                    <option v-for="brand in brands" :key="brand.id" :value="brand.id">{{ brand.name }}</option>
                  </select>
                </div>
                <div class="form-group">
                    <label>Nhà cung cấp</label>
                    <select v-model="form.supplier_id" class="form-select">
                        <option value="">-- Không chọn --</option>
                        <option v-for="sup in suppliers" :key="sup.id" :value="sup.id">
                        {{ sup.name }}
                        </option>
                    </select>
                </div>
                <div class="form-group">
                  <label>Kho nhập hàng <span class="required">*</span></label>
                  <select v-model="form.warehouse_id" required class="form-select">
                    <option value="" disabled>-- Chọn kho lưu trữ --</option>
                    <option v-for="wh in warehouses" :key="wh.id" :value="wh.id">
                      {{ wh.name }}
                    </option>
                  </select>
                </div>
                <div class="form-group full-width">
                  <label>Mô tả ngắn</label>
                  <textarea v-model="form.description" class="form-textarea" rows="2" placeholder="Mô tả sơ lược..."></textarea>
                </div>
                <div class="form-group full-width">
                  <label>Nội dung chi tiết</label>
                  <textarea v-model="form.content" class="form-textarea" rows="4"></textarea>
                </div>
                <div class="form-group">
                  <label>Đơn vị tính</label>
                  <input v-model="form.base_unit" required class="form-input" placeholder="Cái, Hộp..." />
                </div>
                <div class="form-group">
                  <label>Trạng thái</label>
                  <select v-model="form.status" class="form-select">
                    <option value="draft">Bản nháp (Chưa bán)</option>
                    <option value="active">Đang bán</option>
                    <option value="inactive">Ngừng bán</option>
                  </select>
                </div>
              </div>

              <div class="variants-section">
                <div class="section-header">
                    <div class="section-title-group">
                        <div class="form-section-title">Biến Thể & Giá</div>
                        <p class="section-desc">Quản lý SKU, giá và thuộc tính (Màu, Size) cho từng biến thể</p>
                    </div>
                    <button type="button" @click="addVariant" class="btn-add-variant">
                        <span>+</span> Thêm biến thể
                    </button>
                </div>
                
                <div v-if="form.variants.length === 0" class="empty-variants">
                    Chưa có biến thể nào. Hãy thêm biến thể để thiết lập giá và tồn kho.
                </div>

                <div v-for="(variant, index) in form.variants" :key="index" class="variant-card">
                   <div class="variant-header">
                        <h5 class="variant-title">Biến thể #{{ index + 1 }}</h5>
                        <button type="button" @click="removeVariant(index)" class="btn-remove-variant">Xóa</button>
                   </div>
                   
                   <div class="variant-grid">
                      <div class="input-group">
                        <label>Mã SKU <span class="required">*</span></label>
                        <input v-model="variant.sku" required class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Mã vạch (Barcode)</label>
                        <input v-model="variant.barcode" placeholder="Quét mã..." class="form-input" />
                      </div>

                      <div class="input-group">
                        <label>Cân nặng (gram)</label>
                        <input v-model.number="variant.weight" type="number" placeholder="0" class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Tên biến thể (Tự động)</label>
                        <input v-model="variant.variant_name" placeholder="VD: 15.6 inch + Màu: Đỏ" class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Tồn kho</label>
                        <input v-model.number="variant.stock" type="number" class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Giá bán lẻ</label>
                        <input v-model.number="variant.retail_price" type="number" class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Giá vốn</label>
                        <input v-model.number="variant.cost_price" type="number" class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Giá sỉ</label>
                        <input v-model.number="variant.wholesale_price" type="number" class="form-input" />
                      </div>
                      <div class="input-group full-width">
                        <label>Ảnh URL</label>
                        <input v-model="variant.image_url" placeholder="Link ảnh..." class="form-input" />
                      </div>
                      <div class="input-group">
                        <label>Vị trí kho (Bin)</label>
                        <input v-model="variant.storage_location" placeholder="Kệ A-01..." class="form-input" />
                      </div>
                   </div>
                   
                   <div class="attributes-container">
                      <label class="attr-label">Thuộc tính (Gõ "Màu" để chọn màu):</label>
                      <div class="attr-list">
                          <div v-for="(attr, attrIndex) in variant.attributes" :key="attrIndex" class="attr-row">
                            
                            <input 
                                v-model="attr.attribute_name" 
                                @input="checkIsColor(attr)"
                                placeholder="Tên (VD: Màu)" 
                                class="form-input small attr-name" 
                            />
                            
                            <div class="value-wrapper">
                                <template v-if="attr.is_color">
                                    <div class="color-input-group">
                                        <input 
                                            v-model="attr.attribute_value" 
                                            @input="updateVariantName(index)"
                                            placeholder="Tên màu" 
                                            class="form-input small color-name-input"
                                        />
                                        <input 
                                            type="color" 
                                            v-model="attr.color_hex" 
                                            @input="updateVariantName(index)"
                                            class="color-picker-input"
                                        />
                                    </div>
                                </template>
                                <template v-else>
                                    <input 
                                        v-model="attr.attribute_value" 
                                        @input="updateVariantName(index)"
                                        placeholder="Giá trị (VD: XL)" 
                                        class="form-input small" 
                                    />
                                </template>
                            </div>

                            <button type="button" @click="removeAttribute(index, attrIndex)" class="btn-remove-attr" title="Xóa thuộc tính">
                                &times;
                            </button>
                          </div>
                          <button type="button" @click="addAttribute(index)" class="btn-small-dashed">+ Thêm TT</button>
                      </div>
                   </div>
                </div>
              </div>
          </div>

          <div class="form-footer">
            <button type="button" @click="showForm = false" class="btn-cancel">Hủy bỏ</button>
            <button type="submit" class="btn-save" :disabled="isSaving" :style="{ opacity: isSaving ? 0.7 : 1 }">
                <span v-if="isSaving">Đang xử lý...</span>
                <span v-else>Lưu Sản Phẩm</span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showViewModal" class="modal-overlay" @click.self="showViewModal = false">
      <div class="view-modal-card" @click.stop>
         <button class="btn-close-view" @click="showViewModal = false">×</button>
         <div class="view-body-grid">
           
           <div class="view-gallery">
               <div class="main-image-wrapper">
                    <img 
                        v-if="currentMainImage" 
                        :src="currentMainImage" 
                        class="view-main-img"
                    >

                    <div v-else class="no-image-state">
                        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                            <circle cx="8.5" cy="8.5" r="1.5"></circle>
                            <polyline points="21 15 16 10 5 21"></polyline>
                        </svg>
                        <p>Sản phẩm này chưa có hình,<br>vui lòng bổ sung thêm.</p>
                    </div>
                </div>
               <div class="thumb-list">
                   <div v-for="(img, idx) in allImages" :key="idx" 
                        class="thumb-item" 
                        :class="{ active: currentMainImage === img }"
                        @click="setActiveImage(img)">
                       <img :src="img" />
                   </div>
               </div>
           </div>

            <div class="view-info">
              <div class="view-breadcrumbs">
                  <span>{{ getCategoryName(viewingProduct.category_id) }}</span> 
                  <span v-if="viewingProduct.brand_id"> / {{ getBrandName(viewingProduct.brand_id) }}</span>
              </div>

              <h1 class="view-product-title">
                  {{ viewingProduct.name }}
                  <span class="title-separator">•</span>
                  <span class="status-text" :class="viewingProduct.status">
                      {{ getStatusLabel(viewingProduct.status) }}
                  </span>
              </h1>

              <div class="view-price-large">
                  {{ formatPrice(selectedVariantPrice || getMinPrice(viewingProduct)) }}
                  <span class="unit-badge">/ {{ viewingProduct.base_unit || 'Cái' }}</span>
              </div>

              <div class="view-meta-grid">
                  <div class="meta-row">
                      <span class="label">SKU: </span>
                      <span class="value" >{{ selectedVariantSKU || viewingProduct.product_variants?.[0]?.sku || '---' }}</span>
                  </div>
                  <div class="meta-row">
                      <span class="label">Barcode: </span>
                      <span class="value">{{ selectedVariant.barcode || '---' }}</span>
                  </div>
                  <div class="meta-row">
                      <span class="label">Tình trạng: </span>
                      <span class="status-badge" :style="{ color: selectedVariantStock > 0 ? '#166534' : '#991b1b', background: selectedVariantStock > 0 ? '#dcfce7' : '#fee2e2', padding: '4px 8px', borderRadius: '99px', fontSize: '12px', fontWeight: 'bold' }">
                          {{ selectedVariantStock > 0 ? `Còn hàng (${selectedVariantStock})` : 'Hết hàng' }}
                      </span>
                  </div>
                  <div class="meta-row">
                      <span class="label">Nhà cung cấp: </span>
                      <span class="value">{{ viewingProduct.suppliers?.name || '---' }}</span>
                  </div>
              </div>

              <div class="variant-details-box" v-if="selectedVariantIndex !== -1">
                  <span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 512 512" fill="currentColor">
                      <path d="M104 96H56c-13.3 0-24 10.7-24 24v104H8c-4.4 0-8 3.6-8 8v48c0 4.4 3.6 8 8 8h24v104c0 13.3 10.7 24 24 24h48c13.3 0 24-10.7 24-24V120c0-13.3-10.7-24-24-24zm352 0h-48c-13.3 0-24 10.7-24 24v272c0 13.3 10.7 24 24 24h48c13.3 0 24-10.7 24-24V120c0-13.3-10.7-24-24-24zM160 232h192v48H160z"/>
                    </svg> Cân nặng: <strong>{{ selectedVariant.weight || 0 }} gr</strong>
                  </span>
                  <span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/>
                      <path d="m3.3 7 8.7 5 8.7-5"/>
                      <path d="M12 22V12"/>
                    </svg> Kho: <strong>{{ getWarehouseName(selectedVariant) }}</strong>
                  </span>
                  <span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon-svg">
                      <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"></path>
                      <circle cx="12" cy="10" r="3"></circle>
                    </svg> Vị trí: <strong>{{ getBinLocation(selectedVariant) }}</strong>
                  </span>
              </div>

              <div class="view-description">
                  {{ viewingProduct.description || 'Chưa có mô tả ngắn.' }}
              </div>

              <div class="view-content-section" v-if="viewingProduct.content">
                  <h3 class="content-heading">Thông tin chi tiết</h3>
                  <div class="content-body">
                      {{ viewingProduct.content }}
                  </div>
              </div>

              <div class="view-pricing-table" v-if="role === 'admin' && selectedVariantIndex !== -1">
                  <div class="pricing-col">
                      <span class="lbl">Giá nhập (Vốn)</span>
                      <span class="val text-red">{{ formatPrice(selectedVariant.cost_price) }}</span>
                  </div>
                  <div class="pricing-col">
                      <span class="lbl">Giá bán sỉ</span>
                      <span class="val text-blue">{{ formatPrice(selectedVariant.wholesale_price) }}</span>
                  </div>
                  <div class="pricing-col">
                      <span class="lbl">Giá bán lẻ</span>
                      <span class="val">{{ formatPrice(selectedVariant.retail_price) }}</span>
                  </div>
              </div>

              <div class="view-variants-selector" v-if="viewingVariants.length > 0">
                  <div class="selector-group">
                      <span class="selector-label">Chọn biến thể:</span>
                      <div class="size-boxes">
                          <button v-for="(v, idx) in viewingVariants" :key="idx"
                              class="size-box" 
                              :class="{ selected: selectedVariantIndex === idx }"
                              @click="selectVariant(idx)">
                              {{ v.variant_name }}
                          </button>
                      </div>
                  </div>
              </div>
            </div>
         </div>
      </div>
    </div>

  </div>
</template>

<script>
import { supabase } from '../supabase'
import Swal from 'sweetalert2'
import * as XLSX from 'xlsx'

export default {
  data() {
    return {
      isSaving: false, // <--- Thêm dòng này vào đầu object data
      currentTab: 'products',

      // Data Arrays
      products: [],
      categories: [],
      brands: [],
      suppliers: [],
      warehouses: [], // <--- THÊM MẢNG KHO
      
      // Filter & Pagination
      searchQuery: '',
      filterCategory: '',
      filterStatus: '',
      currentPage: 1,
      pageSize: 10,
      
      // Form State
      showForm: false,
      editingProduct: null,
      form: {
        name: '', slug: '', category_id: '', brand_id: '', supplier_id: '',
        warehouse_id: '', // <--- THÊM BIẾN CHỌN KHO
        description: '', content: '', base_unit: '', status: 'active',
        is_for_sales: true, variants: []
      },
      
      // View State
      showViewModal: false,
      viewingProduct: {},
      viewingVariants: [],
      selectedVariantIndex: -1,
      activeImage: '',
      
      // System
      role: 'admin' 
    }
  },
  
  async mounted() {
    await Promise.all([
      this.loadProducts(),
      this.loadCategories(),
      this.loadBrands(),
      this.loadSuppliers(),
      this.loadWarehouses() // <--- LOAD KHO KHI CHẠY
    ])
  },

  computed: {
    pageTitle() {
        switch (this.currentTab) {
            case 'products': return 'Sản Phẩm';
            case 'categories': return 'Danh Mục';
            case 'brands': return 'Thương Hiệu';
            default: return 'Sản Phẩm';
        }
    },
    // --- FILTER & PAGINATION ---
    filteredProducts() {
      return this.products.filter(p => {
        const query = this.searchQuery.toLowerCase();
        const matchesSearch = 
            (p.name && p.name.toLowerCase().includes(query)) || 
            (p.slug && p.slug.toLowerCase().includes(query)) ||
            (p.product_variants && p.product_variants.some(v => v.sku && v.sku.toLowerCase().includes(query)));
        
        const matchesCategory = !this.filterCategory || p.category_id === this.filterCategory;
        const matchesStatus = !this.filterStatus || p.status === this.filterStatus;
        
        return matchesSearch && matchesCategory && matchesStatus;
      })
    },
    
    paginatedProducts() {
      const start = (this.currentPage - 1) * this.pageSize;
      return this.filteredProducts.slice(start, start + this.pageSize);
    },
    totalPages() { return Math.ceil(this.filteredProducts.length / this.pageSize) || 1; },

    // --- VIEW MODAL LOGIC ---
    selectedVariant() {
        if (this.selectedVariantIndex !== -1 && this.viewingVariants[this.selectedVariantIndex]) 
            return this.viewingVariants[this.selectedVariantIndex];
        return {};
    },
    
    currentMainImage() {
        if (this.activeImage) return this.activeImage;
        if (this.selectedVariantIndex !== -1) {
            const v = this.viewingVariants[this.selectedVariantIndex];
            if (v.images && v.images.length > 0) return v.images[0].image_url;
        }
        if (this.viewingVariants.length > 0 && this.viewingVariants[0].images?.length > 0) {
             return this.viewingVariants[0].images[0].image_url;
        }
        return null; // Trả về null để biết là không có ảnh
    },

    allImages() {
        const imgs = [];
        this.viewingVariants.forEach(v => { 
            if(v.images && Array.isArray(v.images)) {
                v.images.forEach(img => imgs.push(img.image_url));
            }
        });
        return [...new Set(imgs)]; 
    },

    // Stats
    inStockCount() { return this.products.filter(p => p.total_stock > 0).length; },
    outOfStockCount() { return this.products.filter(p => p.total_stock === 0).length; },

    // View Modal Computed Props
    selectedVariantPrice() {
        if (this.selectedVariantIndex !== -1) return this.viewingVariants[this.selectedVariantIndex].retail_price;
        return 0;
    },
    selectedVariantStock() {
        // Nếu đang chọn một biến thể
        if (this.selectedVariantIndex !== -1 && this.viewingVariants[this.selectedVariantIndex]) {
            return this.viewingVariants[this.selectedVariantIndex].stock; // Trả về số stock đã tính ở trên
        }
        // Nếu không chọn biến thể nào (hoặc sản phẩm đơn), trả về tổng tồn kho của sản phẩm cha
        return this.viewingProduct.total_stock || 0;
    },
    selectedVariantSKU() {
        if (this.selectedVariantIndex !== -1) return this.viewingVariants[this.selectedVariantIndex].sku;
        return '';
    }
  },

  methods: {
    // ============================================================
    // 1. LOAD DATA 
    // ============================================================
    async loadWarehouses() {
        const { data } = await supabase.from('warehouses').select('id, name').eq('is_active', true);
        this.warehouses = data || [];
    },

    getStatusLabel(status) {
        switch(status) {
            case 'active': return 'Đang bán';
            case 'inactive': return 'Ngừng bán';
            case 'draft': return 'Bản nháp';
            default: return '---';
        }
    },

    async loadProducts() {
      // Query lấy thêm inventories để tính tổng tồn kho
      const { data, error } = await supabase
        .from('products')
        .select(`
            *,
            suppliers (name), 
            product_variants (
                id, sku, barcode, variant_name, retail_price, cost_price, wholesale_price, weight,
                inventories (quantity_on_hand, bin_location, warehouses(name)), 
                product_variant_images ( image_url, is_thumbnail ),
                variant_attribute_values (
                    attribute_values ( value, attributes ( name ) )
                )
            )
        `)
        .order('created_at', { ascending: false });

      if (error) { console.error('Lỗi load:', error); return; }

      this.products = data.map(p => {
          let totalStock = 0;
          if (p.product_variants) {
              p.product_variants.forEach(v => {
                  // Cộng tổng tồn kho từ tất cả các kho
                  const q = v.inventories?.reduce((sum, inv) => sum + inv.quantity_on_hand, 0) || 0;
                  totalStock += q;
                  v.current_stock = q; 
              });
          }
          return { ...p, total_stock: totalStock };
      });
    },

    getProductImage(product) {
      if (!product.product_variants || product.product_variants.length === 0) return null;
      // 1. Tìm thumbnail
      for (const v of product.product_variants) {
          if (v.product_variant_images) {
              const thumb = v.product_variant_images.find(img => img.is_thumbnail);
              if (thumb) return thumb.image_url;
          }
      }
      // 2. Lấy ảnh đầu tiên
      for (const v of product.product_variants) {
          if (v.product_variant_images && v.product_variant_images.length > 0) {
              return v.product_variant_images[0].image_url;
          }
      }
      return null;
    },

    handleImageError(product) {
        // Fallback placeholder logic
    },

    // ============================================================
    // 2. OPEN FORM (MAPPING DỮ LIỆU KHI SỬA)
    // ============================================================
    async openForm(product = null) {
      this.editingProduct = product;
      
      if (product) {
        // --- LOGIC MAPPING DỮ LIỆU KHI SỬA ---
        // Query sâu để lấy tồn kho, vị trí, thuộc tính
        const { data: variants } = await supabase
            .from('product_variants')
            .select(`
                *, 
                product_variant_images(image_url), 
                inventories(warehouse_id, quantity_on_hand, bin_location),
                variant_attribute_values(attribute_values(value, attributes(name)))
            `)
            .eq('product_id', product.id);

        // Logic chọn kho mặc định để hiển thị trong form sửa:
        // Lấy kho từ biến thể đầu tiên có dữ liệu tồn kho, nếu không có lấy kho đầu tiên trong danh sách
        let defaultWhId = '';
        if (variants.length > 0 && variants[0].inventories.length > 0) {
            defaultWhId = variants[0].inventories[0].warehouse_id;
        } else if (this.warehouses.length > 0) {
            defaultWhId = this.warehouses[0].id;
        }

        this.form = { 
            ...product, 
            warehouse_id: defaultWhId, // Gán kho vào form
            variants: variants.map(v => {
                // Lấy thông tin tồn kho khớp với kho đang chọn (hoặc lấy cái đầu tiên tìm thấy)
                const inventory = v.inventories.find(i => i.warehouse_id === defaultWhId) || v.inventories[0] || {};

                return {
                    ...v,
                    // Map lại dữ liệu tồn kho & vị trí
                    stock: inventory.quantity_on_hand || 0,
                    storage_location: inventory.bin_location || '',
                    image_url: v.product_variant_images?.map(i => i.image_url).join(', ') || '',
                    // Map ảnh
                    
                    
                    // Map thuộc tính (Flatten từ cấu trúc lồng nhau của DB)
                    attributes: v.variant_attribute_values.map(vav => ({
                        attribute_name: vav.attribute_values.attributes.name,
                        attribute_value: vav.attribute_values.value,
                        is_color: ['màu', 'color'].some(k => vav.attribute_values.attributes.name.toLowerCase().includes(k)),
                        // Nếu có màu hex thì map vào đây
                        color_hex: '#000000' 
                    }))
                };
            })
        };
        this.showForm = true;
      } else {
        // --- LOGIC RESET FORM KHI THÊM MỚI ---
        this.form = {
          name: '', slug: '', category_id: '', brand_id: '', supplier_id: '',
          warehouse_id: this.warehouses.length > 0 ? this.warehouses[0].id : '', // Mặc định chọn kho đầu tiên
          description: '', content: '', base_unit: 'Cái', status: 'active', // Mặc định là đang bán
          variants: []
        };
        this.addVariant(); 
        this.showForm = true;
      }
    },

    // ============================================================
    // 3. SAVE PRODUCT (LOGIC LƯU VÀO KHO)
    // ============================================================
    async saveProduct() {
      // 1. Chặn click liên tục
      if (this.isSaving) return; 
      this.isSaving = true;

      try {
        // --- VALIDATION (Giữ nguyên) ---
        if (!this.form.name || !this.form.category_id || !this.form.brand_id) {
            this.isSaving = false; // Nhớ tắt loading nếu lỗi
            return Swal.fire('Lỗi', 'Vui lòng nhập đầy đủ: Tên, Danh mục và Thương hiệu!', 'error');
        }
        if (!this.form.warehouse_id) {
            this.isSaving = false;
            return Swal.fire('Lỗi', 'Vui lòng chọn Kho nhập hàng!', 'error');
        }

        // --- TẠO PAYLOAD SẢN PHẨM CHA ---
        const productPayload = {
            name: this.form.name,
            slug: this.form.slug || this.generateSlug(this.form.name),
            category_id: this.form.category_id,
            brand_id: this.form.brand_id, 
            supplier_id: this.form.supplier_id || null, 
            description: this.form.description,
            content: this.form.content,
            base_unit: this.form.base_unit,
            status: this.form.status, 
            is_for_sales: this.form.status === 'active'
        };

        // --- LƯU SẢN PHẨM CHA ---
        let productId;
        
        if (this.editingProduct) {
            const { error } = await supabase.from('products').update(productPayload).eq('id', this.editingProduct.id);
            if (error) throw error;
            productId = this.editingProduct.id;
        } else {
            const { data, error } = await supabase.from('products').insert(productPayload).select('id').single();
            if (error) throw error;
            productId = data.id;
        }

        // --- XÓA BIẾN THỂ CŨ ---
        const { error: deleteError } = await supabase.from('product_variants').delete().eq('product_id', productId);
        if (deleteError) {
            console.error("Lỗi xóa biến thể cũ:", deleteError);
            throw new Error("Không thể cập nhật biến thể do ràng buộc dữ liệu.");
        }

        // =========================================================
        // PHẦN TỐI ƯU TỐC ĐỘ CAO (Dùng Promise.all)
        // =========================================================
        if (this.form.variants.length > 0) {
            const variantPromises = this.form.variants.map(async (v) => {
                
                // A. TẠO BIẾN THỂ (Chạy song song OK)
                const { data: vData, error: vError } = await supabase.from('product_variants').insert({
                    product_id: productId,
                    sku: v.sku,
                    variant_name: v.variant_name,
                    retail_price: Number(v.retail_price) || 0,
                    cost_price: Number(v.cost_price) || 0,
                    wholesale_price: Number(v.wholesale_price) || 0,
                    weight: Number(v.weight) || 0,
                    barcode: v.barcode || null 
                }).select('id').single();
                
                if (vError) throw vError;
                const variantId = vData.id;

                // B. CÁC TÁC VỤ CON CỦA BIẾN THỂ
                const subTasks = [];

                // 1. Lưu Tồn kho
                subTasks.push(
                    supabase.from('inventories')
                    .upsert({
                        warehouse_id: this.form.warehouse_id,
                        product_variant_id: variantId,
                        quantity_on_hand: Number(v.stock) || 0,
                        bin_location: v.storage_location || null
                    }, { onConflict: 'warehouse_id, product_variant_id' })
                );

                // 2. Lưu Ảnh
                if (v.image_url) {
                    const urls = v.image_url.split(',').map(u => u.trim()).filter(u => u !== '');
                    if (urls.length > 0) {
                        const imagesInsert = urls.map((url, idx) => ({
                            product_variant_id: variantId,
                            image_url: url,
                            is_thumbnail: idx === 0,
                            sort_order: idx
                        }));
                        subTasks.push(supabase.from('product_variant_images').insert(imagesInsert));
                    }
                }

                // 3. Lưu Thuộc tính (Xử lý an toàn để tránh trùng lặp)
                if (v.attributes && v.attributes.length > 0) {
                    const attrTask = async () => {
                        for (const attr of v.attributes) {
                            if (!attr.attribute_name || !attr.attribute_value) continue;
                            
                            // Tìm hoặc Tạo Attribute (Màu, Size)
                            let attributeId;
                            const { data: existingAttr } = await supabase.from('attributes').select('id').ilike('name', attr.attribute_name.trim()).maybeSingle();
                            if (existingAttr) attributeId = existingAttr.id;
                            else {
                                const { data: newAttr } = await supabase.from('attributes').insert({ name: attr.attribute_name.trim() }).select('id').single();
                                attributeId = newAttr.id;
                            }

                            // Tìm hoặc Tạo Value (Đỏ, XL)
                            let valueId;
                            const { data: existingVal } = await supabase.from('attribute_values').select('id').eq('attribute_id', attributeId).ilike('value', attr.attribute_value.trim()).maybeSingle();
                            if (existingVal) valueId = existingVal.id;
                            else {
                                const { data: newVal } = await supabase.from('attribute_values').insert({ attribute_id: attributeId, value: attr.attribute_value.trim() }).select('id').single();
                                valueId = newVal.id;
                            }

                            // Link vào biến thể
                            await supabase.from('variant_attribute_values').insert({ product_variant_id: variantId, attribute_value_id: valueId });
                        }
                    };
                    subTasks.push(attrTask());
                }

                // Chờ các tác vụ con xong
                await Promise.all(subTasks);
            });

            // Chờ TẤT CẢ biến thể xong
            await Promise.all(variantPromises);
        }

        Swal.fire('Thành công', 'Lưu sản phẩm thành công!', 'success');
        this.showForm = false;
        this.loadProducts();

      } catch (err) {
        console.error("Lỗi Save:", err);
        Swal.fire('Lỗi', err.message || 'Có lỗi xảy ra', 'error');
      } finally {
        this.isSaving = false; // Mở lại nút bấm
      }
    },

    // --- UI HELPERS ---
    addVariant() {
      this.form.variants.push({
        sku: '', barcode: '', weight: 0, 
        storage_location: '', stock: 0, // Các biến mới
        variant_name: '', retail_price: 0, cost_price: 0, wholesale_price: 0,
        attributes: [], image_url: ''
      });
    },
    removeVariant(index) { this.form.variants.splice(index, 1); },
    addAttribute(vIndex) {
        if(!this.form.variants[vIndex].attributes) this.form.variants[vIndex].attributes = [];
        this.form.variants[vIndex].attributes.push({ attribute_name: '', attribute_value: '' });
    },
    removeAttribute(vIndex, aIndex) {
        this.form.variants[vIndex].attributes.splice(aIndex, 1);
        this.updateVariantName(vIndex);
    },
    updateVariantName(index) {
        const v = this.form.variants[index];
        const parts = [];

        // 1. Đưa tên sản phẩm vào trước (nếu có)
        if (this.form.name && this.form.name.trim() !== '') {
            parts.push(this.form.name.trim());
        }

        // 2. Đưa các thuộc tính vào sau
        if (v.attributes && v.attributes.length > 0) {
            // Lấy ra các giá trị thuộc tính (ví dụ: Đỏ, XL)
            const attrValues = v.attributes
                .map(a => a.attribute_value ? a.attribute_value.trim() : '')
                .filter(val => val !== ''); // Loại bỏ giá trị rỗng

            if (attrValues.length > 0) {
                // Nối các thuộc tính lại với nhau bằng dấu gạch ngang
                parts.push(attrValues.join(' - '));
            }
        }

        // 3. Ghép tất cả lại (Tên SP - Thuộc tính 1 - Thuộc tính 2)
        v.variant_name = parts.join(' - ');
    },
    // Hàm này sẽ chạy khi bạn gõ tên sản phẩm
    updateAllVariantNames() {
        // 1. Tự động tạo SLUG nếu đang nhập tên
        // Chỉ tự động tạo khi người dùng CHƯA tự nhập slug riêng (hoặc slug đang trống)
        // Hoặc bạn có thể cho nó luôn luôn tự động cập nhật theo tên
        if (this.form.name) {
            this.form.slug = this.generateSlug(this.form.name);
        }

        // 2. Cập nhật tên biến thể (Logic cũ giữ nguyên)
        if (this.form.variants && this.form.variants.length > 0) {
            this.form.variants.forEach((v, index) => {
                this.updateVariantName(index);
            });
        }
    },

    // --- VIEW MODAL ---
    openViewModal(product) {
        this.viewingProduct = product;
        this.selectedVariantIndex = -1;
        this.activeImage = '';

        // Kiểm tra xem sản phẩm có biến thể không
        if (product.product_variants && product.product_variants.length > 0) {
            
            // --- MAP DỮ LIỆU ĐỂ TÍNH TOÁN TỒN KHO CHÍNH XÁC ---
            this.viewingVariants = product.product_variants.map(v => {
                // 1. Tính tổng tồn kho từ tất cả các kho (inventories)
                // Lưu ý: Phải ép kiểu Number() để tránh lỗi cộng chuỗi
                const totalStock = v.inventories?.reduce((sum, inv) => sum + (Number(inv.quantity_on_hand) || 0), 0) || 0;

                return {
                    ...v,
                    stock: totalStock, // Gán giá trị đã tính vào biến stock
                    
                    // Lấy tên kho đầu tiên để hiển thị (nếu có)
                    warehouse_name: v.inventories?.[0]?.warehouses?.name || '---',
                    bin_location: v.inventories?.[0]?.bin_location || '---',
                    images: v.product_variant_images || []
                };
            });

            // --- QUAN TRỌNG: Tự động chọn biến thể đầu tiên ---
            // Điều này khiến modal hiển thị ngay thông tin chi tiết thay vì "tổng quan"
            this.selectVariant(0); 
            
        } else {
            // Trường hợp sản phẩm đơn (không có biến thể) hoặc lỗi data
            this.viewingVariants = [];
            this.selectedVariantIndex = -1;
        }
        
        this.showViewModal = true;
    },
    selectVariant(index) { this.selectedVariantIndex = index; this.activeImage = ''; },
    setActiveImage(img) { this.activeImage = img; },

    // --- UTILS & LOADER ---
    async loadCategories() {
        const { data } = await supabase.from('categories').select('id, name');
        this.categories = data || [];
    },
    async loadBrands() {
        const { data } = await supabase.from('brands').select('id, name');
        this.brands = data || [];
    },
    async loadSuppliers() {
        const { data } = await supabase.from('suppliers').select('id, name');
        this.suppliers = data || [];
    },
    async loadRole() { this.role = 'admin'; },
    
    async deleteProduct(id) {
        if(!confirm('Xóa sản phẩm?')) return;
        await supabase.from('products').delete().eq('id', id);
        this.loadProducts();
    },

    formatPrice(val) { return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0); },
    getCategoryName(id) { return this.categories.find(x => x.id === id)?.name || '---'; },
    getBrandName(id) { return this.brands.find(x => x.id === id)?.name || ''; },
    getDisplayPrice(p) { return this.formatPrice(p.product_variants?.[0]?.retail_price || 0); },
    getDisplayCostPrice(p) { return this.formatPrice(p.product_variants?.[0]?.cost_price || 0); },
    getProductSKU(p) { return p.product_variants?.[0]?.sku || '---'; },
    getStatusText(s) { return s === 'active' ? 'Đang bán' : 'Ngừng bán'; },
    getStockClass(s) { return s > 0 ? 'stock-badge in-stock' : 'stock-badge out-stock'; },
    checkIsColor(attr) { attr.is_color = attr.attribute_name.toLowerCase().includes('màu'); },
    generateSlug(str) {
      if (!str) return '';
      
      return str
        .toLowerCase() // 1. Chuyển thành chữ thường
        .normalize('NFD') // 2. Tách dấu ra khỏi ký tự (Ví dụ: ô -> o + dấu ^)
        .replace(/[\u0300-\u036f]/g, '') // 3. Xóa các ký tự dấu vừa tách
        .replace(/[đĐ]/g, 'd') // 4. Xử lý chữ đ/Đ riêng (vì nó không phải là dấu)
        .replace(/[^a-z0-9\s-]/g, '') // 5. Xóa hết các ký tự đặc biệt còn lại (giữ lại chữ, số, khoảng trắng, gạch ngang)
        .trim() // 6. Cắt khoảng trắng đầu cuối
        .replace(/\s+/g, '-') // 7. Thay khoảng trắng bằng dấu gạch ngang
        .replace(/-+/g, '-'); // 8. Xóa các dấu gạch ngang liên tiếp (ví dụ: -- thành -)
    },
    
    exportToExcel() {
        try {
            const sourceData = this.filteredProducts && this.filteredProducts.length > 0 ? this.filteredProducts : this.products;
            if (!sourceData || sourceData.length === 0) { Swal.fire('Thông báo', 'Không có dữ liệu!', 'warning'); return; }
            const dataToExport = [];
            sourceData.forEach(p => {
            const variants = p.product_variants || [];
            if (variants.length > 0) {
                variants.forEach(v => {
                dataToExport.push({
                    'ID': p.id, 'Tên': p.name, 'Danh Mục': this.getCategoryName(p.category_id),
                    'Biến Thể': v.variant_name, 'SKU': v.sku, 'Giá Bán': v.retail_price || 0,
                    'Tồn Kho': v.stock || 0
                });
                });
            } else {
                dataToExport.push({
                'ID': p.id, 'Tên': p.name, 'Danh Mục': this.getCategoryName(p.category_id),
                'Biến Thể': 'Đơn', 'SKU': p.sku || '', 'Giá Bán': '---', 'Tồn Kho': p.total_stock || 0
                });
            }
            });
            const ws = XLSX.utils.json_to_sheet(dataToExport);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, "SP");
            XLSX.writeFile(wb, `Export_SP.xlsx`);
            Swal.fire({ icon: 'success', title: 'Xuất file thành công!', toast: true, position: 'top-end', showConfirmButton: false, timer: 3000 });
        } catch (err) {
            console.error(err);
            Swal.fire('Lỗi', 'Không thể xuất file.', 'error');
        }
    },
    // Hiển thị khoảng giá Min - Max
    getPriceRange(product) {
        if (!product.product_variants || product.product_variants.length === 0) return '---';
        const prices = product.product_variants.map(v => v.retail_price);
        const min = Math.min(...prices);
        const max = Math.max(...prices);
        if (min === max) return this.formatPrice(min);
        return `${this.formatPrice(min)} - ${this.formatPrice(max)}`;
    },

    // Lấy giá thấp nhất
    getMinPrice(product) {
        if (!product.product_variants || product.product_variants.length === 0) return 0;
        return Math.min(...product.product_variants.map(v => v.retail_price));
    },

    // Lấy tên kho
    getWarehouseName(variant) {
        return variant.warehouse_name || '---';
    },

    // Lấy vị trí kệ
    getBinLocation(variant) {
        return variant.bin_location || '---';
    },

    // HÀM MỚI: Hiển thị khoảng Giá nhập (Cost Price)
    getCostPriceRange(product) {
        if (!product.product_variants || product.product_variants.length === 0) return '---';
        
        // Lấy danh sách giá vốn
        const prices = product.product_variants.map(v => v.cost_price || 0);
        const min = Math.min(...prices);
        const max = Math.max(...prices);
        
        if (min === max) return this.formatPrice(min);
        return `${this.formatPrice(min)} - ${this.formatPrice(max)}`;
    },
  }
}
</script>

<style scoped>
/* Reset & Global */
* { box-sizing: border-box; }
.products-page { padding: 32px 40px; max-width: 1300px; min-height: 100vh; color: #1f2937; margin: auto; border-radius: 10px; }
.products-page ::placeholder, .products-page select { font-family: 'Quicksand', sans-serif; }

/* HEADER */
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; flex-wrap: wrap; gap: 20px; }
.page-title { font-size: 28px; font-weight: 700; color: #111827; margin: 0; }
.breadcrumb { display: flex; list-style: none; padding: 0; margin: 0; color: #6b7280; font-size: 14px; }
.breadcrumb .separator { margin: 0 8px; color: #d1d5db; }
.breadcrumb .active { color: #374151; font-weight: 500; }
.header-actions { display: flex; gap: 12px; }

/* BUTTONS */
.btn { padding: 10px 20px; border-radius: 30px; font-weight: 600; font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; font-size: 14px; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s; white-space: nowrap; }
.btn-black { background: #000; color: #fff; border: 1px solid #000; }
.btn-black:hover { background: #333; border-color: #333; }
.btn-white { background: #fff; border: 1px solid #e5e7eb; color: #374151; }
.btn-white:hover { background: #f9fafb; border-color: #d1d5db; }
.icon { font-size: 16px; line-height: 1; }

/* NAVIGATION TABS (PILL STYLE) */
/* Container để canh lề nếu cần (tùy chọn) */
.nav-tabs-container {
  margin-bottom: 20px;
}

/* Khối bao bọc nền xám */
.nav-tabs-wrapper { 
  display: inline-flex; /* Để khung co giãn theo nội dung nút */
  gap: 4px; /* Khoảng cách nhỏ giữa các nút */
  padding: 3px; /* Padding để tạo khoảng hở viền */
  background: #e3e4e6; /* Nền xám nhạt bao ngoài */
  border-radius: 99px; /* Bo góc khung bao */
  border: 1px solid #dbdde0;
}

/* Style cho từng nút */
.nav-tab-btn {
    padding: 12px 20px;
    border-radius: 99px; /* Bo góc nút nhỏ hơn khung bao chút */
    border: none;
    font-weight: 500;
    font-size: 14px;
    cursor: pointer;
    background: transparent; /* Mặc định nền trong suốt */
    color: #6b7280; /* Chữ xám */
    transition: all 0.2s ease;
    font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
}

.nav-tab-btn:hover { 
    color: #111827; 
}

/* Khi nút được Active (Đen đậm, chữ trắng) */
.nav-tab-btn.active {
    background: #000000; 
    color: #ffffff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* FILTER BAR */
.filter-bar { display: flex; justify-content: space-between; margin-bottom: 24px; gap: 20px; flex-wrap: wrap; }
.search-wrapper { position: relative; flex: 1; min-width: 300px; }
.search-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); width: 18px; color: #9ca3af; }
.search-input { 
    width: 100%;
    padding: 17px 16px 17px 44px;
    background: #ffffff00;
    border-top: 0;
    border-left: 0;
    border-right: 0;
    border-bottom: 1px solid #a9a9a9;
    font-size: 0.9rem;
    /* box-shadow: 0 2px 6px rgba(0, 0, 0, 0.02); */
    transition: all 0.2s;
}
.search-input:focus { outline: none; border-bottom: 1px solid #555555;}
.filter-actions { display: flex; gap: 12px; }
.filter-select { -webkit-appearance: none; appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='%236b7280' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E"); background-repeat: no-repeat; background-size: 16px; background-position: right 16px center; padding: 10px 48px 10px 20px; border: 1px solid #e5e7eb; border-radius: 99px; background-color: white; outline: none; cursor: pointer; font-size: 14px; color: #374151; transition: border-color 0.2s; }
.filter-select:hover { border-color: #d1d5db; }
.filter-select:focus { border-color: #000; }

/* =========================================
   1. CẤU TRÚC BẢNG & DÒNG (PILL ROW)
   ========================================= */
.table-card {
  background: transparent;
  border: none;
  box-shadow: none;
  overflow-x: auto;
  overflow-y: visible;
  margin-bottom: 24px;
  padding: 4px;
}

.product-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0 12px; /* Khoảng hở để tạo dòng rời */
}

/* Header */
.product-table th {
  background: transparent;
  padding: 0 20px 10px 20px;
  text-align: center;
  font-size: 11px;
  font-weight: 700;
  color: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 1px;
  border: none;
}
.product-table th.text-right { text-align: center; }

/* =========================================
   2. STYLE CHO CÁC Ô (TD) - VIÊN THUỐC 99PX
   ========================================= */
.product-table td {
  background-color: #ffffff;
  padding: 16px 10px;
  text-align: center;
  vertical-align: middle; /* Căn giữa dọc tự nhiên */
  font-size: 12px;
  color: #383838;
  
  /* Viền trên dưới */
  border-top: 1px solid #f3f4f6;
  border-bottom: 1px solid #f3f4f6;
  border-left: none;
  border-right: none;
}

/* --- BO TRÒN 99PX ĐẦU TRÁI --- */
.product-table td:first-child {
  border-left: 1px solid #f3f4f6;
  border-top-left-radius: 99px;  /* Bo tròn ủng */
  border-bottom-left-radius: 99px;
  padding-left: 20px; /* Thêm chút padding để nội dung không sát mép bo */
}

/* --- BO TRÒN 99PX ĐẦU PHẢI --- */
.product-table td:last-child {
  border-right: 1px solid #f3f4f6;
  border-top-right-radius: 99px; /* Bo tròn ủng */
  border-bottom-right-radius: 99px;
  padding-right: 20px; /* Thêm chút padding để nút không sát mép bo */
}

/* =========================================
   3. CỘT HÀNH ĐỘNG (FIX LỖI LỆCH TÂM)
   ========================================= */
.product-table td.actions {
  display: table-cell !important;
  vertical-align: middle !important;
  text-align: right;
  min-width: 140px;
}

/* Div bọc nút bấm */
.action-buttons {
  display: inline-flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  
  /* --- FIX QUAN TRỌNG --- */
  /* Đã xóa dòng transform: translateY(...) đi */
  /* Bây giờ nó sẽ nằm chính xác ở giữa tâm dòng theo tính toán của trình duyệt */
  transform: none; 
}

/* Nút bấm */
.action-btn {
  width: 36px;
  height: 36px;
  border: 1px solid #e5e7eb;
  border-radius: 50%;
  background: white;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}

.action-btn:hover {
  color: #000;
  background: #f9fafb;
  border-color: #d1d5db;
}

.action-btn svg { width: 16px; height: 16px; }

/* =========================================
   4. HIỆU ỨNG HOVER
   ========================================= */
.product-table tbody tr {
  transition: transform 0.2s ease, filter 0.2s ease;
  cursor: pointer;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.02));
}

.product-table tbody tr:hover:not(.empty-state) {
  transform: translateY(-2px); 
  filter: drop-shadow(0 5px 4px rgba(90, 90, 90, 0.08));
  z-index: 10;
}

.product-table tbody tr:hover td {
  border-color: #e5e7eb;
  background-color: #fafafa;
}

/* Các class phụ trợ giữ nguyên */
.product-info-cell { display: flex; align-items: center; gap: 12px; text-align: left; }
.product-details { display: flex; flex-direction: column; align-items: flex-start; }
.product-name-text { font-weight: 600; color: #111827; }
.variant-count-text { font-size: 11px; color: #9ca3af; }
.sku-tag { padding: 4px 8px; border-radius: 4px; font-size: 11px; color: #374151; font-weight: 500;}
.category-tag { background: #f3f4f6; color: #4b5563; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 500; border: 1px solid #e5e7eb; white-space: nowrap;}
.stock-badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; white-space: nowrap;}
.stock-badge.in-stock { background: #ecfdf5; color: #059669; }
.stock-badge.out-stock { background: #fef2f2; color: #dc2626; }
.font-bold { font-weight: 600; }
/* Pagination */
.pagination-wrapper { display: flex; justify-content: space-between; align-items: center; padding: 0 8px; flex-wrap: wrap; gap: 10px; }
.pagination-controls { display: flex; gap: 8px; }
.btn-page-nav, .page-number { width: 40px; height: 40px; display: grid; align-items: center; justify-content: center; border: 1px solid #e5e7eb; background: white; border-radius: 50%; cursor: pointer; }
.page-number.active { background: #000; color: white; border-color: #000; }

/* MODALS */
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; display: flex; align-items: center; justify-content: center; backdrop-filter: blur(2px); }
.modal-card { background: white; width: 900px; max-width: 95vw; max-height: 90vh; border-radius: 0.2rem; display: flex; flex-direction: column; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }
.modal-header { padding: 20px 24px; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; }
.modal-header h2 { margin: 0; font-size: 18px; font-weight: 700; }
.btn-close-modal { background: none; border: none; font-size: 24px; cursor: pointer; color: #9ca3af; }
.product-form { display: flex; flex-direction: column; height: 100%; overflow: hidden; }
.form-scrollable-content { flex: 1; overflow-y: auto; padding: 24px; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full-width { grid-column: span 2; }
.form-group label { font-size: 13px; font-weight: 600; color: #374151; }
.required { color: red; }
.form-input, .form-select, .form-textarea { padding: 10px; border: 1px solid #e9eaeb; border-radius: 0.2rem; font-size: 14px; outline: none; width: 100%; }
.form-input:focus { border-color: #000; }
.input-group { display: flex; flex-direction: column; gap: 6px;}
.input-group label {font-size: 12px;}
.variants-section { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 0.2rem; padding: 20px; }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.form-section-title { font-weight: 700; font-size: 15px; margin-bottom: 20px; }
.section-desc { font-size: 12px; color: #6b7280; margin: 0; margin-top: -16px; }
.btn-add-variant {font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background: #000; color: white; border: none; padding: 8px 12px; border-radius: 99px; cursor: pointer; font-size: 12px; display: flex; align-items: center; gap: 4px; }
.variant-card { background: white; border: 1px solid #e5e7eb; padding: 16px; border-radius: 0.2rem; margin-bottom: 12px; }
.variant-header { display: flex; justify-content: space-between; margin-bottom: 12px; border-bottom: 1px dashed #e5e7eb; padding-bottom: 8px; }
.variant-title { margin: 0; font-size: 13px; font-weight: 700; }
.btn-remove-variant { color: #ef4444; background: none; border: none; cursor: pointer; font-size: 12px; }
.variant-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 12px; }
.attributes-container { border-top: 1px dashed #e5e7eb; padding-top: 10px; }
.attr-label { font-size: 12px; font-weight: 600; margin-bottom: 8px; display: block; }
.attr-list { display: flex; flex-wrap: wrap; gap: 8px; }
.attr-row { display: flex; align-items: center; gap: 8px; background: #fff; border: 1px solid #e5e7eb; padding: 4px; border-radius: 0.2rem; }
.btn-remove-attr { width: 24px; height: 24px; border: none; background: #fee2e2; color: #dc2626; border-radius: 0.2rem; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; }
.value-wrapper { display: flex; align-items: center; }
.color-input-group { display: flex; align-items: center; gap: 5px; border: 1px solid #d1d5db; border-radius: 0.2rem; padding: 2px; background: white; height: 38px; }
.color-name-input { width: 100px; }
.color-picker-input { width: 32px; height: 32px; padding: 0; border: none; background: none; cursor: pointer; }
.form-input.small { padding: 6px 10px; font-size: 12px; }
.form-input.small.attr-name { width: 80px; font-weight: 600; }
.btn-small-dashed { border: 1px dashed #d1d5db; background: white; padding: 6px 10px; border-radius: 99px; cursor: pointer; font-size: 12px; }
.form-footer { padding: 20px 24px; border-top: 1px solid #e5e7eb; display: flex; justify-content: flex-end; gap: 12px; background: white; }
.btn-save { font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background: #000; color: white; border: none; padding: 10px 24px; border-radius: 99px; font-weight: 600; cursor: pointer; }
.btn-cancel { font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background: white; border: 1px solid #e5e7eb; padding: 10px 20px; border-radius: 99px; cursor: pointer; }

/* VIEW MODAL */
.view-modal-card { background: white; width: 1000px; max-width: 95vw; height: 700px; border-radius: 4px; overflow: hidden; position: relative; display: flex; flex-direction: column; }
.btn-close-view { position: absolute; top: 10px; right: 15px; z-index: 20; background: none; border: none; font-size: 32px; cursor: pointer; color: #666; }
.view-body-grid { display: flex; flex: 1; overflow: hidden; }
.view-gallery { flex: 1.3; background: #fdfdfd; border-right: 1px solid #f0f0f0; display: flex; flex-direction: column; padding: 30px; gap: 20px; }
.main-image-wrapper { flex: 1; display: flex; align-items: center; justify-content: center; border: 1px solid #eee; background: white; padding: 10px; }
.view-main-img { max-width: 100%; max-height: 100%; object-fit: contain; }
.thumb-list { display: flex; gap: 10px; justify-content: center; height: 80px; }
.thumb-item { width: 60px; height: 60px; border: 1px solid transparent; cursor: pointer; opacity: 0.6; transition: all 0.2s; }
.thumb-item.active { opacity: 1; border: 1px solid #000; border-radius: 50%; }
.thumb-item img { width: 100%; height: 100%; object-fit: cover; max-width: 60px; max-height: 60px; border-radius: 50%}
.view-info { flex: 1; padding: 40px; overflow-y: auto; display: flex; flex-direction: column; }
.view-breadcrumbs { font-size: 12px; text-transform: uppercase; color: #999; margin-bottom: 10px; letter-spacing: 0.5px; }
.view-product-title { font-size: 26px; font-weight: 500; margin: 0 0 15px 0; line-height: 1.3; }
.view-meta-row { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; font-size: 13px; color: #555; flex-wrap: wrap; }
.view-meta-item { display: flex; align-items: center; gap: 5px; }
.status-dot { width: 8px; height: 8px; border-radius: 50%; }
.bg-green { background-color: #22c55e; }
.bg-red { background-color: #ef4444; }
.view-price-large { font-size: 24px; font-weight: 600; color: #000; margin-bottom: 20px; }
.view-description { font-size: 14px; color: #666; line-height: 1.6; margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 20px; }
.view-content { font-size: 14px; color: #666; line-height: 1.6; margin-bottom: 30px; }
.view-pricing-details { margin-bottom: 30px; }
.view-pricing-details h3 { font-size: 16px; margin-bottom: 10px; }
.pricing-item { margin-bottom: 5px; }
.selector-group { margin-bottom: 20px; }
.selector-label { font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: 10px; display: block; }
.size-boxes { display: flex; flex-wrap: wrap; gap: 10px; }
.size-box { min-width: 44px; height: 40px; border-radius: 99px; padding: 0 12px; border: 1px solid #e5e5e5; background: white; display: flex; align-items: center; justify-content: center; font-size: 13px; cursor: pointer; transition: all 0.2s; }
.size-box:hover { border-color: #999; }
.size-box.selected { background: #000; color: white; border-color: #000; }
.product-avatar { width: 40px; height: 40px; border-radius: 50%; overflow: hidden; border: 1px solid #e5e7eb; flex-shrink: 0; }
.product-img { width: 100%; height: 100%; object-fit: cover; }
.product-avatar .mono-avatar { width: 100%; height: 100%; background: #f3f4f6; color: #000; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 16px; }
.title-separator {
    margin: 0 10px;
    color: #9ca3af;
    font-size: 20px;
}

.status-text {
    font-size: 14px;
    font-weight: 600;
    padding: 2px 0;
    text-transform: uppercase;
}

/* Màu sắc theo trạng thái */
.status-text.active { color: #16a34a; }   /* Xanh lá */
.status-text.inactive { color: #dc2626; } /* Đỏ */
.status-text.draft { color: #6b7280; }    /* Xám */

/* --- Style cho Đơn vị tính --- */
.unit-badge {
    font-size: 16px;
    color: #6b7280;
    font-weight: 400;
}

/* --- Style cho Nội dung chi tiết --- */
.view-content-section {
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e5e7eb;
}

.content-heading {
    font-size: 15px;
    font-weight: 700;
    margin-bottom: 12px;
    color: #111827;
    text-transform: uppercase;
}

.content-body {
    font-size: 14px;
    color: #4b5563;
    line-height: 1.6;
    white-space: pre-line; /* Giữ nguyên xuống dòng của văn bản */
}
/* =========================================
   NEW HERO BANNER (REPLACE STATS GRID)
   ========================================= */
.hero-stats-banner {
    display: flex;
    justify-content: space-between;
    align-items: center;

    border-radius: 24px;
    padding: 32px 48px;
    margin-bottom: 32px;

    position: relative;
    overflow: hidden;
}

/* --- LEFT SIDE --- */
.hero-left {
    flex: 1;
}

.hero-user-info {
    display: flex;
    align-items: center;
    gap: 24px;
}

.hero-avatar img {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid #fff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}
.stat-icon-wrapper.mono {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #5f5f5f; /* Xám nhạt */
  color: #ffffff;
  border: 5px solid;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}
.stat-icon-wrapper svg { width: 32px; height: 32px; }

.hero-text-group {
    display: flex;
    flex-direction: column;
}

.text-label {
    color: #9ca3af;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 5px;
}

.hero-big-number {
    font-size: 48px;
    font-weight: 800;
    color: #111827;
    margin: 0;
    line-height: 1.1;
    letter-spacing: -1px;
    font-family: 'Quicksand', sans-serif;
}

.currency-symbol {
    font-size: 24px;
    color: #9ca3af;
    font-weight: 400;
    vertical-align: top;
    margin-left: 4px;
}

.hero-sub-text {
    color: #6b7280;
    font-size: 13px;
    margin-top: 8px;
    font-weight: 500;
}

.highlight-green {
    color: #10b981;
    font-weight: 700;
}

/* --- RIGHT SIDE --- */
.hero-right {
    display: flex;
    align-items: center;
    gap: 60px; /* Khoảng cách giữa list thống kê và vòng tròn AI */
}

.stats-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
    border-right: 1px solid #e5e7eb;
    padding-right: 40px;
}

.stat-row {
    display: flex;
    justify-content: space-between;
    min-width: 160px;
    font-size: 13px;
}

.s-label { color: #6b7280; font-weight: 500; }
.s-value { color: #111827; font-weight: 700; }
.s-value.red { color: #ef4444; }

/* --- AI ANIMATION WIDGET (DARK SOUL VERSION) --- */
.ai-widget {
    position: relative;
    width: 120px;
    height: 120px;
    display: flex;
    align-items: center;
    justify-content: center;
    perspective: 800px;
}

.ai-ring-container {
    position: relative;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Vòng xoay tròn (The Ring) - Đổi sang màu xám đen */
.ai-ring-light {
    position: absolute;
    inset: 0;
    border-radius: 50%;
    border: 2px solid transparent;
    /* UPDATE: Đổi màu trắng (#ffffff) thành xám đen (#333333) */
    background: conic-gradient(from 0deg, transparent 0%, #333333 40%, transparent 80%);
    
    /* Giữ nguyên mask để tạo vòng mỏng */
    -webkit-mask: radial-gradient(farthest-side, transparent calc(100% - 2px), #fff calc(100% - 2px + 0.5px));
    mask: radial-gradient(farthest-side, transparent calc(100% - 2px), #fff calc(100% - 2px + 0.5px));
    
    animation: rotate 2s linear infinite;
    opacity: 1; /* Tăng opacity lên để màu đen rõ hơn */
    z-index: 1;
}

/* Hiệu ứng mờ ảo (The Glow/Spirit) - Đổi sang bóng tối */
.ai-ring-blur {
    position: absolute;
    width: 90%;
    height: 90%;
    border-radius: 50%;
    background: radial-gradient(circle, rgb(145 145 145 / 90%) 0%, rgb(20 20 20) 60%, transparent 100%);
    
    /* UPDATE: Đổi shadow sang màu đen */
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.6), inset 0 0 20px rgba(0, 0, 0, 0.8);
    
    animation: breathe 3s ease-in-out infinite alternate;
    z-index: 0;
    backdrop-filter: blur(4px);
}

.ai-content {
    z-index: 2;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.ai-label {
    font-size: 9px;
    text-transform: uppercase;
    /* UPDATE: Màu xám đậm hơn chút */
    color: #ffffff; 
    letter-spacing: 1px;
    margin-bottom: 2px;
}

.ai-number {
    font-size: 32px;
    font-weight: 800;
    /* UPDATE: Màu xám đen (hoặc giữ trắng nếu nền web của bạn là màu đen) */
    color: #ffffff; 
    /* Shadow nhẹ để nổi bật */
    text-shadow: 0 1px 5px rgba(255,255,255,0.2); 
    font-family: 'Quicksand', sans-serif;
}

/* KEYFRAMES ANIMATION */
@keyframes rotate {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

@keyframes breathe {
    0% {
        transform: scale(0.95);
        opacity: 0.7;
        /* UPDATE: Shadow đen */
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.4);
    }
    100% {
        transform: scale(1.05);
        opacity: 1;
        /* UPDATE: Shadow đen đậm hơn và inset đen */
        box-shadow: 0 0 30px rgba(0, 0, 0, 0.8), inset 0 0 10px rgba(0, 0, 0, 0.8);
    }
}
/* Style cho bảng giá Admin trong Modal */
.view-pricing-table {
    display: flex;
    gap: 15px;
    margin-bottom: 20px;
    padding: 12px;
    background: #f9fafb; /* Nền xanh nhạt dễ chịu */
    border: 1px dashed #d1d5db;
    border-radius: 8px;
}

.pricing-col {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center; /* Căn giữa */
}

.pricing-col:last-child {
    border-right: none;
}

.pricing-col .lbl {
    font-size: 11px;
    text-transform: uppercase;
    color: #000000;
    font-weight: 700;
    margin-bottom: 4px;
}

.pricing-col .val {
    font-size: 14px;
    font-weight: 700;
    color: #374151;
}

.pricing-col .val.text-red { color: #dc2626; } /* Màu đỏ cho giá vốn */
.pricing-col .val.text-blue { color: #2563eb; } /* Màu xanh cho giá sỉ */
.variant-details-box {
  display: flex;           /* Xếp các phần tử nằm ngang */
  flex-wrap: wrap;         /* Quan trọng: Tự động xuống dòng nếu hết chỗ -> Không bị mất chữ */
  align-items: center;     /* Căn giữa theo chiều dọc */
  gap: 12px 24px;          /* Khoảng cách: 12px hàng dọc, 24px hàng ngang */
  
  /* Style cũ của bạn */
  margin-bottom: 20px;
  padding: 12px 16px;
  border: 1px dashed #d1d5db;
  border-radius: 8px;
  background-color: #f9fafb; /* Thêm màu nền nhẹ cho đẹp */
  font-size: 13px;
  color: #374151;
}

.variant-details-box svg {
    position: relative;
    top: 3px;
    margin-right: 5px;
}
.view-meta-grid {
    margin-bottom: 20px;
    font-size: 14px;
}
.view-meta-grid .meta-row {
    margin-bottom: 10px;
}
/* Style cho khung thông báo không có ảnh */
.no-image-state {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background-color: #f3f4f6; /* Xám rất nhạt */
    border: 2px dashed #d1d5db; /* Viền nét đứt */
    border-radius: 8px;
    color: #6b7280;
    text-align: center;
    padding: 20px;
}

.no-image-state svg {
    margin-bottom: 12px;
    opacity: 0.5;
}

.no-image-state p {
    margin: 0;
    font-size: 14px;
    line-height: 1.5;
    font-weight: 500;
}
/* Responsive cho Mobile */
@media (max-width: 900px) {
    .hero-stats-banner {
        flex-direction: column;
        align-items: flex-start;
        padding: 24px;
        gap: 30px;
    }
    .hero-right {
        width: 100%;
        justify-content: space-between;
        gap: 0;
    }
    .stats-list {
        border-right: none;
        padding-right: 0;
    }
}
/* Responsive */
@media (min-width: 1025px) { .search-input {max-width: 500px;} .stat-card {padding: 36px;} }
@media (max-width: 1024px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } .view-modal-card { width: 95vw; height: 80vh; } }
@media (max-width: 768px) { .filter-select{font-size: 11px; width: 100%;} .nav-tab-btn{font-size: 11px;} .products-page { padding: 16px; } .page-header { flex-direction: column; align-items: flex-start; } .header-actions { width: 100%; justify-content: left; margin-top: 10px; } .stats-grid { grid-template-columns: 1fr; } .filter-bar { flex-direction: column; } .search-wrapper { width: 100%; } .modal-card { width: 100%; height: 100%; border-radius: 0; } .form-grid { grid-template-columns: 1fr; } .form-group.full-width { grid-column: span 1; } .variant-grid { grid-template-columns: 1fr; } .view-modal-card { height: 100vh; border-radius: 0; } .view-body-grid { flex-direction: column; overflow-y: auto; } .view-gallery { flex: none; height: auto; border-right: none; border-bottom: 1px solid #eee; padding: 20px; } .main-image-wrapper { height: 300px; } .view-info { overflow: visible; padding: 20px; } }
@media (max-width: 429px) {
  .stat-row{
    min-width: 130px;
  }
}
</style>