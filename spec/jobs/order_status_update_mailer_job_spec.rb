require 'rails_helper'

RSpec.describe OrderStatusUpdateMailerJob, type: :job do
  let(:order) { create(:order) }

  it 'sends a status update email' do
    expect {
      OrderStatusUpdateMailerJob.perform_now(order.id)
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq([order.visitor.email])
    expect(mail.subject).to eq(I18n.t('email.order_status.subject'))
  end

  it 'raises an error if the order is not found' do
    expect {
      OrderStatusUpdateMailerJob.perform_now(-1)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
