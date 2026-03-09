module ApplicationHelper
  def merged_params(new_params = {}, except: [])
    params
      .to_unsafe_h
      .except(:controller, :action, *except)
      .merge(new_params)
  end
end
