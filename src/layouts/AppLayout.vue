<template>
  <div class="app-layout">
    <aside class="sidebar">
      <div class="sidebar-logo">
        <div class="logo-circle">G/</div>
      </div>

      <nav class="sidebar-menu">
        <ul>
          <li :class="{ active: $route.path === '/dashboard' }">
            <router-link to="/dashboard" title="Dashboard">
              <div class="icon-box">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z" />
                </svg>
              </div>
            </router-link>
          </li>

          <li :class="{ active: $route.path.startsWith('/products') }">
            <router-link to="/products" title="Sản phẩm">
              <div class="icon-box">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
                </svg>
              </div>
            </router-link>
          </li>

          <li :class="{ active: $route.path.startsWith('/orders') }">
            <router-link to="/orders" title="Đơn hàng">
              <div class="icon-box">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                   <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" />
                </svg>
              </div>
            </router-link>
          </li>
          
          <li :class="{ active: $route.path.startsWith('/customers') }">
            <router-link to="/customers" title="Khách hàng">
              <div class="icon-box">
                 <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                </svg>
              </div>
            </router-link>
          </li>

          <li class="add-item">
            <button class="add-btn">
               <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
               </svg>
            </button>
          </li>
        </ul>
      </nav>

      <div class="sidebar-footer">
          <button class="footer-icon-btn">
             <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M8.625 12a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H8.25m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H12m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0h-.375M21 12c0 4.556-4.03 8.25-9 8.25a9.764 9.764 0 01-2.555-.337A5.972 5.972 0 015.41 20.97a5.969 5.969 0 01-.474-.065 4.48 4.48 0 00.978-2.025c.09-.457-.133-.901-.467-1.226C3.93 16.178 3 14.189 3 12c0-4.556 4.03-8.25 9-8.25s9 3.694 9 8.25z" />
             </svg>
          </button>
          <button class="footer-icon-btn">
             <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 01-1.12-1.243l1.264-12A1.125 1.125 0 015.513 7.5h12.974c.576 0 1.059.435 1.119 1.007zM8.625 10.5a.375.375 0 11-.75 0 .375.375 0 01.75 0zm7.5 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z" />
             </svg>
          </button>
      </div>
    </aside>

    <div class="main-content">
      <header class="header">
        <div class="header-left">
           <button class="notification-btn">
             <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
               <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
             </svg>
           </button>
        </div>

        <div class="header-right">
          <div class="search-bar">
            <svg xmlns="http://www.w3.org/2000/svg" class="search-icon" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <input type="text" placeholder='Tap "/" to search' class="search-input" />
          </div>

          <button class="hexagon-btn" title="Cài đặt cửa hàng">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2L4 6.5V17.5L12 22L20 17.5V6.5L12 2Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
            <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
            </svg>
          </button>

          <div class="user-dropdown-container" ref="dropdownRef">
             <div class="avatar-wrapper" @click="toggleDropdown">
                <img :src="userStore.user?.image_url || 'https://i.pravatar.cc/150?img=68'" alt="Avatar" class="avatar" />
             </div>
             
             <transition name="fade">
               <div v-if="isDropdownOpen" class="dropdown-menu">
                  <div class="dropdown-header">
                     <p class="dd-name">{{ userStore.user?.full_name || 'Admin User' }}</p>
                     <p class="dd-role">{{ userStore.user?.role_id || 'Administrator' }}</p>
                  </div>
                  <ul class="dropdown-list">
                     <li @click="goToProfile">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" /></svg>
                        Thông tin tài khoản
                     </li>
                     <li @click="changePassword">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>
                        Đổi mật khẩu
                     </li>
                     <div class="divider"></div>
                     <li @click="logout" class="text-danger">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9" /></svg>
                        Đăng xuất
                     </li>
                  </ul>
               </div>
             </transition>
          </div>
        </div>
      </header>

      <main class="page-content">
         <slot></slot>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { useRouter } from 'vue-router'
// 1. Import thư viện SweetAlert2
import Swal from 'sweetalert2'

const userStore = useUserStore()
const router = useRouter()

// Các biến cho dropdown & sidebar
const isDropdownOpen = ref(false)
const dropdownRef = ref(null)
// Biến cho responsive sidebar
const isSidebarOpen = ref(false) 

// --- CÁC HÀM XỬ LÝ CŨ GIỮ NGUYÊN ---
const toggleDropdown = () => {
  isDropdownOpen.value = !isDropdownOpen.value
}

const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value
}

const closeSidebar = () => {
  isSidebarOpen.value = false
}

const handleLinkClick = () => {
  if (window.innerWidth <= 1024) {
    closeSidebar()
  }
}

const handleClickOutside = (event) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
    isDropdownOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})

const goToProfile = () => {
    isDropdownOpen.value = false;
    router.push('/profile') 
}

const changePassword = () => {
    isDropdownOpen.value = false;
    router.push('/change-password')
}

