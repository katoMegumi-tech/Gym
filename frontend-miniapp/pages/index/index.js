const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    venues: [],
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
  },

  async loadVenues() {
    try {
      const res = await request.get('/venues', { page: 1, size: 10 })
      const venues = res.data.records || []
      
      // 处理场馆图片URL
      venues.forEach(venue => {
        if (venue.images) {
          venue.images = upload.getImageUrl(venue.images)
        }
      })
      
      this.setData({ venues })
    } catch (error) {
      console.error(error)
    }
  },

  goToVenue(e) {
    const id = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/courts/courts?venueId=${id}`
    })
  },

  goToSport(e) {
    const type = e.currentTarget.dataset.type
    wx.navigateTo({
      url: `/pages/courts/courts?sportType=${type}`
    })
  },

  onSearch(e) {
    console.log('搜索:', e.detail.value)
  }
})
