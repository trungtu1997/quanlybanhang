import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './assets/global.css'
import App from './App.vue'
import router from './router'
//import 'bootstrap/dist/css/bootstrap.css'
import '@fontsource/quicksand'; // Default: 400 weight
import '@fontsource/quicksand/500.css'; // Medium nếu cần
import '@fontsource/quicksand/700.css'; // Bold cho heading

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.mount('#app')