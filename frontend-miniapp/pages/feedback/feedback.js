const request = require('../../utils/request')

Page({
  data: {
    types: [
      { value: 'COMPLAINT', label: '投诉' },
      { value: 'SUGGESTION', label: '建议' },
      { value: 'QUESTION', label: '咨询' }
    ],
    selectedType: 0,
    title: '',
    content: '',
    rating: 0,
    feedbackList: []
  },

  onLoad() {
    this.loadFeedbackList()
  },

  onTypeChange(e) {
    this.setData({ selectedType: e.detail.value })
  },

  onTitleInput(e) {
    this.setData({ title: e.detail.value })
  },

  onContentInput(e) {
    this.setData({ content: e.detail.value })
  },

  onRatingChange(e) {
    this.setData({ rating: e.currentTarget.dataset.rating })
  },

  async handleSubmit() {
    const { types, selectedType, title, content, rating } = this.data

    if (!title) {
      wx.showToast({
        title: '请输入标题',
        icon: 'none'
      })
      return
    }

    if (!content) {
      wx.showToast({
        title: '请输入内容',
        icon: 'none'
      })
      return
    }

    try {
      await request.post('/feedback', {
        type: types[selectedType].value,
        title,
        content,
        rating: rating || null
      })

      wx.showToast({
        title: '提交成功',
        icon: 'success'
      })

      this.setData({
        title: '',
        content: '',
        rating: 0,
        selectedType: 0
      })

      this.loadFeedbackList()
    } catch (error) {
      console.error('提交失败:', error)
    }
  },

  async loadFeedbackList() {
    try {
      const res = await request.get('/feedback/my', {
        page: 1,
        size: 20
      })
      this.setData({ feedbackList: res.data.records || [] })
    } catch (error) {
      console.error('加载反馈列表失败:', error)
    }
  },

  getTypeText(type) {
    const map = {
      COMPLAINT: '投诉',
      SUGGESTION: '建议',
      QUESTION: '咨询'
    }
    return map[type] || type
  },

  getStatusText(status) {
    const map = {
      PENDING: '待处理',
      PROCESSING: '处理中',
      RESOLVED: '已解决',
      CLOSED: '已关闭'
    }
    return map[status] || status
  }
})
