require 'rails_helper'

module AuthM
  RSpec.describe BranchesController, type: :controller do

    routes { AuthM::Engine.routes }

    context do 
      let!(:user){ user = FactoryBot.build(:auth_m_user, roles: [:root])
                  user.save!(:validate => false)
                  sign_in user
                  controller.set_current_branch(user.branch.id)
                  user}

      describe "#GET show/:id ->" do

        before :each do
          get :show, params: { id: controller.current_branch.id }
        end

        it { should respond_with(200) }
        it { should render_template('show') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:branch)).to eq(controller.current_branch)        
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
          expect(assigns(:branch)).to be_a_new(AuthM::Branch)       
        end
      end

      describe "#GET edit/:id ->" do

        before :each do
          get :edit, params: { id: controller.current_branch.id}
        end

        it { should respond_with(200) }
        it { should render_template('edit') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:branch)).to eq(controller.current_branch)        
        end
      end

      describe "#POST create ->" do
        context "with valid attributes" do
          it "test1" do
            expect{
              post :create, params: {branch: FactoryBot.attributes_for(:auth_m_branch)}
            }.to change(AuthM::Branch,:count).by(1)
          end

          it "test2" do
            post :create, params: {branch: FactoryBot.attributes_for(:auth_m_branch)}
            expect(response).to redirect_to AuthM::Branch.last
          end
        end

        context "with invalid attributes" do
          it "test1" do
            expect{
              post :create, params: {branch: FactoryBot.attributes_for(:auth_m_branch, name: nil)}
            }.to_not change(AuthM::Branch,:count)
          end

          it "test2" do
            post :create, params: {branch: FactoryBot.attributes_for(:auth_m_branch, name: nil)}
            expect(response).to render_template :new
          end
        end 
      end

      describe "#PUT update/:id ->" do

        context "with valid attributes" do
          before(:each) do
            put :update, params: {id: controller.current_branch.id, branch: {name: "Dummy887"}}
            controller.current_branch.reload
          end

          it "test1" do 
            expect(response).to redirect_to(controller.current_branch)
          end

          it "test2" do 
            expect(controller.current_branch.name).to eq("Dummy887")
          end
        end

        context "with invalid attributes" do
          before(:each) do
            put :update, params: {id: controller.current_branch.id, branch: {name: nil}}
            controller.current_branch.reload
          end

          it "test1" do 
            expect(response).to render_template :edit
          end

          it "test2" do 
            expect(controller.current_branch.name).to_not eq(nil)
          end
        end
      end

      describe "#DELETE destroy ->" do
        before(:each) do
          post :create, params: {branch: FactoryBot.attributes_for(:auth_m_branch)}
        end

        it 'test1' do
          expect { 
            delete :destroy, params:{ id: controller.current_branch.id }
          }.to change(AuthM::Branch,:count).by(-1)
        end

        it 'test2' do
          delete :destroy, params:{ id: controller.current_branch.id }
          expect(response).to redirect_to("http://test.host/")
        end
      end

      describe "#strong_parameters ->" do 
        # it { should permit(:name).for(:create, params: {branch: {name: "Dummy457"}}).on(:branch)}
        it "test1" do 
          expect{ post(:create, params: {}) }.to raise_error ActionController::ParameterMissing
        end 
      end

      #####################################################################################################

      describe "#POST change ->" do 
        let(:branch){FactoryBot.create(:auth_m_branch, id:3)}

        it "test1" do 
          post :change, params: {branch_selector: branch.id}
          expect(session[:branch_id]).to eq("3")
        end

        it "test2" do 
          post :change, params: {branch_selector: branch.id}
          expect(response).to redirect_to(branch)
        end
      end

      describe "#destroy_resources(branch) ->" do 
        let(:resource){FactoryBot.create(:auth_m_resource, branch_id: controller.current_branch.id)}

        it "test1" do 
          resource.reload
          expect{ put :update, params: {id: controller.current_branch.id, branch: {name: "Dummy887", resources_attributes: {"0" => {name: "AuthM::User", id: resource.id, selected: "false"}}}}}
          .to change(AuthM::Resource,:count).by(-1)
        end

      end

      describe "#create_resources(branch) ->" do 
        it "test1" do 
          expect{
            put :update, params: {id: controller.current_branch.id, branch: {name: "Dummy664", resources_attributes: {"0" => {name: "AuthM::User", selected: "true"}}}}
          }.to change(AuthM::Resource,:count).by(1)
        end
      end

    end

    context do 
      describe "#can't_access ->" do 
        context do
          let(:user2){FactoryBot.create(:auth_m_user)}

          before :each do 
            sign_in user2 
          end 
    
          it "can't access action show" do
            get :show, params: { id: user2.branch.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action new" do
            get :new
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action edit" do
            get :edit, params: { id: user2.branch.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action create" do
            post :create, params: {branch: FactoryBot.attributes_for(:auth_m_branch)}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action update" do
            put :update, params: {id: user2.branch.id, branch: {name: "Dummy887"}}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action destroy" do
            delete :destroy, params:{ id: user2.branch.id }
            expect(response).to redirect_to("/401.html")
          end
        end
      end 
    end

  end
end
