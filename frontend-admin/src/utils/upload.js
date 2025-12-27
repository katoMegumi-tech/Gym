import axios from 'axios'

const API_BASE_URL = '/api'

/**
 * 上传用户头像
 * @param {File} file - 文件对象
 * @returns {Promise} 返回上传结果
 */
export const uploadAvatar = async (file) => {
  const formData = new FormData()
  formData.append('file', file)
  
  try {
    const response = await axios.post(`${API_BASE_URL}/files/upload/avatar`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    return response.data
  } catch (error) {
    throw new Error(error.response?.data?.message || '上传失败')
  }
}

/**
 * 上传场馆图片
 * @param {File} file - 文件对象
 * @returns {Promise} 返回上传结果
 */
export const uploadVenueImage = async (file) => {
  const formData = new FormData()
  formData.append('file', file)
  
  try {
    const response = await axios.post(`${API_BASE_URL}/files/upload/venue`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    return response.data
  } catch (error) {
    throw new Error(error.response?.data?.message || '上传失败')
  }
}

/**
 * 删除头像
 * @param {string} fileName - 文件名
 * @returns {Promise} 返回删除结果
 */
export const deleteAvatar = async (fileName) => {
  try {
    const response = await axios.delete(`${API_BASE_URL}/files/avatar/${fileName}`)
    return response.data
  } catch (error) {
    throw new Error(error.response?.data?.message || '删除失败')
  }
}

/**
 * 删除场馆图片
 * @param {string} fileName - 文件名
 * @returns {Promise} 返回删除结果
 */
export const deleteVenueImage = async (fileName) => {
  try {
    const response = await axios.delete(`${API_BASE_URL}/files/venue/${fileName}`)
    return response.data
  } catch (error) {
    throw new Error(error.response?.data?.message || '删除失败')
  }
}

/**
 * 获取文件完整 URL
 * @param {string} fileUrl - 文件相对路径
 * @returns {string} 完整 URL
 */
export const getFileUrl = (fileUrl) => {
  if (!fileUrl) return ''
  if (fileUrl.startsWith('http')) return fileUrl
  // 如果已经包含 /api，直接返回
  if (fileUrl.startsWith('/api')) return fileUrl
  return `${API_BASE_URL}${fileUrl}`
}

/**
 * 验证图片文件
 * @param {File} file - 文件对象
 * @param {number} maxSize - 最大文件大小（字节），默认 5MB
 * @returns {Object} 验证结果
 */
export const validateImageFile = (file, maxSize = 5 * 1024 * 1024) => {
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp']
  
  if (!validTypes.includes(file.type)) {
    return {
      valid: false,
      message: '只支持 JPG、PNG、GIF、WEBP 格式的图片'
    }
  }
  
  if (file.size > maxSize) {
    return {
      valid: false,
      message: `文件大小不能超过 ${(maxSize / 1024 / 1024).toFixed(0)}MB`
    }
  }
  
  return {
    valid: true,
    message: '验证通过'
  }
}
