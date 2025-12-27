const request = require('../../utils/request')

Page({
  data: {
    activeTab: 'available',
    coupons: [],
    myCoupons: [],
    loading: false
  },

  onLoad() {
    this.loadCoupons()
  },

  switchTab(e) {
    const tab = e.currentTarget.dataset.tab
    this.setData({ activeTab: tab })
    if (tab === 'available') {
      this.loadCoupons()
    } else {
      this.loadMyCoupons()
    }
  },

  async loadCoupons() {
    this.setData({ loading: true })
    try {
      const res = await request.get('/coupons', {
        page: 1,
        size: 50,
        status: 'ACTIVE'
      })
      this.setData({ coupons: res.data.records || [] })
    } catch (error) {
      console.error('加载优惠券失败:', error)
    } finally {
      this.setData({ loading: false })
    }
  },

  async loadMyCoupons() {
    this.setData({ loading: true })
    try {
      const res = await request.get('/coupons/my', {
        page: 1,
        size: 50
      })
      this.setData({ myCoupons: res.data.records || [] })
    } catch (error) {
      console.error('加载我的优惠券失败:', error)
    } finally {
      this.setData({ loading: false })
    }
  },

  async claimCoupon(e) {
    const id = e.currentTarget.dataset.id
    try {
      await request.post(`/coupons/${id}/claim`)
      wx.showToast({
        title: '领取成功',
        icon: 'success'
      })
      this.loadCoupons()
    } catch (error) {
      console.error('领取失败:', error)
    }
  },

  getStatusText(status) {
    const map = {
      UNUSED: '未使用',
      USED: '已使用',
      EXPIRED: '已过期'
    }
    return map[status] || status
  }
})
