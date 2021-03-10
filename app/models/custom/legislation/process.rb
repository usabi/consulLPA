require_dependency Rails.root.join('app', 'models', 'legislation', 'process').to_s
class Legislation::Process

  def self.max_documents_allowed
    3
  end

  def self.max_file_size
    5.megabytes
  end

  def self.accepted_content_types
    ["application/pdf"]
  end

end
