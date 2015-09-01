require 'rails_helper'

describe RouteAccessErrors do

  let(:wicked_error) {Wicked::Wizard::InvalidStepError.new}
  let(:cancan_error){CanCan::AccessDenied.new}
  let(:errors_router_wicked){RouteAccessErrors.new(wicked_error)}
  let(:errors_router_cancan){RouteAccessErrors.new(cancan_error)}
  let(:login_error){{"Order"  => [:index, :show, :update, :cart, :add_to_cart, :delete_from_cart, :cancel, :new],
                     "Review" => [:index, :show, :edit, :create, :update, :destroy, :new],
                     "Book"   => [:add_to_wish_list, :delete_from_wish_list]}}



  it "has constant LOGINERROR" do
    expect(RouteAccessErrors::LOGINERROR).to eq login_error
  end

  describe "#initialize" do
    it "sets @error to error" do
      @error = errors_router_wicked.instance_variable_get(:@error)
      expect(@error).to eq(wicked_error)
    end
  end

  describe "#cancan_error?" do
    context "is a cancan error" do
      it "returns true" do
        expect(errors_router_cancan.send :cancan_error?).to eq true
      end
    end

    context "is a wicked error" do
      it "returns false" do
        expect(errors_router_wicked.send :cancan_error?).to eq false
      end
    end
  end

  describe "#login_error?" do
    context "error.subject && error.object are included in error hash" do
      before do
        cancan_error.instance_variable_set(:@subject, Order.new)
        cancan_error.instance_variable_set(:@action,  :index)
      end
      it "returns true" do
        expect(errors_router_cancan.send :login_error?).to eq true
      end
    end

    context "error.subject !&& error.object are included in error hash" do
      before do
        cancan_error.instance_variable_set(:@subject, Book.new)
        cancan_error.instance_variable_set(:@action,  :index)
      end
      it "returns false" do
        expect(errors_router_cancan.send :login_error?).to eq false
      end
    end
  end

  describe "#call" do
    before do
      allow(errors_router_cancan).to receive(:login_error?)
    end

    it "calls #login_error?" do
      expect(errors_router_cancan).to receive(:login_error?)
      errors_router_cancan.call
    end
  end
end