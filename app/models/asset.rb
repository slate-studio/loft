class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include LoftAsset
end
