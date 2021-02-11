class PulsecheckersController < ApplicationController
  before_action :current_monitor, only: %i[show edit update destroy]
  
  def index
    @pulsecheckers = current_user.pulsecheckers
  end

  def show
  end

  def new
    @pulsechecker = Pulsechecker.new
  end

  def edit
  end

  def create
    pulsechecker = current_user.pulsecheckers.create!(pulsechecker_params)
    if pulsechecker.save
      redirect_to pulsecheckers_path
    else
      render :new
    end
  end

  def update
    if @pulsechecker.update(pulsechecker_params)
      redirect_to pulsecheckers_path
    else
      render :edit
    end
  end

  def destroy
    @pulsechecker.destroy

    redirect_to pulsecheckers_path
  end

  private

  def current_monitor
    @pulsechecker = Pulsechecker.find(params[:id])
  end

  def pulsechecker_params
    params.require(:pulsechecker).permit(
      :kind,
      :name,
      :url,
      :interval
    )
  end
end
