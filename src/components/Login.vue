<template>
  <div class="login-container">
    <div class="main-content">
      <div class="content-wrapper">
        <div class="header-section">
          <h1 class="heading-1">Hello!</h1>
          <p class="subtitle">Đăng nhập để tiếp tục sử dụng</p>
        </div>

        <div class="grid-layout">
          <div class="intro-section">
            <h2 class="heading-2">Hệ Thống Quản Lý Bán Hàng</h2>
            <p class="intro-text">
              Giải pháp toàn diện giúp bạn quản lý sản phẩm, tồn kho, đơn hàng, khách hàng và nhân viên một cách dễ dàng, realtime cập nhật tức thì.
            </p>
            <!-- Có thể thêm icon hoặc list feature nhỏ ở đây sau -->
          </div>

          <div class="login-form">
            <form @submit.prevent="handleLogin">
              <div class="form-group">
                <input v-model="username" type="text" class="form-input" placeholder=" " required />
                <label class="form-label">Tên đăng nhập</label>
              </div>

              <div class="form-group">
                <input v-model="password" type="password" class="form-input" placeholder=" " required />
                <label class="form-label">Mật khẩu</label>
              </div>

              <p v-if="message" class="message text-danger text-center">{{ message }}</p>

              <button type="submit" class="main-button" :disabled="loading">
                <span v-if="loading">Đang đăng nhập...</span>
                <span v-else>Đăng Nhập</span>
              </button>
            </form>

            <!-- Tạm comment phần Google nếu chưa dùng -->
            <!-- <div class="divider-section">
              <div class="divider-content">
                <h3>Hoặc</h3>
                <button type="button" class="button-gg" disabled>
                  <img src="https://www.google.com/favicon.ico" alt="Google">
                  <span>Đăng nhập với Google</span>
                </button>
              </div>
            </div> -->
          </div>
        </div>

        <div class="footer-section">
          <p class="subtitle">© 2025 Phát triển bởi Trung Tú. All Rights Reserved.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useUserStore } from '../stores/user'
import { useRouter } from 'vue-router'

const username = ref('')
const password = ref('')
const message = ref('')
const loading = ref(false)
const userStore = useUserStore()
const router = useRouter()

const handleLogin = async () => {
  loading.value = true
  message.value = ''
  const result = await userStore.login(username.value, password.value)
  if (result.success) {
    router.push('/dashboard')
  } else {
    message.value = result.message || 'Sai tên đăng nhập hoặc mật khẩu!'
  }
  loading.value = false
}

// Auto redirect nếu đã login
userStore.loadFromStorage()
if (userStore.user) router.push('/dashboard')
</script>

<style scoped>
/* --- Các biến CSS (tùy chọn) --- */
:root {
    --primary-color: #635bff; /* Màu xanh tím */
    --gray-900: #1f2937;
    --gray-600: #4b5563;
    --gray-500: #6b7280;
    --gray-300: #d1d5db;
    --gray-200: #e5e7eb;
    --blue-100: #dbeafe;
    --green-100: #dcfce7;
    --purple-100: #ede9fe;
    --orange-100: #ffedd5;
}

/* --- Thiết lập cơ bản --- */
body {
    margin: 0;
    font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
}

/* --- Container chính (Tương đương .login-container và .min-h-screen) --- */
.login-container, .min-h-screen {
    min-height: 100vh;
    background-color: #fff;
    display: flex;
    flex-direction: column;
    color: #43434d;
}

/* --- Phần nội dung chính (Tương đương .flex-1 .flex .items-center .justify-center .px-4) --- */
.main-content {
    flex: 1 1 0%;
    display: flex;
    align-items: center;
    justify-content: center;
    padding-left: 1rem; /* px-4 */
    padding-right: 1rem; /* px-4 */
    max-width: 950px;
    margin: auto;
}

.content-wrapper {
    width: 100%;
}

/* --- Phần Header (Đăng nhập & Giới thiệu) --- */
.header-section {
    text-align: center;
    margin-bottom: 4rem; /* mb-12 */
}

.footer-section {
    margin-top: 4rem;
    text-align: center;
}

.footer-section p {
    font-size: small;
}

.heading-1 {
    font-size: 3rem; /* text-5xl */
    font-weight: 700; /* font-bold */
    margin-bottom: 0.5rem;
}

