App({
  globalData: {
    baseUrl: 'http://localhost:8080/api',
    token: '',
    searchKeyword: '' // 添加搜索关键词全局变量
  },
  
  onLaunch() {
    const token = wx.getStorageSync('token')
    if (token) {
      this.globalData.token = token
    }
  }
})
