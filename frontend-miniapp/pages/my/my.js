const app = getApp()
const upload = require('../../utils/upload')
const request = require('../../utils/request')

Page({
  data: {
    userInfo: null
  },

  onShow() {
    this.loadUserInfo()
  },

  async loadUserInfo() {
    const userInfo = wx.getStorageSync('userInfo')
    if (userInfo) {
      // 处理头像URL
      if (userInfo.avatarUrl) {
        userInfo.avatarUrl = upload.getImageUrl(userInfo.avatarUrl)
      }
      
      // 加载用户统计数据
      try {
        const token = wx.getStorageSync('token')
        if (token) {
          // 获取预约数量
          const resRes = await request.get('/reservations/my', { page: 1, size: 1 })
          userInfo.reservationCount = resRes.data.total || 0
          
          // 获取收藏数量
          const favRes = await request.get('/favorites/my')
          userInfo.favoriteCount = (favRes.data || []).length
          
          // 获取优惠券数量
          const couponRes = await request.get('/coupons/my', { page: 1, size: 1 })
          userInfo.couponCount = couponRes.data.total || 0
        }
      } catch (e) {
        console.error('加载统计数据失败:', e)
      }
      
      this.setData({ userInfo })
    } else {
      this.setData({ userInfo: null })
    }
  },

  async handleUploadAvatar() {
    if (!this.data.userInfo || !this.data.userInfo.userId) {
      wx.showToast({
        title: '请先登录',
        icon: 'none'
      })
      return
    }
    
    try {
      const result = await upload.chooseAndUploadImage('avatar')
      
      // 更新用户信息
      await request.put(`/users/${this.data.userInfo.userId}`, {
        avatarUrl: result.fileUrl
      })
      
      // 更新本地用户信息 - 使用完整URL
      const userInfo = this.data.userInfo
      userInfo.avatarUrl = upload.getImageUrl(result.fileUrl)
      
      // 保存到本地存储时也保存相对路径
      const storageUserInfo = { ...userInfo, avatarUrl: result.fileUrl }
      wx.setStorageSync('userInfo', storageUserInfo)
      
      // 页面显示使用完整URL
      this.setData({ userInfo })
      
    } catch (error) {
      console.error('上传头像失败:', error)
    }
  },

  goToLogin() {
    wx.navigateTo({
      url: '/pages/login/login'
    })
  },

  goToReservations() {
    const token = wx.getStorageSync('token')
    if (!token) {
      wx.navigateTo({
        url: '/pages/login/login'
      })
      return
    }
    wx.navigateTo({
      url: '/pages/my-reservations/my-reservations'
    })
  },

  goToCoupons() {
    const token = wx.getStorageSync('token')
    if (!token) {
      wx.navigateTo({
        url: '/pages/login/login'
      })
      return
    }
    wx.navigateTo({
      url: '/pages/coupons/coupons'
    })
  },

  goToFavorites() {
    const token = wx.getStorageSync('token')
    if (!token) {
      wx.navigateTo({
        url: '/pages/login/login'
      })
      return
    }
    wx.navigateTo({
      url: '/pages/favorites/favorites'
    })
  },

  goToFeedback() {
    const token = wx.getStorageSync('token')
    if (!token) {
      wx.navigateTo({
        url: '/pages/login/login'
      })
      return
    }
    wx.navigateTo({
      url: '/pages/feedback/feedback'
    })
  },

  goToNotifications() {
    wx.navigateTo({
      url: '/pages/notifications/notifications'
    })
  },

  handleLogout() {
    wx.showModal({
      title: '提示',
      content: '确定退出登录？',
      success: (res) => {
        if (res.confirm) {
          wx.removeStorageSync('token')
          wx.removeStorageSync('userInfo')
          app.globalData.token = ''
          this.setData({ userInfo: null })
          wx.showToast({ title: '已退出', icon: 'success' })
        }
      }
    })
  }
})
