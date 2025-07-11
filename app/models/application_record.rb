class ApplicationRecord < ActiveRecord::Base
  include ApplicationHelper
  primary_abstract_class
end
