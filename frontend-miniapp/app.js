App({
  globalData: {
    baseUrl: 'http://localhost:8080/api',
    token: ''
  },
  
  onLaunch() {
    const token = wx.getStorageSync('token')
    if (token) {
      this.globalData.token = token
    }
  }
})
