<template>
  <div class="container mt-5">
    <div class="alert alert-success">
      <h2>🎉 Đăng nhập thành công!</h2>
      <p>Xin chào <strong>{{ userStore.user?.full_name || 'Admin' }}</strong></p>
      <p>Role: {{ userStore.user?.role_id }}</p>
    </div>
    
    <h3>Dashboard đang xây dựng...</h3>
    <p>Realtime orders và tồn kho sẽ hiện ở đây sớm thôi!</p>
    
    <button @click="logout" class="btn btn-danger">Đăng Xuất</button>
  </div>
</template>

<script setup>
import { useUserStore } from '../stores/user'
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const router = useRouter()

const logout = () => {
  userStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.container {
  max-width: 800px;
}
</style>