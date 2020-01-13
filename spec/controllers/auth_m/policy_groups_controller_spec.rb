require 'rails_helper'

module AuthM
  RSpec.describe PolicyGroupsController, type: :controller do
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
            policy_group = FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id)
          end
          
          expect(assigns(:policy_groups).count).to eq(31)        
        end
      end

      describe "#GET show/:id ->" do
        let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id)}

        before :each do
          get :show, params: { id: policy_group.id }
        end

        it { should respond_with(200) }
        it { should render_template('show') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:policy_group)).to eq(policy_group)        
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
          expect(assigns(:policy_group)).to be_a_new(AuthM::PolicyGroup)       
        end
      end

      describe "#GET edit/:id ->" do
        let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id)}

        before :each do
          get :edit, params: { id: policy_group.id }
        end

        it { should respond_with(200) }
        it { should render_template('edit') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:policy_group)).to eq(policy_group)        
        end
      end

      describe "#POST create ->" do
        context "with valid attributes" do
          it "test1" do
            expect{
              post :create, params: {policy_group: FactoryBot.attributes_for(:auth_m_policy_group)}
            }.to change(AuthM::PolicyGroup,:count).by(1)
          end

          it "test2" do
            post :create, params: {policy_group: FactoryBot.attributes_for(:auth_m_policy_group)}
            expect(response).to redirect_to AuthM::PolicyGroup.last
          end
        end

        context "with invalid attributes" do
          it "test1" do
            expect{
              post :create, params: {policy_group: FactoryBot.attributes_for(:auth_m_policy_group, name: nil)}
            }.to_not change(AuthM::PolicyGroup,:count)
          end

          it "test2" do
            post :create, params: {policy_group: FactoryBot.attributes_for(:auth_m_policy_group, name: nil)}
            expect(response).to render_template :new
          end
        end 

        context "policies" do 
          let(:resource1){FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)}
          let(:resource2){FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)}
          let(:resource3){FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)}

          it "test1" do
            expect{
              post :create, params: {policy_group: { name: "dummy", policies_attributes: {"0"=>{resource_id: resource1.id, access: "read"}, "1"=>{resource_id: resource2.id, access: "manage"}, "2"=>{resource_id: resource3.id, access: "none"}}}}
            }.to change(AuthM::Policy,:count).by(2)
          end
        end 
      end

      describe "#PUT update/:id ->" do
        let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id)}

        context "with valid attributes" do
          before(:each) do
            put :update, params: {id: policy_group.id, policy_group: {name: "dummy887"}}
            policy_group.reload
          end

          it "test1" do 
            expect(response).to redirect_to(policy_group)
          end

          it "test2" do 
            expect(policy_group.name).to eq("Dummy887")
          end
        end

        context "with invalid attributes" do
          before(:each) do
            put :update, params: {id: policy_group.id, policy_group: {name: nil}}
            policy_group.reload
          end

          it "test1" do 
            expect(response).to render_template :edit
          end

          it "test2" do 
            expect(policy_group.name).to_not eq(nil)
          end
        end

        context "policies" do 
          let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id )}
          let(:policy){FactoryBot.create(:auth_m_policy, resource: (FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)), policy_group_id: policy_group.id, access: "read")}

          it "test1" do
            post :update, params: { id: policy_group.id, policy_group: {policies_attributes: {"0"=>{id: policy.id, resource_id: policy.resource.id, access: "manage"}}}}
            policy.reload
            expect(policy.access).to eq("manage")
          end
        end 
      end

      describe "#DELETE destroy ->" do
        let!(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id)}

        it 'test1' do
          expect { 
            delete :destroy, params:{ id: policy_group.id }
          }.to change(AuthM::PolicyGroup,:count).by(-1)
        end

        it 'test2' do
          delete :destroy, params:{ id: policy_group.id }
          expect(response).to redirect_to(policy_groups_path)
        end

        context "policies" do 
          let(:policy_group){FactoryBot.create(:auth_m_policy_group, branch_id: controller.current_branch.id )}
          let(:policy){FactoryBot.create(:auth_m_policy, resource: (FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)), policy_group_id: policy_group.id, access: "read")}

          it "test1" do
            post :update, params: { id: policy_group.id, policy_group: {policies_attributes: {"0"=>{id: policy.id, resource_id: policy.resource.id, access: "none"}}}}
            policy_group.reload
            expect(policy_group.policies.count).to eq(0)
          end
        end 
      end

      describe "#strong_parameters ->" do 
        # it { should permit(:first_name, :last_name, :dni).for(:create, params: {policy_group: {first_name: "Dummy457"}}).on(:policy_group)}
        it "test1" do 
          expect{ post(:create, params: {}) }.to raise_error ActionController::ParameterMissing
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
            get :show, params: { id: user.policy_group.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action new" do
            get :new
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action edit" do
            get :edit, params: { id: user.policy_group.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action create" do
            post :create, params: {policy_group: FactoryBot.attributes_for(:auth_m_policy_group)}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action update" do
            put :update, params: {id: user.policy_group.id, policy_group: {name: "Dummy887"}}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action destroy" do
            delete :destroy, params:{ id: user.policy_group.id }
            expect(response).to redirect_to("/401.html")
          end
        end
      end 
    end
  end
end
