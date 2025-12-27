const request = require('../../utils/request')

Page({
  data: {
    courtId: null,
    courtInfo: null,
    selectedDate: '',
    timeslots: [],
    selectedSlot: null,
    loading: false
  },

  onLoad(options) {
    if (options.courtId) {
      this.setData({ courtId: options.courtId })
      this.loadCourtInfo()
      this.initDate()
    }
  },

  initDate() {
    const today = new Date()
    const dateStr = this.formatDate(today)
    this.setData({ selectedDate: dateStr })
    this.loadTimeslots()
  },

  formatDate(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  },

  async loadCourtInfo() {
    try {
      const res = await request.get(`/courts/${this.data.courtId}`)
      this.setData({ courtInfo: res.data })
    } catch (error) {
      console.error('加载场地信息失败:', error)
    }
  },

  async loadTimeslots() {
    this.setData({ loading: true })
    try {
      const res = await request.get('/timeslots', {
        courtId: this.data.courtId,
        date: this.data.selectedDate
      })
      this.setData({ timeslots: res.data || [] })
    } catch (error) {
      console.error('加载时间段失败:', error)
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  onDateChange(e) {
    this.setData({
      selectedDate: e.detail.value,
      selectedSlot: null
    })
    this.loadTimeslots()
  },

  selectSlot(e) {
    const index = e.currentTarget.dataset.index
    const slot = this.data.timeslots[index]
    
    if (slot.status !== 'AVAILABLE') {
      wx.showToast({
        title: '该时段不可预约',
        icon: 'none'
      })
      return
    }
    
    this.setData({ selectedSlot: slot })
  },

  async handleBooking() {
    if (!this.data.selectedSlot) {
      wx.showToast({
        title: '请选择时间段',
        icon: 'none'
      })
      return
    }

    try {
      await request.post('/reservations', {
        courtId: this.data.courtId,
        slotDate: this.data.selectedDate,
        startTime: this.data.selectedSlot.startTime,
        endTime: this.data.selectedSlot.endTime,
        amount: this.data.selectedSlot.price,
        participants: 1,
        contactName: '用户',
        contactPhone: '13800000000'
      })

      wx.showToast({
        title: '预约成功',
        icon: 'success'
      })

      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      console.error('预约失败:', error)
    }
  }
})
