# frozen_string_literal: true

class AddSlugToDecidimConsultationsQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_consultations_questions,
               :decidim_organization_id,
               foreign_key: true,
               index: {
                 name: "index_decidim_questions_on_decidim_organization_id"
               }
    add_column :decidim_consultations_questions, :slug, :string

    Decidim::Consultations::Question.find_each do |question|
      question.decidim_organization_id = question.consultation.decidim_organization_id
      question.slug = "q-#{question.id}"
      question.save
    end

    change_column_null :decidim_organizations_questions, :decidim_organization_id, false
    change_column_null :decidim_organizations_questions, :slug, false

    add_index :decidim_consultations_questions,
              [:decidim_organization_id, :slug],
              name: "index_unique_question_slug_and_organization",
              unique: true
  end
end
