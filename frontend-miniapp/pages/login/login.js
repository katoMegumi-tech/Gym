const app = getApp()
const request = require('../../utils/request')

Page({
  data: {
    username: '',
    password: '',
    loading: false
  },

  onUsernameInput(e) {
    this.setData({
      username: e.detail.value
    })
  },

  onPasswordInput(e) {
    this.setData({
      password: e.detail.value
    })
  },

  async handleLogin() {
    const { username, password } = this.data

    if (!username) {
      wx.showToast({
        title: '请输入用户名',
        icon: 'none'
      })
      return
    }

    if (!password) {
      wx.showToast({
        title: '请输入密码',
        icon: 'none'
      })
      return
    }

    this.setData({ loading: true })

    try {
      const res = await request.post('/auth/login', {
        username,
        password
      })

      // 保存token和用户信息
      wx.setStorageSync('token', res.data.token)
      wx.setStorageSync('userInfo', res.data)
      app.globalData.token = res.data.token

      wx.showToast({
        title: '登录成功',
        icon: 'success'
      })

      // 延迟跳转，让用户看到成功提示
      setTimeout(() => {
        wx.switchTab({
          url: '/pages/index/index'
        })
      }, 1500)

    } catch (error) {
      console.error('登录失败:', error)
      wx.showToast({
        title: '登录失败，请检查账号密码',
        icon: 'none',
        duration: 2000
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  async handleWechatLogin() {
    this.setData({ loading: true })

    try {
      // 1. 调用微信登录获取code
      const loginRes = await wx.login()
      const code = loginRes.code

      if (!code) {
        throw new Error('获取微信登录凭证失败')
      }

      console.log('获取到微信code:', code)

      // 2. 将code发送到后端，换取token
      const res = await request.post('/auth/wechat-login', { code })

      // 3. 保存token和用户信息
      wx.setStorageSync('token', res.data.token)
      wx.setStorageSync('userInfo', res.data)
      app.globalData.token = res.data.token

      wx.showToast({
        title: '微信登录成功',
        icon: 'success',
        duration: 2000
      })

      // 4. 延迟跳转到首页
      setTimeout(() => {
        wx.switchTab({
          url: '/pages/index/index'
        })
      }, 1500)

    } catch (error) {
      console.error('微信登录失败:', error)
      wx.showToast({
        title: error.message || '微信登录失败',
        icon: 'none',
        duration: 2000
      })
    } finally {
      this.setData({ loading: false })
    }
  },

  // 快速填充测试账号
  onLoad() {
    // 开发环境可以预填充测试账号
    // this.setData({
    //   username: 'alice',
    //   password: '123456'
    // })
  }
})
