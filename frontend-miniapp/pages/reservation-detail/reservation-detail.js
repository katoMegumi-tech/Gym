const request = require('../../utils/request')

Page({
  data: {
    reservationId: null,
    detail: null,
    loading: true
  },

  onLoad(options) {
    if (options.id) {
      this.setData({ reservationId: options.id })
      this.loadDetail()
    }
  },

  async loadDetail() {
    this.setData({ loading: true })
    try {
      const res = await request.get(`/reservations/${this.data.reservationId}`)
      this.setData({ detail: res.data })
    } catch (error) {
      console.error('加载详情失败:', error)
      wx.showToast({ title: '加载失败', icon: 'none' })
    } finally {
      this.setData({ loading: false })
    }
  },

  async handlePay() {
    wx.showLoading({ title: '支付中...' })
    try {
      await request.post(`/reservations/${this.data.reservationId}/pay`, {
        paymentMethod: 'WECHAT'
      })
      wx.hideLoading()
      wx.showToast({ title: '支付成功', icon: 'success' })
      this.loadDetail()
    } catch (error) {
      wx.hideLoading()
      console.error('支付失败:', error)
    }
  },

  handleCancel() {
    wx.showModal({
      title: '取消预约',
      content: '确定要取消这个预约吗？已支付的订单将自动退款。',
      success: async (res) => {
        if (res.confirm) {
          try {
            await request.put(`/reservations/${this.data.reservationId}/cancel?reason=用户取消`)
            wx.showToast({ title: '取消成功', icon: 'success' })
            setTimeout(() => wx.navigateBack(), 1500)
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
      CANCELLED: 'status-cancelled',
      REFUNDED: 'status-refunded'
    }
    return map[status] || ''
  }
})
