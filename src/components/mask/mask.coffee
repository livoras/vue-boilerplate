maskTpl = require './mask.html'

Vue.component 'f-mask',
  template: maskTpl
  data: 
    ips: ['one', 'two', 'three', 'four']
