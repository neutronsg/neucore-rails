module Neucore
  module Localeable
    extend ActiveSupport::Concern

    module ClassMethods
      def ml(*columns)
        define_methods(columns)
      end

      def define_methods(columns)
        columns.each do |column|
          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            def #{column}_ml=(value)
              column = __method__.to_s.gsub(/_ml=/, '')
              value.each do |locale, v|
                attribute = column + "_" + locale.to_s + "="
                send(attribute, v)
              end
            end

            def #{column}_ml
              mls = {}
              column = __method__.to_s.gsub(/_ml/, '')
              I18n.ml_locales.each do |locale|
                attribute = column + "_" + locale.to_s
                mls[locale] = send(attribute)
              end
              mls
            end
          METHODS
        end
      end
    end
  end
end
