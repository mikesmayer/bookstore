require 'rails_helper'

describe Ability do
  
    subject {ability}
    let(:ability){Ability.new(user)}

  describe "abilities for admin" do
    let(:user){FactoryGirl.create :user, :as_admin}
    it { expect(ability).to be_able_to(:manage, :all) }
  end

  describe "abilities for customer" do
    let(:user){FactoryGirl.create :user, :as_customer}
    let(:another_user){FactoryGirl.create :user, :as_customer}
    let(:order){FactoryGirl.create :order, user_id: user.id}
    let(:another_order) { FactoryGirl.create :order}
    let(:review){ FactoryGirl.create :review, user_id: user.id}
    let(:another_review){FactoryGirl.create :review}

    context "for Book" do
      it { expect(ability).to be_able_to(:read, Book) }
      it { expect(ability).to be_able_to(:add_to_cart, Book) }
      it { expect(ability).to be_able_to(:delete_from_cart, Book) }
      it { expect(ability).to be_able_to(:add_to_wish_list, Book) }
      it { expect(ability).to be_able_to(:delete_from_wish_list, Book) }
      it { expect(ability).to be_able_to(:cart, Book) }
    end

    context "for Author" do
      it { expect(ability).to be_able_to(:read, Author) }
      it { expect(ability).not_to be_able_to(:index, Author) }
    end
    
    context "for Category" do
      it { expect(ability).to be_able_to(:read, Category) }
      it { expect(ability).not_to be_able_to(:index, Category) }
    end

    context "for Order" do
      it { expect(ability).to be_able_to(:manage, order) }
      it { expect(ability).not_to be_able_to(:manage, another_order) }
    end

    context "for Profile" do
      it { expect(ability).to be_able_to(:manage, user.profile) }
      it { expect(ability).not_to be_able_to(:manage, another_user.profile) }
    end

    context "for Review" do
      it { expect(ability).to be_able_to(:manage, review) }
      it { expect(ability).not_to be_able_to(:manage, another_review) }
      it { expect(ability).not_to be_able_to(:update_status, review) }
    end
  end

  describe "abilities for visitors" do
    let(:user){User.new}

    context "for Book" do
      it { expect(ability).to be_able_to(:read, Book) }
      it { expect(ability).to be_able_to(:add_to_cart, Book) }
      it { expect(ability).to be_able_to(:delete_from_cart, Book) }
      it { expect(ability).not_to be_able_to(:add_to_wish_list, Book) }
      it { expect(ability).not_to be_able_to(:delete_from_wish_list, Book) }
      it { expect(ability).to be_able_to(:cart, Book) }
    end

    context "for Author" do
      it { expect(ability).to be_able_to(:read, Author) }
      it { expect(ability).not_to be_able_to(:index, Author) }
    end
    
    context "for Category" do
      it { expect(ability).to be_able_to(:read, Category) }
      it { expect(ability).not_to be_able_to(:index, Category) }
    end

    context "for Order" do
      it { expect(ability).not_to be_able_to(:manage, Order) }
    end

    context "for Profile" do
      it { expect(ability).not_to be_able_to(:manage, Profile) }
    end

    context "for Review" do
      it { expect(ability).to be_able_to(:read, Review) }
    end
  end
end


