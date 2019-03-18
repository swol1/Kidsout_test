require 'rails_helper'

RSpec.describe "Responses", type: :request do
  before do
    @user1 = User.create!
    @user2 = User.create!
    @user3 = User.create!
    @user4 = User.create!

    @announcement1 = Announcement.create!(user_id: @user1.id, description: 'first announcement')
    @announcement2 = Announcement.create!(user_id: @user2.id, description: 'second announcement')

    @response1 = Response.create!(user_id: @user2.id, announcement_id: @announcement1.id, price: 1000)
    @response2 = Response.create!(user_id: @user1.id, announcement_id: @announcement2.id, price: 500)
    @response3 = Response.create!(user_id: @user3.id, announcement_id: @announcement1.id, price: 500)
  end

  describe "POST /announcements/:id/responses" do
    context "user is not the author of the announcement" do
      it "create response to the announcement" do
        post "/announcements/#{@announcement1.id}/responses", params: { response: { price: 1500 } },
             headers: { "X-USER-ID" => @user4.id }

        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json).to include("announcement_id" => @announcement1.id,
                                "user_id" => @user4.id,
                                "status" => "pending",
                                "price" => 1500)
      end

      it "doesn't create response to not active announcement" do
        @announcement1.update(status: 'closed')

        expect {
          post "/announcements/#{@announcement1.id}/responses", params: { response: { price: 1500 } },
               headers: { "X-USER-ID" => @user2.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "doesn't create response when declined" do
        @response1.update(status: :declined)

        post "/announcements/#{@announcement1.id}/responses", params: { response: { price: 1500 } },
             headers: { "X-USER-ID" => @user2.id }

        json = JSON.parse(response.body)
        expect(json).to eq("status" => ["you have already responded"])
      end

      it "creates response when cancelled" do
        @response1.update(status: :cancelled)

        post "/announcements/#{@announcement1.id}/responses", params: { response: { price: 1500 } },
             headers: { "X-USER-ID" => @user4.id }

        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json).to include("announcement_id" => @announcement1.id,
                                "user_id" => @user4.id,
                                "status" => "pending",
                                "price" => 1500)
      end

    end

    context "user is the author of the announcement" do
      it "doesn't create response to the announcement" do
        post "/announcements/#{@announcement1.id}/responses", params: { response: { price: 1500 } },
             headers: { "X-USER-ID" => @user1.id }

        json = JSON.parse(response.body)
        expect(json).to eq("user_id" => ["can't be self respond"])
      end
    end
  end

  describe "PUT /announcements/:announcement_id/responses/:id" do
    it "updates response to accepted and declines others" do
      put "/announcements/#{@announcement1.id}/responses/#{@response1.id}/accept",
          headers: { "X-USER-ID" => @user1.id }

      expect(response).to have_http_status(200)
      expect(@announcement1.reload.status).to eq("closed")

      user_response = @announcement1.responses.find { |response| response.id == 1 }
      responses_except_accepted = @announcement1.responses.reject { |response| response.id == 1 }

      expect(user_response.status).to eq("accepted")
      expect(
        responses_except_accepted.all? { |response| response.status == "declined" }
      ).to eq true
    end
  end

  describe "PUT /announcements/:announcement_id/responses/:id/cancel" do
    it "updates response status to cancelled" do
      put "/announcements/#{@announcement1.id}/responses/#{@response1.id}/cancel",
          headers: { "X-USER-ID" => @user2.id }

      expect(response).to have_http_status(200)
      expect(@response1.reload.status).to eq("cancelled")
    end
  end
end
