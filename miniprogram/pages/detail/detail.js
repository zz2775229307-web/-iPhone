// detail.js
const mock = require('../../data/mock_data.json')

Page({
  data: {
    model: {},
    history: []
  },

  onLoad(options) {
    const key = options.model
    this.loadModel(key)
  },

  loadModel(key) {
    const d = mock
    const model = d.models.find(m => m.key === key) || {}
    const history = model.history || [
      { date: d.date, price: model.median_price },
      { date: '2026-07-22', price: Math.round(model.median_price * 1.02) },
      { date: '2026-07-15', price: Math.round(model.median_price * 0.98) }
    ]
    model.trendDisplay = model.trend > 0 ? '↑' + (model.trend * 100).toFixed(1) + '%' : (model.trend < 0 ? '↓' + (Math.abs(model.trend) * 100).toFixed(1) + '%' : '—')
    this.setData({ model, history })
  },

  onBack() {
    wx.navigateBack()
  }
})
