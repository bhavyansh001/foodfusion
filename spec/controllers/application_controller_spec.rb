require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
      head :ok
    end
  end

  describe 'before_action :set_locale' do
    before do
      allow(I18n).to receive(:default_locale).and_return(:en)
    end

    it 'sets the locale from params' do
      get :index, params: { locale: 'hi' }
      expect(I18n.locale).to eq(:hi)
    end

    it 'sets the locale to default if not provided' do
      get :index
      expect(I18n.locale).to eq(:en)
    end
  end

  describe '#default_url_options' do
    it 'includes locale in default URL options' do
      I18n.locale = :en
      allow_any_instance_of(ApplicationController).to receive(:default_url_options).and_call_original
      expect(controller.default_url_options).to eq({ locale: I18n.locale })
    end
  end
end
