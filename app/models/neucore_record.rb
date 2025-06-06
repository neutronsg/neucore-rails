class NeucoreRecord < ActiveRecord::Base
  include ::Neucore::AutoStripAttributes
  include ::Neucore::Localeable
  include ::Neucore::Enumable
  include ::Neucore::Versionable

  acts_as_paranoid
  primary_abstract_class

  has_paper_trail on: [:update, :destroy], ignore: [
    :created_at, :updated_at, :deleted_at, :image, :avatar, :log, 
    :file, :html_body, :description, :extra_data, :desc, :date_types,
    :sync_percentage
  ]

  # has_paper_trail on: [:update, :create, :destroy], ignore: [
  #   :updated_at, :moodle_snapshot
  # ]

  def display_name
    if respond_to?(:name)
      "#{name}(#{id})"
    else
      "#{self.class.name}(#{id})"
    end
  end

  def display_deleted_name
    "#{display_name}(#{I18n.t(:deleted)})"
  end

  def check_dependence_destroy!
    if respond_to?(:check_dependence!)
      destroy if check_dependence!
    else
      destroy
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s }
  end
  
end