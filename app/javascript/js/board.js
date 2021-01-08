import Sortable from 'sortablejs'
import Rails from '@rails/ujs'
import BSN from 'bootstrap.native/dist/bootstrap-native.js'
import formAutoSubmit from 'js/form-auto-submit'
import dependentFields from 'js/dependent-fields'
import displaySnackbars from 'js/display-snackbars'
import emailTemplateSelectHandling from 'js/email-template-select-handling'

export function boardRedraw() {
  var url = window.location.href
  var nodeBoard = document.querySelector('#board')
  if (nodeBoard !== null) {
    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'html',
      success: (response) => {
        nodeBoard.outerHTML = response.body.innerHTML
        boardManagement()
      },
      error: (response) => {
        console.log('error boardManagement')
        console.log(response)
      }
    })
  }
}

export function boardShowRejectionModal(url) {
  var nodeBoard = document.querySelector('#board')
  if (nodeBoard !== null) {
    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'html',
      success: (response) => {
        var html = response.body.innerHTML
        var nodeRemoteContentModal = document.querySelector('#remoteContentModal')
        var nodeModalContent = nodeRemoteContentModal.querySelector('.modal-content')
        nodeModalContent.insertAdjacentHTML('afterbegin', html)
        new BSN.Modal('#remoteContentModal').show()
        BSN.initCallback()
        formAutoSubmit()
        dependentFields()
        displaySnackbars()
        emailTemplateSelectHandling()
      },
      error: (response) => {
        console.log('error boardManagement')
        console.log(response)
      }
    })
  }
}

export function boardManagement() {
  var board = document.getElementById('board')
  if (board !== null && board.getAttribute('data-draggable') !== null) {
    ;[].forEach.call(board.querySelectorAll('.lists .list'), function(listNode) {
      var state = listNode.getAttribute('data-state')
      ;[].forEach.call(listNode.querySelectorAll('.cards'), function(cardListNode) {
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
              },
              error: (response) => {
                console.log('error boardManagement')
                console.log(response)
              }
            })
          }
        })
      })
    })
  }
}
