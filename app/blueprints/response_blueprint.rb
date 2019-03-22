class ResponseBlueprint < Blueprinter::Base
  identifier :id
  fields :price, :user_id, :announcement_id, :status, :created_at, :updated_at
end