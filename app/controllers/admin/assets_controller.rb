class Admin::AssetsController < Admin::BaseController
  mongosteen

  has_scope :by_type
end
