# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"

module Decidim
  module Consultations
    # Decidim's Consultations Rails Admin Engine.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Consultations::Admin

      paths["db/migrate"] = nil

      routes do
        resources :consultations, param: :slug, except: :show do
          resource :publish, controller: "consultation_publications", only: [:create, :destroy]
          resources :questions, param: :slug, except: :show, shallow: true do
            resource :publish, controller: "question_publications", only: [:create, :destroy]
          end
        end

        scope "/questions/:question_slug" do
          resources :features do
            resource :permissions, controller: "feature_permissions"
            member do
              put :publish
              put :unpublish
            end
            resources :exports, only: :create
          end
        end

        scope "/questions/:question_slug/features/:feature_id/manage" do
          Decidim.feature_manifests.each do |manifest|
            next unless manifest.admin_engine

            constraints CurrentFeature.new(manifest) do
              mount manifest.admin_engine, at: "/", as: "decidim_admin_question_#{manifest.name}"
            end
          end
        end
      end

      # initializer "admin_decidim_initiatives.assets" do |app|
      #   app.config.assets.precompile += %w[
      #     admin_decidim_initiatives_manifest.js
      #   ]
      # end

      initializer "decidim_consultations.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.admin_abilities += %w[
            Decidim::Consultations::Abilities::Admin::ConsultationAdminAbility
          ]
        end
      end

      initializer "decidim_consultations.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.consultations", scope: "decidim.admin"),
                    decidim_admin_consultations.consultations_path,
                    icon_name: "comment-square",
                    position: 3.8,
                    active: :inclusive,
                    if: can?(:index, Decidim::Consultation)
        end
      end
    end
  end
end
