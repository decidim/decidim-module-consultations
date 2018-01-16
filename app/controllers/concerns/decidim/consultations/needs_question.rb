# frozen_string_literal: true

module Decidim
  module Consultations
    # This module, when injected into a controller, ensures there's a
    # question available and deducts it from the context.
    module NeedsQuestion
      def self.enhance_controller(instance_or_module)
        instance_or_module.class_eval do
          helper_method :current_question, :current_consultation
        end
      end

      def self.extended(base)
        base.extend Decidim::NeedsOrganization, InstanceMethods

        enhance_controller(base)
      end

      def self.included(base)
        base.include Decidim::NeedsOrganization, InstanceMethods

        enhance_controller(base)
      end

      module InstanceMethods
        # Public: Finds the current Question given this controller's
        # context.
        #
        # Returns the current Question.
        def current_question
          @current_question ||= detect_question
        end

        # Public: Finds the current Consultation given this controller's
        # context.
        #
        # Returns the current Consultation.
        def current_consultation
          @current_consultation ||= current_question&.consultation || detect_consultation
        end

        alias current_participatory_space current_question

        private

        def ability_context
          super.merge(
            current_question: current_question,
            current_consultation: current_consultation
          )
        end

        def detect_question
          request.env["current_question"] ||
            Decidim::Consultations::Question.find_by(slug: params[:question_slug] || params[:slug])
        end

        def detect_consultation
          request.env["current_consultation"] ||
            organization_consultations.find_by(slug: params[:consultation_slug])
        end

        def organization_consultations
          @organization_consultations ||= OrganizationConsultations.new(current_organization).query
        end
      end
    end
  end
end
