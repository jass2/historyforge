class Cms::Picture < Cms::PageWidget

  has_one_attached :file

  json_attribute :style, as: :string
  json_attribute :width, as: :integer
  json_attribute :height, as: :integer
  json_attribute :caption, as: :string
  json_attribute :alt_text, as: :string
  json_attribute :bootstrap_class, as: :enumeration, values: %w{thumbnail rounded circle}, strict: true
  json_attribute :alignment, as: :enumeration, values: %w{left center right}, strict: true

  before_save :cache_html

  def self.style_options
    [
      ['Full Width Picture', 'full'],
      ['Half Width Picture', 'half'],
      ['Third Width Picture', 'third'],
      ['Quarter Width Picture', 'quarter'],
      ['Raw Image URL', 'raw']
    ]
  end

  def render
    if style.present?
      if style == 'raw'
        RawImgTagRenderer.new(self).render
      else
        PictureTagRenderer.new(self).render
      end
    else
      ImgTagRenderer.new(self).render
    end
  end

  def url
    file.attached? && Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  class BaseRenderer
    include ActionView::Helpers::TagHelper
    attr_reader :picture

    def initialize(picture)
      @picture = picture
    end

    def render
      html = render_image.html_safe

      if picture.caption?
        html << content_tag(:p, picture.caption)
      end

      html_options = { class: 'cms-slide cms-image ' }
      html_options[:id] = picture.css_id if picture.css_id?
      html_options[:class] << picture.css_class if picture.css_class?
      if picture.css_clear.present? && picture.css_clear != 'none'
        html_options[:style] = "clear: #{picture.css_clear}"
      end

      if picture.alignment?
        html_options[:class] << " img-#{picture.alignment}"
        html = content_tag(:div, html) if picture.alignment == 'center'
      end

      content_tag :div, html, html_options
    end
  end

  class ImgTagRenderer < BaseRenderer
    def render_image
      html_options = {}
      style_attr = ''
      style_attr << "width:#{picture.width}px;" if picture.width?
      style_attr << "height:#{picture.height}px;" if picture.height?
      html_options[:style] = style_attr if style_attr.present?
      html_options[:alt] = picture.alt_text if picture.alt_text?
      html_options[:src] = picture.url
      html_options[:class] = "img-responsive"
      html_options[:class] << " img-#{picture.bootstrap_class}" if picture.bootstrap_class?
      tag :img, html_options
    end
  end

  class PictureTagRenderer < BaseRenderer
    def render_image
      img_class = picture.bootstrap_class? ? "img-#{picture.bootstrap_class}" : nil
      return <<-EOD
      <picture>
      <!--[if IE 9]><video style="display: none;"><![endif]-->
      <source srcset="/uploads/pictures/#{picture.id}/#{picture.style}/phone.jpg" media="(max-width:480px)">
      <source srcset="/uploads/pictures/#{picture.id}/#{picture.style}/tablet.jpg" media="(min-width:481px) and (max-width:1024px)">
      <source srcset="/uploads/pictures/#{picture.id}/#{picture.style}/desktop.jpg" media="(min-width:1025px)">
      <!--[if IE 9]></video><![endif]-->
      <img src="#{picture.url}" alt="#{picture.alt_text}" title="" class="img-responsive #{img_class}">
      </picture>
      EOD
    end
  end

  class RawImgTagRenderer < BaseRenderer
    def render
      picture.url
    end
  end
end