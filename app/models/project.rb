class Project
  include ActiveModel::Model
  attr_accessor :numero_fiscal, :reference_avis, :description
  validates :numero_fiscal, :reference_avis, :revenu_reference, presence: true

  def owner
    @owner ||= api_particulier.owner
  end

  def revenu_reference
    @revenu_reference ||= api_particulier.revenu_reference
  end

  def anah_eligible?
    self.revenu_reference < 14308
  end

  def address
    @address ||= api_particulier.address
  end

  private
    def api_particulier
      @api_particulier ||= ApiParticulier.new(reference_avis, numero_fiscal)
    end
end