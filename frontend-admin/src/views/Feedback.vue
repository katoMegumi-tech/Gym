<template>
  <div>
    <div style="margin-bottom: 16px;">
      <a-select v-model:value="statusFilter" placeholder="反馈状态" style="width: 200px;" @change="loadData" allowClear>
        <a-select-option value="PENDING">待处理</a-select-option>
        <a-select-option value="PROCESSING">处理中</a-select-option>
        <a-select-option value="RESOLVED">已解决</a-select-option>
        <a-select-option value="CLOSED">已关闭</a-select-option>
      </a-select>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'type'">
          <a-tag :color="getTypeColor(record.type)">
            {{ getTypeText(record.type) }}
          </a-tag>
        </template>
        <template v-if="column.key === 'rating'">
          <a-rate v-model:value="record.rating" disabled />
        </template>
        <template v-if="column.key === 'status'">
          <a-tag :color="getStatusColor(record.status)">
            {{ getStatusText(record.status) }}
          </a-tag>
        </template>
        <template v-if="column.key === 'action'">
          <a-space>
            <a @click="viewDetail(record)">查看</a>
            <a v-if="!record.reply" @click="showReplyModal(record)">回复</a>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal v-model:open="detailVisible" title="反馈详情" width="600px" :footer="null">
      <a-descriptions :column="1" bordered v-if="currentRecord">
        <a-descriptions-item label="用户ID">{{ currentRecord.userId }}</a-descriptions-item>
        <a-descriptions-item label="类型">
          <a-tag :color="getTypeColor(currentRecord.type)">
            {{ getTypeText(currentRecord.type) }}
          </a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="标题">{{ currentRecord.title }}</a-descriptions-item>
        <a-descriptions-item label="内容">{{ currentRecord.content }}</a-descriptions-item>
        <a-descriptions-item label="评分" v-if="currentRecord.rating">
          <a-rate v-model:value="currentRecord.rating" disabled />
        </a-descriptions-item>
        <a-descriptions-item label="回复" v-if="currentRecord.reply">{{ currentRecord.reply }}</a-descriptions-item>
        <a-descriptions-item label="回复时间" v-if="currentRecord.repliedAt">{{ currentRecord.repliedAt }}</a-descriptions-item>
        <a-descriptions-item label="状态">
          <a-tag :color="getStatusColor(currentRecord.status)">
            {{ getStatusText(currentRecord.status) }}
          </a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="创建时间">{{ currentRecord.createdAt }}</a-descriptions-item>
      </a-descriptions>
    </a-modal>

    <a-modal v-model:open="replyVisible" title="回复反馈" @ok="handleReply" width="500px">
      <a-textarea v-model:value="replyContent" :rows="4" placeholder="请输入回复内容" />
    </a-modal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import request from '@/utils/request'

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
  { title: '用户ID', dataIndex: 'userId', key: 'userId', width: 100 },
  { title: '类型', key: 'type', width: 100 },
  { title: '标题', dataIndex: 'title', key: 'title' },
  { title: '评分', key: 'rating', width: 150 },
  { title: '状态', key: 'status', width: 100 },
  { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
  { title: '操作', key: 'action', width: 150 }
]

const data = ref([])
const loading = ref(false)
const statusFilter = ref(null)
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const detailVisible = ref(false)
const replyVisible = ref(false)
const currentRecord = ref(null)
const replyContent = ref('')

const typeMap = {
  COMPLAINT: '投诉',
  SUGGESTION: '建议',
  QUESTION: '咨询'
}

const typeColorMap = {
  COMPLAINT: 'red',
  SUGGESTION: 'blue',
  QUESTION: 'green'
}

const statusMap = {
  PENDING: '待处理',
  PROCESSING: '处理中',
  RESOLVED: '已解决',
  CLOSED: '已关闭'
}

const statusColorMap = {
  PENDING: 'orange',
  PROCESSING: 'blue',
  RESOLVED: 'green',
  CLOSED: 'gray'
}

const getTypeText = (type) => typeMap[type] || type
const getTypeColor = (type) => typeColorMap[type] || 'default'
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
    
    const res = await request({ url: '/feedback', params })
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

const showReplyModal = (record) => {
  currentRecord.value = record
  replyContent.value = ''
  replyVisible.value = true
}

const handleReply = async () => {
  if (!replyContent.value) {
    message.error('请输入回复内容')
    return
  }
  
  try {
    await request({ 
      url: `/feedback/${currentRecord.value.id}/reply`, 
      method: 'put',
      params: { reply: replyContent.value }
    })
    message.success('回复成功')
    replyVisible.value = false
    loadData()
  } catch (error) {
    console.error(error)
  }
}

onMounted(() => {
  loadData()
})
</script>
