const request = require('../../utils/request')

Page({
  data: {
    courtId: null,
    courtInfo: null,
    selectedDate: '',
    dateList: [],
    timeslots: [],
    selectedSlot: null,
    loading: false,
    contactName: '',
    contactPhone: '',
    participants: 1
  },

  onLoad(options) {
    if (options.courtId) {
      this.setData({ courtId: options.courtId })
      this.loadCourtInfo()
      this.initDateList()
    }
  },

  initDateList() {
    const dateList = []
    const today = new Date()
    for (let i = 0; i < 7; i++) {
      const date = new Date(today)
      date.setDate(today.getDate() + i)
      const dateStr = this.formatDate(date)
      const weekDay = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][date.getDay()]
      dateList.push({
        date: dateStr,
        display: i === 0 ? '今天' : (i === 1 ? '明天' : weekDay),
        fullDisplay: `${date.getMonth() + 1}/${date.getDate()}`
      })
    }
    this.setData({ 
      dateList,
      selectedDate: dateList[0].date 
    })
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
      
      // 加载用户信息作为默认联系人
      const userInfo = wx.getStorageSync('userInfo')
      if (userInfo) {
        this.setData({
          contactName: userInfo.realName || userInfo.username || '',
          contactPhone: userInfo.phone || ''
        })
      }
    } catch (error) {
      console.error('加载场地信息失败:', error)
    }
  },

  async loadTimeslots() {
    this.setData({ loading: true, selectedSlot: null })
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

  selectDate(e) {
    const date = e.currentTarget.dataset.date
    this.setData({ selectedDate: date })
    this.loadTimeslots()
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

  onInputChange(e) {
    const field = e.currentTarget.dataset.field
    this.setData({ [field]: e.detail.value })
  },

  onParticipantsChange(e) {
    this.setData({ participants: parseInt(e.detail.value) || 1 })
  },

  async handleBooking() {
    if (!this.data.selectedSlot) {
      wx.showToast({ title: '请选择时间段', icon: 'none' })
      return
    }

    if (!this.data.contactName) {
      wx.showToast({ title: '请输入联系人', icon: 'none' })
      return
    }

    if (!this.data.contactPhone) {
      wx.showToast({ title: '请输入联系电话', icon: 'none' })
      return
    }

    wx.showLoading({ title: '提交中...' })

    try {
      const res = await request.post('/reservations', {
        courtId: this.data.courtId,
        slotDate: this.data.selectedDate,
        startTime: this.data.selectedSlot.startTime,
        endTime: this.data.selectedSlot.endTime,
        amount: this.data.selectedSlot.price,
        participants: this.data.participants,
        contactName: this.data.contactName,
        contactPhone: this.data.contactPhone
      })

      wx.hideLoading()

      // 跳转到预约详情页进行支付
      wx.navigateTo({
        url: `/pages/reservation-detail/reservation-detail?id=${res.data.id}`
      })
    } catch (error) {
      wx.hideLoading()
      console.error('预约失败:', error)
    }
  }
})
