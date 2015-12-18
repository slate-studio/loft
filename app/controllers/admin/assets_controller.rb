module Admin
  class AssetsController < Admin::BaseController
    mongosteen

    has_scope :by_type
    has_scope :images, type: :boolean
    has_scope :not_images, type: :boolean
  end
end
