function setTimeoutWithTurbo(intervalFunction, milliseconds) {
  var interval = setTimeout(intervalFunction, milliseconds);

  document.addEventListener('turbo:before-render', function () {
    clearTimeout(interval);
  });
}

export default function timeoutAlert() {
  setTimeoutWithTurbo(function () {
    var date = new Date();
    date.setMinutes(date.getMinutes() + 10);
    options = {
      hour: '2-digit',
      minute: '2-digit'
    };
    var date_str = date.toLocaleString('fr-FR', options);

    Snackbar.show({
      text: 'Sans action de votre part dans les 10 prochaines minutes, votre session expirera et vous serez déconnecté de la plateforme à ' + date_str,
      duration: 0,
      showAction: false,
      customClass: 'warning-snackbar'
    });
  }, 1 * 45 * 1000)
}
