<template>
  <div class="image-upload">
    <a-upload
      :before-upload="beforeUpload"
      :custom-request="handleUpload"
      :show-upload-list="false"
      accept="image/*"
    >
      <div class="upload-area">
        <img v-if="imageUrl" :src="imageUrl" alt="preview" class="preview-image" />
        <div v-else class="upload-placeholder">
          <plus-outlined />
          <div class="upload-text">{{ placeholder }}</div>
        </div>
      </div>
    </a-upload>
    
    <a-button 
      v-if="imageUrl && showDelete" 
      type="link" 
      danger 
      @click="handleDelete"
      class="delete-btn"
    >
      删除图片
    </a-button>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { message } from 'ant-design-vue'
import { PlusOutlined } from '@ant-design/icons-vue'
import { uploadAvatar, uploadVenueImage, deleteAvatar, deleteVenueImage, validateImageFile, getFileUrl } from '@/utils/upload'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'avatar', // avatar 或 venue
    validator: (value) => ['avatar', 'venue'].includes(value)
  },
  placeholder: {
    type: String,
    default: '点击上传图片'
  },
  showDelete: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['update:modelValue', 'change'])

const imageUrl = ref('')
const fileName = ref('')

// 监听外部值变化
watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    imageUrl.value = getFileUrl(newVal)
    // 从 URL 中提取文件名
    const parts = newVal.split('/')
    fileName.value = parts[parts.length - 1]
  } else {
    imageUrl.value = ''
    fileName.value = ''
  }
}, { immediate: true })

// 上传前验证
const beforeUpload = (file) => {
  const validation = validateImageFile(file)
  if (!validation.valid) {
    message.error(validation.message)
    return false
  }
  return true
}

// 处理上传
const handleUpload = async ({ file }) => {
  try {
    const uploadFn = props.type === 'avatar' ? uploadAvatar : uploadVenueImage
    const result = await uploadFn(file)
    
    if (result.success) {
      imageUrl.value = getFileUrl(result.fileUrl)
      fileName.value = result.fileName
      emit('update:modelValue', result.fileUrl)
      emit('change', result)
      message.success(result.message)
    } else {
      message.error(result.message)
    }
  } catch (error) {
    message.error(error.message || '上传失败')
  }
}

// 处理删除
const handleDelete = async () => {
  if (!fileName.value) return
  
  try {
    const deleteFn = props.type === 'avatar' ? deleteAvatar : deleteVenueImage
    const result = await deleteFn(fileName.value)
    
    if (result.success) {
      imageUrl.value = ''
      fileName.value = ''
      emit('update:modelValue', '')
      emit('change', null)
      message.success(result.message)
    } else {
      message.error(result.message)
    }
  } catch (error) {
    message.error(error.message || '删除失败')
  }
}
</script>

<style scoped>
.image-upload {
  display: inline-block;
}

.upload-area {
  width: 120px;
  height: 120px;
  border: 1px dashed #d9d9d9;
  border-radius: 4px;
  cursor: pointer;
  overflow: hidden;
  transition: border-color 0.3s;
}

.upload-area:hover {
  border-color: #1890ff;
}

.preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #999;
}

.upload-placeholder .anticon {
  font-size: 32px;
  margin-bottom: 8px;
}

.upload-text {
  font-size: 12px;
}

.delete-btn {
  display: block;
  margin-top: 8px;
  padding: 0;
}
</style>
