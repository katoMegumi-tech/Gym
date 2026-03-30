const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    venues: [],
    announcements: [],
    searchKeyword: '',
    sportTypes: [
      { type: 'BASKETBALL', name: '篮球', icon: '🏀' },
      { type: 'BADMINTON', name: '羽毛球', icon: '🏸' },
      { type: 'TENNIS', name: '网球', icon: '🎾' },
      { type: 'FITNESS', name: '健身', icon: '💪' },
      { type: 'YOGA', name: '瑜伽', icon: '🧘' },
      { type: 'SWIMMING', name: '游泳', icon: '🏊' }
    ]
  },

  onLoad() {
    this.loadVenues()
    this.loadAnnouncements()
  },

  onShow() {
    // 每次显示刷新数据
    this.loadVenues()
  },

  async loadVenues() {
    try {
      const res = await request.get('/venues', { page: 1, size: 10 })
      const venues = res.data.records || []
      
      // 处理场馆图片URL
      venues.forEach(venue => {
        if (venue.images) {
          try {
            const imgs = JSON.parse(venue.images)
            venue.coverImage = imgs.length > 0 ? upload.getImageUrl(imgs[0]) : ''
          } catch (e) {
            venue.coverImage = upload.getImageUrl(venue.images)
          }
        }
      })
      
      this.setData({ venues })
    } catch (error) {
      console.error(error)
    }
  },

  async loadAnnouncements() {
    try {
      const res = await request.get('/announcements', { page: 1, size: 3, status: 'PUBLISHED' })
      this.setData({ announcements: res.data.records || [] })
    } catch (error) {
      console.error(error)
    }
  },

  onSearchInput(e) {
    console.log('输入内容:', e.detail.value)
    this.setData({ searchKeyword: e.detail.value })
  },

  onSearch() {
    const keyword = this.data.searchKeyword.trim()
    console.log('搜索关键词:', keyword)
    if (keyword) {
      // 将搜索关键词保存到全局
      const app = getApp()
      app.globalData.searchKeyword = keyword
      
      // 跳转到场馆列表页面（tabBar页面）
      wx.switchTab({
        url: '/pages/venues/venues'
      })
    } else {
      wx.showToast({
        title: '请输入搜索内容',
        icon: 'none'
      })
    }
  },

  goToVenue(e) {
    const id = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/venue-detail/venue-detail?id=${id}`
    })
  },

  goToSport(e) {
    const type = e.currentTarget.dataset.type
    wx.navigateTo({
      url: `/pages/courts/courts?sportType=${type}`
    })
  },

  goToAnnouncement(e) {
    const item = e.currentTarget.dataset.item
    wx.showModal({
      title: item.title,
      content: item.content,
      showCancel: false,
      confirmText: '知道了'
    })
  },

  goToVenueList() {
    wx.switchTab({
      url: '/pages/venues/venues'
    })
  }
})
