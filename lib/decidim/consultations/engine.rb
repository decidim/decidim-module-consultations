# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"

module Decidim
  module Consultations
    # Decidim"s Consultations Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Consultations

      # routes do
      #   get "/initiative_types/search", to: "initiative_types#search", as: :initiative_types_search
      #   get "/initiative_type_scopes/search", to: "initiatives_type_scopes#search", as: :initiative_type_scopes_search
      #
      #   resources :create_initiative
      #
      #   get "initiatives/:initiative_id", to: redirect { |params, _request|
      #     initiative = Decidim::Initiative.find(params[:initiative_id])
      #     initiative ? "/initiatives/#{initiative.slug}" : "/404"
      #   }, constraints: { initiative_id: /[0-9]+/ }
      #
      #   get "/initiatives/:initiative_id/f/:feature_id", to: redirect { |params, _request|
      #     initiative = Decidim::Initiative.find(params[:initiative_id])
      #     initiative ? "/initiatives/#{initiative.slug}/f/#{params[:feature_id]}" : "/404"
      #   }, constraints: { initiative_id: /[0-9]+/ }
      #
      #   resources :initiatives, param: :slug, only: [:index, :show], path: "initiatives" do
      #     member do
      #       get :signature_identities
      #     end
      #
      #     resource :initiative_vote, only: [:create, :destroy]
      #     resource :initiative_widget, only: :show, path: "embed"
      #     resources :committee_requests, only: [:new], shallow: true do
      #       collection do
      #         get :spawn
      #       end
      #     end
      #   end
      #
      #   scope "/initiatives/:initiative_slug/f/:feature_id" do
      #     Decidim.feature_manifests.each do |manifest|
      #       next unless manifest.engine
      #
      #       constraints CurrentFeature.new(manifest) do
      #         mount manifest.engine, at: "/", as: "decidim_initiative_#{manifest.name}"
      #       end
      #     end
      #   end
      # end

      # initializer "decidim_initiatives.assets" do |app|
      #   app.config.assets.precompile += %w(
      #     decidim_consultations_manifest.js
      #   )
      # end
      #
      # initializer "decidim_initiatives.inject_abilities_to_user" do |_app|
      #   Decidim.configure do |config|
      #     config.abilities += %w(
      #       Decidim::Initiatives::Abilities::NonLoggedUserAbility
      #       Decidim::Initiatives::Abilities::EveryoneAbility
      #       Decidim::Initiatives::Abilities::CurrentUserAbility
      #       Decidim::Initiatives::Abilities::VoteAbility
      #     )
      #   end
      # end
      #
      # initializer "decidim_initiatives.view_hooks" do
      #   Decidim.view_hooks.register(:highlighted_elements, priority: Decidim::ViewHooks::MEDIUM_PRIORITY) do |view_context|
      #     highlighted_initiatives = OrganizationPrioritizedInitiatives.new(view_context.current_organization)
      #
      #     next unless highlighted_initiatives.any?
      #
      #     view_context.render(
      #       partial: "decidim/initiatives/pages/home/highlighted_initiatives",
      #       locals: {
      #         highlighted_initiatives: highlighted_initiatives
      #       }
      #     )
      #   end
      # end
      #
      # initializer "decidim_initiatives.menu" do
      #   Decidim.menu :menu do |menu|
      #     menu.item I18n.t("menu.initiatives", scope: "decidim"),
      #               decidim_initiatives.initiatives_path,
      #               position: 2.6,
      #               active: :inclusive
      #   end
      # end
    end
  end
end
