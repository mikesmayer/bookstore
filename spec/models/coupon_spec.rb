require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it{should belong_to :order}

  describe "#coupon_active" do
    context "#owner_changed? && #used? == true" do
      before do
        allow(subject).to receive(:owner_changed?).and_return(true)
        allow(subject).to receive(:used?).and_return(true)
      end

      it "adds errors to coupon" do
        expect(subject.coupon_active?).to eq ["This coupon has already been used"]
      end

      it "makes coupon invalid" do
        expect(subject).not_to be_valid
      end
    end

    context "#owner_changed? && #used? == false" do
      before do
        allow(subject).to receive(:owner_changed?).and_return(false)
        allow(subject).to receive(:used?).and_return(true)
      end

      it "returns nil" do
        expect(subject.coupon_active?).to eq nil
      end

      it "makes coupon valid" do
        expect(subject).to be_valid
      end
    end
  end
end
