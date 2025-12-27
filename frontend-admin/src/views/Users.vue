<template>
  <div>
    <div style="margin-bottom: 16px; display: flex; justify-content: space-between;">
      <a-input-search v-model:value="keyword" placeholder="搜索用户名/姓名/手机号" style="width: 300px;" @search="loadData" />
    </div>
    
    <a-table :columns="columns" :data-source="data" :loading="loading" :pagination="pagination" @change="handleTableChange">
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === 'ACTIVE' ? 'green' : 'red'">
            {{ record.status === 'ACTIVE' ? '正常' : '禁用' }}
          </a-tag>
        </template>
        <template v-if="column.key === 'action'">
          <a-space>
            <a @click="showModal(record)">编辑</a>
            <a @click="showPasswordModal(record)">修改密码</a>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal v-model:open="visible" title="编辑用户" @ok="handleSubmit" width="600px">
      <a-form :model="form" :label-col="{ span: 6 }">
        <a-form-item label="用户名">
          <a-input v-model:value="form.username" disabled />
        </a-form-item>
        <a-form-item label="真实姓名">
          <a-input v-model:value="form.realName" />
        </a-form-item>
        <a-form-item label="手机号">
          <a-input v-model:value="form.phone" />
        </a-form-item>
        <a-form-item label="邮箱">
          <a-input v-model:value="form.email" />
        </a-form-item>
        <a-form-item label="状态">
          <a-select v-model:value="form.status">
            <a-select-option value="ACTIVE">正常</a-select-option>
            <a-select-option value="DISABLED">禁用</a-select-option>
          </a-select>
        </a-form-item>
      </a-form>
    </a-modal>

    <a-modal v-model:open="passwordVisible" title="修改密码" @ok="handlePasswordSubmit" width="500px">
      <a-form :model="passwordForm" :label-col="{ span: 6 }">
        <a-form-item label="新密码">
          <a-input-password v-model:value="passwordForm.newPassword" />
        </a-form-item>
        <a-form-item label="确认密码">
          <a-input-password v-model:value="passwordForm.confirmPassword" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import request from '@/utils/request'

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 80 },
  { title: '用户名', dataIndex: 'username', key: 'username' },
  { title: '真实姓名', dataIndex: 'realName', key: 'realName' },
  { title: '手机号', dataIndex: 'phone', key: 'phone' },
  { title: '邮箱', dataIndex: 'email', key: 'email' },
  { title: '状态', key: 'status', width: 100 },
  { title: '操作', key: 'action', width: 200 }
]

const data = ref([])
const loading = ref(false)
const keyword = ref('')
const pagination = ref({ current: 1, pageSize: 10, total: 0 })
const visible = ref(false)
const passwordVisible = ref(false)
const form = ref({})
const passwordForm = ref({})

const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.current,
      size: pagination.value.pageSize
    }
    if (keyword.value) params.keyword = keyword.value
    
    const res = await request({ url: '/users', params })
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
  form.value = { ...record }
  visible.value = true
}

const showPasswordModal = (record) => {
  passwordForm.value = { userId: record.id, newPassword: '', confirmPassword: '' }
  passwordVisible.value = true
}

const handleSubmit = async () => {
  try {
    await request({ url: `/users/${form.value.id}`, method: 'put', data: form.value })
    message.success('更新成功')
    visible.value = false
    loadData()
  } catch (error) {
    console.error(error)
  }
}

const handlePasswordSubmit = async () => {
  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    message.error('两次密码不一致')
    return
  }
  
  try {
    await request({ 
      url: `/users/${passwordForm.value.userId}/password`, 
      method: 'put',
      params: {
        oldPassword: '123456', // 管理员重置密码
        newPassword: passwordForm.value.newPassword
      }
    })
    message.success('密码修改成功')
    passwordVisible.value = false
  } catch (error) {
    console.error(error)
  }
}

onMounted(() => {
  loadData()
})
</script>
