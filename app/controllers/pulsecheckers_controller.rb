class PulsecheckersController < ApplicationController
  before_action :current_pulsechecker, only: %i[show edit update destroy change_status]
  
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
    @pulsechecker = current_user.pulsecheckers.create(pulsechecker_params)
    if @pulsechecker.save
      flash[:success] = t('controllers.plusechecker.create')
      redirect_to pulsecheckers_path
    else
      render :new
    end
  end

  def update
    if @pulsechecker.update(pulsechecker_params)
      flash[:success] = t('controllers.plusechecker.update')
      redirect_to pulsecheckers_path
    else
      render :edit
    end
  end

  def change_status
    @pulsechecker.update!(active: !@pulsechecker.active)
  end

  def destroy
    @pulsechecker.destroy
  end

  private

  def current_pulsechecker
    @pulsechecker = current_user.pulsecheckers.find(params[:id] || params[:pulsechecker_id])
  rescue ActiveRecord::RecordNotFound => _e
    flash[:warning] = t('controllers.plusechecker.not_found')
    redirect_to pulsecheckers_path
  end

  def pulsechecker_params
    params.require(:pulsechecker).permit(
      :kind,
      :name,
      :url,
      :interval,
      :response_time
    )
  end
end
