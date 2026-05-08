import Sortable from "sortablejs";
import Rails from "@rails/ujs";
import BSN from "bootstrap.native/dist/bootstrap-native.js";
import formAutoSubmit from "./form-auto-submit";
import dependentFields from "./dependent-fields";
import displaySnackbars from "./display-snackbars";
import emailTemplateSelectHandling from "./email-template-select-handling";

export function boardRedraw() {
  var url = window.location.href;
  var nodeBoard = document.querySelector("#board");
  if (nodeBoard !== null) {
    Rails.ajax({
      type: "GET",
      url: url,
      dataType: "html",
      success: (response) => {
        nodeBoard.outerHTML = response.body.innerHTML;
        boardManagement();
      },
      error: (response) => {
        console.log("error boardManagement");
        console.log(response);
      },
    });
  }
}

export function boardManagement() {
  var board = document.getElementById("board");
  if (board !== null && board.getAttribute("data-draggable") !== null) {
    [].forEach.call(
      board.querySelectorAll(".lists .list"),
      function (listNode) {
        var state = listNode.getAttribute("data-state");
        [].forEach.call(
          listNode.querySelectorAll(".cards"),
          function (cardListNode) {
            Sortable.create(cardListNode, {
              group: "job-applications",
              sort: false,
              onAdd: (evt) => {
                var item = evt.item;
                var oldState = item.getAttribute("data-state");
                var to = evt.to;
                var newState = to.getAttribute("data-state");

                if (newState === "rejected") {
                  var rejectionUrl = item.getAttribute("data-rejection-url");
                  if (rejectionUrl === "#") {
                    Snackbar.show({
                      text: "Vous n'êtes pas autorisé(e) à refuser cette candidature.",
                      showAction: false,
                    });
                    boardRedraw();
                    return;
                  }
                  Rails.ajax({
                    type: "GET",
                    url: rejectionUrl,
                    dataType: "html",
                    success: (response) => {
                      var modal = document.getElementById("remoteContentModal");
                      var modalBody = modal.querySelector(".modal-body");
                      modalBody.innerHTML = response.body
                        ? response.body.innerHTML
                        : response.documentElement.innerHTML;
                      var form = modalBody.querySelector("form");
                      if (form) {
                        form.setAttribute("data-remote", "true");
                      }
                      new BSN.Modal(modal).show();
                      modal.addEventListener(
                        "hidden.bs.modal",
                        function onHidden() {
                          modal.removeEventListener(
                            "hidden.bs.modal",
                            onHidden,
                          );
                          boardRedraw();
                        },
                      );
                    },
                    error: (response) => {
                      console.log("error loading rejection form");
                      console.log(response);
                      boardRedraw();
                    },
                  });
                } else if (item.getAttribute("data-rejected") === "true") {
                  if (newState === "initial") {
                    var rejectionUrl = item.getAttribute("data-rejection-url");
                    if (rejectionUrl === "#") {
                      Snackbar.show({
                        text: "Vous n'êtes pas autorisé(e) à annuler le refus de cette candidature.",
                        showAction: false,
                      });
                      boardRedraw();
                      return;
                    }
                    var destroyUrl = rejectionUrl.replace("/new", "");
                    Rails.ajax({
                      type: "DELETE",
                      url: destroyUrl,
                      dataType: "script",
                    });
                  } else {
                    Snackbar.show({
                      text: 'Vous devez d\'abord remettre la candidature en "Nouvelle candidature"',
                      showAction: false,
                    });
                    boardRedraw();
                  }
                } else {
                  var changeStateUrl = item.getAttribute(
                    "data-change-state-url",
                  );
                  var newChangeStateUrl = changeStateUrl.replace(
                    `state=${oldState}`,
                    `state=${newState}`,
                  );

                  Rails.ajax({
                    type: "PATCH",
                    url: newChangeStateUrl,
                    dataType: "script",
                    success: (response) => {},
                    error: (response) => {
                      console.log("error boardManagement");
                      console.log(response);
                    },
                  });
                }
              },
            });
          },
        );
      },
    );
  }
}
