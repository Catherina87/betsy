require "test_helper"

describe MerchantsController do
  describe "login" do
    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:merchant1))
      
      must_respond_with :redirect
    end
    
    it "can log in a new merchant" do
      new_merchant = Merchant.new(uid: "6789", username: "Anto", provider: "github", email: "anto@blahblahblah.org")
      
      expect {
        logged_in_user = perform_login(new_merchant)
      }.must_change "Merchant.count", 1
      
      must_respond_with :redirect
    end
  end

  describe "logout" do
    it "an logout an existing user" do
      perform_login

      expect(session[:merchant_id]).wont_be_nil

      post logout_path, params: {}

      post logout_path

      expect(session[:merchant_id]).must_be_nil
    end

  end

# describe "show" do
#   it "shows individual details for valid merchant" do
# end

# it "redirects when given an invalid id" do
# end
# end
  describe "show" do 
    it "responds with success when showing an existing valid merchant" do 
      merchant = merchants(:merchant_one)

      get merchant_path(merchant.id)

      must_respond_with :success
    end

    it "redirects to products path when an invalid merchant id is provided" do 
      get merchant_path(-1)

      must_respond_with :redirect 
      must_redirect_to products_path 
    end
  end
end