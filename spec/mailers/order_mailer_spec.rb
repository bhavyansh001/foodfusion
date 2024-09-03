require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  describe 'status_update' do
    let(:visitor) { create(:user, role: 'visitor', email: 'visitor@example.com') }
    let(:order) { create(:order, visitor:) }
    let(:mail) { OrderMailer.status_update(order) }

    it 'renders the headers' do
      expect(mail.subject).to eq(I18n.t('email.order_status.subject'))
      expect(mail.to).to eq([visitor.email])
      expect(mail.from).to eq(['hi@foodfusion.diversepixel.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(order.id.to_s)
    end
  end
end
