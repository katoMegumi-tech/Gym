const app = getApp()

function request(options) {
  return new Promise((resolve, reject) => {
    // 获取完整URL
    const fullUrl = app.globalData.baseUrl + options.url
    
    console.log('请求URL:', fullUrl)
    console.log('请求方法:', options.method || 'GET')
    console.log('请求数据:', options.data)
    
    wx.request({
      url: fullUrl,
      method: options.method || 'GET',
      data: options.data || {},
      header: {
        'Content-Type': 'application/json',
        'Authorization': app.globalData.token || ''
      },
      success(res) {
        console.log('响应状态码:', res.statusCode)
        console.log('响应数据:', res.data)
        
        if (res.statusCode === 200 && res.data.code === 200) {
          resolve(res.data)
        } else {
          const errorMsg = res.data.message || '请求失败'
          console.error('请求失败:', errorMsg)
          wx.showToast({
            title: errorMsg,
            icon: 'none',
            duration: 2000
          })
          reject(res.data)
        }
      },
      fail(err) {
        console.error('网络请求失败:', err)
        wx.showToast({
          title: '网络错误，请检查后端服务',
          icon: 'none',
          duration: 3000
        })
        reject(err)
      }
    })
  })
}

module.exports = {
  get: (url, data) => request({ url, data, method: 'GET' }),
  post: (url, data) => request({ url, data, method: 'POST' }),
  put: (url, data) => request({ url, data, method: 'PUT' }),
  delete: (url, data) => request({ url, data, method: 'DELETE' })
}
