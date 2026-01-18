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

    <a-row :gutter="16" style="margin-bottom: 16px;">
      <a-col :span="12">
        <a-card title="预约状态分布" :bordered="false" class="content-card">
          <div class="status-stats">
            <div class="status-item" v-for="(count, status) in stats.reservationByStatus" :key="status">
              <a-tag :color="getStatusColor(status)">{{ getStatusText(status) }}</a-tag>
              <span class="count">{{ count }}</span>
            </div>
          </div>
        </a-card>
      </a-col>
      <a-col :span="12">
        <a-card title="今日收入" :bordered="false" class="content-card">
          <div style="text-align: center; padding: 40px 0;">
            <div style="font-size: 48px; color: #faad14; font-weight: bold;">¥{{ stats.todayRevenue || 0 }}</div>
            <div style="color: #999; margin-top: 10px;">今日已收款金额</div>
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
            <a-button size="large" @click="generateTimeslots">
              <SyncOutlined /> 生成时间段
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
import { message } from 'ant-design-vue'
import { CalendarOutlined, ClockCircleOutlined, UserOutlined, ShopOutlined, AppstoreOutlined, TeamOutlined, SyncOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'

const router = useRouter()
const loading = ref(false)
const stats = ref({ 
  totalReservations: 0, 
  todayReservations: 0, 
  totalUsers: 0, 
  totalRevenue: 0, 
  todayRevenue: 0,
  venueUsageRate: 0,
  reservationByStatus: {}
})
const recentReservations = ref([])

const statusMap = { PENDING_PAYMENT: '待支付', PAID: '已支付', CONFIRMED: '已确认', IN_PROGRESS: '进行中', COMPLETED: '已完成', CANCELLED: '已取消', REFUNDED: '已退款' }
const statusColorMap = { PENDING_PAYMENT: 'orange', PAID: 'blue', CONFIRMED: 'cyan', IN_PROGRESS: 'purple', COMPLETED: 'green', CANCELLED: 'red', REFUNDED: 'gray' }

const getStatusText = (status) => statusMap[status] || status
const getStatusColor = (status) => statusColorMap[status] || 'default'

const loadStats = async () => {
  loading.value = true
  try {
    // 使用新的统计接口
    const [statsRes, reservationsRes, usersRes] = await Promise.all([
      request({ url: '/statistics/dashboard' }),
      request({ url: '/reservations', params: { page: 1, size: 5 } }),
      request({ url: '/users', params: { page: 1, size: 1 } })
    ])
    
    stats.value = {
      ...statsRes.data,
      totalUsers: usersRes.data.total || 0
    }
    recentReservations.value = reservationsRes.data.records || []
  } catch (error) {
    console.error('加载统计数据失败:', error)
  } finally {
    loading.value = false
  }
}

const generateTimeslots = async () => {
  try {
    await request({ url: '/timeslots/generate', method: 'POST', params: { days: 7 } })
    message.success('时间段生成成功')
  } catch (error) {
    message.error('生成失败')
  }
}

onMounted(() => { loadStats() })
</script>

<style scoped>
.dashboard { padding: 24px; background: #f0f2f5; min-height: calc(100vh - 64px); }
.stat-card { border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.stat-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.15); transform: translateY(-2px); transition: all 0.3s; }
.content-card { border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.status-stats { display: flex; flex-wrap: wrap; gap: 16px; padding: 20px 0; }
.status-item { display: flex; align-items: center; gap: 8px; }
.status-item .count { font-size: 20px; font-weight: bold; color: #333; }
</style>
