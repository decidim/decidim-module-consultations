# frozen_string_literal: true

module Decidim
  # The data store for a Consultation in the Decidim::Consultations component.
  class Consultation < ApplicationRecord
    include Decidim::Participable
    include Decidim::Publicable

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"

    belongs_to :highlighted_scope,
               foreign_key: "decidim_highlighted_scope_id",
               class_name: "Decidim::Scope"

    has_many :questions,
             foreign_key: "decidim_consultation_id",
             class_name: "Decidim::Consultations::Question",
             dependent: :destroy

    validates :slug, uniqueness: { scope: :organization }
    validates :slug, presence: true, format: { with: Decidim::Consultation.slug_format }

    mount_uploader :banner_image, Decidim::BannerImageUploader

    scope :upcoming, -> { published.where("start_voting_date > ?", Time.now.utc) }
    scope :active, lambda {
      published
        .where("start_voting_date <= ?", Time.now.utc)
        .where("end_voting_date >= ?", Time.now.utc)
    }
    scope :finished, -> { published.where("end_voting_date < ?", Time.now.utc) }
    scope :order_by_most_recent, -> { order(created_at: :desc) }

    def to_param
      slug
    end

    def upcoming?
      start_voting_date > Time.now.utc
    end

    def active?
      start_voting_date <= Time.now.utc && end_voting_date >= Time.now.utc
    end

    def finished?
      end_voting_date < Time.now.utc
    end

    def highlighted_questions
      questions.published.where(decidim_scope_id: decidim_highlighted_scope_id)
    end

    def regular_questions
      questions.published.where.not(decidim_scope_id: decidim_highlighted_scope_id).group_by(&:scope)
    end

    def self.order_randomly(seed)
      transaction do
        connection.execute("SELECT setseed(#{connection.quote(seed)})")
        select('"decidim_consultations".*, RANDOM()').order("RANDOM()").load
      end
    end
  end
end
