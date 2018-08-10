let offcancasButtonNodes = document.querySelectorAll('[data-toggle="offcanvas"]')
if (offcancasButtonNodes !== null) {
  offcancasButtonNodes.forEach( (offcancasButtonNode) => {
    offcancasButtonNode.addEventListener('click', function(evt) {
      let offcancasMenus = document.querySelectorAll('.offcanvas-collapse')
      if (offcancasMenus !== null) {
        offcancasMenus.forEach( (offcancasMenu) => {
          offcancasMenu.classList.toggle('open')
        })
      }
    })
  })
}

let offcancasMenus = document.querySelectorAll('.offcanvas-collapse')
if (offcancasMenus !== null) {
  offcancasMenus.forEach( (offcancasMenu) => {
    offcancasMenu.addEventListener('click', function(evt) {
      offcancasMenu.classList.toggle('open')
    })
  })
}
