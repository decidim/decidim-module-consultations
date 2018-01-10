# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # A form object used to create consultations from the admin dashboard.
      class ConsultationForm < Form
        include TranslatableAttributes

        mimic :consultation

        translatable_attribute :title, String
        translatable_attribute :subtitle, String
        translatable_attribute :description, String
        attribute :slug, String
        attribute :banner_image
        attribute :remove_banner_image
        attribute :introductory_video_url, String
        attribute :decidim_highlighted_scope_id, Integer
        attribute :start_voting_date, Date

        validates :slug, presence: true, format: { with: Decidim::Consultation.slug_format }
        validates :title, :subtitle, :description, translatable_presence: true
        validates :highlighted_scope, presence: true
        validates :start_voting_date, presence: true

        validate :slug_uniqueness

        validates :banner_image, file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } }, file_content_type: { allow: ["image/jpeg", "image/png"] }

        def highlighted_scope
          @scope ||= current_organization.scopes.where(id: decidim_highlighted_scope_id).first
        end

        private

        def slug_uniqueness
          return unless OrganizationConsultations
                        .new(current_organization)
                        .query
                        .where(slug: slug)
                        .where.not(id: context[:consultation_id]).any?

          errors.add(:slug, :taken)
        end
      end
    end
  end
end
