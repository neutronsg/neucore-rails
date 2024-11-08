# lib/neucore/jwt_token_issuer.rb

module Neucore
  module AutoStripAttributes
    extend ActiveSupport::Concern

    module ClassMethods
      def auto_strip_attributes(*attributes)
        attributes.each do |attribute|
          before_validation do |record|
            value = record.send(attribute)
            record.send("#{attribute}=", value.strip) if value.present?
          end
        end
      end

      def auto_strip_ml_attributes *attributes
        attributes.each do |attribute|
          before_validation do |record|
            I18n.ml_locales.each do |locale|
              value = record.send("#{attribute}_#{locale}")
              record.send("#{attribute}_#{locale}=", value.strip) if value.present?
            end
          end
        end
      end
    end
  end
end