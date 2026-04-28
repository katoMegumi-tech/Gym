const request = require('../../utils/request')
const upload = require('../../utils/upload')

Page({
  data: {
    activeTab: 'VENUE',
    favorites: [],
    loading: false,
    lastLoadAt: 0
  },

  onLoad() {
    this.loadFavorites()
  },

  onShow() {
    // 短时间内返回页面不重复请求，减少切换卡顿
    if (Date.now() - this.data.lastLoadAt > 5000) {
      this.loadFavorites()
    }
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
      this.setData({ favorites: detailedFavorites, lastLoadAt: Date.now() })
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
    const tasks = favorites.map(async (fav) => {
      const item = { ...fav }
      try {
        if (item.targetType === 'VENUE') {
          const res = await request.get(`/venues/${item.targetId}`)
          const venue = res.data
          item.title = venue.name
          item.subtitle = venue.address || venue.description || '暂无简介'
          item.cover = this.resolveImageUrl(venue.images)
          item.statusText = venue.status === 'OPEN' ? '营业中' : '已关闭'
        } else if (item.targetType === 'COURT') {
          const res = await request.get(`/courts/${item.targetId}`)
          const court = res.data
          item.title = court.name
          item.subtitle = this.getSportTypeName(court.sportType) + ' · 容纳' + (court.capacity || 0) + '人'
          item.cover = this.resolveImageUrl(court.images)
          item.statusText = court.status === 'AVAILABLE' ? '可预约' : '维护中'
        }
      } catch (e) {
        item.title = '内容已失效'
        item.subtitle = '该场馆/场地可能已被删除'
        item.cover = ''
        item.statusText = '不可用'
      }
      return item
    })
    return Promise.all(tasks)
  },

  resolveImageUrl(images) {
    if (!images) return ''
    try {
      const parsed = typeof images === 'string' ? JSON.parse(images) : images
      if (Array.isArray(parsed)) {
        return upload.getImageUrl(parsed[0] || '')
      }
      return upload.getImageUrl(images)
    } catch (error) {
      return upload.getImageUrl(images)
    }
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
    const date = new Date(String(timeStr).replace(/-/g, '/'))
    const month = date.getMonth() + 1
    const day = date.getDate()
    const hour = String(date.getHours()).padStart(2, '0')
    const minute = String(date.getMinutes()).padStart(2, '0')
    return `${month}月${day}日 ${hour}:${minute}`
  }
})
