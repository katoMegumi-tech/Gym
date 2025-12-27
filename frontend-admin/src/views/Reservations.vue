<template>
  <div>
    <div style="margin-bottom: 16px;">
      <a-select v-model:value="statusFilter" placeholder="预约状态" style="width: 200px;" @change="loadData" allowClear>
        <a-select-option value="PENDING_PAYMENT">待支付</a-select-option>
        <a-select-option value="PAID">已支付</a-select-option>
        <a-select-option value="CONFIRMED">已确认</a-select-option>
        <a-select-option value="COMPLETED">已完成</a-select-option>
        <a-select-option value="CANCELLED">已取消</a-select-option>
      </a-select>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'status'">
          <a-tag :color="getStatusColor(record.status)">
            {{ getStatusText(record.status) }}
          </a-tag>
        </template>
        <template v-if="column.key === 'amount'">
          ¥{{ record.amount }}
        </template>
        <template v-if="column.key === 'action'">
          <a-space>
            <a @click="viewDetail(record)">查看</a>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal v-model:open="detailVisible" title="预约详情" width="600px" :footer="null">
      <a-descriptions :column="1" bordered v-if="currentRecord">
        <a-descriptions-item label="预约编号">{{ currentRecord.reservationNo }}</a-descriptions-item>
        <a-descriptions-item label="场地ID">{{ currentRecord.courtId }}</a-descriptions-item>
        <a-descriptions-item label="预约日期">{{ currentRecord.slotDate }}</a-descriptions-item>
        <a-descriptions-item label="时间段">{{ currentRecord.startTime }} - {{ currentRecord.endTime }}</a-descriptions-item>
        <a-descriptions-item label="金额">¥{{ currentRecord.amount }}</a-descriptions-item>
        <a-descriptions-item label="参与人数">{{ currentRecord.participants }}人</a-descriptions-item>
        <a-descriptions-item label="联系人">{{ currentRecord.contactName }}</a-descriptions-item>
        <a-descriptions-item label="联系电话">{{ currentRecord.contactPhone }}</a-descriptions-item>
        <a-descriptions-item label="状态">
          <a-tag :color="getStatusColor(currentRecord.status)">
            {{ getStatusText(currentRecord.status) }}
          </a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="创建时间">{{ currentRecord.createdAt }}</a-descriptions-item>
      </a-descriptions>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const columns = [
  { title: '预约编号', dataIndex: 'reservationNo', key: 'reservationNo' },
  { title: '用户ID', dataIndex: 'userId', key: 'userId', width: 100 },
  { title: '场地ID', dataIndex: 'courtId', key: 'courtId', width: 100 },
  { title: '预约日期', dataIndex: 'slotDate', key: 'slotDate' },
  { title: '时间', dataIndex: 'startTime', key: 'startTime' },
  { title: '金额', key: 'amount', width: 100 },
  { title: '状态', key: 'status', width: 120 },
  { title: '操作', key: 'action', width: 100 }
]

const data = ref([])
const loading = ref(false)
const statusFilter = ref(null)
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const detailVisible = ref(false)
const currentRecord = ref(null)

const statusMap = {
  PENDING_PAYMENT: '待支付',
  PAID: '已支付',
  CONFIRMED: '已确认',
  IN_PROGRESS: '进行中',
  COMPLETED: '已完成',
  CANCELLED: '已取消',
  REFUNDED: '已退款'
}

const statusColorMap = {
  PENDING_PAYMENT: 'orange',
  PAID: 'blue',
  CONFIRMED: 'cyan',
  IN_PROGRESS: 'purple',
  COMPLETED: 'green',
  CANCELLED: 'red',
  REFUNDED: 'gray'
}

const getStatusText = (status) => statusMap[status] || status
const getStatusColor = (status) => statusColorMap[status] || 'default'

const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.current,
      size: pagination.value.pageSize
    }
    if (statusFilter.value) params.status = statusFilter.value
    
    const res = await request({ url: '/reservations', params })
    data.value = res.data.records
    pagination.value.total = res.data.total
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleTableChange = (pag) => {
  pagination.value.current = pag.current
  loadData()
}

const viewDetail = (record) => {
  currentRecord.value = record
  detailVisible.value = true
}

onMounted(() => {
  loadData()
})
</script>
