import Sortable from 'sortablejs'
import Rails from 'rails-ujs'

function recomputeColumnTotal(stateName) {
  var listNode = document.querySelector(`.list[data-state='${stateName}']`)
  if (listNode !== null) {
    var total = listNode.querySelector('.cards').childElementCount
    var totalNode = listNode.querySelector('.total')
    totalNode.innerHTML = total
  }
}

window.recomputeColumnTotal = recomputeColumnTotal

document.addEventListener("DOMContentLoaded", function() {
  var board = document.getElementById('board')
  if (board !== null) {
    var listNodes = board.querySelectorAll('.lists .list')
    listNodes.forEach( (listNode) => {
      var state = listNode.getAttribute('data-state')
      var cardListNodes = listNode.querySelectorAll('.cards')
      cardListNodes.forEach( (cardListNode) => {
        Sortable.create(cardListNode, {
          group: 'job-applications',
          sort: false,
          onAdd: (evt) => {
            var item = evt.item
            var oldState = item.getAttribute('data-state')
            var to = evt.to
            var newState = to.getAttribute('data-state')
            var changeStateUrl = item.getAttribute('data-change-state-url')
            var newChangeStateUrl = changeStateUrl.replace(`state=${oldState}`, `state=${newState}`)

            Rails.ajax({
              type: 'PATCH',
              url: newChangeStateUrl,
              dataType: 'script',
              success: (response) => {
                recomputeColumnTotal(oldState)
              },
              error: (response) => {
                console.log("error")
                console.log(response)
              }
            })
          }
        })
      })
    })
  }
})
