<template>
  <div>
    <div style="margin-bottom: 16px; display: flex; justify-content: space-between;">
      <a-space>
        <a-select v-model:value="venueId" placeholder="选择场馆" style="width: 200px;" @change="loadData" allowClear>
          <a-select-option v-for="venue in venues" :key="venue.id" :value="venue.id">
            {{ venue.name }}
          </a-select-option>
        </a-select>
        <a-select v-model:value="sportType" placeholder="运动类型" style="width: 150px;" @change="loadData" allowClear>
          <a-select-option value="BASKETBALL">篮球</a-select-option>
          <a-select-option value="BADMINTON">羽毛球</a-select-option>
          <a-select-option value="TENNIS">网球</a-select-option>
          <a-select-option value="FITNESS">健身</a-select-option>
          <a-select-option value="YOGA">瑜伽</a-select-option>
          <a-select-option value="SWIMMING">游泳</a-select-option>
        </a-select>
      </a-space>
      <a-button type="primary" @click="showModal()">
        <PlusOutlined /> 新增场地
      </a-button>
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'sportType'">
          <a-tag color="blue">{{ getSportTypeName(record.sportType) }}</a-tag>
        </template>
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === 'AVAILABLE' ? 'green' : 'red'">
            {{ record.status === 'AVAILABLE' ? '可用' : '维护中' }}
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
        <a-form-item label="场馆" required>
          <a-select v-model:value="form.venueId">
            <a-select-option v-for="venue in venues" :key="venue.id" :value="venue.id">
              {{ venue.name }}
            </a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="场地名称" required>
          <a-input v-model:value="form.name" />
        </a-form-item>
        <a-form-item label="运动类型" required>
          <a-select v-model:value="form.sportType">
            <a-select-option value="BASKETBALL">篮球</a-select-option>
            <a-select-option value="BADMINTON">羽毛球</a-select-option>
            <a-select-option value="TENNIS">网球</a-select-option>
            <a-select-option value="FITNESS">健身</a-select-option>
            <a-select-option value="YOGA">瑜伽</a-select-option>
            <a-select-option value="SWIMMING">游泳</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="容量">
          <a-input-number v-model:value="form.capacity" :min="1" />
        </a-form-item>
        <a-form-item label="描述">
          <a-textarea v-model:value="form.description" :rows="4" />
        </a-form-item>
        <a-form-item label="场地图片">
          <ImageUpload v-model:modelValue="form.images" type="court" placeholder="上传场地图片" />
        </a-form-item>
        <a-form-item label="状态">
          <a-select v-model:value="form.status">
            <a-select-option value="AVAILABLE">可用</a-select-option>
            <a-select-option value="MAINTENANCE">维护中</a-select-option>
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
import ImageUpload from '@/components/ImageUpload.vue'

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
  { title: '场地名称', dataIndex: 'name', key: 'name' },
  { title: '运动类型', key: 'sportType' },
  { title: '容量', dataIndex: 'capacity', key: 'capacity', width: 100 },
  { title: '状态', key: 'status', width: 100 },
  { title: '操作', key: 'action', width: 150 }
]

const data = ref([])
const venues = ref([])
const loading = ref(false)
const venueId = ref(null)
const sportType = ref(null)
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const visible = ref(false)
const modalTitle = ref('新增场地')
const form = ref({})

const sportTypeMap = {
  BASKETBALL: '篮球',
  BADMINTON: '羽毛球',
  TENNIS: '网球',
  FITNESS: '健身',
  YOGA: '瑜伽',
  SWIMMING: '游泳'
}

const getSportTypeName = (type) => sportTypeMap[type] || type

const loadVenues = async () => {
  try {
    const res = await request({ url: '/venues', params: { page: 1, size: 100 } })
    venues.value = res.data.records
  } catch (error) {
    console.error(error)
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.current,
      size: pagination.value.pageSize
    }
    if (venueId.value) params.venueId = venueId.value
    if (sportType.value) params.sportType = sportType.value
    
    const res = await request({ url: '/courts', params })
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
    modalTitle.value = '编辑场地'
    form.value = { ...record }
  } else {
    modalTitle.value = '新增场地'
    form.value = { status: 'AVAILABLE', capacity: 1 }
  }
  visible.value = true
}

const handleSubmit = async () => {
  try {
    if (form.value.id) {
      await request({ url: `/courts/${form.value.id}`, method: 'put', data: form.value })
      message.success('更新成功')
    } else {
      await request({ url: '/courts', method: 'post', data: form.value })
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
    await request({ url: `/courts/${id}`, method: 'delete' })
    message.success('删除成功')
    loadData()
  } catch (error) {
    console.error(error)
  }
}

onMounted(() => {
  loadVenues()
  loadData()
})
</script>
