<template>
  <div class="dashboard">
    <a-row :gutter="16" style="margin-bottom: 16px;">
      <a-col :span="6">
        <a-card class="stat-card" :bordered="false">
          <a-statistic title="总预约数" :value="stats.totalReservations" :value-style="{ color: '#3f8600' }">
            <template #prefix><CalendarOutlined /></template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card class="stat-card" :bordered="false">
          <a-statistic title="今日预约" :value="stats.todayReservations" :value-style="{ color: '#1890ff' }">
            <template #prefix><ClockCircleOutlined /></template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card class="stat-card" :bordered="false">
          <a-statistic title="总用户数" :value="stats.totalUsers" :value-style="{ color: '#cf1322' }">
            <template #prefix><UserOutlined /></template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card class="stat-card" :bordered="false">
          <a-statistic title="总收入" :value="stats.totalRevenue" prefix="¥" :precision="2" :value-style="{ color: '#faad14' }" />
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="16" style="margin-bottom: 16px;">
      <a-col :span="12">
        <a-card title="最近预约" :bordered="false" class="content-card">
          <a-list :data-source="recentReservations" :loading="loading">
            <template #renderItem="{ item }">
              <a-list-item>
                <a-list-item-meta>
                  <template #title><span>预约编号: {{ item.reservationNo }}</span></template>
                  <template #description>
                    <div>
                      <a-tag :color="getStatusColor(item.status)">{{ getStatusText(item.status) }}</a-tag>
                      <span style="margin-left: 8px;">{{ item.slotDate }} {{ item.startTime }}</span>
                    </div>
                  </template>
                </a-list-item-meta>
                <div>¥{{ item.amount }}</div>
              </a-list-item>
            </template>
          </a-list>
        </a-card>
      </a-col>
      <a-col :span="12">
        <a-card title="场馆使用率" :bordered="false" class="content-card">
          <div style="height: 300px; display: flex; align-items: center; justify-content: center;">
            <a-progress type="dashboard" :percent="stats.venueUsageRate" :format="percent => `${percent}%`" />
          </div>
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="16">
      <a-col :span="24">
        <a-card title="快捷操作" :bordered="false" class="content-card">
          <a-space size="large">
            <a-button type="primary" size="large" @click="$router.push('/venues')">
              <ShopOutlined /> 管理场馆
            </a-button>
            <a-button type="primary" size="large" @click="$router.push('/courts')">
              <AppstoreOutlined /> 管理场地
            </a-button>
            <a-button type="primary" size="large" @click="$router.push('/reservations')">
              <CalendarOutlined /> 查看预约
            </a-button>
            <a-button type="primary" size="large" @click="$router.push('/users')">
              <TeamOutlined /> 用户管理
            </a-button>
          </a-space>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { CalendarOutlined, ClockCircleOutlined, UserOutlined, ShopOutlined, AppstoreOutlined, TeamOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'

const router = useRouter()
const loading = ref(false)
const stats = ref({ totalReservations: 0, todayReservations: 0, totalUsers: 0, totalRevenue: 0, venueUsageRate: 0 })
const recentReservations = ref([])

const statusMap = { PENDING_PAYMENT: '待支付', PAID: '已支付', CONFIRMED: '已确认', IN_PROGRESS: '进行中', COMPLETED: '已完成', CANCELLED: '已取消' }
const statusColorMap = { PENDING_PAYMENT: 'orange', PAID: 'blue', CONFIRMED: 'cyan', IN_PROGRESS: 'purple', COMPLETED: 'green', CANCELLED: 'red' }

const getStatusText = (status) => statusMap[status] || status
const getStatusColor = (status) => statusColorMap[status] || 'default'

const loadStats = async () => {
  loading.value = true
  try {
    const [reservationsRes, usersRes, paymentsRes] = await Promise.all([
      request({ url: '/reservations', params: { page: 1, size: 10 } }),
      request({ url: '/users', params: { page: 1, size: 1 } }),
      request({ url: '/payments', params: { page: 1, size: 100, paymentStatus: 'SUCCESS' } })
    ])
    stats.value.totalReservations = reservationsRes.data.total || 0
    stats.value.totalUsers = usersRes.data.total || 0
    const payments = paymentsRes.data.records || []
    stats.value.totalRevenue = payments.reduce((sum, p) => sum + (p.amount || 0), 0)
    const today = new Date().toISOString().split('T')[0]
    stats.value.todayReservations = reservationsRes.data.records.filter(r => r.slotDate === today).length
    stats.value.venueUsageRate = Math.min(Math.round((stats.value.totalReservations / 1000) * 100), 100)
    recentReservations.value = reservationsRes.data.records.slice(0, 5)
  } catch (error) {
    console.error('加载统计数据失败:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => { loadStats() })
</script>

<style scoped>
.dashboard { padding: 24px; background: #f0f2f5; min-height: calc(100vh - 64px); }
.stat-card { border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.stat-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.15); transform: translateY(-2px); transition: all 0.3s; }
.content-card { border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
</style>
