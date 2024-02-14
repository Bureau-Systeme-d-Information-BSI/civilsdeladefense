if ENV["RORVSWILD_API_KEY"].present?
  RorVsWild.start(
    api_key: ENV["RORVSWILD_API_KEY"],
    ignore_exceptions: ["ActionController::RoutingError"],
    editor_url: ENV.fetch("RORVSWILD_EDITOR_URL", "vscode://file${path}:${line}"),
    widget: "top-right"
  )
end
