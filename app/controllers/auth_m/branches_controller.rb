module AuthM
	class BranchesController < ApplicationController
		include AuthM::BranchesControllerConcern
   	# authorize_resource

   	# before_action :set_branch, only: [:show, :edit, :update, :destroy]
   	# before_action :check_resources, only: [:create, :update]

	  # def show
	  # 	super
	  # end

	  # def new
	  # 	super
	  # end

	  # def edit
	  # 	super
	  # end
	  
	  # def create
	  # 	super
	  # end

	  # def update
	  # 	super
	  # end

	  # def destroy
	  # 	super
	  # end

	  # def change
	  # 	super
	  # end

	  # private

	  #   def set_branch
	  #   	super
	  #   end

	  #   def branch_params
	  #   	super
	  #   end

	  #   def check_resources
	  #   	super
	  #   end 
	end
end