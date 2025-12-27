<template>
  <div>
    <div style="margin-bottom: 16px;">
      <a-select v-model:value="statusFilter" placeholder="支付状态" style="width: 200px;" @change="loadData" allowClear>
        <a-select-option value="PENDING">待支付</a-select-option>
        <a-select-option value="SUCCESS">支付成功</a-select-option>
        <a-select-option value="FAILED">支付失败</a-select-option>
        <a-select-option value="REFUNDED">已退款</a-select-option>
      </a-select>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'amount'">
          ¥{{ record.amount }}
        </template>
        <template v-if="column.key === 'paymentMethod'">
          <a-tag>{{ getPaymentMethodText(record.paymentMethod) }}</a-tag>
        </template>
        <template v-if="column.key === 'paymentStatus'">
          <a-tag :color="getStatusColor(record.paymentStatus)">
            {{ getStatusText(record.paymentStatus) }}
          </a-tag>
        </template>
        <template v-if="column.key === 'action'">
          <a-space>
            <a @click="viewDetail(record)">查看</a>
            <a v-if="record.paymentStatus === 'SUCCESS'" @click="handleRefund(record.id)" style="color: orange;">退款</a>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal v-model:open="detailVisible" title="支付详情" width="600px" :footer="null">
      <a-descriptions :column="1" bordered v-if="currentRecord">
        <a-descriptions-item label="支付单号">{{ currentRecord.paymentNo }}</a-descriptions-item>
        <a-descriptions-item label="预约ID">{{ currentRecord.reservationId }}</a-descriptions-item>
        <a-descriptions-item label="支付金额">¥{{ currentRecord.amount }}</a-descriptions-item>
        <a-descriptions-item label="支付方式">{{ getPaymentMethodText(currentRecord.paymentMethod) }}</a-descriptions-item>
        <a-descriptions-item label="支付状态">
          <a-tag :color="getStatusColor(currentRecord.paymentStatus)">
            {{ getStatusText(currentRecord.paymentStatus) }}
          </a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="第三方交易号">{{ currentRecord.transactionNo || '-' }}</a-descriptions-item>
        <a-descriptions-item label="支付时间">{{ currentRecord.paidAt || '-' }}</a-descriptions-item>
        <a-descriptions-item label="退款金额">{{ currentRecord.refundAmount ? `¥${currentRecord.refundAmount}` : '-' }}</a-descriptions-item>
        <a-descriptions-item label="退款时间">{{ currentRecord.refundedAt || '-' }}</a-descriptions-item>
        <a-descriptions-item label="创建时间">{{ currentRecord.createdAt }}</a-descriptions-item>
      </a-descriptions>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import request from '@/utils/request'

const columns = [
  { title: '支付单号', dataIndex: 'paymentNo', key: 'paymentNo' },
  { title: '预约ID', dataIndex: 'reservationId', key: 'reservationId', width: 100 },
  { title: '金额', key: 'amount', width: 100 },
  { title: '支付方式', key: 'paymentMethod', width: 120 },
  { title: '状态', key: 'paymentStatus', width: 120 },
  { title: '支付时间', dataIndex: 'paidAt', key: 'paidAt' },
  { title: '操作', key: 'action', width: 150 }
]

const data = ref([])
const loading = ref(false)
const statusFilter = ref(null)
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const detailVisible = ref(false)
const currentRecord = ref(null)

const paymentMethodMap = {
  WECHAT: '微信支付',
  ALIPAY: '支付宝',
  CASH: '现金',
  BALANCE: '余额'
}

const statusMap = {
  PENDING: '待支付',
  SUCCESS: '支付成功',
  FAILED: '支付失败',
  REFUNDED: '已退款'
}

const statusColorMap = {
  PENDING: 'orange',
  SUCCESS: 'green',
  FAILED: 'red',
  REFUNDED: 'gray'
}

const getPaymentMethodText = (method) => paymentMethodMap[method] || method
const getStatusText = (status) => statusMap[status] || status
const getStatusColor = (status) => statusColorMap[status] || 'default'

const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.current,
      size: pagination.value.pageSize
    }
    if (statusFilter.value) params.paymentStatus = statusFilter.value
    
    const res = await request({ url: '/payments', params })
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

const handleRefund = (id) => {
  Modal.confirm({
    title: '确认退款',
    content: '确定要对此订单进行退款吗？',
    onOk: async () => {
      try {
        await request({ url: `/payments/${id}/refund`, method: 'put' })
        message.success('退款成功')
        loadData()
      } catch (error) {
        console.error(error)
      }
    }
  })
}

onMounted(() => {
  loadData()
})
</script>
