class TiersController < InheritedResources::Base
  before_filter :admin_required
end
