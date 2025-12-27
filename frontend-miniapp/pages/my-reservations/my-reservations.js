const request = require('../../utils/request')

Page({
  data: {
    reservations: [],
    loading: false,
    page: 1,
    hasMore: true
  },

  onLoad() {
    this.loadReservations()
  },

  async loadReservations() {
    if (this.data.loading || !this.data.hasMore) return

    this.setData({ loading: true })

    try {
      const res = await request.get('/reservations/my', {
        page: this.data.page,
        size: 10
      })

      const newData = res.data.records || []
      
      this.setData({
        reservations: this.data.page === 1 ? newData : [...this.data.reservations, ...newData],
        hasMore: newData.length >= 10,
        page: this.data.page + 1
      })
    } catch (error) {
      console.error('加载预约失败:', error)
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  onReachBottom() {
    this.loadReservations()
  },

  onPullDownRefresh() {
    this.setData({
      page: 1,
      hasMore: true,
      reservations: []
    })
    this.loadReservations().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  cancelReservation(e) {
    const id = e.currentTarget.dataset.id
    
    wx.showModal({
      title: '取消预约',
      content: '确定要取消这个预约吗？',
      success: async (res) => {
        if (res.confirm) {
          try {
            await request.put(`/reservations/${id}/cancel?reason=用户取消`)
            wx.showToast({
              title: '取消成功',
              icon: 'success'
            })
            this.setData({
              page: 1,
              hasMore: true,
              reservations: []
            })
            this.loadReservations()
          } catch (error) {
            console.error('取消失败:', error)
          }
        }
      }
    })
  },

  getStatusText(status) {
    const map = {
      PENDING_PAYMENT: '待支付',
      PAID: '已支付',
      CONFIRMED: '已确认',
      IN_PROGRESS: '进行中',
      COMPLETED: '已完成',
      CANCELLED: '已取消',
      REFUNDED: '已退款'
    }
    return map[status] || status
  },

  getStatusClass(status) {
    const map = {
      PENDING_PAYMENT: 'status-pending',
      PAID: 'status-paid',
      CONFIRMED: 'status-confirmed',
      COMPLETED: 'status-completed',
      CANCELLED: 'status-cancelled'
    }
    return map[status] || ''
  }
})
