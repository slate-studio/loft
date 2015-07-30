require 'autoinc'
require 'mongoid_search'

module Mongoid
  module LoftAsset
    extend ActiveSupport::Concern

    included do

      include Mongoid::Timestamps
      include Mongoid::Autoinc
      include Mongoid::Search

      include Ants::Id

      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::NumberHelper


      ## Attributes
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
      increments :_number


      ## Uploaders
      mount_uploader :file, AssetFileUploader


      ## Validations
      validates :file, presence: true


      ## Search
      search_in :name, :filename


      ## Scopes
      default_scope   -> { desc(:created_at) }
      scope :by_type, -> asset_type { where(type: asset_type) }


      ## Indexes
      index({ created_at: -1 })


      ## Callbacks
      before_save :update_asset_attributes


      ## Helpers
      def _list_item_title
        name
      end


      def _list_item_subtitle
        time_ago_in_words(self.created_at) + " ago"
      end


      def _list_item_thumbnail
        if is_image?
          { medium: file._200x150_2x.url, small: file._40x40_2x.url }
        else
          {}
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


      def is_pdf?
        return false unless file?
        content_type.match(/pdf/) ? true : false
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
          self.type = 'text'    if self.is_pdf?
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




