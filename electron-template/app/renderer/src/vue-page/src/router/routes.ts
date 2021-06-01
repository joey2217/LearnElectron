import { RouteRecordRaw } from 'vue-router'
import Home from '../views/home/index.vue'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: Home,
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/about/index.vue'),
  },
]

export default routes
