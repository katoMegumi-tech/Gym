const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    venues: [],
    loading: false,
    page: 1,
    hasMore: true,
    keyword: '',
    searchKeyword: ''
  },

  onLoad(options) {
    if (options.keyword) {
      this.setData({ 
        keyword: decodeURIComponent(options.keyword),
        searchKeyword: decodeURIComponent(options.keyword)
      })
    }
    this.loadVenues()
  },

  async loadVenues() {
    if (this.data.loading || !this.data.hasMore) return

    this.setData({ loading: true })

    try {
      const params = {
        page: this.data.page,
        size: 10
      }
      
      if (this.data.keyword) {
        params.keyword = this.data.keyword
      }

      console.log('搜索参数:', params)
      const res = await request.get('/venues', params)
      console.log('搜索结果:', res)

      const newVenues = res.data.records || []
      
      // 处理场馆图片URL
      newVenues.forEach(venue => {
        if (venue.images) {
          try {
            const imgs = JSON.parse(venue.images)
            venue.coverImage = imgs.length > 0 ? upload.getImageUrl(imgs[0]) : ''
          } catch (e) {
            venue.coverImage = upload.getImageUrl(venue.images)
          }
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

  onSearchInput(e) {
    this.setData({ searchKeyword: e.detail.value })
  },

  onSearch() {
    this.setData({
      keyword: this.data.searchKeyword,
      page: 1,
      hasMore: true,
      venues: []
    })
    this.loadVenues()
  },

  onClearSearch() {
    this.setData({
      keyword: '',
      searchKeyword: '',
      page: 1,
      hasMore: true,
      venues: []
    })
    this.loadVenues()
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
      url: `/pages/venue-detail/venue-detail?id=${id}`
    })
  }
})
