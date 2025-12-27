<template>
  <a-layout style="min-height: 100vh">
    <a-layout-sider v-model:collapsed="collapsed" collapsible>
      <div class="logo">场地预约系统</div>
      <a-menu v-model:selectedKeys="selectedKeys" theme="dark" mode="inline">
        <a-menu-item key="dashboard" @click="navigate('/dashboard')">
          <DashboardOutlined />
          <span>仪表盘</span>
        </a-menu-item>
        <a-menu-item key="venues" @click="navigate('/venues')">
          <ShopOutlined />
          <span>场馆管理</span>
        </a-menu-item>
        <a-menu-item key="courts" @click="navigate('/courts')">
          <AppstoreOutlined />
          <span>场地管理</span>
        </a-menu-item>
        <a-menu-item key="reservations" @click="navigate('/reservations')">
          <CalendarOutlined />
          <span>预约管理</span>
        </a-menu-item>
        <a-menu-item key="users" @click="navigate('/users')">
          <TeamOutlined />
          <span>用户管理</span>
        </a-menu-item>
        <a-menu-item key="announcements" @click="navigate('/announcements')">
          <NotificationOutlined />
          <span>公告管理</span>
        </a-menu-item>
        <a-menu-item key="payments" @click="navigate('/payments')">
          <DollarOutlined />
          <span>支付管理</span>
        </a-menu-item>
        <a-menu-item key="coupons" @click="navigate('/coupons')">
          <GiftOutlined />
          <span>优惠券管理</span>
        </a-menu-item>
        <a-menu-item key="feedback" @click="navigate('/feedback')">
          <MessageOutlined />
          <span>反馈管理</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
    <a-layout>
      <a-layout-header style="background: #fff; padding: 0 20px; display: flex; justify-content: space-between; align-items: center;">
        <div></div>
        <a-dropdown>
          <a class="ant-dropdown-link" @click.prevent>
            <UserOutlined /> {{ userStore.userInfo.username }}
          </a>
          <template #overlay>
            <a-menu>
              <a-menu-item @click="handleLogout">
                <LogoutOutlined /> 退出登录
              </a-menu-item>
            </a-menu>
          </template>
        </a-dropdown>
      </a-layout-header>
      <a-layout-content style="margin: 16px; padding: 24px; background: #fff; min-height: 280px;">
        <router-view />
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { 
  DashboardOutlined, 
  ShopOutlined, 
  AppstoreOutlined, 
  CalendarOutlined,
  TeamOutlined,
  NotificationOutlined,
  DollarOutlined,
  GiftOutlined,
  MessageOutlined,
  UserOutlined,
  LogoutOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const collapsed = ref(false)
const selectedKeys = ref(['dashboard'])

watch(() => route.path, (path) => {
  const key = path.split('/')[1] || 'dashboard'
  selectedKeys.value = [key]
}, { immediate: true })

const navigate = (path) => {
  router.push(path)
}

const handleLogout = () => {
  userStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.logo {
  height: 32px;
  margin: 16px;
  color: white;
  font-size: 18px;
  font-weight: bold;
  text-align: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 8px;
  line-height: 32px;
}

:deep(.ant-layout-sider) {
  background: #001529;
}

:deep(.ant-menu-dark) {
  background: #001529;
}

:deep(.ant-menu-item:hover) {
  background: rgba(255,255,255,0.1) !important;
}

:deep(.ant-menu-item-selected) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
}

:deep(.ant-layout-header) {
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.ant-dropdown-link {
  color: #333;
  font-size: 14px;
  cursor: pointer;
  padding: 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.ant-dropdown-link:hover {
  color: #1890ff;
}
</style>