.heading-2 {
    font-weight: 500;
}

.subtitle {
    color: var(--gray-600);
    font-size: 1.125rem; /* text-lg */
}

/* --- Layout Grid (Tương đương .grid .md:grid-cols-2 .gap-16) --- */
.grid-layout {
    display: grid;
}
.icon-blue-text { color: #2563eb; } /* text-blue-600 */
.icon-green-text { color: #10b981; } /* text-green-600 */
.icon-purple-text { color: #7c3aed; } /* text-purple-600 */
.icon-orange-text { color: #f97316; } /* text-orange-600 */

.feature-title {
    font-weight: 600; /* font-semibold */
    color: var(--gray-900);
    margin-bottom: 0.25rem; /* mb-1 */
}

.feature-detail {
    font-size: 0.875rem; /* text-sm */
    color: var(--gray-600);
}

/* --- Bên phải - Form đăng nhập (.login-form .space-y-8) --- */
.login-form {
    display: flex;
    flex-direction: column;
    gap: 2rem; /* space-y-8 */
}

.form-group {
    position: relative; /* relative */
}

.form-input {
    width: 100%; /* w-full */
    padding-left: 0; /* px-0 */
    padding-right: 0; /* px-0 */
    padding-top: 0.75rem; /* py-3 */
    padding-bottom: 0.75rem; /* py-3 */
    border: 0; /* border-0 */
    border-bottom: 1px solid #adadad; /* border-b border-gray-300 */
    outline: none; /* focus:outline-none */
    background-color: transparent; /* bg-transparent */
    font-size: 1.125rem; /* text-lg */
    transition: border-color 0.2s ease-in-out;
}

.form-input:focus {
    border-color: var(--primary-color); /* focus:border-[#635bff] */
}

.form-label {
    position: absolute; /* absolute */
    left: 0; /* left-0 */
    top: 0.75rem; /* top-3 */
    color: var(--gray-500);
    transition: all 0.2s; /* transition-all duration-200 */
    pointer-events: none;
}

/* Kỹ thuật placeholder-shown / focus để tạo hiệu ứng label trôi nổi */
.form-input:focus + .form-label,
.form-input:not(:placeholder-shown) + .form-label {
    top: -1.25rem; /* -top-5 */
    font-size: 0.875rem; /* text-sm */
    color: var(--primary-color); /* focus:text-[#635bff] */
}

/* --- Nút Đăng nhập chính (Tương đương .main-button) --- */
.main-button {
    width: 100%; /* w-full */
    padding-top: 1rem; /* py-4 */
    padding-bottom: 1rem; /* py-4 */
    background-color: #43434d; /* bg-[#635bff] */
    color: white; /* text-white */
    font-weight: 600; /* font-semibold */
    font-size: 1.125rem; /* text-lg */
    font-family: 'Quicksand',-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    border-radius: 30px; /* rounded-xl */
    transition: all 0.2s; /* transition transform */
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); /* shadow-lg */
    border: none;
    cursor: pointer;
}

.main-button:hover {
    background-color: #575764; /* hover:bg-blue-700 (giả định) */
    transform: translateY(-2px); /* hover:-translate-y-0.5 */
}

/* --- Phần chia (Hoặc) --- */
.divider-section {
    padding-top: 1.5rem; /* pt-6 */
    border-top: 1px solid var(--gray-200); /* border-t border-gray-200 */
}

.divider-content {
    display: flex;
    flex-direction: column;
    gap: 0.75rem; /* space-y-3 */
}

.divider-content h3 {
    text-align: center;
}

.grid-layout {
  display: grid;
  grid-template-columns: 1fr; /* mobile: 1 cột */
  gap: 60px;
  max-width: 1200px;
  margin: 0 auto;
}

.intro-text {
    line-height: 1.5rem;
}

@media (min-width: 768px) {
  .grid-layout {
    grid-template-columns: 1fr 1fr; /* desktop: 2 cột */
  }
}

.intro-section {
  padding-right: 40px;
}

@media (max-width: 767px) {
  .intro-section {
    padding-right: 0;
    text-align: center;
  }
}
.login-form .form-group {
    margin-bottom: 2.5rem;
}
</style>