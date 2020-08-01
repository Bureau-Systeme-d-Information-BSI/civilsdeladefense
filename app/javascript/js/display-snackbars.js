export default function displaySnackbars() {
  var alertNotice = document.querySelector('.alert.alert-info')
  if (alertNotice !== null) {
    var msg = alertNotice.innerHTML
    // $.snackbar({content: msg})
  }
}
