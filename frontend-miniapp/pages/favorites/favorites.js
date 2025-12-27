const request = require('../../utils/request')

Page({
  data: {
    activeTab: 'VENUE',
    favorites: [],
    loading: false
  },

  onLoad() {
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
      this.setData({ favorites: res.data || [] })
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
        url: `/pages/courts/courts?venueId=${id}`
      })
    } else {
      wx.navigateTo({
        url: `/pages/booking/booking?courtId=${id}`
      })
    }
  }
})