// --- HÀM LOGOUT MỚI (CÓ HỎI LẠI) ---
const logout = () => {
  // Đóng menu trước cho gọn
  isDropdownOpen.value = false; 

  // Hiển thị Popup hỏi
  Swal.fire({
    title: 'Đăng xuất?',
    text: "Bạn có chắc chắn muốn thoát phiên làm việc?",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#1e293b', // Màu đen (theo theme sidebar)
    cancelButtonColor: '#ef4444', // Màu đỏ
    confirmButtonText: 'Đăng xuất',
    cancelButtonText: 'Hủy',
    reverseButtons: true, // Đảo nút Hủy sang trái, Đăng xuất sang phải
    borderRadius: '12px'
  }).then((result) => {
    if (result.isConfirmed) {
      // Nếu người dùng bấm "Đăng xuất"
      userStore.logout()
      router.push('/login')
      
      // Thông báo nhỏ góc màn hình (Optional)
      const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
      })
      Toast.fire({
        icon: 'success',
        title: 'Đã đăng xuất thành công'
      })
    }
  })
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

.app-layout {
  display: flex;
  min-height: 100vh;
  background-color: #F3F5F7;
  color: #1e293b;
}

/* ================= DESKTOP STYLES (Giữ nguyên như cũ) ================= */
.sidebar {
  width: 120px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 24px 0;
  z-index: 10;
  position: sticky;
  top: 0;
  background: #f3f5f7;
}

.sidebar-logo {
  margin-bottom: 120px; 
  margin-top: 12px;
}

.logo-circle {
  width: 60px;
  height: 60px;
  background: #1e293b;
  border-radius: 50%;
  color: #4ade80;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 1.1rem;
}

.sidebar-menu {
  flex: 1;
  width: 100%;
}

.sidebar-menu ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}

