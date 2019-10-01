require_dependency Rails.root.join('app', 'models', 'legislation', 'process').to_s
class Legislation::Process
  documentable max_documents_allowed: 3,
  max_file_size: 5.megabytes,
  accepted_content_types: [ "application/pdf" ]
end
