// index.js
const mock = require('../../data/mock_data.json')

Page({
  data: {
    summaryTitle: '今日摘要',
    summary: '',
    models: []
  },

  onLoad() {
    this.loadData()
  },

  loadData() {
    // 使用本地 mock 数据
    const d = mock
    const models = d.models.map(m => ({
      ...m,
      trendDisplay: m.trend > 0 ? '↑' + (m.trend * 100).toFixed(1) + '%' : (m.trend < 0 ? '↓' + (Math.abs(m.trend) * 100).toFixed(1) + '%' : '—')
    }))
    this.setData({ summaryTitle: '摘要（' + d.date + '）', summary: d.summary, models })
  },

  onRefresh() {
    wx.showToast({ title: '已刷新（模拟）', icon: 'none' })
    this.loadData()
  },

  openDetail(e) {
    const key = e.currentTarget.dataset.key
    wx.navigateTo({ url: '/pages/detail/detail?model=' + key })
  }
})
