MaintenanceTasks.error_handler = ->(error, task_context, errored_element) do
  RorVsWild.record_error(error, task_context: task_context, errored_element: errored_element)
end
