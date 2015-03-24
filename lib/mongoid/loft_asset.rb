require 'autoinc'
require 'mongoid_search'

module Mongoid
  module LoftAsset
    extend ActiveSupport::Concern

    included do

      include Mongoid::Autoinc
      include Mongoid::Search
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::NumberHelper

      # attributes
      field :name,           default: ''
      field :filename,       default: ''
      field :size,           type: Integer
      field :humanized_size, default: ''
      field :type,           default: 'other'
                                      # - image
                                      # - video
                                      # - audio
                                      # - archive
                                      # - text

      # increment value, used by uploader
      field :_number, type: Integer
      increments :number

      # uploaders
      mount_uploader :file, AssetFileUploader

      # validations
      validates :file, presence: true

      # search
      search_in :name, :filename

      # scopes
      default_scope   -> { desc(:created_at) }
      scope :by_type, -> asset_type { where(type: asset_type) }

      # indexes
      index({ created_at: -1 })

      # callbacks
      before_save :update_asset_attributes


      # helpers
      def created_ago
        time_ago_in_words(self.created_at) + " ago"
      end


      def list_item_thumbnail
        if is_image? and file?
          file.small_150.url
        else
          ''
        end
      end


      def content_type
        @content_type ||= file.content_type
      end


      def is_image?
        return false unless file?
        content_type.match(/image\//) ? true : false
      end

      def is_text?
        return false unless file?
        content_type.match(/text\//) ? true : false
      end

      def is_archive?
        return false unless file?
        # need to add more archive types: rar, gz, bz2, gzip
        content_type.match(/zip/) ? true : false
      end

      def is_audio?
        return false unless file?
        content_type.match(/audio\//) ? true : false
      end

      def is_video?
        return false unless file?
        content_type.match(/video\//) ? true : false
      end


      def update_asset_attributes
        if file.present? && file_changed?

          # save original file name for search
          self.filename = file.file.original_filename

          # save file size in plain for search
          self.size = file.file.size

          # save humanized file size
          self.humanized_size = number_to_human_size(self.size)

          # asset types
          self.type = 'image'   if self.is_image?
          self.type = 'text'    if self.is_text?
          self.type = 'archive' if self.is_archive?
          self.type = 'audio'   if self.is_audio?
          self.type = 'video'   if self.is_video?
        end

        # use filename as an asset name if name is empty ''
        self.name = self.name.empty? ? self.filename : self.name
      end
      private :update_asset_attributes

    end
  end
end




