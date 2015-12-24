module LoftAssetFileUploader
  extend ActiveSupport::Concern

  included do
    include CarrierWave::MiniMagick

    def store_dir
      "loft/#{ model._number }"
    end

    version :_40x40_2x, if: :is_image? do
      process :resize_to_fill => [80, 80]
    end

    version :_200x150_2x, if: :is_image? do
      process :resize_to_fill => [400, 300]
    end

    version :thumbnail, if: :is_image? do
      process :resize_to_fill => [320, 320]
    end

    version :small, if: :is_image? do
      process :resize_to_fit => [320, 320]
    end

    version :medium, if: :is_image? do
      process :resize_to_fit => [640, 640]
    end

    version :large, if: :is_image? do
      process :resize_to_fit => [1280, 1280]
    end

    def is_image? new_file
      model.is_image?
    end
    private :is_image?

  end
end
