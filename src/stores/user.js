import { defineStore } from 'pinia'
import { supabase } from '../supabase'

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null // {id, username, full_name, role_id, ...}
  }),
  actions: {
    async login(username, password) {
      const { data, error } = await supabase.rpc('login_user', {
        u_username: username,
        u_password: password
      })
      if (error) {
        console.error('Lỗi login:', error)
        return { success: false, message: error.message }
      }
      if (data.success) {
        this.user = {
          id: data.id,
          username: data.username,
          full_name: data.full_name,
          role_id: data.role_id,
          image_url: data.image_url
        }
        // Lưu vào localStorage để giữ login khi refresh
        localStorage.setItem('user', JSON.stringify(this.user))
        return { success: true }
      } else {
        return { success: false, message: data.message }
      }
    },
    logout() {
      this.user = null
      localStorage.removeItem('user')
    },
    loadFromStorage() {
      const saved = localStorage.getItem('user')
      if (saved) this.user = JSON.parse(saved)
    }
  }
})