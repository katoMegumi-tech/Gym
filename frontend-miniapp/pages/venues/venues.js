const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    venues: [],
    loading: false,
    page: 1,
    hasMore: true
  },

  onLoad() {
    this.loadVenues()
  },

  async loadVenues() {
    if (this.data.loading || !this.data.hasMore) return

    this.setData({ loading: true })

    try {
      const res = await request.get('/venues', {
        page: this.data.page,
        size: 10
      })

      const newVenues = res.data.records || []
      
      // 处理场馆图片URL
      newVenues.forEach(venue => {
        if (venue.images) {
          venue.images = upload.getImageUrl(venue.images)
        }
      })
      
      this.setData({
        venues: this.data.page === 1 ? newVenues : [...this.data.venues, ...newVenues],
        hasMore: newVenues.length >= 10,
        page: this.data.page + 1
      })
    } catch (error) {
      console.error('加载场馆失败:', error)
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  onReachBottom() {
    this.loadVenues()
  },

  onPullDownRefresh() {
    this.setData({
      page: 1,
      hasMore: true,
      venues: []
    })
    this.loadVenues().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  goToVenueDetail(e) {
    const id = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/courts/courts?venueId=${id}`
    })
  }
})
