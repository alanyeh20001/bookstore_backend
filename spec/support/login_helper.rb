module LoginHelper
  def login_user(role = nil)
    is_admin = role == "admin" ? true : false

    let(:user) { create(:user, is_admin: is_admin) }
    before { allow_any_instance_of(DecodeAuthenticationCommand).to receive(:result).and_return(user) }
  end
end
