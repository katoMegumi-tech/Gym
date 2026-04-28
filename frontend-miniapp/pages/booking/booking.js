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
    participants: 1,
    couponList: [],
    myCoupons: [],
    selectedCouponId: null,
    selectedCouponText: '不使用优惠券',
    discountAmount: 0,
    payableAmount: 0,
    isFavorite: false
  },

  onLoad(options) {
    if (options.courtId) {
      this.setData({ courtId: options.courtId })
      this.loadCourtInfo()
      this.initDateList()
      this.loadCouponData()
      this.checkFavorite()
    }
  },

  onShow() {
    if (this.data.courtId) {
      this.checkFavorite()
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

  async checkFavorite() {
    const token = wx.getStorageSync('token')
    if (!token || !this.data.courtId) return

    try {
      const res = await request.get('/favorites/check', {
        targetType: 'COURT',
        targetId: this.data.courtId
      })
      this.setData({ isFavorite: !!res.data })
    } catch (error) {
      console.error('检查场地收藏状态失败:', error)
    }
  },

  async toggleFavorite() {
    const token = wx.getStorageSync('token')
    if (!token) {
      wx.navigateTo({ url: '/pages/login/login' })
      return
    }

    try {
      if (this.data.isFavorite) {
        await request.delete('/favorites', {
          targetType: 'COURT',
          targetId: this.data.courtId
        })
        wx.showToast({ title: '取消收藏', icon: 'success' })
      } else {
        await request.post('/favorites', {
          targetType: 'COURT',
          targetId: this.data.courtId
        })
        wx.showToast({ title: '收藏成功', icon: 'success' })
      }
      this.setData({ isFavorite: !this.data.isFavorite })
    } catch (error) {
      console.error('场地收藏操作失败:', error)
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
    
    this.setData({ selectedSlot: slot }, () => {
      this.updatePriceInfo()
    })
  },

  onInputChange(e) {
    const field = e.currentTarget.dataset.field
    this.setData({ [field]: e.detail.value })
  },

  onParticipantsChange(e) {
    this.setData({ participants: parseInt(e.detail.value) || 1 })
  },

  async loadCouponData() {
    try {
      const [couponRes, myCouponRes] = await Promise.all([
        request.get('/coupons', { page: 1, size: 100, status: 'ACTIVE' }),
        request.get('/coupons/my', { page: 1, size: 100, status: 'UNUSED' })
      ])

      this.setData({
        couponList: couponRes.data.records || [],
        myCoupons: myCouponRes.data.records || []
      })
      this.updatePriceInfo()
    } catch (error) {
      console.error('加载优惠券失败:', error)
    }
  },

  getCouponDetail(couponId) {
    return (this.data.couponList || []).find(item => item.id === couponId) || null
  },

  parseDateTime(value) {
    if (!value) return null
    const raw = String(value).trim()
    // 兼容多种后端返回格式，避免解析失败导致过期券漏筛
    const candidates = [
      raw,
      raw.replace('T', ' '),
      raw.replace('T', ' ').replace(/-/g, '/'),
      raw.replace(/-/g, '/')
    ]
    for (let i = 0; i < candidates.length; i++) {
      const parsed = new Date(candidates[i])
      if (!Number.isNaN(parsed.getTime())) {
        return parsed
      }
    }
    return null
  },

  getUsableCoupons() {
    const selectedSlot = this.data.selectedSlot
    if (!selectedSlot) return []

    const amount = Number(selectedSlot.price) || 0
    const now = new Date()
    const nowMs = now.getTime()

    return (this.data.myCoupons || []).filter(userCoupon => {
      if (userCoupon.status !== 'UNUSED') return false
      const expireAt = this.parseDateTime(userCoupon.expireAt)
      if (expireAt && expireAt.getTime() <= nowMs) return false

      const coupon = this.getCouponDetail(userCoupon.couponId)
      if (!coupon) return false
      if (coupon.status !== 'ACTIVE') return false

      // 过滤优惠券本身已过期/未生效
      const startTime = this.parseDateTime(coupon.startTime)
      const endTime = this.parseDateTime(coupon.endTime)
      if (startTime && startTime.getTime() > nowMs) return false
      if (endTime && endTime.getTime() <= nowMs) return false

      const minAmount = Number(coupon.minAmount) || 0
      return amount >= minAmount
    })
  },

  calculateDiscount(coupon, amount) {
    const rawAmount = Number(amount) || 0
    if (!coupon || rawAmount <= 0) return 0

    let discount = 0
    if (coupon.type === 'AMOUNT') {
      discount = Number(coupon.value) || 0
    } else if (coupon.type === 'PERCENTAGE') {
      const rate = Number(coupon.value) || 0
      // 与后端保持一致：PERCENTAGE 按 "优惠百分比" 计算，例如 10 表示减免 10%
      discount = rawAmount * (rate / 100)
    }

    discount = Math.max(0, discount)
    return Number(Math.min(discount, rawAmount).toFixed(2))
  },

  updatePriceInfo() {
    const selectedSlot = this.data.selectedSlot
    if (!selectedSlot) {
      this.setData({
        discountAmount: 0,
        payableAmount: 0,
        selectedCouponId: null,
        selectedCouponText: '不使用优惠券'
      })
      return
    }

    const amount = Number(selectedSlot.price) || 0
    const usableCoupons = this.getUsableCoupons()

    let selectedCouponId = this.data.selectedCouponId
    if (selectedCouponId && !usableCoupons.some(item => item.couponId === selectedCouponId)) {
      selectedCouponId = null
    }

    let discountAmount = 0
    let selectedCouponText = '不使用优惠券'
    if (selectedCouponId) {
      const coupon = this.getCouponDetail(selectedCouponId)
      discountAmount = this.calculateDiscount(coupon, amount)
      selectedCouponText = this.formatCouponText(coupon)
    }

    this.setData({
      selectedCouponId,
      selectedCouponText,
      discountAmount,
      payableAmount: Number((amount - discountAmount).toFixed(2))
    })
  },

  formatCouponText(coupon) {
    if (!coupon) return '不使用优惠券'
    if (coupon.type === 'AMOUNT') {
      return `${coupon.name} - 减${coupon.value}元`
    }
    return `${coupon.name} - ${coupon.value}折`
  },

  chooseCoupon() {
    if (!this.data.selectedSlot) {
      wx.showToast({ title: '请先选择时间段', icon: 'none' })
      return
    }

    const usableCoupons = this.getUsableCoupons()
    if (usableCoupons.length === 0) {
      wx.showToast({ title: '暂无可用优惠券', icon: 'none' })
      return
    }

    const itemList = ['不使用优惠券', ...usableCoupons.map(item => {
      const coupon = this.getCouponDetail(item.couponId)
      const discount = this.calculateDiscount(coupon, this.data.selectedSlot.price)
      return `${this.formatCouponText(coupon)} (省¥${discount})`
    })]

    wx.showActionSheet({
      itemList,
      success: (res) => {
        if (res.tapIndex === 0) {
          this.setData({
            selectedCouponId: null,
            selectedCouponText: '不使用优惠券'
          }, () => this.updatePriceInfo())
          return
        }

        const chosen = usableCoupons[res.tapIndex - 1]
        const coupon = this.getCouponDetail(chosen.couponId)
        this.setData({
          selectedCouponId: chosen.couponId,
          selectedCouponText: this.formatCouponText(coupon)
        }, () => this.updatePriceInfo())
      }
    })
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
        contactPhone: this.data.contactPhone,
        couponId: this.data.selectedCouponId
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
