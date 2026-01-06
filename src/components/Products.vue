<template>
  <div class="products-page">
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">Quản Lý Sản Phẩm</h1>
        <ul class="breadcrumb">
          <li>Trang chủ</li>
          <li class="separator">/</li>
          <li class="active">Sản phẩm</li>
        </ul>
      </div>
      <div class="header-actions">
        <button @click="openForm()" class="btn btn-black">
          <span class="icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px;">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
          </span> Thêm sản phẩm
        </button>
        <button class="btn btn-white" @click="exportToExcel">
        <span class="icon" style="margin-right: 8px; display: flex; align-items: center;">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#107c41" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <line x1="16" y1="13" x2="8" y2="13"></line>
            <line x1="16" y1="17" x2="8" y2="17"></line>
            <line x1="10" y1="9" x2="8" y2="9"></line>
            </svg>
        </span>
        Xuất Excel
        </button>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon-wrapper mono">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
        </div>
        <div class="stat-content">
          <span class="stat-label">Tổng sản phẩm</span>
          <h3 class="stat-value">{{ products.length }}</h3>
          <span class="stat-sub">Sản phẩm trong kho</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon-wrapper mono">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
        </div>
        <div class="stat-content">
          <span class="stat-label">Còn hàng</span>
          <h3 class="stat-value">{{ inStockCount }}</h3>
          <span class="stat-sub">Sản phẩm có sẵn</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon-wrapper mono">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
        </div>
        <div class="stat-content">
          <span class="stat-label">Hết hàng</span>
          <h3 class="stat-value">{{ outOfStockCount }}</h3>
          <span class="stat-sub">Cần nhập thêm</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon-wrapper mono">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
        </div>
        <div class="stat-content">
          <span class="stat-label">Danh mục</span>
          <h3 class="stat-value">{{ categories.length }}</h3>
          <span class="stat-sub">Nhóm hàng</span>
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
          <option value="draft">Nháp</option>
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
            <td v-if="role === 'admin'">{{ getDisplayCostPrice(product) }}</td>
            
            <td class="font-bold">
                {{ getDisplayPrice(product) }}
            </td>

            <td class="actions text-right">
              <button class="action-btn view" @click="openViewModal(product)" title="Xem chi tiết">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
              </button>
              <button class="action-btn edit" @click="openForm(product)" title="Chỉnh sửa">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
              </button>
              <button v-if="role === 'admin'" class="action-btn delete" @click="deleteProduct(product.id)" title="Xóa">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
              </button>
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
                  <input v-model="form.name" required class="form-input" placeholder="Nhập tên sản phẩm..." />
                </div>
                <div class="form-group">
                  <label>Slug (URL) <span class="required">*</span></label>
                  <input v-model="form.slug" required class="form-input" placeholder="ten-san-pham" />
                </div>
                <div class="form-group">
                  <label>Danh mục</label>
                  <select v-model="form.category_id" required class="form-select">
                    <option value="">-- Chọn danh mục --</option>
                    <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Thương hiệu</label>
                  <select v-model="form.brand_id" class="form-select">
                    <option value="">-- Chọn thương hiệu --</option>
                    <option v-for="brand in brands" :key="brand.id" :value="brand.id">{{ brand.name }}</option>
                  </select>
                </div>
                <div class="form-group">
                    <label>Nhà cung cấp <span class="required">*</span></label>
                    <select v-model="form.supplier_id" class="form-select">
                        <option value="">-- Chọn nhà cung cấp --</option>
                        <option v-for="sup in suppliers" :key="sup.id" :value="sup.id">
                        {{ sup.name }}
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
                    <option value="draft">Nháp</option>
                    <option value="active">Đang bán</option>
                    <option value="inactive">Ngừng bán</option>
                  </select>
                </div>
                <div class="form-group checkbox-group">
                  <label class="checkbox-container">
                    <input type="checkbox" v-model="form.is_for_sale" />
                    <span class="checkmark"></span>
                    Cho phép bán
                  </label>
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
            <button type="submit" class="btn-save">Lưu Sản Phẩm</button>
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
                     <img :src="currentMainImage" class="view-main-img">
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

                <h1 class="view-product-title">{{ viewingProduct.name }}</h1>
                
                <div class="view-meta-row">
                    <div class="view-meta-item">
                        <span class="label">SKU:</span>
                        <span class="value">{{ selectedVariantSKU || viewingProduct.sku || 'N/A' }}</span>
                    </div>
                    <div class="view-meta-item status">
                        <span class="status-dot" :class="selectedVariantStock > 0 ? 'bg-green' : 'bg-red'"></span>
                        <span class="value">{{ selectedVariantStock > 0 ? selectedVariantStock + ' Còn hàng' : 'Hết hàng' }}</span>
                    </div>
                    <div class="view-meta-item">
                        <span class="label">Trạng thái:</span>
                        <span class="value">
                            {{ getStatusText(viewingProduct.status) }}
                        </span>
                    </div>
                </div>

                <div class="view-price-large">
                    {{ formatPrice(selectedVariantPrice || viewingProduct.retail_price) }}
                </div>

                <div class="view-description">
                    {{ viewingProduct.description || 'Chưa có mô tả ngắn.' }}
                </div>

                <div class="view-content">
                    <h3>Nội dung chi tiết:</h3>
                    {{ viewingProduct.content || 'Chưa có nội dung chi tiết.' }}
                </div>

                <div class="view-pricing-details" v-if="role === 'admin' && selectedVariantIndex !== -1">
                    <h3>Chi tiết giá (Admin):</h3>
                    <div class="pricing-item">Giá vốn: {{ formatPrice(selectedVariant.cost_price) }}</div>
                    <div class="pricing-item">Giá sỉ: {{ formatPrice(selectedVariant.wholesale_price) }}</div>
                </div>

                <div class="divider"></div>

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
import Swal from 'sweetalert2' // Đảm bảo đúng đường dẫn file supabase.js của bạn
import * as XLSX from 'xlsx'

