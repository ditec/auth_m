require 'rails_helper'

module AuthM
  RSpec.describe PeopleController, type: :controller do

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
            person = FactoryBot.create(:auth_m_person, management_id: management.id)
          end
          expect(assigns(:people).count).to eq(31)        
        end
      end

      describe "#GET show/:id ->" do
        let(:person){FactoryBot.create(:auth_m_person)}

        before :each do
          get :show, params: { id: person.id }
        end

        it { should respond_with(200) }
        it { should render_template('show') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:person)).to eq(person)        
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
          expect(assigns(:person)).to be_a_new(AuthM::Person)       
        end
      end

      describe "#GET edit/:id ->" do
        let(:person){FactoryBot.create(:auth_m_person)}

        before :each do
          get :edit, params: { id: person.id }
        end

        it { should respond_with(200) }
        it { should render_template('edit') }
        it { should render_with_layout('application') }

        it "test1" do
          expect(assigns(:person)).to eq(person)        
        end
      end

      describe "#POST create ->" do
        context "with valid attributes" do
          it "test1" do
            expect{
              post :create, params: {person: FactoryBot.attributes_for(:auth_m_person)}
            }.to change(AuthM::Person,:count).by(1)
          end

          it "test2" do
            post :create, params: {person: FactoryBot.attributes_for(:auth_m_person)}
            expect(response).to redirect_to AuthM::Person.last
          end
        end

        context "with invalid attributes" do
          it "test1" do
            expect{
              post :create, params: {person: FactoryBot.attributes_for(:auth_m_person, dni: "asd23323")}
            }.to_not change(AuthM::Person,:count)
          end

          it "test2" do
            post :create, params: {person: FactoryBot.attributes_for(:auth_m_person, dni: "asd23323")}
            expect(response).to render_template :new
          end
        end 
      end

      describe "#PUT update/:id ->" do
        let(:person){FactoryBot.create(:auth_m_person)}

        context "with valid attributes" do
          before(:each) do
            put :update, params: {id: person.id, person: {first_name: "Dummy887"}}
            person.reload
          end

          it "test1" do 
            expect(response).to redirect_to(person)
          end

          it "test2" do 
            expect(person.first_name).to eq("Dummy887")
          end
        end

        context "with invalid attributes" do
          before(:each) do
            put :update, params: {id: person.id, person: {dni: "123asd"}}
            person.reload
          end

          it "test1" do 
            expect(response).to render_template :edit
          end

          it "test2" do 
            expect(person.dni).to_not eq("123asd")
          end
        end
      end

      describe "#DELETE destroy ->" do
        let!(:person){FactoryBot.create(:auth_m_person)}

        it 'test1' do
          expect { 
            delete :destroy, params:{ id: person.id }
          }.to change(AuthM::Person,:count).by(-1)
        end

        it 'test2' do
          delete :destroy, params:{ id: person.id }
          expect(response).to redirect_to(people_path)
        end
      end

      describe "#strong_parameters ->" do 
        # it { should permit(:first_name, :last_name, :dni).for(:create, params: {person: {first_name: "Dummy457"}}).on(:person)}
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
            get :show, params: { id: user.person.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action new" do
            get :new
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action edit" do
            get :edit, params: { id: user.person.id }
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action create" do
            post :create, params: {person: FactoryBot.attributes_for(:auth_m_person)}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action update" do
            put :update, params: {id: user.person.id, person: {name: "Dummy887"}}
            expect(response).to redirect_to("/401.html")
          end      
          it "can't access action destroy" do
            delete :destroy, params:{ id: user.person.id }
            expect(response).to redirect_to("/401.html")
          end
        end
      end 
    end

  end
end
