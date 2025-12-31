const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    venueId: null,
    venue: null,
    courts: [],
    courtStats: {},
    isFavorite: false,
    loading: true,
    currentImageIndex: 0
  },

  onLoad(options) {
    if (options.id) {
      this.setData({ venueId: options.id })
      this.loadVenueDetail()
      this.loadCourts()
      this.checkFavorite()
    }
  },

  async loadVenueDetail() {
    try {
      const res = await request.get(`/venues/${this.data.venueId}`)
      const venue = res.data
      // 处理图片URL
      venue.imageList = []
      if (venue.images) {
        try {
          const images = JSON.parse(venue.images)
          venue.imageList = images.map(img => upload.getImageUrl(img))
        } catch (e) {
          venue.imageList = [upload.getImageUrl(venue.images)]
        }
      }
      this.setData({ venue, loading: false })
    } catch (error) {
      console.error('加载场馆详情失败:', error)
      this.setData({ loading: false })
    }
  },

  async loadCourts() {
    try {
      const res = await request.get('/courts', {
        venueId: this.data.venueId,
        page: 1,
        size: 50
      })
      const courts = res.data.records || []
      
      // 统计各类型场地数量
      const stats = {}
      courts.forEach(court => {
        const type = court.sportType
        if (!stats[type]) {
          stats[type] = { count: 0, available: 0 }
        }
        stats[type].count++
        if (court.status === 'AVAILABLE') {
          stats[type].available++
        }
      })
      
      this.setData({ courts, courtStats: stats })
    } catch (error) {
      console.error('加载场地失败:', error)
    }
  },

  async checkFavorite() {
    const token = wx.getStorageSync('token')
    if (!token) return
    
    try {
      const res = await request.get('/favorites/check', {
        targetType: 'VENUE',
        targetId: this.data.venueId
      })
      this.setData({ isFavorite: res.data })
    } catch (error) {
      console.error('检查收藏状态失败:', error)
    }
  },

  async toggleFavorite() {
    const token = wx.getStorageSync('token')
    if (!token) {
      wx.navigateTo({ url: '/pages/login/login' })
      return
    }

    try {
      if (this.data.isFavorite) {
        await request.delete('/favorites', {
          targetType: 'VENUE',
          targetId: this.data.venueId
        })
        wx.showToast({ title: '取消收藏', icon: 'success' })
      } else {
        await request.post('/favorites', {
          targetType: 'VENUE',
          targetId: this.data.venueId
        })
        wx.showToast({ title: '收藏成功', icon: 'success' })
      }
      this.setData({ isFavorite: !this.data.isFavorite })
    } catch (error) {
      console.error('操作失败:', error)
    }
  },

  onSwiperChange(e) {
    this.setData({ currentImageIndex: e.detail.current })
  },

  goToBooking(e) {
    const courtId = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/booking/booking?courtId=${courtId}`
    })
  },

  previewImage(e) {
    const current = e.currentTarget.dataset.url
    wx.previewImage({
      current,
      urls: this.data.venue.imageList
    })
  },

  makePhoneCall() {
    if (this.data.venue && this.data.venue.contactPhone) {
      wx.makePhoneCall({
        phoneNumber: this.data.venue.contactPhone
      })
    }
  },

  openLocation() {
    // 模拟打开地图
    wx.showToast({
      title: '地图功能开发中',
      icon: 'none'
    })
  },

  getSportTypeName(type) {
    const map = {
      BASKETBALL: '篮球',
      BADMINTON: '羽毛球',
      TENNIS: '网球',
      FITNESS: '健身',
      YOGA: '瑜伽',
      SWIMMING: '游泳'
    }
    return map[type] || type
  },

  getSportTypeIcon(type) {
    const map = {
      BASKETBALL: '🏀',
      BADMINTON: '🏸',
      TENNIS: '🎾',
      FITNESS: '💪',
      YOGA: '🧘',
      SWIMMING: '🏊'
    }
    return map[type] || '🏟️'
  }
})
