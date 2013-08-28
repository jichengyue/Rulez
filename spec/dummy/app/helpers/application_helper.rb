module ApplicationHelper
  def rulez? rule, params = {}
    return Rulez::rulez? rule, params
  end
end
