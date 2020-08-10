module Dox
  module DSL
    module Syntax
      extend ActiveSupport::Concern

      def document(subject, &block)
        documentation = _subjects[subject] = Documentation.new(subject: subject)
        documentation.instance_eval(&block)
      end

      def const_missing(name)
        documentation = _subjects[infer_subject(name)]

        return super unless documentation

        Module.new do
          define_singleton_method :included do |base|
            base.metadata.merge! documentation.config
          end
        end
      end

      def infer_subject(name)
        name.to_s.underscore.to_sym
      end

      def _subjects
        @_subjects ||= {}
      end
    end
  end
end
