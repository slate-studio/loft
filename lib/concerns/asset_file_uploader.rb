module Loft
  module AssetFileUploader
    extend ActiveSupport::Concern
    included do

      include CarrierWave::MiniMagick

      def store_dir
        "loft/#{ model._number }"
      end

      version :_200x150_2x, if: :is_image? do
        process :resize_to_fill => [400, 300]
      end

      def is_image? new_file
        model.is_image?
      end
      private :is_image?

    end
  end
end