export default function offCanvas() {
  ;[].forEach.call(document.querySelectorAll('[data-toggle="offcanvas"]'), function(offcanvasButtonNode) {
    offcanvasButtonNode.addEventListener('click', function(evt) {
      ;[].forEach.call(document.querySelectorAll('.offcanvas-collapse'), function(offcanvasMenu) {
        offcanvasMenu.classList.toggle('open')
      })
    })
  })

  ;[].forEach.call(document.querySelectorAll('.offcanvas-collapse'), function(offcanvasMenu) {
    offcanvasMenu.addEventListener('click', function(evt) {
      offcanvasMenu.classList.toggle('open')
    })
  })
}