class ResellersController < InheritedResources::Base
  def new
     @reseller = Reseller.new
    @reseller.build_user
  end
end
