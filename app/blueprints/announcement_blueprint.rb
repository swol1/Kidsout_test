class AnnouncementBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :user_id, :description, :status, :created_at, :updated_at
  end

  view :extended do
    include_view :normal

    association :responses, blueprint: ResponseBlueprint
  end
end