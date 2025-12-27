<template>
  <div>
    <div style="margin-bottom: 16px; display: flex; justify-content: space-between;">
      <a-select v-model:value="statusFilter" placeholder="优惠券状态" style="width: 200px;" @change="loadData" allowClear>
        <a-select-option value="ACTIVE">有效</a-select-option>
        <a-select-option value="INACTIVE">无效</a-select-option>
        <a-select-option value="EXPIRED">已过期</a-select-option>
      </a-select>
      <a-button type="primary" @click="showModal()">
        <PlusOutlined /> 新增优惠券
      </a-button>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'type'">
          <a-tag :color="record.type === 'AMOUNT' ? 'blue' : 'green'">
            {{ record.type === 'AMOUNT' ? '满减' : '折扣' }}
          </a-tag>
        </template>
        <template v-if="column.key === 'value'">
          {{ record.type === 'AMOUNT' ? `¥${record.value}` : `${record.value}折` }}
        </template>
        <template v-if="column.key === 'status'">
          <a-tag :color="getStatusColor(record.status)">
            {{ getStatusText(record.status) }}
          </a-tag>
        </template>
        <template v-if="column.key === 'usage'">
          {{ record.usedQuantity }} / {{ record.totalQuantity }}
        </template>
        <template v-if="column.key === 'action'">
          <a-space>
            <a @click="showModal(record)">编辑</a>
            <a-popconfirm title="确定删除?" @confirm="handleDelete(record.id)">
              <a style="color: red;">删除</a>
            </a-popconfirm>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal v-model:open="visible" :title="modalTitle" @ok="handleSubmit" width="600px">
      <a-form :model="form" :label-col="{ span: 6 }">
        <a-form-item label="优惠券码" required>
          <a-input v-model:value="form.code" />
        </a-form-item>
        <a-form-item label="名称" required>
          <a-input v-model:value="form.name" />
        </a-form-item>
        <a-form-item label="类型" required>
          <a-select v-model:value="form.type">
            <a-select-option value="AMOUNT">满减</a-select-option>
            <a-select-option value="PERCENTAGE">折扣</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="面值/折扣" required>
          <a-input-number v-model:value="form.value" :min="0" style="width: 100%;" />
        </a-form-item>
        <a-form-item label="最低消费">
          <a-input-number v-model:value="form.minAmount" :min="0" style="width: 100%;" />
        </a-form-item>
        <a-form-item label="生效时间" required>
          <a-date-picker v-model:value="form.startTime" show-time style="width: 100%;" />
        </a-form-item>
        <a-form-item label="失效时间" required>
          <a-date-picker v-model:value="form.endTime" show-time style="width: 100%;" />
        </a-form-item>
        <a-form-item label="总数量" required>
          <a-input-number v-model:value="form.totalQuantity" :min="1" style="width: 100%;" />
        </a-form-item>
        <a-form-item label="状态">
          <a-select v-model:value="form.status">
            <a-select-option value="ACTIVE">有效</a-select-option>
            <a-select-option value="INACTIVE">无效</a-select-option>
          </a-select>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { PlusOutlined } from '@ant-design/icons-vue'
import request from '@/utils/request'
import dayjs from 'dayjs'

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
  { title: '优惠券码', dataIndex: 'code', key: 'code' },
  { title: '名称', dataIndex: 'name', key: 'name' },
  { title: '类型', key: 'type', width: 100 },
  { title: '面值', key: 'value', width: 100 },
  { title: '最低消费', dataIndex: 'minAmount', key: 'minAmount', width: 100 },
  { title: '使用情况', key: 'usage', width: 120 },
  { title: '状态', key: 'status', width: 100 },
  { title: '操作', key: 'action', width: 150 }
]

const data = ref([])
const loading = ref(false)
const statusFilter = ref(null)
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const visible = ref(false)
const modalTitle = ref('新增优惠券')
const form = ref({})

const statusMap = {
  ACTIVE: '有效',
  INACTIVE: '无效',
  EXPIRED: '已过期'
}

const statusColorMap = {
  ACTIVE: 'green',
  INACTIVE: 'gray',
  EXPIRED: 'red'
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
    
    const res = await request({ url: '/coupons', params })
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

const showModal = (record) => {
  if (record) {
    modalTitle.value = '编辑优惠券'
    form.value = { 
      ...record,
      startTime: record.startTime ? dayjs(record.startTime) : null,
      endTime: record.endTime ? dayjs(record.endTime) : null
    }
  } else {
    modalTitle.value = '新增优惠券'
    form.value = { status: 'ACTIVE', type: 'AMOUNT', minAmount: 0, totalQuantity: 100 }
  }
  visible.value = true
}

const handleSubmit = async () => {
  try {
    const submitData = {
      ...form.value,
      startTime: form.value.startTime ? form.value.startTime.format('YYYY-MM-DD HH:mm:ss') : null,
      endTime: form.value.endTime ? form.value.endTime.format('YYYY-MM-DD HH:mm:ss') : null
    }
    
    if (form.value.id) {
      await request({ url: `/coupons/${form.value.id}`, method: 'put', data: submitData })
      message.success('更新成功')
    } else {
      await request({ url: '/coupons', method: 'post', data: submitData })
      message.success('创建成功')
    }
    visible.value = false
    loadData()
  } catch (error) {
    console.error(error)
  }
}

const handleDelete = async (id) => {
  try {
    await request({ url: `/coupons/${id}`, method: 'delete' })
    message.success('删除成功')
    loadData()
  } catch (error) {
    console.error(error)
  }
}

onMounted(() => {
  loadData()
})
</script>
