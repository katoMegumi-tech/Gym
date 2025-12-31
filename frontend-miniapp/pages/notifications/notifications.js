const request = require('../../utils/request')

Page({
  data: {
    notifications: [],
    loading: false
  },

  onLoad() {
    this.loadNotifications()
  },

  onPullDownRefresh() {
    this.loadNotifications().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  async loadNotifications() {
    this.setData({ loading: true })
    try {
      // 加载公告作为通知
      const res = await request.get('/announcements', {
        page: 1,
        size: 20,
        status: 'PUBLISHED'
      })
      
      const announcements = res.data.records || []
      const notifications = announcements.map(item => ({
        id: item.id,
        title: item.title,
        content: item.content,
        type: item.type,
        time: item.publishTime,
        read: false
      }))
      
      this.setData({ notifications })
    } catch (error) {
      console.error('加载通知失败:', error)
    } finally {
      this.setData({ loading: false })
    }
  },

  viewDetail(e) {
    const id = e.currentTarget.dataset.id
    const notification = this.data.notifications.find(n => n.id === id)
    
    if (notification) {
      // 标记为已读
      const notifications = this.data.notifications.map(n => {
        if (n.id === id) {
          return { ...n, read: true }
        }
        return n
      })
      this.setData({ notifications })
      
      // 显示详情
      wx.showModal({
        title: notification.title,
        content: notification.content,
        showCancel: false,
        confirmText: '知道了'
      })
    }
  },

  getTypeText(type) {
    const map = {
      SYSTEM: '系统通知',
      ACTIVITY: '活动通知',
      VENUE: '场馆通知'
    }
    return map[type] || '通知'
  },

  getTypeClass(type) {
    const map = {
      SYSTEM: 'type-system',
      ACTIVITY: 'type-activity',
      VENUE: 'type-venue'
    }
    return map[type] || ''
  }
})
