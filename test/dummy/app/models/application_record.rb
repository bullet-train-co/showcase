class ApplicationRecord < ActiveRecord::Base
  respond_to?(:primary_abstract_class) ? primary_abstract_class : abstract_class
end
