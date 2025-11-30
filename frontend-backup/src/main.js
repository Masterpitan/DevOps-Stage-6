import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import { createStore } from 'vuex'
import axios from 'axios'
import 'bootstrap/dist/css/bootstrap.css'

import App from './components/App.vue'

// Simple router setup
const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: () => import('./components/Login.vue') },
    { path: '/todos', component: () => import('./components/Todos.vue') }
  ]
})

// Simple store setup
const store = createStore({
  state: {
    user: null,
    todos: []
  },
  mutations: {
    setUser(state, user) {
      state.user = user
    },
    setTodos(state, todos) {
      state.todos = todos
    }
  }
})

const app = createApp(App)
app.use(router)
app.use(store)
app.config.globalProperties.$http = axios
app.mount('#app')