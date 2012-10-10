class DependenciesController < ApplicationController
  def new
    @dependency = Dependency.new
  end

  def create
    @dependency = Dependency.new(params[:dependents])    
    render :new
  end
end
