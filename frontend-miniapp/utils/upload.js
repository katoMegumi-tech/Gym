const app = getApp()

/**
 * 上传图片到服务器
 * @param {string} filePath - 本地文件路径
 * @param {string} type - 类型 avatar 或 venue
 * @returns {Promise}
 */
function uploadImage(filePath, type = 'avatar') {
  return new Promise((resolve, reject) => {
    const token = wx.getStorageSync('token')
    if (!token) {
      reject(new Error('请先登录'))
      return
    }

    const baseURL = app.globalData.baseUrl || 'http://localhost:8080/api'
    const uploadUrl = type === 'avatar' 
      ? `${baseURL}/files/upload/avatar`
      : `${baseURL}/files/upload/venue`

    wx.uploadFile({
      url: uploadUrl,
      filePath: filePath,
      name: 'file',
      header: {
        'Authorization': token
      },
      success: (res) => {
        console.log('上传响应:', res)
        try {
          const data = JSON.parse(res.data)
          console.log('解析后的数据:', data)
          
          // 文件上传接口直接返回 {success: true, fileName: ..., fileUrl: ..., message: ...}
          if (data.success) {
            resolve(data)
          } else {
            reject(new Error(data.message || '上传失败'))
          }
        } catch (error) {
          console.error('解析上传响应失败:', error)
          reject(new Error('上传失败'))
        }
      },
      fail: (error) => {
        reject(error)
      }
    })
  })
}

/**
 * 选择并上传图片
 * @param {string} type - 类型 avatar 或 venue
 * @returns {Promise}
 */
function chooseAndUploadImage(type = 'avatar') {
  return new Promise((resolve, reject) => {
    wx.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album', 'camera'],
      success: async (res) => {
        const tempFilePath = res.tempFilePaths[0]
        
        wx.showLoading({ title: '上传中...' })
        
        try {
          const result = await uploadImage(tempFilePath, type)
          wx.hideLoading()
          wx.showToast({ title: '上传成功', icon: 'success' })
          resolve(result)
        } catch (error) {
          wx.hideLoading()
          wx.showToast({ title: error.message || '上传失败', icon: 'none' })
          reject(error)
        }
      },
      fail: (error) => {
        reject(error)
      }
    })
  })
}

/**
 * 获取完整图片URL
 * @param {string} fileUrl - 文件相对路径
 * @returns {string}
 */
function getImageUrl(fileUrl) {
  if (!fileUrl) return ''
  if (fileUrl.startsWith('http')) return fileUrl
  
  const baseURL = app.globalData.baseUrl || 'http://localhost:8080/api'
  
  // 如果路径以 /api 开头，需要去掉 /api 再拼接
  if (fileUrl.startsWith('/api')) {
    return baseURL + fileUrl.substring(4)
  }
  
  return `${baseURL}${fileUrl}`
}

module.exports = {
  uploadImage,
  chooseAndUploadImage,
  getImageUrl
}