.icon-box {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
  transition: all 0.3s ease;
  background: #e7e7e7;
}
.icon-box svg { width: 24px; }
.icon-box:hover { background-color: #acacac; color: #ffffff; }

.sidebar-menu li.active .icon-box {
  background-color: #1e293b;
  color: #ffffff;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
}

.add-item { margin-top: 10px; }
.add-btn {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    border: 2px dashed #9c9c9c;
    background: rgba(206, 206, 206, 0.1);
    color: #9c9c9c;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
}
.add-btn:hover { background: #a1a1a1; color: white; border-style: solid; }
.add-btn svg { width: 20px; }

.sidebar-footer {
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-top: auto;
}
.footer-icon-btn {
    background: transparent;
    border: none;
    color: #94a3b8;
    cursor: pointer;
    padding: 8px;
    border-radius: 12px;
    transition: all 0.2s;
}
.footer-icon-btn:hover { background: #f1f5f9; color: #64748b; }
.footer-icon-btn svg { width: 24px; }

/* Main & Header */
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.header {
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-left: 8rem; /* Desktop margin */
}

.notification-btn {
  position: relative;
  background: #e7e7e7;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  width: 60px;
  height: 60px;
}
.notification-btn:hover { background: #acacac; color: #ffffff; }
.notification-btn svg { width: 24px; }

.notification-dot {
  position: absolute;
  top: 9px; right: 10px;
  width: 8px; height: 8px;
  background: #ef4444;
  border-radius: 50%;
  border: 1px solid #F3F5F7;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.search-bar { position: relative; width: 300px; }
.search-input {
  width: 100%;
  padding: 17px 16px 17px 44px;
  background: #ffffff4d;
  border: 1px solid transparent;
  border-radius: 99px;
  font-size: 0.9rem;
  box-shadow: 0 2px 6px rgba(0,0,0,0.02);
  transition: all 0.2s;
  box-sizing: border-box;
}
.search-input:focus { outline: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
.search-icon {
    position: absolute;
    left: 14px; top: 50%; transform: translateY(-50%);
    width: 18px; color: #94a3b8;
}

.hexagon-btn {
    background: #e7e7e7;
    border: none;
    cursor: pointer;
    color: #94a3b8;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 6px rgba(0,0,0,0.02);
    transition: all 0.2s;
}
.hexagon-btn:hover { background: #acacac; color: #ffffff; }
.hexagon-btn svg { width: 22px; height: 22px; }

.user-dropdown-container { position: relative; }
.avatar-wrapper {
    cursor: pointer;
    padding: 2px;
    border-radius: 50%;
    border: 2px solid transparent;
    transition: border-color 0.2s;
    width: 60px;
    height: 60px;
    transition: 0.5s;
}
.avatar-wrapper:hover { border-color: #cbd5e1; width: 60px; height: 60px; }
.avatar { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; }

.dropdown-menu {
    position: absolute;
    top: 70px; right: 0;
    width: 240px;
    background: #FFFFFF;
    border-radius: 16px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
    border: 1px solid #f1f5f9;
    z-index: 100;
    overflow: hidden;
    transform-origin: top right;
}
.dropdown-header { padding: 16px; border-bottom: 1px solid #f1f5f9; background: #fafafa; }
.dd-name { font-weight: 600; color: #0f172a; font-size: 0.95rem; margin: 0; }
.dd-role { font-size: 0.75rem; color: #64748b; margin: 4px 0 0 0; }
.dropdown-list { list-style: none; padding: 8px; margin: 0; }
.dropdown-list li {
    display: flex; align-items: center; gap: 12px;
    padding: 10px 12px; font-size: 0.9rem; color: #334155;
    cursor: pointer; border-radius: 8px; transition: background 0.2s;
}
.dropdown-list li:hover { background: #f1f5f9; }
.dropdown-list li.text-danger { color: #ef4444; }
.dropdown-list li.text-danger svg { color: #ef4444; }
.dropdown-list li svg { width: 18px; }

.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease, transform 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; transform: translateY(-10px); }
.page-content { flex: 1; padding: 0 32px 32px 32px; }

/* ================= RESPONSIVE (MOBILE/TABLET < 1024px) ================= */
@media (max-width: 1024px) {
  .app-layout {
    flex-direction: column;
  }

  /* --- SIDEBAR BIẾN THÀNH BOTTOM NAV --- */
  .sidebar {
    width: 100%;
    height: 80px; /* Chiều cao cố định thanh dưới */
    position: fixed;
    bottom: 0;
    top: auto;
    flex-direction: row; /* Xếp ngang */
    border-top: 1px solid #e2e8f0;
    background: #FFFFFF;
    justify-content: center;
    padding: 0;
    box-shadow: 0 -4px 20px rgba(0,0,0,0.05);
    justify-content: flex-start;
  }

  /* Ẩn Logo và Footer button trên mobile cho đỡ chật */
  .sidebar-logo, .sidebar-footer {
    display: none;
  }

  .sidebar-menu {
    flex: 1;
    width: 100%; /* Chiếm hết chiều ngang */
    overflow-x: auto; /* Cho phép cuộn ngang */
    overflow-y: hidden; /* Ẩn cuộn dọc */
    
    /* Ẩn thanh cuộn xấu xí nhưng vẫn cho phép vuốt */
    scrollbar-width: none; /* Firefox */
    -ms-overflow-style: none; /* IE/Edge */
  }
  .sidebar-menu::-webkit-scrollbar {
    display: none;
  }

  .sidebar-menu ul {
    display: flex;
    flex-direction: row;
    align-items: center;
    /* Bỏ justify-content: space-evenly cũ */
    gap: 20px; /* Khoảng cách giữa các icon */
    padding: 0 20px; /* Cách lề trái phải một chút cho đẹp */
    margin: 0;
    height: 100%;
    
    /* Đảm bảo danh sách dài ra theo nội dung */
    width: max-content;
  }
  /* QUAN TRỌNG: Ngăn icon bị bóp méo khi màn hình nhỏ */
  .sidebar-menu li {
    flex-shrink: 0; 
  }

  .add-item { margin-top: 0; }

  /* Thu nhỏ icon trên mobile */
  .icon-box, .add-btn, .avatar-wrapper, .notification-btn, .hexagon-btn {
     width: 48px;
     height: 48px;
  }
  .notification-dot { top: 6px; right: 8px; }

  /* --- HEADER RESPONSIVE --- */
  .header {
    height: 90px;
    padding: 0 16px;
  }
  
  .header-left {
    margin-left: 0; /* Xóa margin lớn của desktop */
  }

  .header-right {
    gap: 10px;
  }

  /* Search bar thu nhỏ */
  .search-bar {
    width: 180px;
  }
  .search-input {
    padding: 12px 16px 12px 36px;
  }
  .search-icon { left: 10px; }

  /* --- CONTENT --- */
  .main-content {
    padding-bottom: 100px; /* Chừa khoảng trống dưới cùng để không bị thanh Nav che mất */
  }
  
  .page-content {
    padding: 16px;
  }
}

/* --- MOBILE NHỎ (< 480px) --- */
@media (max-width: 480px) {

   
   /* Nếu muốn click vào mới hiện input thì cần thêm JS, ở đây làm CSS đơn giản */
   .search-bar:focus-within {
       width: 150px;
       position: absolute;
       right: 70px;
       z-index: 20;
       border-radius: 99px;
   }
   .search-bar:focus-within .search-input { opacity: 1; padding: 10px 10px 10px 36px; }
   .search-bar:focus-within .search-icon { left: 10px; transform: translateY(-50%); }

}
/* --- MOBILE NHỎ (< 400px) --- */
@media (max-width: 400px) {

   
   /* Nếu muốn click vào mới hiện input thì cần thêm JS, ở đây làm CSS đơn giản */
   .search-bar {
    display: none;
   }
}
</style>