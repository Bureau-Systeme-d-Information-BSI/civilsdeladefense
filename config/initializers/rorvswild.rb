if Rails.application.credentials.rorvswild_api_key.present?
  RorVsWild.start(
    api_key: Rails.application.credentials.rorvswild_api_key,
    ignore_exceptions: ["ActionController::RoutingError"],
    editor_url: ENV.fetch("RORVSWILD_EDITOR_URL", "vscode://file${path}:${line}"),
    widget: "top-right"
  )
end
