const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    activeTab: 'VENUE',
    favorites: [],
    loading: false
  },

  onLoad() {
    this.loadFavorites()
  },

  onShow() {
    // 每次显示页面时刷新数据
    this.loadFavorites()
  },

  switchTab(e) {
    const tab = e.currentTarget.dataset.tab
    this.setData({ activeTab: tab })
    this.loadFavorites()
  },

  async loadFavorites() {
    this.setData({ loading: true })
    try {
      const res = await request.get('/favorites/my', {
        targetType: this.data.activeTab
      })
      const favorites = res.data || []
      
      // 加载详细信息
      const detailedFavorites = await this.loadDetails(favorites)
      this.setData({ favorites: detailedFavorites })
    } catch (error) {
      console.error('加载收藏失败:', error)
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  async loadDetails(favorites) {
    const results = []
    for (const fav of favorites) {
      try {
        if (fav.targetType === 'VENUE') {
          const res = await request.get(`/venues/${fav.targetId}`)
          const venue = res.data
          fav.name = venue.name
          fav.description = venue.address || venue.description
          fav.image = venue.images ? upload.getImageUrl(JSON.parse(venue.images)[0] || venue.images) : ''
          fav.status = venue.status
        } else if (fav.targetType === 'COURT') {
          const res = await request.get(`/courts/${fav.targetId}`)
          const court = res.data
          fav.name = court.name
          fav.description = this.getSportTypeName(court.sportType) + ' · ¥' + court.pricePerHour + '/小时'
          fav.image = court.images ? upload.getImageUrl(JSON.parse(court.images)[0] || court.images) : ''
          fav.status = court.status
        }
      } catch (e) {
        fav.name = '已删除'
        fav.description = '该内容已不存在'
      }
      results.push(fav)
    }
    return results
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

  async removeFavorite(e) {
    const id = e.currentTarget.dataset.id
    const favorite = this.data.favorites.find(f => f.id === id)
    
    try {
      await request.delete('/favorites', {
        targetType: favorite.targetType,
        targetId: favorite.targetId
      })
      wx.showToast({
        title: '取消成功',
        icon: 'success'
      })
      this.loadFavorites()
    } catch (error) {
      console.error('取消收藏失败:', error)
    }
  },

  goToDetail(e) {
    const { type, id } = e.currentTarget.dataset
    if (type === 'VENUE') {
      wx.navigateTo({
        url: `/pages/venue-detail/venue-detail?id=${id}`
      })
    } else {
      wx.navigateTo({
        url: `/pages/booking/booking?courtId=${id}`
      })
    }
  },

  formatTime(timeStr) {
    if (!timeStr) return ''
    const date = new Date(timeStr)
    return `${date.getMonth() + 1}月${date.getDate()}日`
  }
})
