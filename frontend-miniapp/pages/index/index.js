const request = require('../../utils/request')

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
      this.setData({
        venues: res.data.records
      })
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
