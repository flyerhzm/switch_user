require 'spec_helper'
require 'switch_user'
require 'switch_user_helper'

RSpec.describe SwitchUserHelper, type: :helper do
  before do
    SwitchUser.provider = :dummy
  end

  let(:user) { double(:user, id: 1) }
  let(:admin) { double(:admin, id: 1) }
  let(:provider) {
    _provider = SwitchUser::Provider::Dummy.new(controller)
    _provider
  }

  describe "#switch_user_select" do
    let(:guest_record) { SwitchUser::GuestRecord.new }
    let(:user_record) { double(:user_record, user: user, scope: :user, label: 'user1', scope_id: 'user_1') }
    let(:admin_record) { double(:admin_record, user: admin, scope: :admin, label: 'admin1', scope_id: 'admin_1') }

    let(:guest_option_tags) { %Q^<optgroup label="Guest"><option value="">Guest</option></optgroup>^ }
    let(:user_option_tags) { %Q^<optgroup label="User"><option value="user_1">user1</option></optgroup>^ }
    let(:user_selected_option_tags) { %Q^<optgroup label="User"><option selected="selected" value="user_1">user1</option></optgroup>^ }
    let(:admin_option_tags) { %Q^<optgroup label="Admin"><option value="admin_1">admin1</option></optgroup>^ }
    let(:admin_selected_option_tags) { %Q^<optgroup label="Admin"><option selected="selected" value="admin_1">admin1</option></optgroup>^ }

    before do
      allow(SwitchUser).to receive(:switch_back).and_return(false)

      allow(helper).to receive(:available?).and_return(true)

      provider.instance_variable_set(:@user, user)
      allow(helper).to receive(:provider).and_return(provider)

      allow(provider).to receive(:current_user).and_return(user)

      allow(SwitchUser).to receive(:all_users).and_return([guest_record, user_record])
    end

    it "when unavailable" do
      allow(helper).to receive(:available?).and_return(false)

      expect(helper.switch_user_select).to eq(nil)
    end

    it "when current_user is nil and all_users is []" do
      allow(provider).to receive(:current_user).and_return(nil)
      allow(SwitchUser).to receive(:all_users).and_return([])

      expect(helper.switch_user_select).not_to match(%r{</option>})
    end

    it "when current_user is nil and all_users is [guest_record]" do
      allow(provider).to receive(:current_user).and_return(nil)
      allow(SwitchUser).to receive(:all_users).and_return([guest_record])

      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
    end

    it "when current_user is nil and all_users is [guest_record, user_record]" do
      allow(provider).to receive(:current_user).and_return(nil)
      allow(SwitchUser).to receive(:all_users).and_return([guest_record, user_record])

      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{user_option_tags}})
    end

    it "when current_user is user and all_users is []" do
      allow(provider).to receive(:current_user).and_return(user)
      allow(SwitchUser).to receive(:all_users).and_return([])

      expect(helper.switch_user_select).not_to match(%r{</option>})
    end

    it "when current_user is user and all_users is [guest_record, user_record]" do
      allow(provider).to receive(:current_user).and_return(user)
      allow(SwitchUser).to receive(:all_users).and_return([guest_record, user_record])

      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{user_selected_option_tags}})
    end

    it "when current_user is default allow and all_users is default allow" do
      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{user_selected_option_tags}})
    end

    it "when current_user is user and all_users is [guest_record, user_record, admin_record]" do
      allow(provider).to receive(:current_user).and_return(user)
      allow(SwitchUser).to receive(:all_users).and_return([guest_record, user_record, admin_record])

      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{user_selected_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{admin_option_tags}})
    end

    it "when current_user is admin and all_users is [guest_record, user_record, admin_record]" do
      provider.instance_variable_set(:@user, admin)
      allow(helper).to receive(:provider).and_return(provider)

      allow(provider).to receive(:current_user).and_return(admin)

      allow(SwitchUser).to receive(:all_users).and_return([guest_record, user_record, admin_record])

      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{user_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{admin_selected_option_tags}})
    end

    it "when current_user is admin and all_users is [guest_record, user_record]" do
      provider.instance_variable_set(:@user, admin)
      allow(helper).to receive(:provider).and_return(provider)

      allow(provider).to receive(:current_user).and_return(admin)

      allow(SwitchUser).to receive(:all_users).and_return([guest_record, user_record])

      expect(helper.switch_user_select).to match(%r{#{guest_option_tags}})
      expect(helper.switch_user_select).to match(%r{#{user_option_tags}})
      expect(helper.switch_user_select).to_not match(%r{#{admin_option_tags}})
    end
  end

  describe "#user_tag_value" do
    it "for user" do
      user = double(:user, id: 1)

      expect(helper.send(:user_tag_value, user, :id, :user)).to eq('user_1')
    end
  end

  describe "#user_tag_label" do
    it "when name has call method" do
      user = double(:user)
      name = ->(user) { 'user1' }

      expect(helper.send(:user_tag_label, user, name)).to eq('user1')
    end

    it "when name not has call method" do
      user = double(:name, name: 'user1')
      name = :name

      expect(helper.send(:user_tag_label, user, name)).to eq('user1')
    end
  end

  describe "#available?" do
    it "return true" do
      allow_any_instance_of(SwitchUser.guard_class).to receive(:view_available?).and_return(true)

      expect(helper.send(:available?)).to eq(true)
    end

    it "return false" do
      allow_any_instance_of(SwitchUser.guard_class).to receive(:view_available?).and_return(false)

      expect(helper.send(:available?)).to eq(false)
    end
  end

  describe "#provider" do
    it "normal" do
      allow(SwitchUser::Provider).to receive(:init).with(controller).and_return(provider)

      expect(helper.send(:provider)).to eq(provider)
    end
  end
end
