<template>
  <div>
    <div style="margin-bottom: 16px; display: flex; justify-content: space-between;">
      <a-select v-model:value="typeFilter" placeholder="公告类型" style="width: 150px;" @change="loadData" allowClear>
        <a-select-option value="SYSTEM">系统公告</a-select-option>
        <a-select-option value="ACTIVITY">活动公告</a-select-option>
        <a-select-option value="VENUE">场馆公告</a-select-option>
      </a-select>
      <a-button type="primary" @click="showModal()">
        <PlusOutlined /> 新增公告
      </a-button>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'type'">
          <a-tag color="blue">{{ getTypeName(record.type) }}</a-tag>
        </template>
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === 'PUBLISHED' ? 'green' : 'orange'">
            {{ record.status === 'PUBLISHED' ? '已发布' : '草稿' }}
          </a-tag>
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

    <a-modal v-model:open="visible" :title="modalTitle" @ok="handleSubmit" width="700px">
      <a-form :model="form" :label-col="{ span: 4 }">
        <a-form-item label="标题" required>
          <a-input v-model:value="form.title" />
        </a-form-item>
        <a-form-item label="类型" required>
          <a-select v-model:value="form.type">
            <a-select-option value="SYSTEM">系统公告</a-select-option>
            <a-select-option value="ACTIVITY">活动公告</a-select-option>
            <a-select-option value="VENUE">场馆公告</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="内容" required>
          <a-textarea v-model:value="form.content" :rows="6" />
        </a-form-item>
        <a-form-item label="状态">
          <a-select v-model:value="form.status">
            <a-select-option value="DRAFT">草稿</a-select-option>
            <a-select-option value="PUBLISHED">发布</a-select-option>
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

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
  { title: '标题', dataIndex: 'title', key: 'title' },
  { title: '类型', key: 'type', width: 120 },
  { title: '状态', key: 'status', width: 100 },
  { title: '发布时间', dataIndex: 'publishTime', key: 'publishTime', width: 180 },
  { title: '操作', key: 'action', width: 150 }
]

const data = ref([])
const loading = ref(false)
const typeFilter = ref(null)
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const visible = ref(false)
const modalTitle = ref('新增公告')
const form = ref({})

const typeMap = {
  SYSTEM: '系统公告',
  ACTIVITY: '活动公告',
  VENUE: '场馆公告'
}

const getTypeName = (type) => typeMap[type] || type

const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.current,
      size: pagination.value.pageSize
    }
    if (typeFilter.value) params.type = typeFilter.value
    
    const res = await request({ url: '/announcements', params })
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
    modalTitle.value = '编辑公告'
    form.value = { ...record }
  } else {
    modalTitle.value = '新增公告'
    form.value = { status: 'DRAFT', type: 'SYSTEM' }
  }
  visible.value = true
}

const handleSubmit = async () => {
  try {
    if (form.value.status === 'PUBLISHED' && !form.value.publishTime) {
      form.value.publishTime = new Date().toISOString()
    }
    
    if (form.value.id) {
      await request({ url: `/announcements/${form.value.id}`, method: 'put', data: form.value })
      message.success('更新成功')
    } else {
      await request({ url: '/announcements', method: 'post', data: form.value })
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
    await request({ url: `/announcements/${id}`, method: 'delete' })
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
