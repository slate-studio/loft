module ActionDispatch::Routing
  class Mapper
    def mount_loft_assets_crud
      resources :assets, controller: 'assets'
    end
  end
end
