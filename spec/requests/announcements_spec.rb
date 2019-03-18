require 'rails_helper'

RSpec.describe "Announcements", type: :request do
  before do
    @user1 = User.create!
    @user2 = User.create!
    @user3 = User.create!

    @announcement1 = Announcement.create!(user_id: @user1.id, description: 'first announcement')
    @announcement2 = Announcement.create!(user_id: @user2.id, description: 'second announcement')

    Response.create!(user_id: @user2.id, announcement_id: @announcement1.id, price: 1000)
    Response.create!(user_id: @user1.id, announcement_id: @announcement2.id, price: 500)
    Response.create!(user_id: @user3.id, announcement_id: @announcement1.id, price: 700)
  end

  describe "GET /announcements" do
    it "shows all active announcements (no responses in json)" do
      get announcements_path
      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)
      expect(json.count).to eq 2

      announcement = json.find { |item| item["id"] == @announcement1.id }
      expect(announcement).to include("id" => @announcement1.id, "user_id" => @user1.id,
                                      "description" => 'first announcement')
      expect(announcement["responses"]).to be_nil
    end
  end

  describe "GET /announcements/:id" do
    context "when announcement belongs to current user" do
      it "shows announcement" do
        get announcement_path(@announcement1), headers: { "X-USER-ID" => @user1.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)

        expect(json).to include("id" => @announcement1.id, "user_id" => @user1.id,
                                "description" => 'first announcement')
        expect(json["responses"].count).to eq 2
      end
    end

    context "when announcement doesn't belong to current user" do
      it "doesn't show announcement" do
        expect {
          get announcement_path(@announcement1), headers: { "X-USER-ID" => @user2.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "PUT /announcements/:id/cancel" do
    context "when user is owner" do
      it "change announcement status to canceled" do
        put "/announcements/#{@announcement1.id}/cancel", headers: { "X-USER-ID" => @user1.id }

        expect(response).to have_http_status(200)
        expect(@announcement1.reload.status).to eq "cancelled"
      end

      it "changes all responses statuses to declined" do
        put "/announcements/#{@announcement1.id}/cancel", headers: { "X-USER-ID" => @user1.id }

        expect(response).to have_http_status(200)
        expect(
          @announcement1.responses.all? { |response| response.status == "declined" }
        ).to eq true
      end
    end

    context "when user is not owner" do
      it "change announcement status to canceled" do
        expect {
          put "/announcements/#{@announcement1.id}/cancel", headers: { "X-USER-ID" => @user2.id }
        }.to raise_error(ActiveRecord::RecordNotFound)

        expect(@announcement1.reload.status).to eq "active"
      end
    end
  end

  describe "POST /announcements" do
    context "when current user is present" do
      it 'create announcement' do
        expect {
          post "/announcements", params: { announcement: { description: 'announcement from post' } },
               headers: { "X-USER-ID" => @user1.id }
        }.to change { Announcement.count }.by(1)

        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json).to include("user_id" => @user1.id,
                                "description" => 'announcement from post',
                                "status" => "active")
      end
    end

    context "when current user is not present" do
      it "doesn't create announcement" do
        expect {
          post "/announcements", params: { announcement: { description: 'announcement from post' } },
               headers: { "X-USER-ID" => nil }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
