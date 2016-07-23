class WorkReferencesController < ApplicationController
  def new
    @worker = Worker.find(params[:worker_id])
    @work_reference = @worker.work_references.new
  end

  def create
    @worker = Worker.find(params[:worker_id])
    @work_reference = WorkReference.new(work: work_reference_params['work'],
                                        comment: work_reference_params['comment'],
                                        worker: @worker,
                                        employer: current_user)
    if @work_reference.save
      redirect_to @work_reference.worker, notice: 'Thanks for giving a reference!'
    else
      render :new
    end
  end

  private

  def work_reference_params
    params.require(:work_reference)
          .permit(:work, :comment)
  end
end
