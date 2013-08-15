class AttachmentsController < ApplicationController

  before_action :set_attachment, only: [:show, :destroy]
  skip_before_action :authenticate_user!, only: [:show]

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.user = current_user
    @attachment.save!
    head :no_content
  end

  def index
    @attachments = current_user.attachments.newer

    respond_to do |format|
      format.html {}
      format.json { 
        json = @attachments.page(params[:p]).per(5).map do |attachment|
          {
            path: attachment_path(attachment),
          }
        end 
        render json: json
      }
    end
  end

  def show
    send_file @attachment.file.path, disposition: 'inline'
  end

  def destroy
    not_found unless can_edit?(@attachment)
    @attachment.destroy
    redirect_to :attachments, notice: I18n.t('flash.models.destroy', model: Attachment.model_name.human) 
  end

private
  def set_attachment
    @attachment = Attachment.find_by!(id: params[:id])
    not_found unless "#{params[:id]}.#{params[:format]}" == @attachment.to_param
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end


end
