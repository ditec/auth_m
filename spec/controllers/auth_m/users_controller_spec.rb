require 'rails_helper'

module AuthM
  RSpec.describe UsersController, type: :controller do

    routes { AuthM::Engine.routes }

    context do 
      let!(:user){ user = FactoryBot.build(:auth_m_user, roles: [:root])
                  user.save!(:validate => false)
                  sign_in user
                  controller.set_current_branch(user.branch.id)
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
            users = FactoryBot.create(:auth_m_user, branch_id: controller.current_branch.id)
          end
          
          expect(assigns(:users).count).to eq(32)        
        end
      end

      describe "#GET public ->" do
        before :each do
          get :public
        end

        it { should respond_with(200) }
        it { should render_template('public') }
        it { should render_with_layout('application') }

        it "test1" do
          31.times do 
            user = FactoryBot.create(:auth_m_user, branch_id: nil, roles: [:public])
          end
          expect(assigns(:users).count).to eq(31)        
        end
      end


      describe "#GET new ->" do

        before :each do
          get :new
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
          get :edit, params: {id: user2.id}
        end

        it { should respond_with(200) }
        it { should render_template('edit') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:user)).to eq(user2)        
        end
      end

      describe "#POST create_user ->" do
        let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id)}

        context "with valid attributes" do
          it "test1" do
            expect{
              post :create_user, params: {policy_group_selector: policy_group.id, user: FactoryBot.attributes_for(:auth_m_user)}
            }.to change(AuthM::User,:count).by(1)
          end

          it "test2" do
            post :create_user, params: {policy_group_selector: policy_group.id, user: FactoryBot.attributes_for(:auth_m_user)}
            expect(response).to redirect_to AuthM::User.last
          end
        end

        context "with invalid attributes" do
          it "test1" do
            expect{
              post :create_user, params: {user: FactoryBot.attributes_for(:auth_m_user, email: "dummy")}
            }.to_not change(AuthM::User,:count)
          end

          it "test2" do
            post :create_user, params: {user: FactoryBot.attributes_for(:auth_m_user, email: "dummy")}
            expect(response).to render_template :new
          end
        end 
      end

      describe "#PUT update/:id ->" do
        let(:user2){FactoryBot.create(:auth_m_user)}

        context "with valid attributes" do
          before(:each) do
            put :update, params: {id: user2.id, user: {email: "dummy887@a.com"}}
            user2.reload
          end

          it "test1" do 
            expect(response).to redirect_to(user2)
          end

          it "test2" do 
            expect(user2.email).to eq("dummy887@a.com")
          end
        end

        context "with invalid attributes" do
          before(:each) do
            put :update, params: {id: user2.id, user: {email: "dummy"}}
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
            delete :destroy, params:{id: user2.id }
          }.to change(AuthM::User,:count).by(-1)
        end

        it 'test2' do
          delete :destroy, params:{id: user2.id }
          expect(response).to redirect_to(users_path)
        end
      end

      #####################################################################################################

      describe "#impersonate ->" do 
        let(:user2){FactoryBot.create(:auth_m_user)}
        it "test1" do 
          post :impersonate, params: {id: user2.id}
          expect(controller.current_user).to eq(user2)
        end
      end

      describe "#stop_impersonating ->" do 
        let(:user2){FactoryBot.create(:auth_m_user)}
        it "test1" do 
          post :impersonate, params: {id: user2.id}
          post :stop_impersonating
          expect(controller.current_user).to eq(user)
        end
      end

      describe "#generate_new_password_email ->" do 
        let(:user2){FactoryBot.create(:auth_m_user)}

        it "test2" do 
          expect { post :generate_new_password_email, params: {id: user2.id } }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "test1" do 
          post :generate_new_password_email, params: {id: user2.id }
          expect(flash[:notice]).to be_present
        end 

      end

      describe "#create_policies(user) ->" do 
        let(:resource){FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)}

        it "test1" do 
          expect{
            post :create_user, params: {policy_group_selector: "Customize", user: {email: "dummy@a.com", password: "asd12345", roles_mask: 2, policy_group_attributes: {policies_attributes: {"0"=>{resource_id: resource.id, access: "manage"}}}}}
          }.to change(AuthM::Policy,:count).by(1)
        end

        it "test2" do 
          resource2 = FactoryBot.create(:auth_m_resource)
          expect{
            post :create_user, params: {user: {email: "dummy@a.com", password: "asd12345", roles_mask: 2, policies_attributes: {"0"=>{resource_id: resource2.id, access: "manage"}}}}
          }.to change(AuthM::Policy,:count).by(0)
        end

        it "test3" do 
          expect{
            post :create_user, params: {user: {email: "dummy@a.com", password: "asd12345", roles_mask: 2, policies_attributes: {"0"=>{resource_id: resource.id, access: "none"}}}}
          }.to change(AuthM::Policy,:count).by(0)
        end

        it "test4" do 
          post :create_user, params: {policy_group_selector: "Customize", user: {email: "dummy@a.com", password: "asd12345", roles_mask: 2, policy_group_attributes: {policies_attributes: {"0"=>{resource_id: resource.id, access: "read"}}}}}
          policy = AuthM::Policy.last
          expect(policy.access).to eq("read")
        end
      end  

      describe "#destroy_policies(user) ->" do 
        let(:resource){FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)}
        let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id, customized: true)}
        let(:policy){FactoryBot.create(:auth_m_policy, resource_id: resource.id,  policy_group_id: policy_group.id)}

        let(:user2){FactoryBot.create(:auth_m_user, policy_group_id: policy_group.id, branch_id: controller.current_branch.id)}

        it "test1" do 
          policy.reload
          expect{
            put :update, params: {id: user2.id, policy_group_selector: "Customize", user: {policy_group_attributes: { id: policy_group.id, policies_attributes: {"0"=>{resource_id: resource.id, id: policy.id, access: "none"}}}}}
          }.to change(AuthM::Policy,:count).by(-1)
        end
      end       


      describe "#add_policy(user) ->" do 
        let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id, customized: true)}
        let(:user2){FactoryBot.create(:auth_m_user, policy_group_id: policy_group.id, branch_id: controller.current_branch.id)}
        let(:resource){FactoryBot.create(:auth_m_resource, branch_id: user2.branch.id)}

        it "test1" do 
          expect{
            put :update, params: {id: user2.id, policy_group_selector: "Customize", user: {policy_group_attributes: { id: policy_group.id, policies_attributes: {"0"=>{resource_id: resource.id, access: "read"}}}}}
          }.to change(AuthM::Policy,:count).by(1)
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

          it "can't access action public" do
            get :public
            expect(response).to redirect_to("/401.html")
          end           
          it "can't access action new" do
            get :new
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action edit" do
            get :edit, params: { id: user.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action create" do
            post :create_user, params: {user: FactoryBot.attributes_for(:auth_m_user)}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action update" do
            put :update, params: {id: user.id, user: {name: "Dummy887"}}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action destroy" do
            delete :destroy, params:{id: user.id }
            expect(response).to redirect_to("/401.html")
          end
        end
      end 
    end

  end
end
