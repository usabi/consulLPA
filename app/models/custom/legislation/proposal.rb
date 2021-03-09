require_dependency Rails.root.join('app', 'models', 'legislation', 'proposal').to_s
class Legislation::Proposal
  # documentable max_documents_allowed: 3, TODO: por setings
  # max_file_size: 5.megabytes,
  # accepted_content_types: [ "application/pdf" ]
end
