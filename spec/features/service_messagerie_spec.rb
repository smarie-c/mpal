require "rails_helper"
require "support/mpal_features_helper"
require "support/api_particulier_helper"
require "support/api_ban_helper"

feature "messagerie" do
  let(:projet)            { create(:projet, :prospect, :locked, :with_contacted_operateur, :with_invited_instructeur, :with_invited_pris, :with_account) }
  let(:message_demandeur) { "Bonjour ! J'ai une question sur mon projet." }
  let(:message_operateur) { "J'attends votre question." }
  let(:operateur)         { projet.contacted_operateur }
  let(:agent_operateur)   { create :agent, intervenant: operateur }
  let(:demandeur)         { projet.demandeur_user }

  context "en tant que demandeur dont l’éligibilité est figée" do
    before { login_as demandeur, scope: :user }

    scenario "je veux ajouter un commentaire" do
      visit new_projet_message_path(projet)
      fill_in :message_corps_message, with: message_demandeur
      click_button I18n.t("projets.visualisation.lien_ajout_message")
      expect(page).to have_content(message_demandeur)
    end
  end

  context "en tant qu’intervenant" do
    before { login_as agent_operateur, scope: :agent }

    scenario "je veux répondre à un commentaire" do
      visit new_dossier_message_path(projet)
      fill_in :message_corps_message, with: message_operateur
      click_button I18n.t("projets.visualisation.lien_ajout_message")
      within ".test-messages-history" do
        expect(page).to have_content(operateur.raison_sociale)
        expect(page).to have_content(message_operateur)
      end
    end
  end
end

