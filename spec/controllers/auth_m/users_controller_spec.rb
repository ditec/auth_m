require 'rails_helper'

module AuthM
  RSpec.describe UsersController, type: :controller do

    routes { AuthM::Engine.routes }

    context do 
      let!(:user){ user = FactoryBot.build(:auth_m_user, roles: [:root])
                  user.save!(:validate => false)
                  sign_in user
                  controller.set_current_management(user.management.id)
                  user}

      describe "#GET index ->" do
        before :each do
          get :index
        end

        it { should respond_with(200) }
        it { should render_template('index') }
        it { should render_with_layout('application') }

        it "test1" do
          31.times do 
            person = FactoryBot.create(:auth_m_person, management_id: controller.current_management.id)
            user = FactoryBot.create(:auth_m_user, person_id: person.id)
          end
          expect(assigns(:users).count).to eq(31)        
        end
      end

      describe "#GET show/:id ->" do
        let(:user2){FactoryBot.create(:auth_m_user)}

        before :each do
          get :show, params: { person_id: user2.person.id, id: user2.id }
        end

        it { should respond_with(200) }
        it { should render_template('show') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:user)).to eq(user2)        
        end
      end

      describe "#GET new ->" do
        let(:person){FactoryBot.create(:auth_m_person)}

        before :each do
          get :new, params: {person_id: person.id}
        end

        it { should respond_with(200) }
        it { should render_template('new') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:user)).to be_a_new(AuthM::User)       
        end
      end

      describe "#GET edit/:id ->" do
        let(:user2){FactoryBot.create(:auth_m_user)}

        before :each do
          get :edit, params: { person_id: user2.person.id, id: user2.id }
        end

        it { should respond_with(200) }
        it { should render_template('edit') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:user)).to eq(user2)        
        end
      end

      describe "#POST create_user ->" do
        let(:person){FactoryBot.create(:auth_m_person)}

        context "with valid attributes" do
          it "test1" do
            expect{
              post :create_user, params: {person_id: person.id, user: FactoryBot.attributes_for(:auth_m_user)}
            }.to change(AuthM::User,:count).by(1)
          end

          it "test2" do
            post :create_user, params: {person_id: person.id, user: FactoryBot.attributes_for(:auth_m_user)}
            expect(response).to redirect_to AuthM::User.last.person
          end
        end

        context "with invalid attributes" do
          it "test1" do
            expect{
              post :create_user, params: {person_id: person.id, user: FactoryBot.attributes_for(:auth_m_user, email: "dummy")}
            }.to_not change(AuthM::User,:count)
          end

          it "test2" do
            post :create_user, params: {person_id: person.id, user: FactoryBot.attributes_for(:auth_m_user, email: "dummy")}
            expect(response).to render_template :new
          end
        end 
      end

      describe "#PUT update/:id ->" do
        let(:user2){FactoryBot.create(:auth_m_user)}

        context "with valid attributes" do
          before(:each) do
            put :update, params: {person_id: user2.person.id, id: user2.id, user: {email: "dummy887@a.com"}}
            user2.reload
          end

          it "test1" do 
            expect(response).to redirect_to(user2.person)
          end

          it "test2" do 
            expect(user2.email).to eq("dummy887@a.com")
          end
        end

        context "with invalid attributes" do
          before(:each) do
            put :update, params: {person_id: user2.person.id, id: user2.id, user: {email: "dummy"}}
            user2.reload
          end

          it "test1" do 
            expect(response).to render_template :edit
          end

          it "test2" do 
            expect(user2.email).to_not eq("dummy")
          end
        end
      end

      describe "#DELETE destroy ->" do
        let!(:user2){FactoryBot.create(:auth_m_user)}

        it 'test1' do
          expect { 
            delete :destroy, params:{ person_id: user2.person.id, id: user2.id }
          }.to change(AuthM::User,:count).by(-1)
        end

        it 'test2' do
          delete :destroy, params:{ person_id: user2.person.id, id: user2.id }
          expect(response).to redirect_to(user2.person)
        end
      end

      describe "#strong_parameters ->" do 
        let(:person){FactoryBot.create(:auth_m_person)}
        
        it "test1" do 
          expect{ post(:create_user, params: {person_id: person.id, user: {}}) }.to raise_error ActionController::ParameterMissing
        end
      end

      #####################################################################################################

      describe "#impersonate ->" do 
        let(:user2){FactoryBot.create(:auth_m_user)}
        it "test1" do 
          post :impersonate, params: {person_id: user2.person.id, id: user2.id}
          expect(controller.current_user).to eq(user2)
        end
      end

      describe "#stop_impersonating ->" do 
        let(:user2){FactoryBot.create(:auth_m_user)}
        it "test1" do 
          post :impersonate, params: {person_id: user2.person.id, id: user2.id}
          post :stop_impersonating
          expect(controller.current_user).to eq(user)
        end
      end

      describe "#generate_new_password_email ->" do 
        let(:user2){FactoryBot.create(:auth_m_user)}

        it "test2" do 
          expect { post :generate_new_password_email, params: {person_id: user2.person.id, id: user2.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "test1" do 
          post :generate_new_password_email, params: {person_id: user2.person.id, id: user2.id }
          expect(flash[:notice]).to be_present
        end 

      end

      describe "#create_policies(user) ->" do 
        let(:person){FactoryBot.create(:auth_m_person, management_id: controller.current_management.id)}
        let(:resource){FactoryBot.create(:auth_m_resource, management_id: controller.current_management.id)}

        it "test1" do 
          expect{
            post :create_user, params: {person_id: person.id, user: {email: "dummy@a.com", password: "asd12345", policies: {:"#{resource.id}" => "manage" }}}
          }.to change(AuthM::Policy,:count).by(1)
        end

        it "test2" do 
          resource2 = FactoryBot.create(:auth_m_resource)
          expect{
            post :create_user, params: {person_id: person.id, user: {email: "dummy@a.com", password: "asd12345", policies: {:"#{resource2.id}" => "manage" }}}
          }.to change(AuthM::Policy,:count).by(0)
        end

        it "test3" do 
          expect{
            post :create_user, params: {person_id: person.id, user: {email: "dummy@a.com", password: "asd12345", policies: {:"#{resource.id}" => "none" }}}
          }.to change(AuthM::Policy,:count).by(0)
        end

        it "test4" do 
          post :create_user, params: {person_id: person.id, user: {email: "dummy@a.com", password: "asd12345", policies: {:"#{resource.id}" => "read" }}}
          policy = AuthM::Policy.last
          expect(policy.access).to eq("read")
        end
      end 

    end

    context do 
      describe "#can't_access ->" do 
        context do
          let(:user){FactoryBot.create(:auth_m_user)}

          before :each do 
            sign_in user 
          end 

          it "can't access action index" do
            get :index
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action show" do
            get :show, params: { person_id: user.person.id, id: user.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action new" do
            get :new, params: { person_id: user.person.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action edit" do
            get :edit, params: { person_id: user.person.id, id: user.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action create" do
            post :create_user, params: {person_id: user.person.id, user: FactoryBot.attributes_for(:auth_m_user)}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action update" do
            put :update, params: {person_id: user.person.id, id: user.id, user: {name: "Dummy887"}}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action destroy" do
            delete :destroy, params:{ person_id: user.person.id, id: user.id }
            expect(response).to redirect_to("/401.html")
          end
        end
      end 
    end

  end
end