export default {
  data() {
    return {
      // Data Arrays
      products: [],
      categories: [],
      brands: [],
      suppliers: [], // Thêm suppliers
      
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
      role: 'admin' // Mặc định admin để test full quyền
    }
  },
  
  async mounted() {
    await Promise.all([
      this.loadProducts(),
      this.loadCategories(),
      this.loadBrands(),
      this.loadSuppliers()
    ])
  },

  computed: {
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
    
    // Logic lấy ảnh đang hiển thị trong modal
    currentMainImage() {
        if (this.activeImage) return this.activeImage;
        
        // 1. Nếu đang chọn biến thể -> Lấy ảnh đầu tiên của biến thể đó
        if (this.selectedVariantIndex !== -1) {
            const v = this.viewingVariants[this.selectedVariantIndex];
            if (v.images && v.images.length > 0) return v.images[0].image_url;
        }
        
        // 2. Mặc định: Lấy ảnh của biến thể đầu tiên
        if (this.viewingVariants.length > 0 && this.viewingVariants[0].images?.length > 0) {
             return this.viewingVariants[0].images[0].image_url;
        }
        
        return 'https://via.placeholder.com/500x500?text=No+Image';
    },

    // Gom tất cả ảnh từ tất cả biến thể để làm Gallery
    allImages() {
        const imgs = [];
        this.viewingVariants.forEach(v => { 
            if(v.images && Array.isArray(v.images)) {
                v.images.forEach(img => imgs.push(img.image_url));
            }
        });
        return [...new Set(imgs)]; // Loại bỏ ảnh trùng
    },

    // Stats
    inStockCount() { return this.products.filter(p => p.total_stock > 0).length; },
    outOfStockCount() { return this.products.filter(p => p.total_stock === 0).length; }
  },

  methods: {
    // ============================================================
    // 1. LOAD DATA (QUERY DEEP CHO IMAGE & ATTRIBUTE)
    // ============================================================
    async loadProducts() {
      // Query lồng nhau: Product -> Variant -> (Images, Attribute Values)
      const { data, error } = await supabase
        .from('products')
        .select(`
            *,
            product_variants (
                id, sku, variant_name, retail_price, cost_price, wholesale_price, stock:inventories(quantity_on_hand),
                product_variant_images ( image_url, is_thumbnail ),
                variant_attribute_values (
                    attribute_values (
                        value,
                        attributes ( name )
                    )
                )
            )
        `)
        .order('created_at', { ascending: false });

      if (error) {
          console.error('Lỗi load:', error);
          return;
      }

      // Transform dữ liệu cho dễ dùng ở Frontend
      this.products = data.map(p => {
          // Tính tổng tồn kho (giả sử bảng inventories quan hệ 1-1 với variant ở kho mặc định)
          let totalStock = 0;
          if (p.product_variants) {
              p.product_variants.forEach(v => {
                  // Lấy số lượng từ mảng inventories (nếu có)
                  const q = (v.stock && v.stock.length > 0) ? v.stock[0].quantity_on_hand : 0;
                  totalStock += q;
                  v.current_stock = q; // Gán tạm để dùng
              });
          }
          return { ...p, total_stock: totalStock };
      });
    },

    // Lấy ảnh đại diện cho list (Lấy ảnh thumbnail hoặc ảnh đầu tiên)
    getProductImage(product) {
      if (!product.product_variants || product.product_variants.length === 0) return null;
      
      // Tìm ảnh thumbnail true trước
      for (const v of product.product_variants) {
          if (v.product_variant_images) {
              const thumb = v.product_variant_images.find(img => img.is_thumbnail);
              if (thumb) return thumb.image_url;
          }
      }
      
      // Nếu không có, lấy ảnh đầu tiên bất kỳ
      for (const v of product.product_variants) {
          if (v.product_variant_images && v.product_variant_images.length > 0) {
              return v.product_variant_images[0].image_url;
          }
      }
      return null;
    },

    // ============================================================
    // 2. FORM & SAVE LOGIC (XỬ LÝ NHIỀU ẢNH)
    // ============================================================
    async openForm(product = null) {
      this.editingProduct = product;
      if (product) {
        // Fetch chi tiết để điền vào form
        const { data: variants } = await supabase
            .from('product_variants')
            .select(`
                *,
                product_variant_images(image_url),
                variant_attribute_values(
                    attribute_values(value, attributes(name))
                )
            `)
            .eq('product_id', product.id);

        this.form = { 
            ...product, 
            variants: variants.map(v => ({
                ...v,
                // Chuyển mảng ảnh thành chuỗi string ngăn cách phẩy để hiển thị input đơn giản
                // Hoặc bạn có thể sửa UI để hiện list input ảnh. Ở đây mình dùng cách gộp chuỗi cho gọn UI.
                image_urls_string: v.product_variant_images.map(i => i.image_url).join('\n'),
                
                // Map attributes từ DB sang form
                attributes: v.variant_attribute_values.map(vav => ({
                    attribute_name: vav.attribute_values.attributes.name,
                    attribute_value: vav.attribute_values.value,
                    is_color: ['màu', 'color'].includes(vav.attribute_values.attributes.name.toLowerCase())
                }))
            }))
        };
        this.showForm = true;
      } else {
        // Reset Form
        this.form = {
          name: '', slug: '', category_id: '', brand_id: '', supplier_id: '',
          description: '', content: '', base_unit: 'Cái', status: 'active',
          is_for_sales: true, variants: []
        };
        this.addVariant(); // Thêm 1 dòng trống mặc định
        this.showForm = true;
      }
    },

    async saveProduct() {
      try {
        // 1. Lưu bảng Products
        const productPayload = {
           name: this.form.name,
           slug: this.form.slug || this.generateSlug(this.form.name),
           category_id: this.form.category_id,
           brand_id: this.form.brand_id || null,
           supplier_id: this.form.supplier_id || null,
           description: this.form.description,
           content: this.form.content,
           base_unit: this.form.base_unit,
           status: this.form.status, 
           is_for_sales: this.form.is_for_sales
        };

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

        // 2. Xử lý Variants (Xóa cũ thêm mới để đồng bộ hoàn toàn)
        // Lưu ý: Thực tế nên dùng upsert, ở đây dùng delete-insert cho đơn giản logic demo
        await supabase.from('product_variants').delete().eq('product_id', productId);

        if (this.form.variants.length > 0) {
            for (const v of this.form.variants) {
                // a. Insert Variant
                const { data: vData, error: vError } = await supabase.from('product_variants').insert({
                    product_id: productId,
                    sku: v.sku,
                    variant_name: v.variant_name,
                    retail_price: Number(v.retail_price) || 0,
                    cost_price: Number(v.cost_price) || 0,
                    wholesale_price: Number(v.wholesale_price) || 0,
                    weight: Number(v.weight) || 0,
                    barcode: v.barcode
                }).select('id').single();
                
                if (vError) throw vError;
                const variantId = vData.id;

                // b. Insert Images (Xử lý nhiều ảnh)
                if (v.image_urls_string) {
                    const urls = v.image_urls_string.split(/[\n,]+/).map(u => u.trim()).filter(u => u !== '');
                    if (urls.length > 0) {
                        const imagesInsert = urls.map((url, idx) => ({
                            product_variant_id: variantId,
                            image_url: url,
                            is_thumbnail: idx === 0, // Ảnh đầu tiên là thumbnail
                            sort_order: idx
                        }));
                        await supabase.from('product_variant_images').insert(imagesInsert);
                    }
                }

                // c. Insert Attributes (Logic phức tạp: Phải check bảng attributes/values trước)
                // Phần này cần Backend xử lý để chuẩn, ở đây mình bỏ qua để code chạy được 
                // (Vì cần tạo attribute_id, value_id nếu chưa có -> Rất dài dòng ở Client)
            }
        }

        alert('Lưu thành công!');
        this.showForm = false;
        this.loadProducts();

      } catch (err) {
        console.error(err);
        alert('Lỗi: ' + err.message);
      }
    },

    // --- UI HELPERS ---
    addVariant() {
      this.form.variants.push({
        sku: '', variant_name: '', retail_price: 0, cost_price: 0, 
        attributes: [], image_urls_string: '' // Dùng chuỗi để nhập nhiều ảnh xuống dòng
      });
    },
    removeVariant(index) { this.form.variants.splice(index, 1); },
    
    // Attribute logic (chỉ làm UI, chưa lưu xuống DB ở code này)
    addAttribute(vIndex) {
        if(!this.form.variants[vIndex].attributes) this.form.variants[vIndex].attributes = [];
        this.form.variants[vIndex].attributes.push({ attribute_name: '', attribute_value: '' });
    },
    removeAttribute(vIndex, aIndex) {
        this.form.variants[vIndex].attributes.splice(aIndex, 1);
        this.updateVariantName(vIndex);
    },
    updateVariantName(index) {
        // Tự động tạo tên biến thể từ thuộc tính
        const v = this.form.variants[index];
        if (v.attributes && v.attributes.length > 0) {
            v.variant_name = v.attributes.map(a => a.attribute_value).join(' - ');
        }
    },

    // --- VIEW MODAL ---
    openViewModal(product) {
        this.viewingProduct = product;
        this.selectedVariantIndex = -1;
        this.activeImage = '';
        
        // Map variants để hiển thị đúng structure view
        if (product.product_variants) {
            this.viewingVariants = product.product_variants.map(v => ({
                ...v,
                images: v.product_variant_images || []
            }));
        } else {
            this.viewingVariants = [];
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
    async loadRole() { this.role = 'admin'; }, // Mock role
    
    async deleteProduct(id) {
        if(!confirm('Xóa sản phẩm?')) return;
        await supabase.from('products').delete().eq('id', id);
        this.loadProducts();
    },

    // Formatting
    formatPrice(val) { return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val || 0); },
    getCategoryName(id) { return this.categories.find(x => x.id === id)?.name || '---'; },
    getBrandName(id) { return this.brands.find(x => x.id === id)?.name || ''; },
    getDisplayPrice(p) { return this.formatPrice(p.product_variants?.[0]?.retail_price || 0); },
    getDisplayCostPrice(p) { return this.formatPrice(p.product_variants?.[0]?.cost_price || 0); },
    getProductSKU(p) { return p.product_variants?.[0]?.sku || '---'; },
    getStatusText(s) { return s === 'active' ? 'Đang bán' : 'Ngừng bán'; },
    getStockClass(s) { return s > 0 ? 'stock-badge in-stock' : 'stock-badge out-stock'; },
    checkIsColor(attr) { attr.is_color = attr.attribute_name.toLowerCase().includes('màu'); },
    generateSlug(text) { return text.toLowerCase().replace(/ /g, '-').replace(/[^\w-]+/g, ''); },
    
    exportToExcel() {
        try {
            console.log("Bắt đầu xuất Excel...");

            // 1. Lấy dữ liệu: Ưu tiên dữ liệu đang lọc, nếu không thì lấy tất cả
            const sourceData = this.filteredProducts && this.filteredProducts.length > 0 
                                ? this.filteredProducts 
                                : this.products;

            if (!sourceData || sourceData.length === 0) {
            Swal.fire('Thông báo', 'Không có dữ liệu để xuất!', 'warning');
            return;
            }

            // 2. Chuẩn bị mảng dữ liệu phẳng (Flatten Data)
            const dataToExport = [];

            sourceData.forEach(p => {
            // Lấy danh sách biến thể, nếu không có thì tạo mảng rỗng
            const variants = p.product_variants || [];

            if (variants.length > 0) {
                // Trường hợp 1: Có biến thể -> Mỗi biến thể là 1 dòng
                variants.forEach(v => {
                dataToExport.push({
                    'ID Sản Phẩm': p.id,
                    'Tên Sản Phẩm': p.name,
                    'Danh Mục': this.getCategoryName(p.category_id),
                    'Thương Hiệu': this.getBrandName(p.brand_id),
                    'Nhà Cung Cấp': p.supplier_name || '',
                    'Loại Biến Thể': v.variant_name,
                    'Mã SKU': v.sku,
                    'Giá Vốn': this.role === 'admin' ? (v.cost_price || 0) : '***',
                    'Giá Bán': v.retail_price || 0,
                    'Tồn Kho': v.stock || 0,
                    'Đơn Vị': p.base_unit,
                    'Trạng Thái': p.status === 'active' ? 'Đang bán' : 'Ngừng bán'
                });
                });
            } else {
                // Trường hợp 2: Sản phẩm đơn (Không có biến thể) -> Xuất 1 dòng
                dataToExport.push({
                'ID Sản Phẩm': p.id,
                'Tên Sản Phẩm': p.name,
                'Danh Mục': this.getCategoryName(p.category_id),
                'Thương Hiệu': this.getBrandName(p.brand_id),
                'Nhà Cung Cấp': p.supplier_name || '',
                'Loại Biến Thể': 'Sản phẩm đơn',
                'Mã SKU': p.sku || '',
                'Giá Vốn': '---',
                'Giá Bán': '---', // Hoặc lấy p.retail_price nếu có
                'Tồn Kho': p.total_stock || 0,
                'Đơn Vị': p.base_unit,
                'Trạng Thái': p.status === 'active' ? 'Đang bán' : 'Ngừng bán'
                });
            }
            });

            console.log("Dữ liệu xuất:", dataToExport); // Kiểm tra data ở Console

            // 3. Tạo File Excel
            // Tạo Sheet từ JSON
            const ws = XLSX.utils.json_to_sheet(dataToExport);
            
            // Tự động chỉnh độ rộng cột (Optional)
            const wscols = [
                {wch: 10}, {wch: 30}, {wch: 15}, {wch: 15}, {wch: 15}, 
                {wch: 25}, {wch: 15}, {wch: 10}, {wch: 10}, {wch: 10}
            ];
            ws['!cols'] = wscols;

            // Tạo Workbook
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, "Danh_Sach_San_Pham");

            // 4. Lưu file
            const fileName = `Export_SanPham_${new Date().toISOString().slice(0,10)}.xlsx`;
            XLSX.writeFile(wb, fileName);

            // Thông báo thành công
            const Toast = Swal.mixin({
            toast: true, position: 'top-end', showConfirmButton: false, timer: 3000, timerProgressBar: true
            });
            Toast.fire({ icon: 'success', title: 'Xuất file Excel thành công!' });

        } catch (err) {
            console.error("Lỗi xuất Excel:", err);
            Swal.fire('Lỗi', 'Không thể xuất file. Vui lòng kiểm tra Console (F12).', 'error');
        }
        }
  }
}
</script>

