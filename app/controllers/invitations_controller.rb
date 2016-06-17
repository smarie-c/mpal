class InvitationsController < ApplicationController
  def new
    @projet = Projet.find(params[:projet_id])
    @operateur = Operateur.find(params[:operateur_id])
  end

  def create
    @projet = Projet.find(params[:projet_id])
    @operateur = Operateur.find(params[:operateur_id])
    @projet.adresse = params[:projet][:adresse]
    @projet.description = params[:projet][:description]
    @projet.email = params[:projet][:email]
    @projet.tel = params[:projet][:tel]
    @invitation = Invitation.new(projet: @projet, operateur: @operateur)
    if valid? && @projet.save && @invitation.save
      ProjetMailer.invitation_operateur(@invitation).deliver_now!
      flash[:notice_titre] = t('invitations.messages.succes_titre')
      redirect_to @projet, notice: t('invitations.messages.succes', operateur: @operateur.raison_sociale)
    else
      render :new
    end
  end

  def show
    invitation = Invitation.find_by_token(params[:jeton_id])
    @projet = invitation.projet
    gon.push({
      latitude: @projet.latitude,
      longitude: @projet.longitude
    })
    @profil = invitation.operateur.raison_sociale
    render 'projets/show'
  end

  private
  def valid?
    @projet.errors[:adresse] = t('invitations.messages.adresse.obligatoire') unless @projet.adresse.present?
    @projet.errors[:description] = t('invitations.messages.description.obligatoire') unless @projet.description.present?
    @projet.errors[:email] = t('invitations.messages.email.obligatoire') unless @projet.email.present?
    @projet.description.present? && @projet.email.present? && @projet.adresse.present?
  end
end