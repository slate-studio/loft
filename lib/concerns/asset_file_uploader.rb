module Loft
  module AssetFileUploader
    extend ActiveSupport::Concern
    included do

      include CarrierWave::MiniMagick

      def store_dir
        "assets/#{ model._number }"
      end

      version :small_150, if: :is_image? do
        process :resize_to_fill => [150, 150]
      end

      def is_image? new_file
        model.is_image?
      end
      private :is_image?

    end
  end
end