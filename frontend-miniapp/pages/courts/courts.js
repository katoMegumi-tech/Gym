const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    courts: [],
    loading: false,
    venueId: null,
    sportType: null,
    sportTypes: [
      { value: '', label: '全部' },
      { value: 'BASKETBALL', label: '篮球' },
      { value: 'BADMINTON', label: '羽毛球' },
      { value: 'TENNIS', label: '网球' },
      { value: 'FITNESS', label: '健身' },
      { value: 'YOGA', label: '瑜伽' },
      { value: 'SWIMMING', label: '游泳' }
    ],
    selectedType: '',
    selectedTypeLabel: '全部'
  },

  onLoad(options) {
    if (options.venueId) {
      this.setData({ venueId: options.venueId })
    }
    if (options.sportType) {
      this.setData({ 
        sportType: options.sportType,
        selectedType: options.sportType
      })
    }
    this.loadCourts()
  },

  async loadCourts() {
    this.setData({ loading: true })

    try {
      const params = {
        page: 1,
        size: 50
      }
      
      if (this.data.venueId) {
        params.venueId = this.data.venueId
      }
      
      if (this.data.selectedType) {
        params.sportType = this.data.selectedType
      }

      const res = await request.get('/courts', params)
      
      // 处理场地图片URL
      const courts = res.data.records || []
      courts.forEach(court => {
        if (court.images) {
          court.images = upload.getImageUrl(court.images)
        }
      })
      
      this.setData({
        courts: courts
      })
    } catch (error) {
      console.error('加载场地失败:', error)
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  onTypeChange(e) {
    const index = e.detail.value
    const selectedType = this.data.sportTypes[index]
    this.setData({
      selectedType: selectedType.value,
      selectedTypeLabel: selectedType.label
    })
    this.loadCourts()
  },

  goToBooking(e) {
    const id = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `/pages/booking/booking?courtId=${id}`
    })
  }
})