<style scoped>
/* =========================================
   0. RESET & GLOBAL
   ========================================= */
* {
  box-sizing: border-box;
}

.products-page {
  padding: 32px 40px;
  max-width: 1500px;
  min-height: 100vh;
  color: #1f2937;
  margin: auto;
  border-radius: 10px;
}
.products-page ::placeholder, .products-page select {
  font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
}

/* =========================================
   1. HEADER & ACTIONS
   ========================================= */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 30px;
  flex-wrap: wrap;
  gap: 20px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: #111827;
  margin: 0 0 8px 0;
}

.breadcrumb {
  display: flex;
  list-style: none;
  padding: 0;
  margin: 0;
  color: #6b7280;
  font-size: 14px;
}
.breadcrumb .separator { margin: 0 8px; color: #d1d5db; }
.breadcrumb .active { color: #374151; font-weight: 500; }

.header-actions {
  display: flex;
  gap: 12px;
}

.btn {
  padding: 10px 20px;
  border-radius: 30px;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.2s;
  white-space: nowrap;
}

.btn-black {
  background: #000000;
  color: #ffffff;
  border: 1px solid #000000;
}
.btn-black:hover {
  background: #333333;
  border-color: #333333;
}

.btn-white {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  color: #374151;
}
.btn-white:hover {
  background: #f9fafb;
  border-color: #d1d5db;
}

.icon { font-size: 16px; line-height: 1; }

/* =========================================
   2. STATS GRID (MONOCHROME)
   ========================================= */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
  margin-bottom: 32px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.stat-card:hover {
    transform: translateY(-5px);
    transition: 0.5s;
    background: #fbfbfb;
}

.stat-icon-wrapper.mono {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #ffb300; 
  color: #ffffff;
}
.stat-icon-wrapper svg { width: 24px; height: 24px; }

.stat-content { display: flex; flex-direction: column; }
.stat-label { color: #6b7280; font-size: 12px; font-weight: 600; text-transform: uppercase; margin-bottom: 4px; }
.stat-value { font-size: 24px; font-weight: 700; color: #111827; margin: 0; }
.stat-sub { color: #9ca3af; font-size: 12px; margin-top: 2px; }

/* =========================================
   3. FILTER BAR
   ========================================= */
.filter-bar {
  display: flex;
  justify-content: space-between;
  margin-bottom: 24px;
  gap: 20px;
  flex-wrap: wrap;
}

.search-wrapper { position: relative; flex: 1; min-width: 300px; }
.search-icon {
  position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
  width: 18px; color: #9ca3af;
}
.search-input {
    width: 100%;
    padding: 17px 16px 17px 44px;
    background: #ffffff;
    border: 1px solid transparent;
    border-radius: 99px;
    font-size: 0.9rem;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.02);
    transition: all 0.2s;
    box-sizing: border-box;
}
.search-input:focus { outline: none; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); }

.filter-actions { display: flex; gap: 12px; }
.filter-select {
  /* 1. Tắt mũi tên mặc định của trình duyệt */
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;

  /* 2. Thêm mũi tên tùy chỉnh (SVG) */
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='%236b7280' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-size: 16px;
  
  /* 3. QUAN TRỌNG: Đẩy mũi tên vào trong (cách lề phải 16px) */
  background-position: right 16px center; 

  /* 4. Căn chỉnh khoảng cách chữ */
  padding: 10px 48px 10px 20px; /* Padding phải lớn để chữ không đè lên mũi tên */
  
  /* Style giao diện (Bo tròn giống hình bạn gửi) */
  border: 1px solid #e5e7eb;
  border-radius: 99px; /* Bo tròn kiểu viên thuốc */
  background-color: white;
  outline: none;
  cursor: pointer;
  font-size: 14px;
  color: #374151;
  transition: border-color 0.2s;
}

.filter-select:hover {
  border-color: #d1d5db;
}

.filter-select:focus {
  border-color: #000;
}

/* =========================================
   4. DATA TABLE
   ========================================= */
.table-card {
  background: white;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  overflow-x: auto;
  margin-bottom: 24px;
}

.product-table { width: 100%; border-collapse: collapse; min-width: 900px; }

.product-table th {
  background: #f9fafb;
  padding: 14px 20px;
  text-align: center;
  font-size: 12px; font-weight: 700; color: #6b7280;
  text-transform: uppercase; border-bottom: 1px solid #e5e7eb;
}

.product-table td {
  padding: 14px 20px;
  vertical-align: middle;
  font-size: 14px; color: #374151;
}

.product-table tr {
  border-bottom: 1px solid #f3f4f6;
}

.product-table tr:hover {
    background: #f7f7f7;
}

/* Avatar Cell */
.product-info-cell { display: flex; align-items: center; gap: 12px; }
.product-details { display: flex; flex-direction: column; }
.product-name-text { font-weight: 600; color: #111827; }
.variant-count-text { font-size: 11px; color: #9ca3af; }

/* Badges & Actions */
.sku-tag { padding: 4px 8px; border-radius: 0.2rem; font-size: 12px; }
.category-tag { background: #f3f4f6; color: #4b5563; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; border: 1px solid #e5e7eb; }

.stock-badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
.stock-badge.in-stock { background: #ecfdf5; color: #059669; }
.stock-badge.out-stock { background: #fef2f2; color: #dc2626; }
.stock-badge.low-stock { background: #fffbeb; color: #d97706; }

.actions { display: flex; justify-content: flex-end; gap: 6px; }
.action-btn {
  width: 40px; height: 40px;
  border-radius: 50%;
  background: white; color: #6b7280;
  display: grid; align-items: center; justify-content: center;
  cursor: pointer; transition: all 0.2s;
}
.action-btn:hover { border:none; color: #000; background: rgb(240, 239, 239) }
.action-btn svg { width: 16px; height: 16px; }
.text-right { text-align: right; }
.font-bold { font-weight: 600; }

/* Pagination */
.pagination-wrapper { display: flex; justify-content: space-between; align-items: center; padding: 0 8px; flex-wrap: wrap; gap: 10px; }
.pagination-controls { display: flex; gap: 8px; }
.btn-page-nav, .page-number {
  width: 40px; height: 40px;
  display: grid; align-items: center; justify-content: center;
  border: 1px solid #e5e7eb; background: white; border-radius: 50%;
  cursor: pointer;
}
.page-number.active { background: #000; color: white; border-color: #000; }

/* =========================================
   5. FORM MODAL (ADD/EDIT)
   ========================================= */
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.5);
  z-index: 1000;
  display: flex; align-items: center; justify-content: center;
  backdrop-filter: blur(2px);
}

.modal-card {
  background: white;
  width: 900px;
  max-width: 95vw;
  max-height: 90vh;
  border-radius: 0.2rem;
  display: flex; flex-direction: column;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.modal-header {
  padding: 20px 24px;
  border-bottom: 1px solid #e5e7eb;
  display: flex; justify-content: space-between; align-items: center;
}
.modal-header h2 { margin: 0; font-size: 18px; font-weight: 700; }
.btn-close-modal { background: none; border: none; font-size: 24px; cursor: pointer; color: #9ca3af; }

.product-form { display: flex; flex-direction: column; height: 100%; overflow: hidden; }
.form-scrollable-content { flex: 1; overflow-y: auto; padding: 24px; }

.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full-width { grid-column: span 2; }
.form-group label { font-size: 13px; font-weight: 600; color: #374151; text-align: justify; }
.required { color: red; }

.form-input, .form-select, .form-textarea {
  padding: 10px; border: 1px solid #e9eaeb; border-radius: 0.2rem;
  font-size: 14px; outline: none; width: 100%;
}
.form-input:focus { border-color: #000; }

/* Variants Section */
.variants-section { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 0.2rem; padding: 20px; }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.form-section-title { font-weight: 700; font-size: 15px; margin-bottom: 4px; }
.section-desc { font-size: 12px; color: #6b7280; margin: 0; }
.btn-add-variant { background: #000; color: white; border: none; padding: 6px 12px; border-radius: 0.2rem; cursor: pointer; font-size: 12px; display: flex; align-items: center; gap: 4px; }

.variant-card { background: white; border: 1px solid #e5e7eb; padding: 16px; border-radius: 0.2rem; margin-bottom: 12px; }
.variant-header { display: flex; justify-content: space-between; margin-bottom: 12px; border-bottom: 1px dashed #e5e7eb; padding-bottom: 8px; }
.variant-title { margin: 0; font-size: 13px; font-weight: 700; }
.btn-remove-variant { color: #ef4444; background: none; border: none; cursor: pointer; font-size: 12px; }

.variant-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 12px; }
.input-group label { font-size: 11px; font-weight: 600; color: #6b7280; margin-bottom: 4px; display: block; text-align: justify; }

/* ATTRIBUTES STYLES */
.attributes-container { border-top: 1px dashed #e5e7eb; padding-top: 10px; }
.attr-label { font-size: 12px; font-weight: 600; margin-bottom: 8px; display: block; }
.attr-list { display: flex; flex-wrap: wrap; gap: 8px; }
.attr-row { display: flex; align-items: center; gap: 8px; background: #fff; border: 1px solid #e5e7eb; padding: 4px; border-radius: 0.2rem; }
.btn-remove-attr { width: 24px; height: 24px; border: none; background: #fee2e2; color: #dc2626; border-radius: 0.2rem; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; }
.btn-remove-attr:hover { background: #dc2626; color: white; }

.value-wrapper { display: flex; align-items: center; }
.color-input-group { display: flex; align-items: center; gap: 5px; border: 1px solid #d1d5db; border-radius: 0.2rem; padding: 2px 6px 2px 2px; background: white; height: 38px; }
.color-name-input { width: 100px; }
.color-picker-input { width: 32px; height: 32px; padding: 0; border: none; background: none; cursor: pointer; }
.color-hex-text { font-size: 11px; color: #555; min-width: 50px; }

.form-input.small { padding: 6px 10px; font-size: 12px; }
.form-input.small.attr-name { width: 80px; font-weight: 600; }
.btn-small-dashed { border: 1px dashed #d1d5db; background: white; padding: 6px 10px; border-radius: 0.2rem; cursor: pointer; font-size: 12px; }

.form-footer { padding: 20px 24px; border-top: 1px solid #e5e7eb; display: flex; justify-content: flex-end; gap: 12px; background: white; }
.btn-save { background: #000; color: white; border: none; padding: 10px 24px; border-radius: 0.2rem; font-weight: 600; cursor: pointer; }
.btn-cancel { background: white; border: 1px solid #e5e7eb; padding: 10px 20px; border-radius: 0.2rem; cursor: pointer; }

/* =========================================
   6. VIEW MODAL (CLEAN E-COMMERCE STYLE)
   ========================================= */
.view-modal-card {
  background: white;
  width: 1000px;
  max-width: 95vw;
  height: 700px;
  border-radius: 4px;
  overflow: hidden;
  position: relative;
  display: flex;
  flex-direction: column;
}

.btn-close-view {
  position: absolute; top: 10px; right: 15px; 
  z-index: 20; background: none; border: none; 
  font-size: 32px; cursor: pointer; color: #666;
}

.view-body-grid {
  display: flex;
  flex: 1;
  overflow: hidden; 
}

/* Cột trái: Ảnh */
.view-gallery {
  flex: 1.3;
  background: #fdfdfd;
  border-right: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
  padding: 30px;
  gap: 20px;
}

.main-image-wrapper {
  flex: 1;
  display: flex; align-items: center; justify-content: center;
  border: 1px solid #eee; background: white; padding: 10px;
}
.view-main-img { max-width: 100%; max-height: 100%; object-fit: contain; }

.thumb-list {
  display: flex; gap: 10px; justify-content: center; height: 80px;
}
.thumb-item {
  width: 60px; height: 100%; 
  border: 1px solid transparent; cursor: pointer; opacity: 0.6; 
  transition: all 0.2s;
}
.thumb-item.active { opacity: 1; border: 1px solid #000; }
.thumb-item img { width: 100%; height: 100%; object-fit: cover; }

/* Cột phải: Thông tin */
.view-info {
  flex: 1;
  padding: 40px;
  overflow-y: auto; 
  display: flex; flex-direction: column;
}

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

/* Selectors */
.selector-group { margin-bottom: 20px; }
.selector-label { font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: 10px; display: block; }

.size-boxes { display: flex; flex-wrap: wrap; gap: 10px; }
.size-box { 
  min-width: 44px; height: 40px; padding: 0 12px;
  border: 1px solid #e5e5e5; background: white; 
  display: flex; align-items: center; justify-content: center; 
  font-size: 13px; cursor: pointer; transition: all 0.2s;
}
.size-box:hover { border-color: #999; }
.size-box.selected { background: #000; color: white; border-color: #000; }

.product-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  border: 1px solid #e5e7eb;
  flex-shrink: 0;
}

.product-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-avatar .mono-avatar {
  width: 100%;
  height: 100%;
  background: #f3f4f6;
  color: #000;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 16px;
}

/* =========================================
   7. RESPONSIVE (MOBILE FIX)
   ========================================= */
@media (min-width: 1025px) {
  .search-input {max-width: 500px;}
  .stat-card {padding: 36px;}
}
@media (max-width: 1024px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
  .view-modal-card { width: 95vw; height: 80vh; }
}

@media (max-width: 768px) {
  .products-page { padding: 16px; }
  .page-header { flex-direction: column; align-items: flex-start; }
  .header-actions { width: 100%; justify-content: space-between; margin-top: 10px; }
  .stats-grid { grid-template-columns: 1fr; }
  
  .filter-bar { flex-direction: column; }
  .search-wrapper { width: 100%; }
  
  /* Modal responsive */
  .modal-card { width: 100%; height: 100%; border-radius: 0; }
  .form-grid { grid-template-columns: 1fr; }
  .form-group.full-width { grid-column: span 1; }
  .variant-grid { grid-template-columns: 1fr; }
  
  /* View Modal responsive */
  .view-modal-card { height: 100vh; border-radius: 0; }
  .view-body-grid { flex-direction: column; overflow-y: auto; }
  .view-gallery { flex: none; height: auto; border-right: none; border-bottom: 1px solid #eee; padding: 20px; }
  .main-image-wrapper { height: 300px; }
  .view-info { overflow: visible; padding: 20px; }
}
</style>