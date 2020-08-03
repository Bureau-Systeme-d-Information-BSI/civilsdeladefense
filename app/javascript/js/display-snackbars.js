export default function displaySnackbars() {
  var alertNotice = document.querySelector('.alert.alert-info')
  if (alertNotice !== null) {
    var msg = alertNotice.innerHTML
    Snackbar.show({showAction: false, text: msg})
  }
}
