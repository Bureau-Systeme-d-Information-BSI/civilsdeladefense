;[].forEach.call(document.querySelectorAll('[data-toggle="offcanvas"]'), function(offcancasButtonNode) {
  offcancasButtonNode.addEventListener('click', function(evt) {
    ;[].forEach.call(document.querySelectorAll('.offcanvas-collapse'), function(offcancasMenu) {
      offcancasMenu.classList.toggle('open')
    })
  })
})

;[].forEach.call(document.querySelectorAll('.offcanvas-collapse'), function(offcancasMenu) {
  offcancasMenu.addEventListener('click', function(evt) {
    offcancasMenu.classList.toggle('open')
  })
})
