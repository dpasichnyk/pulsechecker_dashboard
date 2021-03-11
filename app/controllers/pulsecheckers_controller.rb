class PulsecheckersController < ApplicationController
  before_action :current_pulsechecker, only: %i[update destroy change_status]

  def index
    @pulsecheckers = current_user.pulsecheckers
  end

  def show
  end

  def create
    @pulsechecker = current_user.pulsecheckers.new(pulsechecker_params)

    if @pulsechecker.save
      render json: @pulsechecker
    else
      render_not_valid(@pulsechecker.errors)
    end
  end

  def update
    if @pulsechecker.update(pulsechecker_params)
      render json: @pulsechecker
    else
      render_not_valid(@pulsechecker.errors)
    end
  end

  def destroy
    @pulsechecker.destroy
  end

  def change_status
    @pulsechecker.update!(active: !@pulsechecker.active)
  end

  private

  def current_pulsechecker
    @pulsechecker = current_user.pulsecheckers.find(params[:id] || params[:pulsechecker_id])
  rescue ActiveRecord::RecordNotFound => _e
    render_error(error: t('controllers.plusechecker.not_found'), status: 422)
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
