# frozen_string_literal: true

module Decidim
  module Consultations
    # A controller that holds the logic to show questions in a
    # public layout.
    class QuestionsController < Decidim::ApplicationController
      layout "layouts/decidim/question"

      include NeedsQuestion

      helper Decidim::SanitizeHelper
      helper Decidim::IconHelper
      helper Decidim::WidgetUrlsHelper
      helper Decidim::Comments::CommentsHelper
      helper Decidim::AttachmentsHelper
      helper Decidim::FeatureReferenceHelper

      helper_method :stats

      def show
        authorize! :read, current_question
      end

      def technical_info
        authorize! :read, current_question
      end

      private

      def stats
        @stats ||= QuestionStatsPresenter.new(question: current_question)
      end
    end
  end
end
