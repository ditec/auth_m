require 'rails_helper'

module AuthM
  RSpec.describe ManagementsController, type: :controller do

    routes { AuthM::Engine.routes }

    context do 
      let!(:user){ user = FactoryBot.build(:auth_m_user, roles: [:root])
                  user.save!(:validate => false)
                  sign_in user
                  controller.set_current_management(user.management.id)
                  user}

      describe "#GET show/:id ->" do

        before :each do
          get :show, params: { id: controller.current_management.id }
        end

        it { should respond_with(200) }
        it { should render_template('show') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:management)).to eq(controller.current_management)        
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
          expect(assigns(:management)).to be_a_new(AuthM::Management)       
        end
      end

      describe "#GET edit/:id ->" do

        before :each do
          get :edit, params: { id: controller.current_management.id}
        end

        it { should respond_with(200) }
        it { should render_template('edit') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:management)).to eq(controller.current_management)        
        end
      end

      describe "#POST create ->" do
        context "with valid attributes" do
          it "test1" do
            expect{
              post :create, params: {management: FactoryBot.attributes_for(:auth_m_management)}
            }.to change(AuthM::Management,:count).by(1)
          end

          it "test2" do
            post :create, params: {management: FactoryBot.attributes_for(:auth_m_management)}
            expect(response).to redirect_to AuthM::Management.last
          end
        end

        context "with invalid attributes" do
          it "test1" do
            expect{
              post :create, params: {management: FactoryBot.attributes_for(:auth_m_management, name: nil)}
            }.to_not change(AuthM::Management,:count)
          end

          it "test2" do
            post :create, params: {management: FactoryBot.attributes_for(:auth_m_management, name: nil)}
            expect(response).to render_template :new
          end
        end 
      end

      describe "#PUT update/:id ->" do

        context "with valid attributes" do
          before(:each) do
            put :update, params: {id: controller.current_management.id, management: {name: "Dummy887"}}
            controller.current_management.reload
          end

          it "test1" do 
            expect(response).to redirect_to(controller.current_management)
          end

          it "test2" do 
            expect(controller.current_management.name).to eq("Dummy887")
          end
        end

        context "with invalid attributes" do
          before(:each) do
            put :update, params: {id: controller.current_management.id, management: {name: nil}}
            controller.current_management.reload
          end

          it "test1" do 
            expect(response).to render_template :edit
          end

          it "test2" do 
            expect(controller.current_management.name).to_not eq(nil)
          end
        end
      end

      describe "#DELETE destroy ->" do
        before(:each) do
          post :create, params: {management: FactoryBot.attributes_for(:auth_m_management)}
        end

        it 'test1' do
          expect { 
            delete :destroy, params:{ id: controller.current_management.id }
          }.to change(AuthM::Management,:count).by(-1)
        end

        it 'test2' do
          delete :destroy, params:{ id: controller.current_management.id }
          expect(response).to redirect_to("http://test.host/")
        end
      end

      describe "#strong_parameters ->" do 
        # it { should permit(:name).for(:create, params: {management: {name: "Dummy457"}}).on(:management)}
        it "test1" do 
          expect{ post(:create, params: {}) }.to raise_error ActionController::ParameterMissing
        end 
      end

      #####################################################################################################

      describe "#POST change ->" do 
        let(:management){FactoryBot.create(:auth_m_management, id:3)}

        it "test1" do 
          post :change, params: {management_selector: management.id}
          expect(session[:management_id]).to eq("3")
        end

        it "test2" do 
          post :change, params: {management_selector: management.id}
          expect(response).to redirect_to(management)
        end
      end

      describe "#destroy_resources(management) ->" do 
        let(:resource){FactoryBot.create(:auth_m_resource, management_id: controller.current_management.id)}

        it "test1" do 
          resource.reload
          expect{ put :update, params: {id: controller.current_management.id, management: {name: "Dummy887", resources_attributes: {"0" => {name: "AuthM::Person", id: resource.id, selected: "false"}}}}}
          .to change(AuthM::Resource,:count).by(-1)
        end

      end

      describe "#create_resources(management) ->" do 
        it "test1" do 
          expect{
            put :update, params: {id: controller.current_management.id, management: {name: "Dummy664", resources_attributes: {"0" => {name: "AuthM::Person", selected: "true"}}}}
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
            get :show, params: { id: user2.management.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action new" do
            get :new
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action edit" do
            get :edit, params: { id: user2.management.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action create" do
            post :create, params: {management: FactoryBot.attributes_for(:auth_m_management)}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action update" do
            put :update, params: {id: user2.management.id, management: {name: "Dummy887"}}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action destroy" do
            delete :destroy, params:{ id: user2.management.id }
            expect(response).to redirect_to("/401.html")
          end
        end
      end 
    end

  end
end
