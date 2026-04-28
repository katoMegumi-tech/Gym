const app = getApp()

function debugLog(...args) {
  if (app.globalData && app.globalData.debugRequestLog) {
    console.log(...args)
  }
}

function request(options) {
  return new Promise((resolve, reject) => {
    // 获取完整URL
    const fullUrl = app.globalData.baseUrl + options.url
    
    debugLog('请求URL:', fullUrl)
    debugLog('请求方法:', options.method || 'GET')
    debugLog('请求数据:', options.data)
    
    wx.request({
      url: fullUrl,
      method: options.method || 'GET',
      data: options.data || {},
      timeout: options.timeout || 12000,
      header: {
        'Content-Type': 'application/json',
        'Authorization': app.globalData.token || ''
      },
      success(res) {
        debugLog('响应状态码:', res.statusCode)
        debugLog('响应数据:', res.data)
        
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
  get: (url, data, timeout) => request({ url, data, method: 'GET', timeout }),
  post: (url, data, timeout) => request({ url, data, method: 'POST', timeout }),
  put: (url, data, timeout) => request({ url, data, method: 'PUT', timeout }),
  delete: (url, data, timeout) => request({ url, data, method: 'DELETE', timeout })
}
