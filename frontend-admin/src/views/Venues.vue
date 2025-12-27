<template>
  <div>
    <div style="margin-bottom: 16px; display: flex; justify-content: space-between;">
      <a-input-search v-model:value="keyword" placeholder="搜索场馆" style="width: 300px;" @search="loadData" />
      <a-button type="primary" @click="showModal()">
        <PlusOutlined /> 新增场馆
      </a-button>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === 'OPEN' ? 'green' : 'red'">
            {{ record.status === 'OPEN' ? '开放' : '关闭' }}
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

    <a-modal v-model:open="visible" :title="modalTitle" @ok="handleSubmit" width="600px">
      <a-form :model="form" :label-col="{ span: 6 }">
        <a-form-item label="场馆名称" required>
          <a-input v-model:value="form.name" />
        </a-form-item>
        <a-form-item label="地址" required>
          <a-input v-model:value="form.address" />
        </a-form-item>
        <a-form-item label="联系电话">
          <a-input v-model:value="form.contactPhone" />
        </a-form-item>
        <a-form-item label="描述">
          <a-textarea v-model:value="form.description" :rows="4" />
        </a-form-item>
        <a-form-item label="开放时间">
          <a-time-picker v-model:value="form.openTime" format="HH:mm" />
        </a-form-item>
        <a-form-item label="关闭时间">
          <a-time-picker v-model:value="form.closeTime" format="HH:mm" />
        </a-form-item>
        <a-form-item label="状态">
          <a-select v-model:value="form.status">
            <a-select-option value="OPEN">开放</a-select-option>
            <a-select-option value="CLOSED">关闭</a-select-option>
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
import { getVenueList, createVenue, updateVenue, deleteVenue } from '@/api/venue'

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id' },
  { title: '场馆名称', dataIndex: 'name', key: 'name' },
  { title: '地址', dataIndex: 'address', key: 'address' },
  { title: '联系电话', dataIndex: 'contactPhone', key: 'contactPhone' },
  { title: '状态', key: 'status' },
  { title: '操作', key: 'action', width: 150 }
]

const data = ref([])
const loading = ref(false)
const keyword = ref('')
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const visible = ref(false)
const modalTitle = ref('新增场馆')
const form = ref({})

const loadData = async () => {
  loading.value = true
  try {
    const res = await getVenueList({
      page: pagination.value.current,
      size: pagination.value.pageSize,
      keyword: keyword.value
    })
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
    modalTitle.value = '编辑场馆'
    form.value = { ...record }
  } else {
    modalTitle.value = '新增场馆'
    form.value = { status: 'OPEN' }
  }
  visible.value = true
}

const handleSubmit = async () => {
  try {
    if (form.value.id) {
      await updateVenue(form.value.id, form.value)
      message.success('更新成功')
    } else {
      await createVenue(form.value)
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
    await deleteVenue(id)
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
