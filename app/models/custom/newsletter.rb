require_dependency Rails.root.join('app', 'models', 'newsletter').to_s

class Newsletter
  def batch_size
    2000
  end
end
